require 'rubygems'
require 'curb'
require 'json'


#READ THIS FOR DOCUMENTATION
#http://docs.openstack.org/api/openstack-identity-service/2.0/content/
#http://docs.openstack.org/essex/openstack-compute/starter/content/Keystone_Commands-d1e2734.html

class Keystone

  def initialize(name, password, ip_address, port_1, port_2)
    @user_name  = name
    @password   = password
    @ip_address = ip_address
    @port_1     = port_1
    @port_2     = port_2
    @auth       = false
  end

  def auth(tenant)

    if (tenant == "")
      e1 = "Error in function auth: Invalid Tenant Name"
      return [false, e1]
    end

    auth = {"auth" => {"passwordCredentials" => {"username" => @user_name, "password" => @password},
                              "tenantName"   => tenant}}
    json_string = JSON.generate(auth)

    begin
      post_call   = Curl::Easy.http_post("#{@ip_address}:#{@port_1}/v2.0/tokens", json_string
      ) do |curl|
        curl.headers['Content-Type'] = 'application/json'
      end

      #store the token json info inside the object
      parsed_json = JSON.parse(post_call.body_str)

      if (parsed_json.to_s.include? 'error')
        error = parsed_json["error"]["message"]

        e2 = "Error in function auth: Failure to authenticate, reason: " + error.to_s
        return [false, e2]
      else
        @catalog_json = JSON.parse(post_call.body_str)
        @token_json   = @catalog_json["access"]["token"]
        @token        = @token_json["id"]
        @auth         = true
        return [true, "Successfully Authenticated"]
      end
    rescue
      e3 = "Error in function auth: Failure to reach server"
      return [false, e3]
    end
  end

  begin #USER OPS

    def user_password_update(user_id, password)
		  
      script     = {"user" => {"id" => user_id, "password" => password}}
      jsonscript = JSON.generate(script)
      get_call   = Curl::Easy.http_put("#{@ip_address}:#{@port_2}/v2.0/users/#{user_id}/OS-KSADM/password", jsonscript
      ) do |curl|
        curl.headers['x-auth-token'] = @token
        curl.headers['Content-Type'] = 'application/json'
      end
      return JSON.parse(get_call.body_str)
    end

    def user_get(user_id)

      get_call    = Curl::Easy.http_get("#{@ip_address}:#{@port_2}/v2.0/users/#{user_id}"
      ) do |curl|
        curl.headers['x-auth-token'] = @token
        curl.headers['userId']       = user_id
      end

      #puts "user_get returns"

      parsed_json = JSON.parse(get_call.body_str)

      #puts parsed_json
      return parsed_json
    end

    def user_create(username, email, password, tenant_id)


      user        = {"user" => {"name"     => username, "email" => email, "enabled" => true, "password" => password,
                                "tenantId" => tenant_id}}
      json_string = JSON.generate(user)
      post_call   = Curl::Easy.http_post("#{@ip_address}:#{@port_2}/v2.0/users", json_string
      ) do |curl|
        curl.headers['x-auth-token'] = @token
        curl.headers['Content-Type'] = 'application/json'
      end
      parsed_json = JSON.parse(post_call.body_str)

      if parsed_json.has_key? 'error'
        return [false, parsed_json['error']]
      end

      return parsed_json
    end

    def user_delete(user_id)

      if not user_get(user_id).has_key?('error')
        delete_call = Curl::Easy.http_delete("#{@ip_address}:#{@port_2}/v2.0/users/#{user_id}"
        ) do |curl|
          curl.headers['x-auth-token'] = @token
          curl.headers['userId']       = user_id
        end
        return true
      end
      return false
    end

    def user_list

      get_call    = Curl::Easy.http_get("#{@ip_address}:#{@port_2}/v2.0/users/"
      ) do |curl|
        curl.headers['x-auth-token'] = @token
      end
      parsed_json = JSON.parse(get_call.body_str)

      return parsed_json
    end

#_______________________________________________________________________________________________     
    def user_update(email, id)
=begin
      name_blank = (name.nil?) or (name.empty?)
      email_blank = (email.nil?) or (email.empty?)
      no_user = (user_get(id).nil?) or (user_get(id).empty?)

      if(name_blank && email_blank)
        comment = "No update occured: blank username and email."
        return [nil,comment]
      elsif(no_user)
        comment = "User update failed: no user for id #{id}."
        return [nil,comment]
      elsif(name_blank)   
        comment = "No username update occured."
        user = {"user" => {"email" => email, "enabled" => true}}
      elsif(email_blank)
        comment = "No email update occured."
        user = {"user" => {"name" => name, "enabled" => true}}
      else
        comment = "User successfully updated: #{name}, #{email}"
        user = {"user" => {"name" => name, "email" => email, "enabled" => true}}
      end
