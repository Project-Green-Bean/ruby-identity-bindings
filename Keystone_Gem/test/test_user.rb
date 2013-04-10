require File.join(File.dirname(__FILE__), '../lib/keystone.rb')
require 'test/unit'
require 'json'

class TestUser < Test::Unit::TestCase

  def test_user_list
    c = Keystone.new("admin", "password","http://198.61.199.47","5000","35357")
    c.auth("tenant1")
    withoutNewUser = c.user_list
    userID= c.user_create('lawdog','lawdog@com.com','secret', '78f0f0f79cd241a2b6ade773f9ad5cf1')
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
    a = Keystone.new("admin", "password", "http://198.61.199.47", "5000", "35357")
    newUser = a.user_create("lawdog", "secret", "hur@yahoo", "78f0f0f79cd241a2b6ade773f9ad5cf1")
    assert_equal(newUser,a.user_get(newUser['user']['name']))
  end

  def test_user_get_doesnt_exist
    a = Keystone.new("admin", "password", "http://198.61.199.47", "5000", "35357")
    noUser = a.user_get("0000")
    #TODO find a way to assert that the answer is equal
    #TODO to the json object of an empty user
  end


  def test_user_password_update
    #this should allow changing of a user's password under regular circumstances
    a = Keystone.new("admin", "password", "http://198.61.199.47","5000","35357")
    newUser = a.user_create("lawdogpasswordupdate", "secret", "lawdog@yahoo", "78f0f0f79cd241a2b6ade773f9ad5cf1")
    a.user_password_update(newUser['user']['name'], "compromised")
    b = Keystone.new("lawdogpasswordupdate", "compromised", "http://198.61.199.47","5000","35357")
    a.user_delete(newUser)
  end

  def test_user_password_update_unauthorized
    #this should not allow a user's password to be changed
    a = Keystone.new("admin", "password", "http://198.61.199.47","5000","35357")
    newUser = a.user_create("lawdogpasswordupdate", "secret", "lawdog@yahoo", "78f0f0f79cd241a2b6ade773f9ad5cf1")
    newUser2 = a.user_create("lawdog", "easy", "hurr@yahoo", "78f0f0f79cd241a2b6ade773f9ad5cf1")
    b = Keystone.new("lawdogpasswordupdate", "secret", "http://198.61.199.47","5000","35357")
    answer = b.user_password_update(newUser['user']['name'], "compromised")
    #TODO find way to assert that the answer is equal to the
    #TODO error message that a user is not authorized to perform that action
  end

  def test_user_password_update_user_doesnt_exist
    #this should not allow a user's password to be changed
    a = Keystone.new("admin","password", "http://198.61.199.47", "5000", "35357")
    b.user_password_update("1000000000", "easy")
    #TODO find way to assert that the answer is equal to the
    #TODO error message that the user does not exist
  end

end