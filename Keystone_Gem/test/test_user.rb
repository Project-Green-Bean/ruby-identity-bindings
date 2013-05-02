require File.join(File.dirname(__FILE__), '../lib/keystone.rb')
require 'test/unit'
require File.join(File.dirname(__FILE__), '../test/test_parameters.rb')


class TestUser < Test::Unit::TestCase


  def test_user_list
    c = Keystone.new($admin, $adminPass, $serverURL, $serverPort1, $serverPort2)
    c.auth($tenant)
    withoutNewUser = c.user_list
    newTenant = c.tenant_create('test_user_list', 'mock tenant')
    newUser= c.user_create('test_user_list','test_user_list@com.com','secret', newTenant[1]['tenant']['id'])
    withNewUser = c.user_list

    assert_equal(false, withoutNewUser==withNewUser) #makes sure that the list does in fact change

    c.user_delete(newUser['user']['id'])
    c.tenant_delete(newTenant[1]['tenant']['id'])

    assert(withoutNewUser == c.user_list)
  end

  def test_user_create
    #this should allow creation of users under regular circumstances
    c = Keystone.new($admin, $adminPass, $serverURL, $serverPort1, $serverPort2)
    c.auth($tenant)
    withoutNew = c.user_list['users']
    newTenant = c.tenant_create("test_user_create", "")
    newUser = c.user_create("test_user_create", "email", "password", newTenant[1]['tenant']['id'])
    withNew = c.user_list['users']

    difference = withNew.size - withoutNew.size
    assert_equal(1, difference)

    c.user_delete(newUser['user']['id'])
    c.tenant_delete(newTenant[1]['tenant']['id'])
  end

  def test_user_create_duplicate
    c = Keystone.new($admin, $adminPass, $serverURL, $serverPort1, $serverPort2)
    c.auth($tenant)
    newTenant = c.tenant_create("test_user_create_duplicate", "")
    newUser = c.user_create("test_user_create_duplicate", "email", "password", newTenant[1]['tenant']['id'])
    duplicateUser = c.user_create("test_user_create_duplicate", "email", "password", newTenant[1]['tenant']['id'])

    assert_equal(409, duplicateUser[1]['code'])


    c.user_delete(newUser['user']['id'])
    c.tenant_delete(newTenant[1]['tenant']['id'])

  end

  def test_user_create_invalid_tenant
    #this should not allow creation of users
    c = Keystone.new($admin, $adminPass, $serverURL, $serverPort1, $serverPort2)
    c.auth($tenant)

    newUser = c.user_create("test_user_create_invalid_tenant", "email", "password", "TheOddsOfHavingThisTenantIDIsVeryUnlikely")
    assert_equal(404, newUser[1]['code'])

  end

  def test_user_delete
    #this should allow deletion under regular circumstances
    c = Keystone.new($admin, $adminPass, $serverURL, $serverPort1, $serverPort2)
    c.auth($tenant)

    withoutUser = c.user_list
    newTenant = c.tenant_create("test_user_delete", "")
    newUser = c.user_create("test_user_delete", "email", "password", newTenant[1]['tenant']['id'])
    withUser = c.user_list

    difference = withUser['users'].size - withoutUser['users'].size
    assert_equal(1, difference)
    assert_equal(true, c.user_delete(newUser['user']['id']))
    userDeletedList = c.user_list
    difference = withoutUser['users'].size - userDeletedList['users'].size
    assert_equal(0, difference)
    c.tenant_delete(newTenant[1]['tenant']['id'])


  end

=begin
  def test_user_delete_unauthorized
    #this should not allow deletion of users
    c = Keystone.new($admin, $adminPass, $serverURL, $serverPort1, $serverPort2)
    c.auth($tenant)

  end
