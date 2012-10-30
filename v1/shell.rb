require 'optparse'

# Hash that will store all the available options parsed
options = {}


#TODO(alawson) Find out how to access the appropriate ENV[] variables as default values
parser = OptionParser.new do |opts|
  opts.banner = "Usage: keystone [--os-username <auth-user-name>]
                [--os-password <auth-password>]
                [--os-tenant-name <auth-tenant-name>]
                [--os-tenant-id <tenant-id>] [--os-auth-url <auth-url>]
                [--os-region-name <region-name>]
                [--os-identity-api-version <identity-api-version>]
                [--token <service-token>] [--endpoint <service-endpoint>]
                <subcommand> ..."

  options[:os_username] = :blank
  opts.on( "--os-username USERNAME") do |username|
    options[:os_username] = username
  end

  options[:os_password] = :blank
  opts.on( "--password PASS") do |pass|
    options[:os_password] = pass
  end

  options[:os_tenant_name] = :blank
  opts.on( "--os-tenant-name TENANTNAME") do |tenant_name|
    options[:os_tenant_name] = tenant_name
  end

  options[:os_tenant_id] = :blank
  opts.on( "--os-tenant-id TENANTID") do |tenant_id|
    options[:os_tenant_id] = tenant_id
  end

  options[:os_auth_url] = :blank
  opts.on( "--os-auth-url AUTHURL") do |auth_url|
    options[:os_auth_url] = auth_url
  end

  options[:os_region_name] = :blank
  opts.on( "--os-region-name REGION") do |region|
    options[:os_region_name] = region
  end

  options[:os_identity_api_version] = :blank
  opts.on( "--os-identity_api_version APIVERSION") do |api_version|
    options[:os_identity_api_version] = api_version
  end

  options[:os_token] = :blank
  opts.on("--os-token TOKEN") do |token|
    options[:os_token] = token
  end

  options[:os_endpoint] = :blank
  opts.on("--os-endpoint ENDPOINT") do |endpoint|
    options[:os_endpoint] = endpoint
  end

  options[:os_cacert] = :blank
  opts.on("--os-cacert CERT") do |cert|
    options[:os_cacert] = cert
  end

  options[:os_cert] = :blank
  opts.on("--os-cert CERT") do |cert|
    options[:os_cert] = cert
  end

  options[:os_key] = :blank
  opts.on("--os-key KEY") do |key|
    options[:os_key] = key
  end

  options[:insecure] = false
  opts.on("--insecure") do
    options[:insecure] = true
  end


end
