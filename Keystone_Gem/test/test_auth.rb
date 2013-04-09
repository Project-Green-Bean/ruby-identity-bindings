require File.join(File.dirname(__FILE__), '../lib/keystone.rb')
require 'test/unit'
#testing the auth function

class TestAuth < Test::Unit::TestCase
	def test_auth_server
		c = Keystone.new("admin","password","WRONG_SERVER","5000","35357")
		expected = c.auth("tenant1")
		assert_equal expected, false
	end
	
	def test_auth_password
		c = Keystone.new("admin","WRONG","http://198.61.199.47","5000","35357")
		expected = c.auth("tenant1")
		assert_equal expected, false
	end
	
	def test_auth_username
		c = Keystone.new("WRONG","password","http://198.61.199.47","5000","35357")
		expected = c.auth("tenant1")
		assert_equal expected, false
	end
	
	def test_auth_tenant
		c = Keystone.new("admin","password","http://198.61.199.47","5000","35357")
		expected = c.auth("WRONG")
		assert_equal expected, false
	end
	
	def test_auth_correct
		c = Keystone.new("admin","password","http://198.61.199.47","5000","35357")
		expected = c.auth("tenant1")
		assert_equal expected, true
	end
	
end

