require '/home/thicks/Desktop/keiths/Keystone.rb'
require 'test/unit'
#testing the endpoint functions
#demo trinitytu 131.194.71.143 5000 35357
class TestRole < Test::Unit::TestCase
  #("admin","password","http://198.61.199.47","5000","35357")
	def initialize(name, password, ip_address, port_1, port_2, ten)
@aut = Keystone.new(name,password,ip_address,port_1,port_2)
@fai = Keystone.new(name,name.concat("1"),ip_address,port_1,port_2)
	aut.auth(ten)
	fai.auth(ten)
	end
	
	begin #endpoint_list
		def test_endpoint_list
			expected = aut.endpoint_list
			assert(expected[0])
		end
		def test_endpoint_list_fail_to_authenticate
			expected = fai.endpoint_list
			assert(!expected[0])
	end #endpoint_list

	begin #endpoint_delete
		#NOTE: Utilizes get and create to clean up data
		def test_endpoint_delete
			servID = aut.service_list[1]["OS-KSADM:services"][0]["id"] # retrieve service ID
			expected = aut.endpoint_create("dummyDebug",servID,"1","1","1")
			assert(expected[0])
			deleted = aut.endpoint_delete(expected[1]["endpoint"]["id"])
			assert(deleted[0])
			expected = aut.endpoint_get(expected[1]["endpoint"]["id"])
			assert(!expected[0])
		end	
		
		def test_endpoint_delete_fail_to_authenticate #NOTE uses authenticated endpoint list
			endptID = aut.endpoint_list[1]["endpoints"][0]["id"] # retrieve endpoint ID
			expected = fai.endpoint_delete(endptID)
			assert(!expected[0])
		end
		
		def test_endpoint_delete_does_not_exist
			id = "00000000000000000000000000000000" # Could try to use a non-hex string to ensure, but won't
			expected = aut.endpoint_delete(id)
			assert(!expected[0])
		end
	end #endpoint_delete

	begin #endpoint_get
		#NOTE: Utilizes delete and create to clean up data
		def test_endpoint_get
			servID = aut.service_list[1]["OS-KSADM:services"][0]["id"] # retrieve service ID
			expected = aut.endpoint_create("dummyDebug",servID,"1","1","1")
			assert(expected[0])
			deleted = aut.endpoint_delete(expected[1]["endpoint"]["id"])
			assert(deleted[0])
			expected = aut.endpoint_get(expected[1]["endpoint"]["id"])
			assert(!expected[0])
		end
		
		def test_endpoint_get_fail_to_authenticate #NOTE uses authenticated endpoint list
			endptID = aut.endpoint_list[1]["endpoints"][0]["id"] # retrieve endpoint ID
			expected = fai.endpoint_get(endptID)
			assert(!expected[0])
		end
		
		def test_endpoint_get_does_not_exist
			id = "00000000000000000000000000000000" # Could try to use a non-hex string to ensure, but won't
			expected = aut.endpoint_get(id)
			assert(!expected[0])
		end
	end #endpoint_get
	
	begin #endpoint_create 
		#NOTE: Utilizes delete and get to clean up data
		def test_endpoint_create
			servID = aut.service_list[1]["OS-KSADM:services"][0]["id"] # retrieve service ID
			expected = aut.endpoint_create("dummyDebug",servID,"1","1","1")
			assert(expected[0])
			deleted = aut.endpoint_delete(expected[1]["endpoint"]["id"])
			assert(deleted[0])
			expected = aut.endpoint_get(expected[1]["endpoint"]["id"])
			assert(!expected[0])
		end	

		def test_endpoint_create_fail_to_authenticate #NOTE uses authenticated service, failed endpoint
			servID = aut.service_list[1]["OS-KSADM:services"][0]["id"] # retrieve service ID
			expected = fai.endpoint_create("dummyDebug",servID,"1","1","1")
			assert(!expected[0])
		end
	end #endpoint_create	
end
