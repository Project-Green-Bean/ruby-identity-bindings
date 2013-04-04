require 'C:\Users\JuanJose\Desktop\Keystone\lib\keystone.rb'
require 'test/unit'

#testing catalog and token_get

class TestOther < Test::Unit::TestCase
	
	#token tests
	def test_token_get	
			c = Keystone.new("admin","password","http://198.61.199.47","5000","35357")
			c.auth("tenant1")
			expected = c.token_get
			assert_not_nil(expected)
	end

	def test_failure_auth_token_get	
			c = Keystone.new("admin","password","http://198.61.199.47","5000","35357")
			c.auth("WRONG")
			expected = c.token_get
			assert_nil(expected)
	end


	#catalog tests
	def test_catalog	
			c = Keystone.new("admin","password","http://198.61.199.47","5000","35357")
			c.auth("tenant1")
			expected = c.catalog
			assert_not_nil(expected)
	end

	def test_failure_auth_catalog
			c = Keystone.new("admin","password","http://198.61.199.47","5000","35357")
			c.auth("WRONG")
			expected = c.catalog
			assert_nil(expected)
	end

end

