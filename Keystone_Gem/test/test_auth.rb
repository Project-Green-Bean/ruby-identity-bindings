require File.join(File.dirname(__FILE__), '../lib/keystone.rb')
require 'test/unit'
require 'test_parameters'

#testing the auth function

class TestAuth < Test::Unit::TestCase
	def test_auth_server
		c = Keystone.new($admin, $adminPass, "WRONG_SERVER", $serverPort1, $serverPort2)
		expected = c.auth($tenant)
		assert_equal expected, false
	end
	
	def test_auth_password
		c = Keystone.new($admin, "WRONG", $serverURL, $serverPort1, $serverPort2)
		expected = c.auth($tenant)
		assert_equal expected, false
	end
	
	def test_auth_username
		c = Keystone.new("WRONG", $adminPass, $serverURL,$serverPort1,$serverPort2)
		expected = c.auth($tenant)
		assert_equal expected, false
	end
	
	def test_auth_tenant
		c = Keystone.new($admin, $adminPass, $serverURL, $serverPort1, $serverPort2)
		expected = c.auth("WRONG")
		assert_equal expected, false
	end
	
	def test_auth_correct
		c = Keystone.new($admin, $adminPass, $serverURL, $serverPort1, $serverPort2)
		expected = c.auth($tenant)
		assert_equal expected, true
	end
	
end

