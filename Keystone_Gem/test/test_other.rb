require File.join(File.dirname(__FILE__), '../lib/keystone.rb')
require 'test/unit'
require 'test_parameters.rb'

#testing catalog and token_get

class TestOther < Test::Unit::TestCase
	
	#token tests
	def test_token_get	
			c = Keystone.new($admin, $adminPass, $serverURL, $serverPort1, $serverPort2)
			c.auth($tenant)
			expected = c.token_get
			assert_not_nil(expected)
	end

	def test_failure_auth_token_get	
			c = Keystone.new($admin, $adminPass, $serverURL, $serverPort1, $serverPort2)
			c.auth("WRONG")
			expected = c.token_get
			assert_nil(expected)
	end


	#catalog tests
	def test_catalog	
			c = Keystone.new($admin, $adminPass, $serverURL, $serverPort1, $serverPort2)
			c.auth($tenant)
			expected = c.catalog
			assert_not_nil(expected)
	end

	def test_failure_auth_catalog
			c = Keystone.new($admin, $adminPass, $serverURL, $serverPort1, $serverPort2)
			c.auth("WRONG")
			expected = c.catalog
			assert_nil(expected)
	end

end

