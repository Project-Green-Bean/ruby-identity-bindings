require File.join(File.dirname(__FILE__), '../lib/keystone.rb')
require 'test/unit'
require File.join(File.dirname(__FILE__), '../test/test_parameters.rb')

class TestService < Test::Unit::TestCase
	
	$aut = Keystone.new($admin,$adminPass,$serverURL,$serverPort1,$serverPort2)
	$fai = Keystone.new($admin,$randomPass,$serverURL,$serverPort1,$serverPort2)
	$aut.auth($tenant)
	$fai.auth($tenant)
	
	begin #service_list
		def test_service_list	
			expected = $aut.service_list[0]
			assert(expected.has_key? 'OS-KSADM:services')
		end
		
		def test_service_list_fail_to_authenticate
			expected = $fai.service_list[0]
			assert(expected.has_key?("error"))
		end
	end #service_list
	
	begin #service_create 
		#Extra Functions Service_Delete/Get
		def test_service_create
			count = 0
			begin
				expected = $aut.service_create("TestService".concat((count = count+1).to_s),"TestService", "This is a test description")
			end while(expected[0].has_key?("error"))
			expectedID = expected[0]["OS-KSADM:service"]["id"]
			$aut.service_get(expectedID)
			$aut.service_delete(expectedID)
			assert(expected[0].has_key?("OS-KSADM:service"))
		end
		
		def test_service_create_fail_to_authenticate
			expected = $fai.service_create("TestService", "TestService", "This is a test description")[0]
			assert(expected.has_key?("error"))
		end	
=begin
		def test_service_create_already_exists
			expected = $aut.service_create($existingService, $existingType, $existingDescription)
			assert(expected.has_key?("error"))
		end
=end
	end #service_create
	
	begin #service_get
		def test_service_get
			count = 0
			begin
				serviceID = $aut.service_create("TestService".concat((count = count+1).to_s),"TestService", "This is a test description")[0]
			end while(serviceID.has_key?("error"))
			serviceID = serviceID["OS-KSADM:service"]["id"]
			expected = $aut.service_get(serviceID)[0]["OS-KSADM:service"]["id"]
			$aut.service_delete(serviceID)
			assert_equal(expected, serviceID)
		end
		
		def test_service_get_fail_to_authenticate
			count = 0
			begin
				serviceID = $aut.service_create("TestService".concat((count = count+1).to_s),"TestService", "This is a test description")[0]
			end while(serviceID.has_key?("error"))
			serviceID = serviceID["OS-KSADM:service"]["id"]
			expected = $fai.service_get(serviceID)
			$aut.service_delete(serviceID)
			assert(expected == nil)
		end
		
		def test_service_get_does_not_exist
			expected = $aut.service_get("TestService")[0]
			assert(expected == nil)
		end
	end #service_get
	
	begin #service_delete
		#Extra Functions service_Delete/Get
		def test_service_delete
			count = 0
			begin
				expected = $aut.service_create("TestService".concat((count = count+1).to_s), "TestService", "This is a test description")[0]
			end while(expected.has_key?("error"))
			expected = expected["OS-KSADM:service"]["id"]
			$aut.service_get(expected)
			expected = $aut.service_delete(expected)[0]
			assert(expected == true)
		end	
		
		def test_service_delete_fail_to_authenticate
			real = $aut.service_create("TestService", "TestService", "This is a test description")["OS-KSADM:service"]["id"][0]
			expected = $fai.service_delete("123456")
			$aut.service_delete(real)
			assert(expected == false)
		end
		
		def test_service_delete_does_not_exist
			expected = $aut.service_delete("123456")[0]
			assert(expected == false)
		end
	end #service_delete
	

end
