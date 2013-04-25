require File.join(File.dirname(__FILE__), '../lib/keystone.rb')
require 'test/unit'
require File.join(File.dirname(__FILE__), '../test/test_parameters.rb')

#testing the role functions

class TestRole < Test::Unit::TestCase

	$aut = Keystone.new($admin,$adminPass,$serverURL,$serverPort1,$serverPort2)
	$fai = Keystone.new($admin,$randomPass,$serverURL,$serverPort1,$serverPort2)
	$aut.auth($tenant)
	$fai.auth($tenant)

	
	begin #role_list
		def test_role_list	
			expected = $aut.role_list
			assert(expected[0].has_key? 'roles')
		end
		
		def test_role_list_fail_to_authenticate
			expected = $fai.role_list[0]
			assert(expected.has_key?("error"))
		end

	end #role_list
	
	begin #role_create 

		def test_role_create
			cnt = 0
			begin
				expected = $aut.role_create("testName".concat((cnt = cnt+1).to_s))
				
			end while(expected[0].has_key?("error"))
			id = expected[0]["role"]["id"]
			$aut.role_get(id)
			$aut.role_delete(id)
			assert(expected[0].has_key?("role"))
		end	
		
		def test_role_create_fail_to_authenticate	
			expected = $fai.role_create("testing")[0]		
			assert(expected.has_key?("error"))
		end
		
		def test_role_create_already_exists 
			cnt = 0
			begin
				b = "testName".concat((cnt = cnt+1).to_s)
				c = $aut.role_create(b)[0]
			end while(c.has_key?("error"))
			expected = $aut.role_create(b)[0]
			$aut.role_delete(c["role"]["id"])
			assert(expected.has_key?("error"))
		end

	end #role_create
	
	
	begin #role_get

		def test_role_get	
			cnt = 0
			begin
				b = "testName".concat((cnt = cnt+1).to_s)
				c = $aut.role_create(b)[0]
			end while(c.has_key?("error"))
			d = c["role"]["id"]
			expected = $aut.role_get(d)[0]["role"]["id"]
			assert_equal(expected, d)
		end
		
		def test_role_get_fail_to_authenticate
			expected = $fai.role_get("testing")[0]
			assert(expected == nil)
		end
		
		def test_role_get_does_not_exist
			expected = $aut.role_get("thisShouldNotExist")[0]
			assert(expected == nil)
		end

	end #role_get
	
	begin #role_delete

		def test_role_delete
			cnt = 0
			begin
				expected = $aut.role_create("testName".concat((cnt = cnt+1).to_s))[0]
			end while(expected.has_key?("error"))
			expected = expected["role"]["id"]
			$aut.role_get(expected)
			expected = $aut.role_delete(expected)[0]
			assert(expected == true)
		end	
		
		def test_role_delete_fail_to_authenticate
			cnt = 0
			begin
				expected = $aut.role_create("testName".concat((cnt = cnt+1).to_s))[0]
			end while(expected.has_key?("error"))
			real = expected["role"]["id"]
			expected = $fai.role_delete(real)[0]
			$aut.role_delete(real)
			assert(expected == false)
		end
		
		def test_role_delete_does_not_exist
			expected = $aut.role_delete("321321321RandomID")[0]
			assert(expected == false)
		end

	end #role_delete
	
end


