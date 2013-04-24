require 'rubygems'
require 'sinatra'
require '/home/thicks/Desktop/TheGloriousExampleofBusyWork/rubyGroup.rb'

c = Auth.new("admin","password","http://198.61.199.47","5000","35357")
b = 1

get '/' do
	erb :Login	
end

get '/Login_Success' do
	b = c.auth(params[:message])
	erb :Home
end

get '/Home.erb' do
  	erb :Home
end

#TENANTS

get '/Tenants_Add.erb' do
	erb :Tenants_Add
end

get '/Tenants_Add_Form.erb' do
	c.tenant_create(params[:name], params[:description])
end

get '/Tenants_Delete.erb' do
	erb :Tenants_Delete
end

get '/Tenants_Delete_Form.erb' do
	c.tenant_delete(params[:id])
end

get '/Tenants_Get.erb' do
	erb :Tenants_Get
end

get '/Tenants_Get_Form.erb' do
	c.tenant_get(params[:id])
end

get '/Tenants_List.erb' do
	c.tenant_list
end


#USERS

get '/Users_Add.erb' do
	erb :Users_Add
end

get '/Users_Add_Form.erb' do
	c.user_create(params[:username], params[:email], params[:password], b)
end

get '/Users_Delete.erb' do
	erb :Users_Delete
end

get '/Users_Delete_Form.erb' do
	c.user_delete(params[:id])
end

get '/Users_Update_Password.erb' do
	erb :Users_Update_Password
end

get '/Users_Update_Password_Form.erb' do
	c.user_password_update(params[:id], params[:password])
end

get '/Users_Get.erb' do
	erb :Users_Get
end

get '/Users_Get_Form.erb' do
	c.user_get(params[:id])
end

get '/Users_List.erb' do
	c.user_list
end

#SERVICES

get '/Services_Add.erb' do
	erb :Services_Add
end

get '/Services_Add_Form.erb' do
	c.service_create(params[:name], params[:service_type], params[:description])
end

get '/Services_Delete.erb' do
	erb :Services_Delete
end

get '/Services_Delete_Form.erb' do
	c.service_delete(params[:id])
end

get '/Services_Get.erb' do
	erb :Services_Get
end

get '/Services_Get_Form.erb' do
	c.service_get(params[:id])
end

get '/Services_List.erb' do
	c.service_list
end


#ROLES

get '/Roles_Add.erb' do
	erb :Roles_Add
end

get '/Roles_Add_Form.erb' do
	c.role_create(params[:name])
end

get '/Roles_Delete.erb' do
	erb :Roles_Delete
end

get '/Roles_Delete_Form.erb' do
	c.role_delete(params[:id])
end

get '/Roles_Get.erb' do
	erb :Roles_Get
end

get '/Roles_Get_Form.erb' do
	c.role_get(params[:id])
end

get '/Roles_List.erb' do
	c.role_list
end


#Endpoint

get '/Endpoints_Add.erb' do
	erb :Endpoints_Add
end

get '/Endpoints_Add_Form.erb' do
	c.endpoint_create(params[:region], params[:service_id], params[:public_curl], params[:admin_url], params[:internal_url])
end

get '/Endpoints_Delete.erb' do
	erb :Endpoints_Delete
end

get '/Endpoints_Delete_Form.erb' do
	c.endpoint_delete(params[:id])
end

get '/Endpoints_Get.erb' do
	erb :Endpoints_Get
end

get '/Endpoints_Get_Form.erb' do
	c.endpoint_get(params[:id])
end

get '/Endpoints_List.erb' do
	c.endpoint_list
end


	


