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
      puts "Error in function auth: Invalid Tenant Name"

      return false
    end

    auth        = {"auth" => {"passwordCredentials" => {"username" => @user_name, "password" => @password},
                              "tenantName"          => tenant}}
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

        puts "Error in function auth: Failure to authenticate, reason: " + error.to_s
        return false
      else
        @catalog_json = JSON.parse(post_call.body_str)
        @token_json   = @catalog_json["access"]["token"]
        @token        = @token_json["id"]
        @auth         = true
        return true
      end
    rescue
      puts "Error in function auth: Failure to reach server"
      return false
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
      #puts parsed_json
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
      #puts JSON.pretty_generate(parsed_json)
      return parsed_json
    end
  end #USER OPS

  begin #Service OPS

    def service_create(name, service_type, description) #Add service to Service Catalog
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
      #puts parsed_json
      return parsed_json
    end

    def service_delete(id) #Delete service from Service Catalog
      delete_call = Curl::Easy.http_delete("#{@ip_address}:#{@port_2}/v2.0/OS-KSADM/services/#{id}"
      ) do |curl|
        curl.headers['x-auth-token'] = @token
      end
    end

    def service_get(id) #Display service from Service Catalog
      get_call    = Curl::Easy.http_get("#{@ip_address}:#{@port_2}/v2.0/OS-KSADM/services/#{id}"
      ) do |curl|
        curl.headers['x-auth-token'] = @token
      end
      #puts "invoking service-get..."
      parsed_json = JSON.parse(get_call.body_str)
      #puts parsed_json
      return parsed_json
    end

    def service_list() #List all services in Service Catalog
      get_call    = Curl::Easy.http_get("#{@ip_address}:#{@port_2}/v2.0/OS-KSADM/services"
      ) do |curl|
        curl.headers['x-auth-token'] = @token
      end
      #puts "invoking service-list..."
      parsed_json = JSON.parse(get_call.body_str)
      #puts parsed_json
      return parsed_json
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
      if @auth == false
        puts "You have not authenicated yourself properly!"
        return nil
      end

      get_call = Curl::Easy.http_get("#{@ip_address}:#{@port_2}/v2.0/tenants"
      ) do |curl|
        curl.headers['x-auth-token'] = @token
      end

      parsed_json = JSON.parse(get_call.body_str)

      return parsed_json
    end

    def tenant_get(tenant_id)
      if @auth == false
        puts "You have not authenicated yourself properly!"
        return nil
      end


      get_call = Curl::Easy.http_get("#{@ip_address}:#{@port_2}/v2.0/tenants/#{tenant_id}"
      ) do |curl|
        curl.headers['x-auth-token'] = @token
      end

      parsed_json = JSON.parse(get_call.body_str)

      if (parsed_json.to_s.include? 'error')
        error = parsed_json["error"]["message"]
        puts error.to_s
        return nil
      else
        return parsed_json
      end
    end

    def tenant_create(name, description)
      if @auth == false
        puts "You have not authenicated yourself properly!"
        return nil
      end

      tenant      = {"tenant" => {"name" => name, "description" => description, "enabled" => true}}
      json_string = JSON.generate(tenant)
      post_call   = Curl::Easy.http_post("#{@ip_address}:#{@port_2}/v2.0/tenants", json_string
      ) do |curl|
        curl.headers['x-auth-token'] = @token
        curl.headers['Content-Type'] = 'application/json'
      end
      parsed_json = JSON.parse(post_call.body_str)

      if (parsed_json.to_s.include? 'error')
        error = parsed_json["error"]["message"]

        puts error.to_s
        return nil
      else
        return parsed_json
      end
    end


    def tenant_update(name, description, id)
      if @auth == false
        puts "You have not authenicated yourself properly!"
        return nil
      end

      tenant = {"tenant" => {"name" => name, "description" => description, "enabled" => true}}

      json_string = JSON.generate(tenant)
      post_call   = Curl::Easy.http_post("#{@ip_address}:#{@port_2}/v2.0/tenants/#{id}", json_string
      ) do |curl|
        curl.headers['x-auth-token'] = @token
        curl.headers['Content-Type'] = 'application/json'
      end
      parsed_json = JSON.parse(post_call.body_str)

      if (parsed_json.to_s.include? 'error')
        error = parsed_json["error"]["message"]

        puts error.to_s
        return nil
      else
        return parsed_json
      end

    end

    def tenant_delete(tenant_id)
      if @auth == false
        puts "You have not authenicated yourself properly!"
        return false
      end

      begin
        delete_call = Curl::Easy.http_delete("#{@ip_address}:#{@port_2}/v2.0/tenants/#{tenant_id}"
        ) do |curl|
          curl.headers['x-auth-token'] = @token
          curl.headers['userId']       = tenant_id
        end

        return true

      rescue

        return false

      end
    end

  end #TENANT OPS

  begin #ROLE OPS

    def role_create(name)
      role        = {"role" => {"name" => name}}
      json_string = JSON.generate(role)
      post_call   = Curl::Easy.http_post("#{@ip_address}:#{@port_2}/v2.0/OS-KSADM/roles", json_string
      ) do |curl|
        curl.headers['x-auth-token'] = @token
        curl.headers['Content-Type'] = 'application/json'
      end
      parsed_json = JSON.parse(post_call.body_str)
      #puts parsed_json
      return parsed_json
    end

    def role_delete(role)
      delete_call = Curl::Easy.http_delete("#{@ip_address}:#{@port_2}/v2.0/OS-KSADM/roles/#{role}"
      ) do |curl|
        curl.headers['x-auth-token'] = @token
      end
      #puts "invoked role delete"
    end

    def role_get(role)
      get_call = Curl::Easy.http_get("#{@ip_address}:#{@port_2}/v2.0/OS-KSADM/roles/#{role}"
      ) do |curl|
        curl.headers['x-auth-token'] = @token
      end

      parsed_json = JSON.parse(get_call.body_str)

      #puts parsed_json
      return parsed_json
    end

    def role_list
      get_call = Curl::Easy.http_get("#{@ip_address}:#{@port_2}/v2.0/OS-KSADM/roles"
      ) do |curl|
        curl.headers['x-auth-token'] = @token
      end

      parsed_json = JSON.parse(get_call.body_str)

      #puts parsed_json
      return parsed_json
    end

    def user_role_add(tenant_id, user_id, role_id)
      update_call = Curl::Easy.http_put("#{@ip_address}:#{@port_2}/v2.0/tenants/#{tenant_id}/users/#{user_id}/roles/OS-KSADM/#{role_id}", nil
      ) do |curl|
        curl.headers['x-auth-token'] = @token
      end
      return
    end

    def user_role_remove(tenant_id, user_id, role_id)
      delete_call = Curl::Easy.http_delete("#{@ip_address}:#{@port_2}/v2.0/tenants/#{tenant_id}/users/#{user_id}/roles/OS-KSADM/#{role_id}"
      ) do |curl|
        curl.headers['x-auth-token'] = @token
      end

    end

    def user_role_list(tenant_id, user_id)
      get_call    = Curl::Easy.http_get("#{@ip_address}:#{@port_2}/v2.0/tenants/#{tenant_id}/users/#{user_id}/roles"
      ) do |curl|
        curl.headers['x-auth-token'] = @token
      end
      parsed_json = JSON.parse(get_call.body_str)
      #puts parsed_json
      return parsed_json
    end

  end #ROLE OPS

  begin #ENDPOINT OPS

    def endpoint_create(region, service_id, publicurl, adminurl, internalurl)
      body        = {"endpoint" => {"region"   => region, "service_id" => service_id, "publicurl" => publicurl,
                                    "adminurl" => adminurl, "internalurl" => internalurl}}
      json_string = JSON.generate(body)
      post_call   = Curl::Easy.http_post("#{@ip_address}:#{@port_2}/v2.0/endpoints", json_string
      ) do |curl|
        curl.headers['x-auth-token'] = @token
        curl.headers['Content-Type'] = 'application/json'
      end
      parsed_json = JSON.parse(post_call.body_str)
      #puts parsed_json
      return parsed_json
    end

    def endpoint_delete(endpoint_id)
      #puts "Tried delete operation"
      delete_call = Curl::Easy.http_delete("#{@ip_address}:#{@port_2}/v2.0/endpoints/#{endpoint_id}"
      ) do |curl|
        curl.headers['x-auth-token'] = @token
      end
    end

    def endpoint_get(endpoint_id)
      #puts "Tried get operation"
      value = endpoint_list["endpoints"]
      count = 0
      while count < value.length do
        if (value[count]["id"] == endpoint_id) then
          return value[count]
        end
        count += 1
      end
      return "No value found"
    end

    def endpoint_list
      get_call    = Curl::Easy.http_get("#{@ip_address}:#{@port_2}/v2.0/endpoints/"
      ) do |curl|
        curl.headers['x-auth-token'] = @token
      end

      #puts "Here is a list of endpoints..."
      parsed_json = JSON.parse(get_call.body_str)

      #puts parsed_json
      return parsed_json
    end
  end #ENDPOINT OPS
end