=end
      user = {"user" => {"email" => email, "enabled" => true}}
      json_string = JSON.generate(user)
      post_call   = Curl::Easy.http_put("#{@ip_address}:#{@port_2}/v2.0/users/#{id}/OS-KSADM/email", json_string
      ) do |curl|
        curl.headers['x-auth-token'] = @token
        curl.headers['Content-Type'] = 'application/json'
      end
      parsed_json = JSON.parse(post_call.body_str)

      if (parsed_json.to_s.include? 'error')
        error = parsed_json["error"]["message"]
        e = error.to_s
        return [nil, e]
      else
        return [parsed_json, "user updated successfully"]
      end

    end
  #_______________________________________________________________________________________________   
  end #USER OPS

  begin #SERVICE OPS

    def service_create(name, service_type, description)

      service     = {"OS-KSADM:service" =>
                         {"name"        => name,
                          "type"        => service_type,
                          "description" => description}}
      json_string = JSON.generate(service)
      post_call   = Curl::Easy.http_post("#{@ip_address}:#{@port_2}/v2.0/OS-KSADM/services", json_string
      ) do |curl|
        curl.headers['x-auth-token'] = @token
        curl.headers['Content-Type'] = 'application/json'
      end
      parsed_json = JSON.parse(post_call.body_str)
      if (parsed_json.keys? 'error') 
      	return [false,parsed_json]
      else 
      	return [true,parsed_json]
      end
    end

   def service_delete(id)

     if not service_get(id).has_key?('error')
	delete_call = Curl::Easy.http_delete("#{@ip_address}:#{@port_2}/v2.0/OS-KSADM/services/#{id}"
	) do |curl|
	curl.headers['x-auth-token'] = @token end
	parsed_json = JSON.parse(delete_call.body_str)
	return [true, parsed_json]
     else
	return [false, parsed_json]
     end
    end

    def service_get(id)

      get_call    = Curl::Easy.http_get("#{@ip_address}:#{@port_2}/v2.0/OS-KSADM/services/#{id}"
      ) do |curl|
        curl.headers['x-auth-token'] = @token
      end
      parsed_json = JSON.parse(get_call.body_str)
      if (parsed_json.keys? 'error')
	return [false, parsed_json]
      else
	return [true, parsed_json]
      end
    end

    def service_list
      get_call    = Curl::Easy.http_get("#{@ip_address}:#{@port_2}/v2.0/OS-KSADM/services"
      ) do |curl|
        curl.headers['x-auth-token'] = @token
      end
      parsed_json = JSON.parse(get_call.body_str)
      if (parsed_json.keys? 'error')
	return [false, parsed_json]
      else
	return [true, parsed_json]
      end
    end
  end #Service OPS

  begin #MISC. OPS
    def catalog
      return @catalog_json
    end

    def token_get()
      return @token_json
    end
  end #MISC. OPS

  begin #TENANT OPS

  
    def tenant_list
      get_call = Curl::Easy.http_get("#{@ip_address}:#{@port_2}/v2.0/tenants"
      ) do |curl|
        curl.headers['x-auth-token'] = @token
      end

      parsed_json = JSON.parse(get_call.body_str)

      return [true, parsed_json]
    end

    def tenant_get(tenant_id)

      get_call = Curl::Easy.http_get("#{@ip_address}:#{@port_2}/v2.0/tenants/#{tenant_id}"
      ) do |curl|
        curl.headers['x-auth-token'] = @token
      end

      parsed_json = JSON.parse(get_call.body_str)

      if (parsed_json.key? 'error')
        error = parsed_json["error"]["message"]
        e = error.to_s
        return [false, e]
      else
        return [true, parsed_json]
      end
    end

    def tenant_create(name, description)

      tenant      = {"tenant" => {"name" => name, "description" => description, "enabled" => true}}
      json_string = JSON.generate(tenant)
      post_call   = Curl::Easy.http_post("#{@ip_address}:#{@port_2}/v2.0/tenants", json_string
      ) do |curl|
        curl.headers['x-auth-token'] = @token
        curl.headers['Content-Type'] = 'application/json'
      end
      parsed_json = JSON.parse(post_call.body_str)

      if (parsed_json.key? 'error')
        error = parsed_json["error"]["message"]

        e = error.to_s
        return [false, e]
      else
        return [true, parsed_json]
      end
    end


    def tenant_update(name, description, id)

      tenant = {"tenant" => {"name" => name, "description" => description, "enabled" => true}}

      json_string = JSON.generate(tenant)
      post_call   = Curl::Easy.http_post("#{@ip_address}:#{@port_2}/v2.0/tenants/#{id}", json_string
      ) do |curl|
        curl.headers['x-auth-token'] = @token
        curl.headers['Content-Type'] = 'application/json'
      end
      parsed_json = JSON.parse(post_call.body_str)

      if (parsed_json.key? 'error')
        error = parsed_json["error"]["message"]

         e = error.to_s
        return [false, e]
      else
        return [true, parsed_json]
      end

    end

    def tenant_delete(tenant_id)

      begin
        delete_call = Curl::Easy.http_delete("#{@ip_address}:#{@port_2}/v2.0/tenants/#{tenant_id}"
        ) do |curl|
          curl.headers['x-auth-token'] = @token
          curl.headers['userId']       = tenant_id
        end

		parsed_json = JSON.parse(delete_call.body_str)
		
        return [true, parsed_json]

      rescue

        return [false, parsed_json]

      end
    end


  end #TENANT OPS

 begin #ROLE OPS	
		def role_create(name)
			role = {"role" => {"name" => name}}	
			json_string = JSON.generate(role)	
			post_call = Curl::Easy.http_post("#{@ip_address}:#{@port_2}/v2.0/OS-KSADM/roles", json_string
			) do |curl|
				curl.headers['x-auth-token'] = @token
				curl.headers['Content-Type'] = 'application/json'
			end
			parsed_json = JSON.parse(post_call.body_str)
			if (parsed_json.keys.include? 'error') return [false,parsed_json]
			else return [true,parsed_json]
			end
		end

		def role_delete(role)
			a = role_list
			if(a.values.include? role) 
				delete_call = Curl::Easy.http_delete("#{@ip_address}:#{@port_2}/v2.0/OS-KSADM/roles/#{role}"
				) do |curl|
					curl.headers['x-auth-token'] = @token
				end
				parsed_json = JSON.parse(delete_call.body_str)
				return [true,parsed_json]
			else
				return [false,nil]
			end
		end

		def role_get(role)
			get_call = Curl::Easy.http_get("#{@ip_address}:#{@port_2}/v2.0/OS-KSADM/roles/#{role}"
			) do |curl| curl.headers['x-auth-token'] = @token end
			parsed_json = JSON.parse(get_call.body_str)
			if (parsed_json.keys.include? 'error')
				return [false, parsed_json]
		   	else
				return [true, parsed_json]
			end
		end

		def role_list
			get_call = Curl::Easy.http_get("#{@ip_address}:#{@port_2}/v2.0/OS-KSADM/roles"
			) do |curl| curl.headers['x-auth-token'] = @token end
			parsed_json = JSON.parse(get_call.body_str)
			if (parsed_json.keys.include? 'error')
				return [false, parsed_json]
		   	else
				return [true, parsed_json]
			end
		end	
	end #ROLE OPS

	
  begin #USER_ROLE OPS
