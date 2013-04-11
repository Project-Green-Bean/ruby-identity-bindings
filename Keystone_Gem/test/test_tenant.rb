require File.join(File.dirname(__FILE__), '../lib/keystone.rb')
require 'test/unit'
require 'test_parameters.rb'


#testing the auth function


class TestTenant < Test::Unit::TestCase
	
	#tenant_list
	def test_tenant_list	
		c = Keystone.new($admin, $adminPass, $serverURL, $serverPort1, $serverPort2)
		c.auth($tenant)
		expected = c.tenant_list
		assert_not_nil(expected)
	end
	
	def test_tenant_list_fail_to_authenticate
		d = Keystone.new($admin, $adminPass, $serverURL, $serverPort1, $serverPort2)
		d.auth($tenant)
		expected = d.tenant_list
		assert_nil(expected)
	end
	
	def tenant_list_empty
		d = Keystone.new($admin, $adminPass, $serverURL, $serverPort1, $serverPort2)
		d.auth($tenant)
		expected = d.tenant_list
		assert_not_nill(expected)
	end

end