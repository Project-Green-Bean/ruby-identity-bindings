require File.join(File.dirname(__FILE__), '../lib/keystone.rb')
require 'test_parameters'



def clean_users
  c = Keystone.new($admin, $adminPass, $serverURL, $serverPort1, $serverPort2)
  c.auth($tenant)

  user_list = c.user_list['users']
  user_ids_to_purge = []
  for user in user_list do
    if (user['name'] != "admin") || (user['name'] != "admin2")
      user_ids_to_purge << user['id']
      puts 'something happened'
    end
  end
  puts user_ids_to_purge.inspect
end