=end

  def test_user_delete_user_doesnt_exist
    #this should not allow deletion of users
    c = Keystone.new($admin, $adminPass, $serverURL, $serverPort1, $serverPort2)
    c.auth($tenant)
    assert_equal(false, c.user_delete("TheOddsOfHavingThisUserIDIsVeryUnlikely"))
  end

  def test_user_get
    #this should allow the retrieving of a user
    #should it fail or return an empty user when the user doesnt exist?
    a = Keystone.new($admin, $adminPass, $serverURL, $serverPort1, $serverPort2)
    a.auth($tenant)
    newTenant = a.tenant_create("user_get_tenant", "for testing purposes")
    newUser = a.user_create("user_get", "secret", "user_get_email", newTenant[1]['tenant']['id'])

    assert_equal(newUser["user"]["id"],a.user_get(newUser['user']['id'])['user']['id'])

    a.user_delete(newUser["user"]["id"])
    a.tenant_delete(newTenant[1]['tenant']['id'])
  end

  def test_user_get_doesnt_exist
    a = Keystone.new($admin, $adminPass, $serverURL, $serverPort1, $serverPort2)
    a.auth($tenant)
    noUser = a.user_get("0000")

    assert_equal(noUser["error"]["code"], 404)
  end


  def test_user_password_update
    #this should allow changing of a user's password under regular circumstances
    #if the b user can authenticate with the new password, the value returned from auth should be true, else false
    a = Keystone.new($admin, $adminPass, $serverURL, $serverPort1, $serverPort2)
    a.auth($tenant)
    newTenant = a.tenant_create("test_password_update", "for testing purposes")
    newUser = a.user_create("test_password_update", "password@yahoo", "secret", newTenant[1]['tenant']['id'])

    a.user_password_update(newUser['user']['id'], "compromised")
    b = Keystone.new("test_password_update", "compromised", $serverURL,$serverPort1,$serverPort2)

    assert_equal(b.auth(newTenant[1]['tenant']['name'])[0],true)

    a.user_delete(newUser['user']['id'])
    a.tenant_delete(newTenant[1]['tenant']['id'])
  end

=begin
    def test_user_password_update_unauthorized
    #this should not allow a user's password to be changed
    a = Keystone.new($admin, $adminPass, $serverURL, $serverPort1, $serverPort2)
    a.auth($tenant)
    testTenant = a.tenant_create("user_password_update_test", "to make sure user belonging to a low level cant change passwords")
    testUser =  a.user_create("lawdogpasswordupdate", "secret", "lawdog@yahoo", testTenant['tenant']['id'])
    testDummy = a.user_create("dummy", "secret", "lawdog@yahoo", testTenant['tenant']['id'])
    b = Keystone.new("lawdogpasswordupdate", "secret", $serverURL, $serverPort1, $serverPort2)
    b.auth(testTenant['tenant']['name'])


    #TODO FIX DIS
    #TODO for some reason it wont let me auth 'lawdogpasswordupdate' to the server under the tenant that i created above


    a.user_delete(testUser['user']['id'])
    a.tenant_delete(testTenant['tenant']['id'])
    end
=end

  def test_user_password_update_user_doesnt_exist
    #this should not allow a user's password to be changed
    a = Keystone.new($admin, $adminPass, $serverURL, $serverPort1, $serverPort2)
    a.auth($tenant)
    assert_equal(a.user_password_update("1337", "31337")['error']['code'],404)
  end

