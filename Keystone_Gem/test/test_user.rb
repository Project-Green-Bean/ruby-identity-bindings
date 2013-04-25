require File.join(File.dirname(__FILE__), '../lib/keystone.rb')
require 'test/unit'
require 'test_parameters'


class TestUser < Test::Unit::TestCase


  def test_user_list
    c = Keystone.new($admin, $adminPass, $serverURL, $serverPort1, $serverPort2)
    c.auth($tenant)
    withoutNewUser = c.user_list
    newTenant = c.tenant_create('test_user_list', 'mock tenant')
    newUser= c.user_create('test_user_list','test_user_list@com.com','secret', newTenant['tenant']['id'])
    withNewUser = c.user_list

    assert(true, withoutNewUser==withNewUser) #makes sure that the list does in fact change

    c.user_delete(newUser['user']['id'])
    c.tenant_delete(newTenant['tenant']['id'])
  end

  def test_user_create
    #this should allow creation of users under regular circumstances
    c = Keystone.new($admin, $adminPass, $serverURL, $serverPort1, $serverPort2)
    c.auth($tenant)
    withoutNew = c.user_list['users']
    newTenant = c.tenant_create("test_user_create", "")
    newUser = c.user_create("test_user_create", "email", "password", newTenant['tenant']['id'])
    withNew = c.user_list['users']

    difference = withNew.size - withoutNew.size
    assert_equal(1, difference)

    c.user_delete(newUser['user']['id'])
    c.tenant_delete(newTenant['tenant']['id'])
  end

  def test_user_create_unauthorized
    #this should not allow creation of users
    c = Keystone.new($admin, $adminPass, $serverURL, $serverPort1, $serverPort2)
    c.auth($tenant)
  end

  def test_user_create_invalid_tenant
    #this should not allow creation of users
    c = Keystone.new($admin, $adminPass, $serverURL, $serverPort1, $serverPort2)
    c.auth($tenant)

    newUser = c.user_create("test_user_create_invalid_tenant", "email", "password", "TheOddsOfHavingThisTenantIDIsVeryUnlikely")
    assert_equal(404, newUser['error']['code'])

  end

  def test_user_delete
    #this should allow deletion under regular circumstances
    c = Keystone.new($admin, $adminPass, $serverURL, $serverPort1, $serverPort2)
    c.auth($tenant)


    newTenant = c.tenant_create("test_user_delete", "")
    newUser = c.user_create("test_user_delete", "email", "password", newTenant['tenant']['id'])
    with

  end

  def test_user_delete_unauthorized
    #this should not allow deletion of users
    c = Keystone.new($admin, $adminPass, $serverURL, $serverPort1, $serverPort2)
    c.auth($tenant)

  end

  def test_user_delete_user_doesnt_exist
    #this should not allow deletion of users
    c = Keystone.new($admin, $adminPass, $serverURL, $serverPort1, $serverPort2)
    c.auth($tenant)
    assert_equal(false, c.user_delete("TheOddsOfHavingThisUserIDIsVeryUnlikely"))
  end

  def test_user_get
    #this should allow the retrieving of a user
    #should it fail or return an empty user when the user doesnt exist?
    a = Keystone.new($admin, $adminPass, $serverURL, $serverPort1, $serverPort2)
    a.auth($tenant)
    newTenant = a.tenant_create("user_get_tenant", "for testing purposes")
    newUser = a.user_create("user_get", "secret", "user_get_email", newTenant['tenant']['id'])

    assert_equal(newUser["user"]["id"],a.user_get(newUser['user']['id'])['user']['id'])

    a.user_delete(newUser["user"]["id"])
    a.tenant_delete(newTenant['tenant']['id'])
  end

  def test_user_get_doesnt_exist
    a = Keystone.new($admin, $adminPass, $serverURL, $serverPort1, $serverPort2)
    a.auth($tenant)
    noUser = a.user_get("0000")

    assert_equal(noUser["error"]["code"], 404)
  end


  def test_user_password_update
    #this should allow changing of a user's password under regular circumstances
    #if the b user can authenticate with the new password, the value returned from auth should be true, else false
    a = Keystone.new($admin, $adminPass, $serverURL, $serverPort1, $serverPort2)
    a.auth($tenant)
    newTenant = a.tenant_create("test_password_update", "for testing purposes")
    newUser = a.user_create("test_password_update", "password@yahoo", "secret", newTenant['tenant']['id'])

    a.user_password_update(newUser['user']['id'], "compromised")
    b = Keystone.new("test_password_update", "compromised", $serverURL,$serverPort1,$serverPort2)

    assert_equal(b.auth(newTenant['tenant']['name']),true)

    a.user_delete(newUser['user']['id'])
    a.tenant_delete(newTenant['tenant']['id'])
  end

  def test_user_password_update_unauthorized
    #this should not allow a user's password to be changed
    a = Keystone.new($admin, $adminPass, $serverURL, $serverPort1, $serverPort2)
    a.auth($tenant)
    testTenant = a.tenant_create("user_password_update_test", "to make sure user belonging to a low level cant change passwords")
    testUser =  a.user_create("lawdogpasswordupdate", "secret", "lawdog@yahoo", testTenant['tenant']['id'])
    testDummy = a.user_create("dummy", "secret", "lawdog@yahoo", testTenant['tenant']['id'])
    b = Keystone.new("lawdogpasswordupdate", "secret", $serverURL, $serverPort1, $serverPort2)
    b.auth(testTenant['tenant']['name'])


    #TODO FIX DIS
    #TODO for some reason it wont let me auth 'lawdogpasswordupdate' to the server under the tenant that i created above


    a.user_delete(testUser['user']['id'])
    a.tenant_delete(testTenant['tenant']['id'])
  end

  def test_user_password_update_user_doesnt_exist
    #this should not allow a user's password to be changed
    a = Keystone.new($admin, $adminPass, $serverURL, $serverPort1, $serverPort2)
    a.auth($tenant)
    assert_equal(a.user_password_update("1337", "31337")['error']['code'],404)
  end


  begin #user_update
  
  def test_user_update
    # This should work fine
    a = Keystone.new($admin, $adminPass, $serverURL, $serverPort1, $serverPort2)
    a.auth($tenant)
    newTenant = a.tenant_create("test_user_update", "testing user update")
    tenantID = newTenant[0]['tenant']['id']
    newUser = a.user_create("test","test email 1", "password",tenantID)
    userID = newUser['user']['id']
    oldUserInfo = newUser['user']['email']
    a.user_update("email 2",userID)
    newUserInfo = newUser['user']['email']
    assert(false, oldUserInfo == newUserInfo)
    a.user_delete(userID)
    a.tenant_delete(tenantID)
  end
		
  def test_user_update_error
    # This should not be allowed
    a = Keystone.new($admin, $adminPass, $serverURL, $serverPort1, $serverPort2)
    a.auth($tenant)
    errorFail = a.user_update("failed","failed","randomIDlolno")
    assert(errorFail == nil)
  end
  
  end #user_update

end

