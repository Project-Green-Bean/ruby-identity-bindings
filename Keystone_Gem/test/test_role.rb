require File.join(File.dirname(__FILE__), '../lib/keystone.rb')
require File.join(File.dirname(__FILE__), '../test/test_parameters.rb')
require 'test/unit'
require 'rubygems'
#testing the role functions

class TestRole < Test::Unit::TestCase

	$aut = Keystone.new($admin,$adminPass,$serverURL,$serverPort1,$serverPort2)
	$fai = Keystone.new($admin,$randomPass,$serverURL,$serverPort1,$serverPort2)
	$aut.auth($tenant)
	$fai.auth($tenant)


	begin #role_list

		def test_role_list	
			expected = $aut.role_list
			assert(expected.has_key? 'roles')
		end
		
		def test_role_list_fail_to_authenticate
			expected = $fai.role_list
			assert(expected.has_key?('error'))
		end

	end #role_list
	
	begin #role_create 

		def test_role_create
			cnt = 0
			begin
				expected = $aut.role_create("testName".concat((cnt = cnt+1).to_s))
			end while(expected.has_key?("error"))
			expected = expected["role"]["id"]
			$aut.role_get(expected)
			$aut.role_delete(expected)
			expected = $aut.role_get(expected)
			assert(expected.has_key?("error"))
		end	
		
		def test_role_create_fail_to_authenticate			
			expected = $fai.role_create(b)			
			assert(expected.has_key?("error"))
		end
		
		def test_role_create_already_exists 
			cnt = 0
			begin
				b = "testName".concat((cnt = cnt+1).to_s
				c = $aut.role_create(b)
			end while(expected.has_key?("error"))
			expected = $aut.role_create(b)
			$aut.role_delete(c["role"]["id"])
			assert(expected.has_key?("error"))
		end

	end #role_create
	
	
	begin #role_get

		def test_role_get	
			cnt = 0
			begin
				b = "testName".concat((cnt = cnt+1).to_s
				c = $aut.role_create(b)
			end while(expected.has_key?("error"))
			d = c["role"]["id"]
			expected = $aut.role_get(d)["role"]["id"]
			assert_equal(expected, d)
		end
		
		def test_role_get_fail_to_authenticate
			expected = $fai.role_get($existingID)
			assert(expected.has_key?("error"))
		end
		
		def test_role_get_does_not_exist
			expected = $aut.role_get("thisShouldNotExist")
			assert(expected.has_key?("error"))
		end

	end #role_get
	
	begin #role_delete

		def test_role_delete
			cnt = 0
			begin
				expected = $aut.role_create("testName".concat((cnt = cnt+1).to_s))
			end while(expected.has_key?("error"))
			expected = expected["role"]["id"]
			$aut.role_get(expected)
			$aut.role_delete(expected)
			expected = $aut.role_get(expected)
			assert(expected.has_key?("error"))
		end	
		
		def test_role_delete_fail_to_authenticate
			cnt = 0
			begin
				expected = $aut.role_create("testName".concat((cnt = cnt+1).to_s))
			end while(expected.has_key?("error"))
			real = expected["role"]["id"]
			expected = $fai.role_delete(real)
			$aut.role_delete(real)
			assert(expected == false)
		end
		
		def test_role_delete_does_not_exist
			expected = $aut.role_delete("321321321RandomID")
			assert(expected == false)
		end

	end #role_delete
	
end

