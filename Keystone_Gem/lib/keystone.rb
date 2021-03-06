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
      user = {"user" => {"id" => id, "email" => email}}
      json_string = JSON.generate(user)
      new_url = "#{@ip_address}:#{@port_2}/v2.0/users/#{id}", flag = true
      begin
        put_call = Curl::Easy.http_put(new_url, json_string
        ) do |curl|
          curl.headers['x-auth-token'] = @token
          curl.headers['Content-Type'] = 'application/json'
        end
        parsed_json = JSON.parse(put_call.body_str)

        if (parsed_json.key? 'error')
          error = parsed_json["error"]["message"] 
          return [flag, error.to_s]
        else
          return [flag, parsed_json]
        end
      rescue
        error = "failed to update user -- put call failed"
        return [flag, error]
      end
    end
 
    
    def user_role_list(tenant_id, user_id)
      new_url = "#{@ip_address}:#{@port_2}/v2.0/tenants/#{tenant_id}/users/#{user_id}/roles", flag = true
      begin
        get_call = Curl::Easy.http_get(new_url
        ) do |curl|
          curl.headers['x-auth-token'] = @token
        end
        parsed_json = JSON.parse(get_call.body_str)
        if(parsed_json.to_s.include? 'error')
          error = parsed_json["error"]["message"]
          e = error.to_s
          return [flag, e]
        else
          return [flag,parsed_json]
        end
      rescue
        m = "get call for user_role_list failed"
        return [flag,m]
      end
    end

    def user_role_add(tenant_id, user_id, role_id)
      role = {"role" => {"id" => role_id}}
      json_string = JSON.generate(role)
      new_url = "#{@ip_address}:#{@port_2}/v2.0/tenants/#{tenant_id}/users/#{user_id}/roles/OS-KSADM/#{role_id}", flag = true
      begin
        put_call = Curl::Easy.http_put(new_url, json_string
        ) do |curl|
          curl.headers['x-auth-token'] = @token
          curl.headers['Content-Type'] = 'application/json'
        end
        parsed_json = JSON.parse(put_call.body_str)

        if (parsed_json.key? 'error')
          error = parsed_json["error"]["message"]
          e = error.to_s
          return [flag, e]
        else
          return [flag, "Role added successfully"]
        end
      rescue
        m = "error with put_call in user_role_add"
        return [flag, m]
      end
    end
    
    def user_role_remove(tenant_id, user_id, role_id)
      new_url = "#{@ip_address}:#{@port_2}/v2.0/tenants/#{tenant_id}/users/#{user_id}/roles/OS-KSADM/#{role_id}}", flag = true
      begin
        delete_call = Curl::Easy.http_delete(new_url
        ) do |curl|
          curl.headers['x-auth-token'] = @token
          curl.headers['Content-Type'] = 'application/json'
        end
        parsed_json = JSON.parse(delete_call.body_str)

        if(parsed_json.to_s.include? 'error')
          error = parsed_json["error"]["message"]
          e = error.to_s
          return [flag, e]
        else
          return [flag, "user_role_remove successful"]
        end
      rescue
        m = "error with delete_call in user_role_remove"
        return [flag,m]
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
      if (parsed_json.key? 'error')
        return [false,parsed_json]
      else
        return [true,parsed_json]
      end
    end

    def service_delete(id)

      if not service_get(id)[1].key?('error')
        delete_call = Curl::Easy.http_delete("#{@ip_address}:#{@port_2}/v2.0/OS-KSADM/services/#{id}"
        ) do |curl|
          curl.headers['x-auth-token'] = @token end
        parsed_json = delete_call.body_str
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
      if (parsed_json.key? 'error')
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
      if (parsed_json.key? 'error')
        return [false, parsed_json]
      else
        return [true, parsed_json]
      end
    end
  end #Service OPS

  begin #MISC. OPS
    def catalog
	
	if(@auth == false)
		return [false, nil]
	else
		return [true,@catalog_json]
	end
    end

    def token_get()
      if(@auth == false)
		return [false, nil]
	else
		return [true,@token_json]
	end
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
        end

        if (delete_call.body_str).empty?
			return [true, nil]
		else
			parsed_json = JSON.parse(delete_call.body_str)
			
			if parsed_json.key? 'error'
				return [false, parsed_json]
			else
				return [true, nil]
			end
		end

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
      if (parsed_json.key? 'error') then return [false,parsed_json]
      else return [true,parsed_json]
      end
    end

    def role_delete(role)
	  	a = role_list
	    delete_call = Curl::Easy.http_delete("#{@ip_address}:#{@port_2}/v2.0/OS-KSADM/roles/#{role}"
	    ) do |curl|
	      curl.headers['x-auth-token'] = @token
	    end

		if((delete_call.body_str).empty?) then 
			return [true,nil]
	  	else 
			parsed_json = JSON.parse(delete_call.body_str)
		end
	    if(parsed_json.key?("error")) then 
			return [false,parsed_json]
        else 
			return [true,parsed_json] 
		end 
	end

    def role_get(role)
      get_call = Curl::Easy.http_get("#{@ip_address}:#{@port_2}/v2.0/OS-KSADM/roles/#{role}"
      ) do |curl| curl.headers['x-auth-token'] = @token end
      parsed_json = JSON.parse(get_call.body_str)
      if (parsed_json.key? 'error')
        return [false, parsed_json]
      else
        return [true, parsed_json]
      end
    end

    def role_list
      get_call = Curl::Easy.http_get("#{@ip_address}:#{@port_2}/v2.0/OS-KSADM/roles"
      ) do |curl| curl.headers['x-auth-token'] = @token end
      parsed_json = JSON.parse(get_call.body_str)
      if (parsed_json.key? 'error')
        return [false, parsed_json]
      else
        return [true, parsed_json]
      end
    end
  end #ROLE OPS


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
	  if(parsed_json.key?("error")) then return [false,parsed_json]
      else return [true,parsed_json] end
    end

    def endpoint_delete(endpoint_id)
	  delete_call = Curl::Easy.http_delete("#{@ip_address}:#{@port_2}/v2.0/endpoints/#{endpoint_id}"
	  ) do |curl|
		curl.headers['x-auth-token'] = @token
	  end
	  if((delete_call.body_str).empty?) then return [true,nil] # What is the hex thing
	  else 
		parsed_json = JSON.parse(delete_call.body_str)
	    if(parsed_json.key?("error")) then return [false,parsed_json]
        else return [true,parsed_json] end # Should never occur (Delete always errors or empties)
	  end
    end

    def endpoint_get(endpoint_id)
      list = endpoint_list
	  if(list[0]) then
		value = list[1]["endpoints"]
		count = 0
		while count < value.length do
		  if (value[count]["id"] == endpoint_id) then return [true,value[count]] end
		count += 1
		end
	  end
      return [false,nil]
    end

    def endpoint_list
      get_call    = Curl::Easy.http_get("#{@ip_address}:#{@port_2}/v2.0/endpoints/"
      ) do |curl|
        curl.headers['x-auth-token'] = @token
      end
      parsed_json = JSON.parse(get_call.body_str)
	  if(parsed_json.key?("error")) then return [false,parsed_json]
      else return [true,parsed_json] end
    end
  end #ENDPOINT OPS
end
