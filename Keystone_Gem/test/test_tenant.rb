require 'C:\Users\JuanJose\Desktop\Keystone\lib\keystone.rb'
require 'test/unit'
#testing the auth function

class TestTenant < Test::Unit::TestCase
	
	#tenant_list
	def test_tenant_list	
		c = Keystone.new("admin","password","http://198.61.199.47","5000","35357")
		c.auth("tenant1")
		expected = c.tenant_list
		assert_not_nil(expected)
	end
	
	def test_tenant_list_fail_to_authenticate
		d = Keystone.new("admin","passwordx","http://198.61.199.47","5000","35357")
		d.auth("tenant1")
		expected = d.tenant_list
		assert_nil(expected)
	end
	
	def tenant_list_empty
		d = Keystone.new("admin","passwordx","http://198.61.199.47","5000","35357")
		d.auth("tenant1")
		expected = d.tenant_list
		assert_not_nill(expected)
	end

end