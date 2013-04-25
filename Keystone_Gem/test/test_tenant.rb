require File.join(File.dirname(__FILE__), '../lib/keystone.rb')
require File.join(File.dirname(__FILE__), '../test/test_parameters.rb')
require 'test/unit'

#testing the auth function

class TestTenant < Test::Unit::TestCase
	
#tenant_list
	def test_tenant_list	
		c = Keystone.new($admin,$adminPass,$serverURL,$serverPort1,$serverPort2)
		c.auth($tenant)
		a = c.tenant_list
		expected = a[0]
		assert_not_nil(expected)
	end
	
	def tenant_list_different_tenant
		d = Keystone.new("test01u",$adminPass,$serverURL,$serverPort1,$serverPort2)
		d.auth("test01")
		a = c.tenant_list
		expected = a[0]
		assert_not_nil(expected)
	end
	
	def test_tenant_create
		c = Keystone.new($admin,$adminPass,$serverURL,$serverPort1,$serverPort2)
		c.auth($tenant)
		expected = c.tenant_create("testing","testing")
		assert_not_nil(expected[0])
	end

	def test_tenant_get_tenant_in_database
		c = Keystone.new($admin,$adminPass,$serverURL,$serverPort1,$serverPort2)
		c.auth($tenant)
		id = tenant_id_search(c, "testing")
		expected = c.tenant_get(id)
		assert_not_nil(expected[0])
	end
	
	def test_tenant_get_tenant_not_in_database
		c = Keystone.new($admin,$adminPass,$serverURL,$serverPort1,$serverPort2)
		c.auth($tenant)
		expected = c.tenant_get("TENANT_NOT_IN_DATABASE!!")
		assert_nil(expected[0])
	end
	
	
	def test_tenant_update
		c = Keystone.new($admin,$adminPass,$serverURL,$serverPort1,$serverPort2)
		c.auth($tenant)
		id = tenant_id_search(c, "testing")
		
		a = c.tenant_update("change_the_testing_temp", "change a test", id)
		if id != 0
			expected = a[0]
		else
			excpected = nil
		end
		assert_not_nil(expected)
	end
	
	def test_tenant_delete
		c = Keystone.new($admin,$adminPass,$serverURL,$serverPort1,$serverPort2)
		c.auth($tenant)
		id = tenant_id_search(c, "change_the_testing_temp")
		
		a = c.tenant_delete(id)
		if id != 0
			expected = a[0]
		else
			excpected = false
		end
		assert_equal expected, true
	end

end

def tenant_id_search(keystone_object, name)
	
		t = keystone_object.tenant_list
		tenants = t[0]
		tenant_list = tenants["tenants"]
		
		for t in tenant_list
			if (t.has_value? name)
				return t["id"]
			end
		end
		
		return 0
end