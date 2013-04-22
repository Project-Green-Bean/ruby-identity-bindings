require File.join(File.dirname(__FILE__), '../lib/keystone.rb')
require 'test/unit'
require 'test_parameters'


class TestUser < Test::Unit::TestCase


  def test_user_list
    c = Keystone.new($admin, $adminPass, $serverURL, $serverPort1, $serverPort2)
    c.auth($tenant)
    withoutNewUser = c.user_list
    userID= c.user_create('lawdog','lawdog@com.com','secret', '78f0f0f79cd241a2b6ade773f9ad5cf1')
    #TODO Replace that tenant ID with a valid mock one and then delete it
    withNewUser = c.user_list
    assert_not_equal(withoutNewUser,withNewUser) #makes sure that the list does in fact change
    c.user_delete(userID["users"]["tenantID"])
    assert_equal(withoutNewUser, c.user_list)
  end

  def test_user_create
    #this should allow creation of users under regular circumstances
  end

  def test_user_create_unauthorized
    #this should not allow creation of users
  end

  def test_user_create_incorrect_tenant
    #this should not allow creation of users
  end

  def test_user_delete
    #this should allow deletion under regular circumstances
  end

  def test_user_delete_unauthorized
    #this should not allow deletion of users
  end

  def test_user_delete_user_doesnt_exist
    #this should not allow deletion of users
  end

  def test_user_get
    #this should allow the retrieving of a user
    #should it fail or return an empty user when the user doesnt exist?
    a = Keystone.new($admin, $adminPass, $serverURL, $serverPort1, $serverPort2)
    a.auth($tenant)
    newUser = a.user_create("lawdizzog", "secret", "hur@yahoo", "78f0f0f79cd241a2b6ade773f9ad5cf1")

    assert_equal(newUser["user"]["id"],a.user_get(newUser['user']['id'])['user']['id'])

    a.user_delete(newUser["user"]["id"])
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

end

#