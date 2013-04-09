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

    def test_user_create_unauthorized
      #this should not allow creation of users
    end

    def test_user_create_incorrect_tenant
      #this should not allow creation of users
    end

    #this should allow creation of users under regular circumstances

  end

  def test_user_delete

    def test_user_delete_user_doesnt_exist
      #this should not allow deletion of users
    end

    def test_user_delete_unauthorized
      #this should not allow deletion of users
    end
    #this should allow deletion under regular circumstances

  end

  def test_user_get

  end

  def test_user_password_update

  end

end