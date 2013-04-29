require File.join(File.dirname(__FILE__), '../lib/keystone.rb')
require File.join(File.dirname(__FILE__), '../test/test_parameters.rb')


def clean_users
  c = Keystone.new($admin, $adminPass, $serverURL, $serverPort1, $serverPort2)
  c.auth($tenant)
  user_list = c.user_list['users']
  for user in user_list do
    if (user['name'] != "admin") && (user['name'] != "admin2")
      c.user_delete(user['id'])
      puts user['name']
    end
  end
end

def clean_tenants
  c = Keystone.new($admin, $adminPass, $serverURL, $serverPort1, $serverPort2)
  c.auth($tenant)

  user_list = c.tenant_list[1]['tenants']
  for tenant in user_list do
    if (tenant['name'] != "tenant1")
      c.tenant_delete(tenant['id'])
      puts tenant['name']
    end
  end
end