#_______________________________________________________________________________________________  
    def user_role_add(tenant_id, user_id, role_id)
      nil_error = (tenant_id.nil?) or (tenant_id.empty?) or
                  (user_id.nil?)   or (user_id.empty?)   or
                  (role_id.nil?)   or (role_id.empty?)
      role = (role_get(role_id))
                          
      if(nil_error)
        msg = "user_role_add unsuccessful: one of the fields was empty"
        return [false, msg]     
      elsif(tenant_get(tenant_id)[0].nil?)
        msg = "user_role_add unsuccessful: error produced for #{tenant_id}"
        return [false, msg]
      elsif(user_get(user_id).hasKey? 'error')
        msg = "user_role_add unsuccessful: error produced for #{user_id}"
        return [false, msg]
      elsif(role[0].nil?)
        msg = "user_role_add unsuccessful: error produced for #{role_id}"
        return [false, msg]
      end
      
      post_call = Curl::Easy.http_put("#{@ip_address}:#{@port_2}/v2.0/tenants/#{tenant_id}/users/#{user_id}/roles", role_id
      ) do |curl|
        curl.headers['x-auth-token'] = @token
        curl.headers['Content-Type'] = 'application/json'
      end
      parsed_json = JSON.parse(post_call.body_str)

      if (parsed_json.to_s.include? 'error')
        error = parsed_json["error"]["message"]
        e = error.to_s
        return [false, e]
      else
        return [true, "Role added successfully"]
      end
    end
