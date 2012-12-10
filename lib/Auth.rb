require 'rubygems'
require 'curb'
require 'json'


#READ THIS FOR DOCUMENTATION
#http://docs.openstack.org/api/openstack-identity-service/2.0/content/
#http://docs.openstack.org/essex/openstack-compute/starter/content/Keystone_Commands-d1e2734.html


class Auth

	def initialize(name, password, ip_address, port_1, port_2)
		@user_name = name
		@password = password
		@ip_address = ip_address
		@port_1 = port_1
		@port_2 = port_2
	end
	
	#Authenticate to generate a (admin) token.
	def auth(tenant)
		
		auth = {"auth" => {"passwordCredentials"  => {"username" => @user_name, "password" => @password}, "tenantName" => tenant}}
		
		json_string = JSON.generate(auth)
		
		post_call = Curl::Easy.http_post("#{@ip_address}:#{@port_1}/v2.0/tokens", json_string
		)do |curl|  curl.headers['Content-Type'] = 'application/json' end
		
		parsed_json = JSON.parse(post_call.body_str)
		@token = parsed_json["access"]["token"]["id"]
		
		return @token
	end
	
	
	begin #TENANT OPS
	#//////////////////////////////////////////////////////////////////////////////////////////////////
	#TENANT OPS
	#//////////////////////////////////////////////////////////////////////////////////////////////////
	
	#--------------------------------------------------------------------------------------------------
	#tenant_get
	#Description: Display tenant details
	# -------------------------------------------------------------------------------------------------
	def tenant_get(tenant_id)
		
		get_call = Curl::Easy.http_get("#{@ip_address}:#{@port_2}/v2.0/tenants/#{tenant_id}"
		) do |curl| curl.headers['x-auth-token'] = @token end
		
		#TODO -- it's working when you pass it an id in the url...figure out how to make it work when passed just the name???
		puts "invoking tenant-get..."
		
		parsed_json = JSON.parse(get_call.body_str)
		
		puts parsed_json
		return parsed_json
	end
	
	
	#--------------------------------------------------------------------------------------------------
	#tenant_list             
	#Description: List all tenants
	# -------------------------------------------------------------------------------------------------
	def tenant_list
		
		get_call = Curl::Easy.http_get("#{@ip_address}:#{@port_2}/v2.0/tenants"
		) do |curl| curl.headers['x-auth-token'] = @token end
		
		puts "invoking tenant-list..."
		
		parsed_json = JSON.parse(get_call.body_str)
		
		puts parsed_json
		return parsed_json
	end
	
	
	#--------------------------------------------------------------------------------------------------
	#tenant-create           
	#Description: Create new tenant
	# -------------------------------------------------------------------------------------------------
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
	
	#--------------------------------------------------------------------------------------------------
	#tenant-update          
	#Description: Update tenant name, description, enabled status
	# -------------------------------------------------------------------------------------------------
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
	
	#--------------------------------------------------------------------------------------------------
	#tenant-delete          
	#Description: Delete tenant
	# -------------------------------------------------------------------------------------------------
	def tenant_delete(tenant_id)
	
		delete_call = Curl::Easy.http_delete("#{@ip_address}:#{@port_2}/v2.0/tenants/#{tenant_id}"
		) do |curl|
			curl.headers['x-auth-token'] = @token
			curl.headers['userId'] = tenant_id
		 end
		
		puts "invoked tenant delete"
	end
	
	
	end #TENANT OPS
	
	begin #USER OPS
	
	#//////////////////////////////////////////////////////////////////////////////////////////////////										
	#USER OPS
	#//////////////////////////////////////////////////////////////////////////////////////////////////
	
	#--------------------------------------------------------------------------------------------------
	#user_create               
	#Description: Create new user
	# -------------------------------------------------------------------------------------------------
	def user_create(username, email, password, tenant_id)
	
		user = {"user" => {"name" => username, "email" => email, "enabled" => true, "password" => password, "tenantid" => tenant_id}}
	
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



	#--------------------------------------------------------------------------------------------------
	#user_delete
	#Description: Delete user
	# -------------------------------------------------------------------------------------------------
	def user_delete(user_id)
		delete_call = Curl::Easy.http_delete("#{@ip_address}:#{@port_2}/v2.0/users/#{user_id}"
		) do |curl|
			curl.headers['x-auth-token'] = @token
			curl.headers['userId'] = user_id
		end
	
	end 
	
	#--------------------------------------------------------------------------------------------------
	#user_list
	#Description: List users
	# -------------------------------------------------------------------------------------------------
	def user_list
		get_call = Curl::Easy.http_get("#{@ip_address}:#{@port_2}/v2.0/users/"
		) do |curl| curl.headers['x-auth-token'] = @token end
		
		puts "Here is a list of users..."
		parsed_json = JSON.parse(get_call.body_str)
		
		puts parsed_json
		return parsed_json
	end






	end #USER OPS
	
	begin #MISC. OPS
	#//////////////////////////////////////////////////////////////////////////////////////////////////
	#MISC. OPS
	#//////////////////////////////////////////////////////////////////////////////////////////////////
	
	#--------------------------------------------------------------------------------------------------
	#CATALOG
	# -------------------------------------------------------------------------------------------------
	def catalog
		get_call = Curl::Easy.http_get("#{@ip_address}:#{@port_2}/v2.0/tokens/#{@token}"
		) do |curl| curl.headers['x-auth-token'] = @token end
		
		puts "Here is the catalog for this tenant... \n\n"
		parsed_json = JSON.parse(get_call.body_str)
		
		puts parsed_json
		return parsed_json
	end

	#--------------------------------------------------------------------------------------------------
	#token_get
	#Description: Display the current user token
	#--------------------------------------------------------------------------------------------------
	def token_get()
		puts "Here is the token  " + @token
	end

	end #MISC. OPS

end






