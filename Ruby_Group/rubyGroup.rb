require 'rubygems'
require 'curb'
require 'json'


#READ THIS FOR DOCUMENTATION
#http://docs.openstack.org/api/openstack-identity-service/2.0/content/
#http://docs.openstack.org/essex/openstack-compute/starter/content/Keystone_Commands-d1e2734.html


class Auth
	begin #USER OPS
		#----------
		#Initialize
		#----------
		def initialize(name, password, ip_address, port_1, port_2)
			@user_name = name
			@password = password
			@ip_address = ip_address
			@port_1 = port_1
			@port_2 = port_2
		end
		
		def increment(num)
			puts num
		end

		#----------
		#Auth
		#----------
		def auth(tenant)
			auth = {"auth" => {"passwordCredentials" => {"username" => @user_name, "password" => @password}, 
				"tenantName" => tenant}}
			json_string = JSON.generate(auth)
			post_call = Curl::Easy.http_post("#{@ip_address}:#{@port_1}/v2.0/tokens", json_string
			)do |curl|  curl.headers['Content-Type'] = 'application/json' end
			parsed_json = JSON.parse(post_call.body_str)
			@token = parsed_json["access"]["token"]["id"]
			return @token
		end

		#----------
		#User Pass Update
		#----------
		def user_password_update(user_id, password)
			script = {"user" => {"id" => user_id,"password" => password}}
			jsonscript = JSON.generate(script)
			puts jsonscript
	   		get_call = Curl::Easy.http_put("#{@ip_address}:#{@port_2}/v2.0/users/#{user_id}/OS-KSADM/password", jsonscript
			)do |curl|
		  		curl.headers['x-auth-token'] = @token
		  		curl.headers['Content-Type'] = 'application/json'
			end
			puts JSON.parse(get_call.body_str)
	  	end

		#----------
		#User Get
		#----------
		def user_get(user_id)
			get_call = Curl::Easy.http_get("#{@ip_address}:#{@port_2}/v2.0/users/#{user_id}"
			) do |curl|
			  curl.headers['x-auth-token'] = @token
			  curl.headers['userId'] = user_id
			end

			puts "user_get returns"

			parsed_json = JSON.parse(get_call.body_str)

			puts parsed_json
			return parsed_json
		end
		
		#----------
		#User Create
		#----------
		def user_create(username, email, password, tenant_id)
			user = {"user" => {"name" => username, "email" => email, "enabled" => true, "password" => password, 
				"tenantid" => tenant_id}}
			json_string = JSON.generate(user)
			post_call = Curl::Easy.http_post("#{@ip_address}:#{@port_2}/v2.0/users", json_string
			) do |curl|
				curl.headers['x-auth-token'] = @token
				curl.headers['Content-Type'] = 'application/json'
			end
			parsed_json = JSON.parse(post_call.body_str)
			puts parsed_json
			return parsed_json
		end

		#----------
		#User Delete
		#----------
		def user_delete(user_id)
			delete_call = Curl::Easy.http_delete("#{@ip_address}:#{@port_2}/v2.0/users/#{user_id}"
			) do |curl|
				curl.headers['x-auth-token'] = @token
				curl.headers['userId'] = user_id
			end
		end 

		#----------
		#User List
		#----------
		def user_list
			get_call = Curl::Easy.http_get("#{@ip_address}:#{@port_2}/v2.0/users/",
			) do |curl| curl.headers['x-auth-token'] = @token end
				parsed_json = JSON.parse(get_call.body_str)
				puts parsed_json
			return parsed_json
		end
	end #USER OPS

  	begin #Service OPS
		#----------
		#Service Create
		#----------
		def service_create(name, service_type, description) #Add service to Service Catalog
			service = {"OS-KSADM:service" =>
				{"name" => name,
			     "type" => service_type,
			     "description" => description}}
			json_string = JSON.generate(service)
			post_call = Curl::Easy.http_post("#{@ip_address}:#{@port_2}/v2.0/OS-KSADM/services", json_string
			) do |curl|
				curl.headers['x-auth-token'] = @token
				curl.headers['Content-Type'] = 'application/json'
			end
			parsed_json = JSON.parse(post_call.body_str)
			puts parsed_json
			return parsed_json
		end

		#----------
		#Service Delete
		#----------
	  	def service_delete(id) #Delete service from Service Catalog
			delete_call = Curl::Easy.http_delete("#{@ip_address}:#{@port_2}/v2.0/OS-KSADM/services/#{id}"
			) do |curl|	curl.headers['x-auth-token'] = @token end
	  	end

		#----------
		#Service Get
		#----------
	  	def service_get(id) #Display service from Service Catalog
			get_call = Curl::Easy.http_get("#{@ip_address}:#{@port_2}/v2.0/OS-KSADM/services/#{id}"
			)do |curl|curl.headers['x-auth-token'] = @token end
			puts "invoking service-get..."
			parsed_json = JSON.parse(get_call.body_str)
			puts parsed_json
			return parsed_json
	  	end

		#----------
		#Service List
		#----------
	  	def service_list() #List all services in Service Catalog
			get_call = Curl::Easy.http_get("#{@ip_address}:#{@port_2}/v2.0/OS-KSADM/services"
			) do |curl| curl.headers['x-auth-token'] = @token end
			puts "invoking service-list..."
			parsed_json = JSON.parse(get_call.body_str)
			puts parsed_json
			return parsed_json
	  	end
  	end #Service OPS

	begin #MISC. OPS
		#----------
		#Catalog
		#----------
		def catalog
			get_call = Curl::Easy.http_get("#{@ip_address}:#{@port_2}/v2.0/tokens/#{@token}"
			) do |curl| curl.headers['x-auth-token'] = @token end

			puts "Here is the catalog for this tenant... \n\n"
			parsed_json = JSON.parse(get_call.body_str)

			puts parsed_json
			return parsed_json
		end

	
		#----------
		#Token Get
		#----------
		def token_get()
			puts "Here is the token " + @token
		end
	end #MISC. OPS


	begin #TENANT OPS
		#----------
		#Tenant Get
		#----------
		def tenant_get(tenant_id)
			get_call = Curl::Easy.http_get("#{@ip_address}:#{@port_2}/v2.0/tenants/#{tenant_id}"
			) do |curl| curl.headers['x-auth-token'] = @token end
			parsed_json = JSON.parse(get_call.body_str)
			puts parsed_json
			return parsed_json
		end

		#----------
		#Tenant List
		#----------
		def tenant_list
			get_call = Curl::Easy.http_get("#{@ip_address}:#{@port_2}/v2.0/tenants"
			) do |curl| curl.headers['x-auth-token'] = @token end
			parsed_json = JSON.parse(get_call.body_str)
			puts parsed_json
			return parsed_json
		end

		#----------
		#Tenant Create
		#----------
		def tenant_create(name, description)
			tenant = {"tenant" => {"name" => name, "description" => description, "enabled" => true}}
			json_string = JSON.generate(tenant)
			post_call = Curl::Easy.http_post("#{@ip_address}:#{@port_2}/v2.0/tenants", json_string
			) do |curl|
				curl.headers['x-auth-token'] = @token
				curl.headers['Content-Type'] = 'application/json'
			end
			parsed_json = JSON.parse(post_call.body_str)
			puts parsed_json
			return parsed_json
		end

		#----------
		#Tenant Update
		#----------
		def tenant_update(name, description, id)
			if(name.length != 0 and description.length != 0 and id.length != 0)
				tenant = {"tenant" => {"name" => name, "description" => description, "enabled" => true}}
			end
			json_string = JSON.generate(tenant)
			post_call = Curl::Easy.http_post("#{@ip_address}:#{@port_2}/tenants/#{id}", json_string
			) do |curl|
				curl.headers['x-auth-token'] = @token
				curl.headers['Content-Type'] = 'application/json'
			end
			parsed_json = JSON.parse(post_call.body_str)
			puts parsed_json
			return parsed_json
		end

		#----------
		#Tenant Delete
		#----------
		def tenant_delete(tenant_id)
			delete_call = Curl::Easy.http_delete("#{@ip_address}:#{@port_2}/v2.0/tenants/#{tenant_id}"
			) do |curl|
				curl.headers['x-auth-token'] = @token
				curl.headers['userId'] = tenant_id
			 end
		end
	end #TENANT OPS

	begin #ROLE OPS	
		#----------
		#Role Create
		#----------
		def role_create(name)
			role = {"role" => {"name" => name}}	
			json_string = JSON.generate(role)	
			post_call = Curl::Easy.http_post("#{@ip_address}:#{@port_2}/v2.0/OS-KSADM/roles", json_string
			) do |curl|
				curl.headers['x-auth-token'] = @token
				curl.headers['Content-Type'] = 'application/json'
			end
			parsed_json = JSON.parse(post_call.body_str)
			puts parsed_json
			return parsed_json
		end

		#----------
		#Role Delete
		#----------
		def role_delete(role)
			delete_call = Curl::Easy.http_delete("#{@ip_address}:#{@port_2}/v2.0/OS-KSADM/roles/#{role}"
			) do |curl|
				curl.headers['x-auth-token'] = @token
			end
			puts "invoked role delete"
		end

		#----------
		#Role Get
		#----------
		def role_get(role)
			get_call = Curl::Easy.http_get("#{@ip_address}:#{@port_2}/v2.0/OS-KSADM/roles/#{role}"
			) do |curl| curl.headers['x-auth-token'] = @token end

			parsed_json = JSON.parse(get_call.body_str)

			puts parsed_json
			return parsed_json
		end

		#----------
		#Role List
		#----------
		def role_list
			get_call = Curl::Easy.http_get("#{@ip_address}:#{@port_2}/v2.0/OS-KSADM/roles"
			) do |curl| curl.headers['x-auth-token'] = @token end

			parsed_json = JSON.parse(get_call.body_str)

			puts parsed_json
			return parsed_json
		end

		#----------
		#User Role Add
		#----------
		def user_role_add(tenant_id, user_id, role_id)	
			update_call = Curl::Easy.http_put("#{@ip_address}:#{@port_2}/v2.0/tenants/#{tenant_id}/users/#{user_id}/roles/OS-KSADM/#{role_id}", nil
			) do |curl|
				curl.headers['x-auth-token'] = @token
			end		
			return
		end
	
		#----------
		#User Role Remove
		#----------
		def user_role_remove(tenant_id, user_id, role_id)
			delete_call = Curl::Easy.http_delete("#{@ip_address}:#{@port_2}/v2.0/tenants/#{tenant_id}/users/#{user_id}/roles/OS-KSADM/#{role_id}"
			) do |curl| curl.headers['x-auth-token'] = @token end
		
		end
	
		#----------
		#User Role List
		#----------
		def user_role_list(tenant_id, user_id)	
			get_call = Curl::Easy.http_get("#{@ip_address}:#{@port_2}/v2.0/tenants/#{tenant_id}/users/#{user_id}/roles"
			) do |curl| curl.headers['x-auth-token'] = @token end		
			parsed_json = JSON.parse(get_call.body_str)		
			puts parsed_json
			return parsed_json
		end
	
	end #ROLE OPS

	begin #ENDPOINT OPS
		#----------
		#Endpoint Create
		#----------
		def endpoint_create(region, service_id, publicurl, adminurl,internalurl)	
			body = {"endpoint" => {"region" => region, "service_id" => service_id, "publicurl" => publicurl, 
				"adminurl" => adminurl, "internalurl" => internalurl}}	
			json_string = JSON.generate(body)	
			post_call = Curl::Easy.http_post("#{@ip_address}:#{@port_2}/v2.0/endpoints", json_string
			) do |curl|
				curl.headers['x-auth-token'] = @token
				curl.headers['Content-Type'] = 'application/json'
			end									  
			parsed_json = JSON.parse(post_call.body_str)		
			puts parsed_json
			return parsed_json
		end

		#----------
		#Endpoint Delete
		#----------
		def endpoint_delete(endpoint_id)
			puts "Tried delete operation"
			delete_call = Curl::Easy.http_delete("#{@ip_address}:#{@port_2}/v2.0/endpoints/#{endpoint_id}"
			) do |curl|
				curl.headers['x-auth-token'] = @token
			end	
		end

		#----------
		#Endpoint Get
		#----------
		def endpoint_get(endpoint_id)
			puts "Tried get operation"
			value = endpoint_list["endpoints"]
			count = 0
			while count < value.length  do
				if(value[count]["id"] == endpoint_id) then 
					return value[count]
				end
				count += 1
			end
			return "No value found"	
		end

		#----------
		#Endpoint List
		#----------
		def endpoint_list
			get_call = Curl::Easy.http_get("#{@ip_address}:#{@port_2}/v2.0/endpoints/",
			) do |curl| curl.headers['x-auth-token'] = @token end
		
			#puts "Here is a list of endpoints..."
			parsed_json = JSON.parse(get_call.body_str)
		
			#puts parsed_json
			return parsed_json
		end
	end #ENDPOINT OPS
end

c = Auth.new("admin","password","http://198.61.199.47","5000","35357")
c.auth("tenant1")

c.user_list
c.tenant_list

c.user_role_add("14c7cb7d417b4f0fabd3c24f3cd41386", "71053653d11044ce9ae269a958c6e9ec", "9d0676f1dd80425ca4c82ef2b944d59f")
c.user_role_list("14c7cb7d417b4f0fabd3c24f3cd41386", "71053653d11044ce9ae269a958c6e9ec")
c.user_role_remove("14c7cb7d417b4f0fabd3c24f3cd41386", "71053653d11044ce9ae269a958c6e9ec", "9d0676f1dd80425ca4c82ef2b944d59f")
c.user_role_list("14c7cb7d417b4f0fabd3c24f3cd41386", "71053653d11044ce9ae269a958c6e9ec")