#_______________________________________________________________________________________________      
    def user_role_remove(tenant_id, user_id, role_id)
      
      nil_error = (tenant_id.nil?) or (tenant_id.empty?) or
                  (user_id.nil?)   or (user_id.empty?)   or
                  (role_id.nil?)   or (role_id.empty?)
      roles = user_role_list(tenant_id, user_id)
      
      if(nil_error)
        msg = "user_role_remove unsuccessful: one of the fields was empty"
        return [false, msg]     
      elsif(tenant_get(tenant_id)[0].nil?)
        msg = "user_role_remove unsuccessful: error produced for #{tenant_id}"
        return [false, msg]
      elsif(user_get(user_id).hasKey? 'error')
        msg = "user_role_remove unsuccessful: error produced for #{user_id}"
        return [false, msg]
      elsif(role_get(role_id)[0].nil?)
        msg = "user_role_remove unsuccessful: error produced for #{role_id}"
        return [false, msg]
      elsif(!(roles.to_is.include? roles))
         msg = "Role is not assigned to user: #{role_id}"
         return [false, msg]
      end
      
      delete_call = Curl::Easy.http_delete("#{@ip_address}:#{@port_2}/v2.0/tenants/#{tenant_id}/users/#{user_id}/roles/#{role_id}}"
        ) do |curl|
        curl.headers['x-auth-token'] = @token
      end
      parsed_json = JSON.parse(delete_call.body_str)
      
      if(parsed_json.to_s.include? 'error')
        error = parsed_json["error"]["message"]
        e = error.to_s
        return [false, e]
      else
        return [true, "user_role_remove successful"]
      end
    end
    
#_______________________________________________________________________________________________ 
    def user_role_list(tenant_id, user_id)
      get_call = Curl::Easy.http_get("#{@ip_address}:#{@port_2}/v2.0/tenants/#{tenant_id}/users/#{user_id}/roles"
      ) do |curl|
        curl.headers['x-auth-token'] = @token
      end
      parsed_json = JSON.parse(get_call.body_str)
      if(parsed_json.to_s.include? 'error')
        error = parsed_json["error"]["message"]
        e = error.to_s
        return[nil, e]
      else
        return [parsed_json,"user_role_list success"]
      end
    end
#_______________________________________________________________________________________________ 

  end #USER_ROLE OPS

 begin #ENDPOINT OPS
 
    def endpoint_create(region, service_id, publicurl, adminurl, internalurl)
      body        = {"endpoint" => {"region"   => region, "service_id" => service_id,
 		"publicurl" => publicurl, "adminurl" => adminurl, "internalurl" => internalurl}}
      json_string = JSON.generate(body)
      post_call   = Curl::Easy.http_post("#{@ip_address}:#{@port_2}/v2.0/endpoints", json_string
      ) do |curl|
        curl.headers['x-auth-token'] = @token
        curl.headers['Content-Type'] = 'application/json'
      end
      parsed_json = JSON.parse(post_call.body_str)
      return parsed_json
    end

    def endpoint_delete(endpoint_id)
		begin
		  delete_call = Curl::Easy.http_delete("#{@ip_address}:#{@port_2}/v2.0/endpoints/#{endpoint_id}"
		  ) do |curl|
			curl.headers['x-auth-token'] = @token
		  end
		  return [true,JSON.parse(delete_call.body_str)]
		rescue
		  return [false,JSON.parse(delete_call.body_str)]
		end
    end

    def endpoint_get(endpoint_id)
      value = endpoint_list[1]["endpoints"]
      count = 0
      while count < value.length do
        if (value[count]["id"] == endpoint_id) then return [true,value[count]] end
        count += 1
      end
      return [false,nil]
    end

    def endpoint_list
      get_call    = Curl::Easy.http_get("#{@ip_address}:#{@port_2}/v2.0/endpoints/"
      ) do |curl|
        curl.headers['x-auth-token'] = @token
      end
      parsed_json = JSON.parse(get_call.body_str)
      return [true,parsed_json] #No obvious fail case on our side
    end
  end #ENDPOINT OPS
end


