require File.join(File.dirname(__FILE__), '../lib/keystone.rb')
require 'test/unit'
require File.join(File.dirname(__FILE__), '../test/test_parameters.rb')

#testing the role functions

class TestRole < Test::Unit::TestCase

	$aut = Keystone.new($admin,$adminPass,$serverURL,$serverPort1,$serverPort2)
	$fai = Keystone.new($admin,"dsadsa",$serverURL,$serverPort1,$serverPort2)
	$aut.auth($tenant)
	$fai.auth($tenant)

	
	begin #role_list
		def test_role_list	
			expected = $aut.role_list[0]
			assert(expected)
		end
		
		def test_role_list_fail_to_authenticate
			expected = $fai.role_list[0]
			assert(!expected)
		end

	end #role_list
	
	begin #role_create 

		def test_role_create
			cnt = 0
			begin
				expected = $aut.role_create("testName".concat((cnt = cnt+1).to_s))				
			end while(expected[0] == false)
			id = expected[1]["role"]["id"]
			$aut.role_delete(id)
			assert(expected[0])
		end	
		
		def test_role_create_fail_to_authenticate	
			expected = $fai.role_create("testing")[0]		
			assert(!expected)
		end
		
		def test_role_create_already_exists 
			cnt = 0
			begin
				b = "testName".concat((cnt = cnt+1).to_s)
				c = $aut.role_create(b)
			end while(c[0] == false)
			expected = $aut.role_create(b)[0]
			$aut.role_delete(c[1]["role"]["id"])
			assert(!expected)
		end

	end #role_create
	
	
	begin #role_get

		def test_role_get	
			cnt = 0
			begin
				c = $aut.role_create("testName".concat((cnt = cnt+1).to_s))
			end while(c[0] == false)
			d = c[1]["role"]["id"]
			expected = $aut.role_get(d)[1]["role"]["id"]
			$aut.role_delete(c[1]["role"]["id"])
			assert_equal(expected, d)
		end
		
		def test_role_get_fail_to_authenticate
			expected = $fai.role_get("testing")[0]
			assert(!expected)
		end
		
		def test_role_get_does_not_exist
			cnt = 0
			begin
				expected = $aut.role_create("testName".concat((cnt = cnt+1).to_s))
			end while(expected[0] == false)
			d = expected[1]["role"]["id"]
			$aut.role_delete(d)
			expected = $aut.role_get(d)[0]
			assert(!expected)
		end

	end #role_get
	
	begin #role_delete

		def test_role_delete
			cnt = 0
			begin
				expected = $aut.role_create("testName".concat((cnt = cnt+1).to_s))
			end while(expected[0] == false)
			d = expected[1]["role"]["id"]
			expected = $aut.role_delete(d)
			assert(expected[0])
		end	
		
		def test_role_delete_fail_to_authenticate
			expected = $fai.role_delete("ThisShouldn'tExist")[0]
			assert(!expected)
		end
		
		def test_role_delete_does_not_exist
			expected = $aut.role_delete("ThisShouldn'tExist")[0]
			assert(!expected)
		end
				

	end #role_delete
	
end