=begin "testing user_update, user_role_add/remove/list"  
  #_________________________________________________________________________________________________________________________________________
  def test_user_update
    #SETUP
      c = Keystone.new($admin, $adminPass, $serverURL, $serverPort1, $serverPort2)
      c.auth($tenant)
      tenantID = c.tenant_create("test_tenant_userUpdate", "")[1]['tenant']['id']    
      userID   = c.user_create("test_user1_userUpdate", "email", "password", tenantID)['user']['id']
      roleID   = c.role_create("test_role1_userUpdate")[1]["role"]["id"]
    #Setup tests
      before_update = c.user_get(userID)   
    #Acceptable user_update
      new_email1    = "new_email1@test.com"
      update1       = c.user_update(new_email1, userID)
      after_update1 = c.user_get(userID)
    #Make sure upser_update works    
      success1 = update1[0]
      success2 = !(before_update != after_update1) #!!!!!!!!!!!!!!!!
      success3 = !(after_update1["email"] == new_email1) #!!!!!!!!!!!!!!
    #Unacceptable user_update (nonexistent user)
      new_email2    = "new_email2@test.com"
      update2       = c.user_update(new_email2, "badUserID")
      after_update2 = c.user_get(userID)
    #Make sure this doesn't work
      failure1 = !update2[0]  #!!!!!!!!
      failure2 = (after_update1 != after_update2)
      failure3 = (after_update2["email"] == new_email2)    
    #TAKEDOWN
      c.tenant_delete(tenantID)
      c.user_delete(userID)
      c.role_delete(roleID)
    #Run asserts
      assert(success1)
      assert(success2)
      assert(success3)
      assert(!failure1)
      assert(!failure2)
      assert(!failure3)
  end
   
  def test_user_role  
  # These test user_role_add, user_role_remove, and user_role_list
  # I did this because I thought it would be fun to utilize more Ruby data structures
 
    #SETUP
      c = Keystone.new($admin, $adminPass, $serverURL, $serverPort1, $serverPort2)
      c.auth($tenant)    
      tenantID = c.tenant_create("test_tenant_userRole", "")[1]['tenant']['id']    
      user1ID  = c.user_create("test_user1_userRole", "email", "password", tenantID)['user']['id']
      user2ID  = c.user_create("test_user2_userRole", "email", "password", tenantID)['user']['id']    
      role1ID  = c.role_create("test_role1_userRole")[1]["role"]["id"]
      role2ID  = c.role_create("test_role2_userRole")[1]["role"]["id"]
    #Setup tests
      test1results = setup_user_role_test1(tenantID, user1ID, role1ID)
      test2results = setup_user_role_test2(tenantID, user1ID, role1ID, role2ID)
      test3results = setup_user_role_test3(tenantID, user1ID, user2ID, role1ID)
      test4results = setup_user_role_test4(tenantID, user1ID, user2ID, role1ID, role2ID)
    #TAKEDOWN
      c.tenant_delete(tenantID)    
      c.user_delete(user1ID)
      c.user_delete(user2ID)    
      c.role_delete(role1ID)
      c.role_delete(role2ID) 
    #Run preliminary tests
      results = test1results
      if(!results[0])
        puts "user_role_add is broken for sure"
        return
      elsif(!results[1])
        puts "user_role_remove is broken for sure"
        return
      elsif(!results[2])
        puts "user_role_list is broken for sure"
        return
      end
    #RUN TEST 1
      test1results.each_index do |testPassed|
        assert(testPassed)
      end
    #RUN TEST 2
      test2results.each do |testPassed|
        assert(testPassed)
      end    
    #RUN TEST 3
      test3results.each do |testPassed|
        assert(testPassed)
      end
    #RUN TEST 4
      test4results.each do |testPassed|
        assert(testPassed)
      end           
  end
    
  def setup_user_role_test1(tenantID, userID, roleID)
    c = Keystone.new($admin, $adminPass, $serverURL, $serverPort1, $serverPort2)
    c.auth($tenant)  
    results  = Array.new(7, true)   
    #original list
      list1  = c.user_role_list(tenantID, userID)
    #add role
      add    = c.user_role_add(tenantID, userID, roleID)
      list2  = c.user_role_list(tenantID, userID)
    #remove role
      remove = c.user_role_remove(tenantID, userID, roleID)
      list3  = c.user_role_list(tenantID, userID)
    #testing add
      results[0] = add[0] # only user_role_add could make this false
      results[1] = (list1[1] != list2[1])
      #results[2] = (c.role_list.key? roleID)
    #testing remove
      results[3] = remove[0] # only user_role_remove could make this false
      results[4] = (list2[1] != list3[1]) && (list1[1] == list3[1])
      #results[5] = !(c.role_get(roleID).key? userID)
    #testing list
      results[6] = list1[0] # only user_role_list could make this false
      results[7] = list2[0] && list3[0]
      results[8] = (list1[1] != list2[1]) && (list2[1] != list3[1]) && (list1[1] == list3[1])
           
    return results      
  end

  def setup_user_role_test2(tenantID, userID, role1, role2)
    c = Keystone.new($admin, $adminPass, $serverURL, $serverPort1, $serverPort2)
    c.auth($tenant)  
    results = Array.new(7,true)
    #original list
      list0 = c.user_role_list(tenantID, userID)
    #add first role to user
      add1  = c.user_role_add(tenantID, userID, role1)
      list1 = c.user_role_list(tenantID, userID)
    #add second role to user
      add2  = c.user_role_add(tenantID, userID, role2)
      list2 = c.user_role_list(tenantID, userID)
    #remove first role from user
      remove1  = c.user_role_remove(tenantID, userID, role1)
      newlist1 = c.user_role_list(tenantID, userID)
    #remove second role from user
      remove2  = c.user_role_remove(tenantID, userID, role2)
      newlist2 = c.user_role_list(tenantID, userID)    
    #testing add
      results[0] = (add1[0] && add2[0])
      #results[1] = !(list0[1] == list1[1] == list2[1]) #!!!!!!!!!!!!!!!!!!
      #results[2] = (c.role_list.key? role1) && (c.role_list.key? role2)
    #testing remove
      results[3] = (remove1[0] && remove2[0])
      results[4] = (newlist1[1] != newlist2[1])
      #results[5] = !((c.role_get(role1).key? userID) && (c.role_get(role2).key? userID))
    #testing list
      results[6] = list0[0] && list1[0] && list2[0] && newlist1[0] && newlist2[0]
      #results[7] = (list0[1] != list1[1] != list2[1]) #!!!!!!!!!!!!!!!!!!!!!!
      results[8] = (newlist1[1] != newlist2[1])
    
    return results      
  end

  def setup_user_role_test3(tenantID, user1, user2, roleID)
    c = Keystone.new($admin, $adminPass, $serverURL, $serverPort1, $serverPort2)
    c.auth($tenant)  
    results = Array.new(7,true)
    #original lists
      user1list0 = c.user_role_list(tenantID, user1)
      user2list0 = c.user_role_list(tenantID, user2)
    #add role to first user
      user1add  = c.user_role_add(tenantID, user1, roleID)
      user1list1 = c.user_role_list(tenantID, user1)
    #add role to second user
      user2add  = c.user_role_add(tenantID, user2, roleID)
      user2list1 = c.user_role_list(tenantID, user2)
    #remove role from first user
      user1remove = c.user_role_remove(tenantID, user1, roleID)
      user1list2   = c.user_role_list(tenantID, user1)
    #remove role from second user
      user2remove = c.user_role_remove(tenantID, user1, roleID)
      user2list2   = c.user_role_list(tenantID, user1)   
    #testing add
      results[0] = (user1add[0] && user2add[0])
      results[1] = (user1list0 != user1list1) && (user2list0 != user2list1)
      #results[2] = (c.role_list.key? roleID)
    #testing remove
      results[3] = (user1remove[0] && user2remove[0])
      results[4] = (user1list1[1] != user1list2[1]) && (user2list1[1] != user2list2[1]) 
      #results[5] = !((c.role_get(roleID).key? user1) && (c.role_get(roleID).key? user2))
    #testing list
      results[6] = (user1list0[0] && user1list1[0] && user1list2[0])
      results[7] = (user2list0[0] && user2list1[0] && user2list2[0])
      #results[8] = (results[0][1] && results[1][1])
    
    return results      
  end
  
  def setup_user_role_test4(tenantID, user1, user2, role1, role2)
    c = Keystone.new($admin, $adminPass, $serverURL, $serverPort1, $serverPort2)
    c.auth($tenant)  
    results = Array.new(3,true)
    #original lists
      user1list0 = c.user_role_list(tenantID, user1)
      user2list0 = c.user_role_list(tenantID, user2)
      
    #add first role to first user
      add1  = c.user_role_add(tenantID, user1, role1)
      list1 = c.user_role_list(tenantID, user1)
    #add second role to first user
      add2  = c.user_role_add(tenantID, user1, role2)
      list2 = c.user_role_list(tenantID, user1)
      add_success_user1  = (add1[0] && add2[0])
      #list_success_user1 = (user1list0[1] != list1[1] != list2[1]) #!!!!!!!!!!!!!
      
    #add first role to second user
      add1  = c.user_role_add(tenantID, user2, role1)
      list1 = c.user_role_list(tenantID, user2)
    #add second role to second user
      add2  = c.user_role_add(tenantID, user2, role2)
      list2 = c.user_role_list(tenantID, user2)
      add_success_user2  = (add1[0] && add2[0])
      #list_success_user2 = (user2list0[1] != list1[1] != list2[1]) #!!!!!!!!!!!!!!!!!!!!!
          
    #remove first role from first user
      remove1 = c.user_role_remove(tenantID, user1, role1)
      list1   = c.user_role_list(tenantID, user1)
    #remove second role from first user
      remove2 = c.user_role_remove(tenantID, user1, role2)
      list2   = c.user_role_list(tenantID, user1)
      remove_success_user1 = (remove1[0] && remove2[0])
      list_success_user1   = (list_success_user1) && (list1 != list2)    
 
    #remove first role from second user
      remove1 = c.user_role_remove(tenantID, user2, role1)
      list1   = c.user_role_list(tenantID, user2)
    #remove second role from second user
      remove2 = c.user_role_remove(tenantID, user2, role2)
      list2   = c.user_role_list(tenantID, user2)
      remove_success_user2 = (remove1[0] && remove2[0])
      list_success_user2   = (list_success_user2) && (list1 != list2)       
 
    #testing add
      results[0] = add_success_user1 && add_success_user2
    #testing remove
      results[1] = remove_success_user1 && remove_success_user2
    #testing list
      results[2] = list_success_user1 && list_success_user2
    
    return results      
  end
=end
end

