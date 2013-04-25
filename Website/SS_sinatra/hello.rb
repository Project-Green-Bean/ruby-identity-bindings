require 'rubygems'
require 'sinatra'
require '/home/thicks/Desktop/ruby-identity-bindings-master/Keystone_Gem/lib/keystone.rb'
#require 'keystone'


get '/' do
	erb :Login	
end

get '/Login_Success' do
	$c = Keystone.new(params[:username], params[:password], params[:ipAddress], params[:port1], params[:port2])
	$sex = $c.auth(params[:tenant])	
	if ($sex == true)
		"<!DOCTYPE HTML>
<html>

<head>
  <title>Senior Software: Rackspace Ruby Group</title>
  <meta name='description' content='Best Website Evar' />
  <meta name='keywords' content='Senior Software, Trinity University, Computer Science, Ruby, Openstack, Keystone' />
  <meta http-equiv='content-type' content='text/html; charset=UTF-8' />
  <link rel='stylesheet' type='text/css' href='/css/ss-style.css'/>
  <script type='text/javascript' src='/javscript/bootstrap.js'></script>
</head>
	<body>
		<div id='main'>
				<div id='logo'>
					<div id='logo_text'>
						<h1><a href='SS'>Senior Software: <span class='logo_colour'>Ruby Group</span></a></h1>
						<h2>Simple. Sexy. Smart.</h2>
					</div>
			</div>
			<div id='menu_container'>
					<nav>
						<ul>
							<li><a href='/Home.erb'>Home</a></li>  
							<li><a>Tenants</a>
								<ul>
									<li><a href='/Tenants_List.erb'>List Tenants</a></li>
									<li><a href='/Tenants_Delete.erb'>Delete Tenant</a></li>
									<li><a href='/Tenants_Add.erb'>Add Tenant</a></li>
									<li><a href='/Tenants_Get.erb'>Get Tenant</a></li>
								</ul>
							</li>
							<li><a>Users</a>
								<ul>
									<li><a href='Users_List.erb'>List Users</a></li>
									<li><a href='Users_Delete.erb'>Delete User</a></li>
									<li><a href='Users_Add.erb'>Add User</a></li>
									<li><a href='Users_Get.erb'>Get User</a></li>
									<li><a href='Users_Update_Password.erb'>Update User Password</a></li>
								</ul>
							</li>
							<li><a>Services</a>
								<ul>
									<li><a href='Services_List.erb'>List Services</a></li>
									<li><a href='Services_Delete.erb'>Delete Service</a></li>
									<li><a href='Services_Add.erb'>Add Service</a></li>
									<li><a href='Services_Get.erb'>Get Service</a></li>
								</ul>
							</li>
							<li><a>Endpoints</a>
								<ul>
									<li><a href='Endpoints_List.erb'>List Endpoints</a></li>
									<li><a href='Endpoints_Delete.erb'>Delete Endpoint</a></li>
									<li><a href='Endpoints_Add.erb'>Add Endpoint</a></li>
									<li><a href='Endpoints_Get.erb'>Get Endpoint</a></li>
								</ul>
							</li>
							<li><a>Roles</a>
								<ul>
									<li><a href='Roles_List.erb'>List Roles</a></li>
									<li><a href='Roles_Delete.erb'>Delete Role</a></li>
									<li><a href='Roles_Add.erb'>Add Role</a></li>
									<li><a href='Roles_Get.erb'>Get Role</a></li>
								</ul>
							</li>
						</ul>
					</nav>
				</div>
		<div id='site_content'>
			<div id='sidebar_container'>
				<div class='sidebar'>
					<h3>Latest News</h3>
					<h4>New Website Launched</h4>
					<h5>February 4, 2013</h5>
					<p>Yea this is pretty much the best website ever created, deal with it.<br /></p>
				</div>
				<div class='sidebar'>
					<h3>Useful Links</h3>
					<ul>
						<li><a href='http://carme.cs.trinity.edu/thicks/4386/Schedule.html'>Senior Software Home Page</a></li>
						<li><a href='http://www.cs.trinity.edu/'>Trinity Computer Science Department</a></li>
						<li><a href='http://www.github.com'>git hub</a></li>
					</ul>
				</div>
			</div>
			<div class='content'>
				<h1>Trinity University Senior Ruby Group</h1>
				<p>This website is mainly purposed towards testing our functions for our openstack project</p>
				<p>#{$c.token_get}</p>
			</div>
		</div>
		<footer>
		  <p>Copyright &copy; Ruby Group | <a> Nowlin, Gleason, Lawson, Dron-Smith, Wedelich, Morales, Amundson</a></p>
		</footer>
	  </div>
	  
	  <p>&nbsp;</p>
	  
	  <script type='text/javascript' src='js/jquery.js'></script>
	  <script type='text/javascript' src='js/jquery.easing-sooper.js'></script>
	  <script type='text/javascript' src='js/jquery.sooperfish.js'></script>
	  <script type='text/javascript'>
		$(document).ready(function() {
		  $('ul.sf-menu').sooperfish();
		});
	  </script>	  
	</body>
</html>"
	else
		erb :login_fail
	end
end

get '/Home.erb' do
  	:Home
end

#TENANTS

get '/Tenants_Add.erb' do
	erb :Tenants_Add
end

get '/Tenants_Add_Form.erb' do
	newTenant = $c.tenant_create(params[:tenantName], params[:tenantDescription])
	"<html><head><link rel='stylesheet' type='text/css' href='/css/ss-style.css'/></head><body>
		<div id='main'>
				<div id='logo'>
					<div id='logo_text'>
						<h1><a href='SS'>Senior Software: <span class='logo_colour'>Ruby Group</span></a></h1>
						<h2>Simple. Sexy. Smart.</h2>
					</div>
				</div>
				<div id='menu_container'>
					<nav>
						<ul>
							<li><a href='/Home.erb'>Home</a></li>  
							<li><a>Tenants</a>
								<ul>
									<li><a href='/Tenants_List.erb'>List Tenants</a></li>
									<li><a href='/Tenants_Delete.erb'>Delete Tenant</a></li>
									<li><a href='/Tenants_Add.erb'>Add Tenant</a></li>
									<li><a href='/Tenants_Get.erb'>Get Tenant</a></li>
								</ul>
							</li>
							<li><a>Users</a>
								<ul>
									<li><a href='Users_List.erb'>List Users</a></li>
									<li><a href='Users_Delete.erb'>Delete User</a></li>
									<li><a href='Users_Add.erb'>Add User</a></li>
									<li><a href='Users_Get.erb'>Get User</a></li>
									<li><a href='Users_Update_Password.erb'>Update User Password</a></li>
								</ul>
							</li>
							<li><a>Services</a>
								<ul>
									<li><a href='Services_List.erb'>List Services</a></li>
									<li><a href='Services_Delete.erb'>Delete Service</a></li>
									<li><a href='Services_Add.erb'>Add Service</a></li>
									<li><a href='Services_Get.erb'>Get Service</a></li>
								</ul>
							</li>
							<li><a>Endpoints</a>
								<ul>
									<li><a href='Endpoints_List.erb'>List Endpoints</a></li>
									<li><a href='Endpoints_Delete.erb'>Delete Endpoint</a></li>
									<li><a href='Endpoints_Add.erb'>Add Endpoint</a></li>
									<li><a href='Endpoints_Get.erb'>Get Endpoint</a></li>
								</ul>
							</li>
							<li><a>Roles</a>
								<ul>
									<li><a href='Roles_List.erb'>List Roles</a></li>
									<li><a href='Roles_Delete.erb'>Delete Role</a></li>
									<li><a href='Roles_Add.erb'>Add Role</a></li>
									<li><a href='Roles_Get.erb'>Get Role</a></li>
								</ul>
							</li>
						</ul>
					</nav>
				</div>
					<p>&nbsp;</p>
					<p>&nbsp;</p>
					<p>&nbsp;</p>
					<p>&nbsp;</p>
					<p>&nbsp;</p>
					<div id='stylized-form' class='myform'>
			<form id='form' name='form'>  
				 <h1>Tenant Successfully Added!</h1>
				 <p>New Tenant Information Below</p>
				 
				<label>Name
				<span class='small'>Tenant Name</span>
				</label>
				<input type='text' name='tenantName' id='tenantName' value='#{newTenant['tenant']['name']}' readonly/>

				<label>ID
				<span class='small'>Tenant ID</span>
				</label>
				<input type='text' name='tenantID' id='tenantID' value='#{newTenant['tenant']['id']}' readonly/>

				<label>Description
				<span class='small'>Tenant Description</span>
				</label>
				<input type='text' name='tenantDescription' id='tenantDescription' value='#{newTenant['tenant']['description']}' readonly/>

				<button type='button'>Submit</button>	 
				 <div class='space'></div>
			</form>  
		</div>
			<footer>
			  <p>Copyright &copy; Ruby Group | <a> Nowlin, Gleason, Lawson, Dron-Smith, Wedelich, Morales, Amundson</a></p>
			</footer>
		</body>
</div>
			</html>"
end

get '/Tenants_Delete.erb' do
	erb :Tenants_Delete
end

get '/Tenants_Delete_Form.erb' do
	if $c.tenant_delete(params[:tenantID]) == false
		erb :login_fail
	else
	"<html><head><link rel='stylesheet' type='text/css' href='/css/ss-style.css'/></head><body>
		<div id='main'>
				<div id='logo'>
					<div id='logo_text'>
						<h1><a href='SS'>Senior Software: <span class='logo_colour'>Ruby Group</span></a></h1>
						<h2>Simple. Sexy. Smart.</h2>
					</div>
				</div>
				<div id='menu_container'>
					<nav>
						<ul>
							<li><a href='/Home.erb'>Home</a></li>  
							<li><a>Tenants</a>
								<ul>
									<li><a href='/Tenants_List.erb'>List Tenants</a></li>
									<li><a href='/Tenants_Delete.erb'>Delete Tenant</a></li>
									<li><a href='/Tenants_Add.erb'>Add Tenant</a></li>
									<li><a href='/Tenants_Get.erb'>Get Tenant</a></li>
								</ul>
							</li>
							<li><a>Users</a>
								<ul>
									<li><a href='Users_List.erb'>List Users</a></li>
									<li><a href='Users_Delete.erb'>Delete User</a></li>
									<li><a href='Users_Add.erb'>Add User</a></li>
									<li><a href='Users_Get.erb'>Get User</a></li>
									<li><a href='Users_Update_Password.erb'>Update User Password</a></li>
								</ul>
							</li>
							<li><a>Services</a>
								<ul>
									<li><a href='Services_List.erb'>List Services</a></li>
									<li><a href='Services_Delete.erb'>Delete Service</a></li>
									<li><a href='Services_Add.erb'>Add Service</a></li>
									<li><a href='Services_Get.erb'>Get Service</a></li>
								</ul>
							</li>
							<li><a>Endpoints</a>
								<ul>
									<li><a href='Endpoints_List.erb'>List Endpoints</a></li>
									<li><a href='Endpoints_Delete.erb'>Delete Endpoint</a></li>
									<li><a href='Endpoints_Add.erb'>Add Endpoint</a></li>
									<li><a href='Endpoints_Get.erb'>Get Endpoint</a></li>
								</ul>
							</li>
							<li><a>Roles</a>
								<ul>
									<li><a href='Roles_List.erb'>List Roles</a></li>
									<li><a href='Roles_Delete.erb'>Delete Role</a></li>
									<li><a href='Roles_Add.erb'>Add Role</a></li>
									<li><a href='Roles_Get.erb'>Get Role</a></li>
								</ul>
							</li>
						</ul>
					</nav>
				</div>
					<p>&nbsp;</p>
					<p>&nbsp;</p>
					<p>&nbsp;</p>
					<p>&nbsp;</p>
					<p>&nbsp;</p>
					<div id='stylized-form' class='myform'>
			<form id='form' name='form'>  
				 <h1>Tenant Successfully Deleted</h1>
				 <p>Tenant Deleted</p>
				 
				<button type='submit'>Submit</button>	 
				 <div class='space'></div>
			</form>  
		</div>
			<footer>
			  <p>Copyright &copy; Ruby Group | <a> Nowlin, Gleason, Lawson, Dron-Smith, Wedelich, Morales, Amundson</a></p>
			</footer>
		</body>
</div>
			</html>"
	end
end

get '/Tenants_Get.erb' do
	erb :Tenants_Get
end

get '/Tenants_Get_Form.erb' do
	getTenant = $c.tenant_get(params[:tenantID])
	"<html><head><link rel='stylesheet' type='text/css' href='/css/ss-style.css'/></head><body>
		<div id='main'>
				<div id='logo'>
					<div id='logo_text'>
						<h1><a href='SS'>Senior Software: <span class='logo_colour'>Ruby Group</span></a></h1>
						<h2>Simple. Sexy. Smart.</h2>
					</div>
				</div>
				<div id='menu_container'>
					<nav>
						<ul>
							<li><a href='/Home.erb'>Home</a></li>  
							<li><a>Tenants</a>
								<ul>
									<li><a href='/Tenants_List.erb'>List Tenants</a></li>
									<li><a href='/Tenants_Delete.erb'>Delete Tenant</a></li>
									<li><a href='/Tenants_Add.erb'>Add Tenant</a></li>
									<li><a href='/Tenants_Get.erb'>Get Tenant</a></li>
								</ul>
							</li>
							<li><a>Users</a>
								<ul>
									<li><a href='Users_List.erb'>List Users</a></li>
									<li><a href='Users_Delete.erb'>Delete User</a></li>
									<li><a href='Users_Add.erb'>Add User</a></li>
									<li><a href='Users_Get.erb'>Get User</a></li>
									<li><a href='Users_Update_Password.erb'>Update User Password</a></li>
								</ul>
							</li>
							<li><a>Services</a>
								<ul>
									<li><a href='Services_List.erb'>List Services</a></li>
									<li><a href='Services_Delete.erb'>Delete Service</a></li>
									<li><a href='Services_Add.erb'>Add Service</a></li>
									<li><a href='Services_Get.erb'>Get Service</a></li>
								</ul>
							</li>
							<li><a>Endpoints</a>
								<ul>
									<li><a href='Endpoints_List.erb'>List Endpoints</a></li>
									<li><a href='Endpoints_Delete.erb'>Delete Endpoint</a></li>
									<li><a href='Endpoints_Add.erb'>Add Endpoint</a></li>
									<li><a href='Endpoints_Get.erb'>Get Endpoint</a></li>
								</ul>
							</li>
							<li><a>Roles</a>
								<ul>
									<li><a href='Roles_List.erb'>List Roles</a></li>
									<li><a href='Roles_Delete.erb'>Delete Role</a></li>
									<li><a href='Roles_Add.erb'>Add Role</a></li>
									<li><a href='Roles_Get.erb'>Get Role</a></li>
								</ul>
							</li>
						</ul>
					</nav>
				</div>
					<p>&nbsp;</p>
					<p>&nbsp;</p>
					<p>&nbsp;</p>
					<p>&nbsp;</p>
					<p>&nbsp;</p>
					<div id='stylized-form' class='myform'>
			<form id='form' name='form' action = '/Home.erb'>  
				 <h1>Tenant Successfully Gotten</h1>
				 <p>Tenant Information</p>
				 
				<label>Name
				<span class='small'>Tenant Name</span>
				</label>
				<input type='text' name='tenantName' id='tenantName' value='#{getTenant['tenant']['name']}' readonly/>

				<label>ID
				<span class='small'>Tenant ID</span>
				</label>
				<input type='text' name='tenantID' id='tenantID' value='#{getTenant['tenant']['id']}' readonly/>

				<label>Description
				<span class='small'>Tenant Description</span>
				</label>
				<input type='text' name='tenantDescription' id='tenantDescription' value='#{getTenant['tenant']['description']}' readonly/>

				<button type='submit'>Submit</button>	 
				 <div class='space'></div>
			</form>  
		</div>
			<footer>
			  <p>Copyright &copy; Ruby Group | <a> Nowlin, Gleason, Lawson, Dron-Smith, Wedelich, Morales, Amundson</a></p>
			</footer>
		</body>
</div>
			</html>"
end

get '/Tenants_List.erb' do
	tenantList = $c.tenant_list
	prettyTenants = JSON.pretty_generate(tenantList)
	prettyHTML = prettyTenants.gsub(/\n/, "<br>")
	prettyHTML = prettyHTML.gsub('{', "")
	prettyHTML = prettyHTML.gsub('}', "")
	prettyHTML = prettyHTML.gsub(']', "")
	prettyHTML = prettyHTML.gsub('[', "")
	prettyHTML = prettyHTML.gsub(',', "")
	"<html><head><link rel='stylesheet' type='text/css' href='/css/ss-style.css'/></head><body>
		<div id='main'>
				<div id='logo'>
					<div id='logo_text'>
						<h1><a href='SS'>Senior Software: <span class='logo_colour'>Ruby Group</span></a></h1>
						<h2>Simple. Sexy. Smart.</h2>
					</div>
				</div>
				<div id='menu_container'>
					<nav>
						<ul>
							<li><a href='/Home.erb'>Home</a></li>  
							<li><a>Tenants</a>
								<ul>
									<li><a href='/Tenants_List.erb'>List Tenants</a></li>
									<li><a href='/Tenants_Delete.erb'>Delete Tenant</a></li>
									<li><a href='/Tenants_Add.erb'>Add Tenant</a></li>
									<li><a href='/Tenants_Get.erb'>Get Tenant</a></li>
								</ul>
							</li>
							<li><a>Users</a>
								<ul>
									<li><a href='Users_List.erb'>List Users</a></li>
									<li><a href='Users_Delete.erb'>Delete User</a></li>
									<li><a href='Users_Add.erb'>Add User</a></li>
									<li><a href='Users_Get.erb'>Get User</a></li>
									<li><a href='Users_Update_Password.erb'>Update User Password</a></li>
								</ul>
							</li>
							<li><a>Services</a>
								<ul>
									<li><a href='Services_List.erb'>List Services</a></li>
									<li><a href='Services_Delete.erb'>Delete Service</a></li>
									<li><a href='Services_Add.erb'>Add Service</a></li>
									<li><a href='Services_Get.erb'>Get Service</a></li>
								</ul>
							</li>
							<li><a>Endpoints</a>
								<ul>
									<li><a href='Endpoints_List.erb'>List Endpoints</a></li>
									<li><a href='Endpoints_Delete.erb'>Delete Endpoint</a></li>
									<li><a href='Endpoints_Add.erb'>Add Endpoint</a></li>
									<li><a href='Endpoints_Get.erb'>Get Endpoint</a></li>
								</ul>
							</li>
							<li><a>Roles</a>
								<ul>
									<li><a href='Roles_List.erb'>List Roles</a></li>
									<li><a href='Roles_Delete.erb'>Delete Role</a></li>
									<li><a href='Roles_Add.erb'>Add Role</a></li>
									<li><a href='Roles_Get.erb'>Get Role</a></li>
								</ul>
							</li>
						</ul>
					</nav>
				</div>
					<p>&nbsp;</p>
					<p>&nbsp;</p>
					<p>&nbsp;</p>
					<p>&nbsp;</p>
					<p>&nbsp;</p>
					<div id='print-area'><p>#{prettyHTML}</p></div>
			<footer>
			  <p>Copyright &copy; Ruby Group | <a> Nowlin, Gleason, Lawson, Dron-Smith, Wedelich, Morales, Amundson</a></p>
			</footer>
		</body>
</div>
			</html>"
end


#USERS

get '/Users_Add.erb' do
	erb :Users_Add
end

get '/Users_Add_Form.erb' do
	addUser = $c.user_create(params[:username], params[:userEmail], params[:userPassword], params[:tenantID])
	"<html><head><link rel='stylesheet' type='text/css' href='/css/ss-style.css'/></head><body>
		<div id='main'>
				<div id='logo'>
					<div id='logo_text'>
						<h1><a href='SS'>Senior Software: <span class='logo_colour'>Ruby Group</span></a></h1>
						<h2>Simple. Sexy. Smart.</h2>
					</div>
				</div>
				<div id='menu_container'>
					<nav>
						<ul>
							<li><a href='/Home.erb'>Home</a></li>  
							<li><a>Tenants</a>
								<ul>
									<li><a href='/Tenants_List.erb'>List Tenants</a></li>
									<li><a href='/Tenants_Delete.erb'>Delete Tenant</a></li>
									<li><a href='/Tenants_Add.erb'>Add Tenant</a></li>
									<li><a href='/Tenants_Get.erb'>Get Tenant</a></li>
								</ul>
							</li>
							<li><a>Users</a>
								<ul>
									<li><a href='Users_List.erb'>List Users</a></li>
									<li><a href='Users_Delete.erb'>Delete User</a></li>
									<li><a href='Users_Add.erb'>Add User</a></li>
									<li><a href='Users_Get.erb'>Get User</a></li>
									<li><a href='Users_Update_Password.erb'>Update User Password</a></li>
								</ul>
							</li>
							<li><a>Services</a>
								<ul>
									<li><a href='Services_List.erb'>List Services</a></li>
									<li><a href='Services_Delete.erb'>Delete Service</a></li>
									<li><a href='Services_Add.erb'>Add Service</a></li>
									<li><a href='Services_Get.erb'>Get Service</a></li>
								</ul>
							</li>
							<li><a>Endpoints</a>
								<ul>
									<li><a href='Endpoints_List.erb'>List Endpoints</a></li>
									<li><a href='Endpoints_Delete.erb'>Delete Endpoint</a></li>
									<li><a href='Endpoints_Add.erb'>Add Endpoint</a></li>
									<li><a href='Endpoints_Get.erb'>Get Endpoint</a></li>
								</ul>
							</li>
							<li><a>Roles</a>
								<ul>
									<li><a href='Roles_List.erb'>List Roles</a></li>
									<li><a href='Roles_Delete.erb'>Delete Role</a></li>
									<li><a href='Roles_Add.erb'>Add Role</a></li>
									<li><a href='Roles_Get.erb'>Get Role</a></li>
								</ul>
							</li>
						</ul>
					</nav>
				</div>
					<p>&nbsp;</p>
					<p>&nbsp;</p>
					<p>&nbsp;</p>
					<p>&nbsp;</p>
					<p>&nbsp;</p>
					<div id='stylized-form' class='myform'>
			<form id='form' name='form'>  
				 <h1>User Successfully Gotten</h1>
				 <p>User Information</p>
				 
				<label>Username
				<span class='small'>User's Username</span>
				</label>
				<input type='text' name='username' id='username' value='#{addUser['user']['name']}' readonly/>

				<label>Email
				<span class='small'>User Email</span>
				</label>
				<input type='text' name='userEmail' id='userEmail' value='#{addUser['user']['email']}' readonly/>

				<label>ID
				<span class='small'>User ID</span>
				</label>
				<input type='text' name='userID' id='userID' value='#{addUser['user']['id']}' readonly/>

				<label>ID
				<span class='small'>Tenant ID</span>
				</label>
				<input type='text' name='tenantID' id='tenantID' value='#{addUser['user']['tenantid']}' readonly/>
		

				<button type='button'>Submit</button>	 
				 <div class='space'></div>
			</form>  
		</div>
			<footer>
			  <p>Copyright &copy; Ruby Group | <a> Nowlin, Gleason, Lawson, Dron-Smith, Wedelich, Morales, Amundson</a></p>
			</footer>
		</body>
</div>
			</html>"
end

get '/Users_Delete.erb' do
	erb :Users_Delete
end

get '/Users_Delete_Form.erb' do
	del = $c.user_delete(params[:userID])
	if del == false
		"<html>	
	<head>
		<title>Senior Software: Rackspace Ruby Group: Login Page</title>
		<link rel='stylesheet' type='text/css' href='/css/ss-style.css' />
		<script type='text/javascript' src='js/modernizr-1.5.min.js'></script>
	</head>	
	<body>
	<br><br>
		<div id='stylized-form' class='myform'>
			<form id='form' name='form' action='/Users_Delete.erb' method='get'>  
				 <h1>Delete Failed!</h1>
				 <p>Please re-enter the User ID</p>
				 
				 <button type='submit'>Back</button>
				 <div class='space'></div>
			</form>  
		</div>
	</body>
</html>"
	else
	"<html><head><link rel='stylesheet' type='text/css' href='/css/ss-style.css'/></head><body>
		<div id='main'>
				<div id='logo'>
					<div id='logo_text'>
						<h1><a href='SS'>Senior Software: <span class='logo_colour'>Ruby Group</span></a></h1>
						<h2>Simple. Sexy. Smart.</h2>
					</div>
				</div>
				<div id='menu_container'>
					<nav>
						<ul>
							<li><a href='/Home.erb'>Home</a></li>  
							<li><a>Tenants</a>
								<ul>
									<li><a href='/Tenants_List.erb'>List Tenants</a></li>
									<li><a href='/Tenants_Delete.erb'>Delete Tenant</a></li>
									<li><a href='/Tenants_Add.erb'>Add Tenant</a></li>
									<li><a href='/Tenants_Get.erb'>Get Tenant</a></li>
								</ul>
							</li>
							<li><a>Users</a>
								<ul>
									<li><a href='Users_List.erb'>List Users</a></li>
									<li><a href='Users_Delete.erb'>Delete User</a></li>
									<li><a href='Users_Add.erb'>Add User</a></li>
									<li><a href='Users_Get.erb'>Get User</a></li>
									<li><a href='Users_Update_Password.erb'>Update User Password</a></li>
								</ul>
							</li>
							<li><a>Services</a>
								<ul>
									<li><a href='Services_List.erb'>List Services</a></li>
									<li><a href='Services_Delete.erb'>Delete Service</a></li>
									<li><a href='Services_Add.erb'>Add Service</a></li>
									<li><a href='Services_Get.erb'>Get Service</a></li>
								</ul>
							</li>
							<li><a>Endpoints</a>
								<ul>
									<li><a href='Endpoints_List.erb'>List Endpoints</a></li>
									<li><a href='Endpoints_Delete.erb'>Delete Endpoint</a></li>
									<li><a href='Endpoints_Add.erb'>Add Endpoint</a></li>
									<li><a href='Endpoints_Get.erb'>Get Endpoint</a></li>
								</ul>
							</li>
							<li><a>Roles</a>
								<ul>
									<li><a href='Roles_List.erb'>List Roles</a></li>
									<li><a href='Roles_Delete.erb'>Delete Role</a></li>
									<li><a href='Roles_Add.erb'>Add Role</a></li>
									<li><a href='Roles_Get.erb'>Get Role</a></li>
								</ul>
							</li>
						</ul>
					</nav>
				</div>
					<p>&nbsp;</p>
					<p>&nbsp;</p>
					<p>&nbsp;</p>
					<p>&nbsp;</p>
					<p>&nbsp;</p>
					<div id='stylized-form' class='myform'>
			<form id='form' name='form' action='/Home.erb'>  
				 <h1>User Successfully Deleted</h1>
				 <p>User Deleted</p>
				 
				<button type='submit'>Submit</button>	 
				 <div class='space'></div>
			</form>  
		</div>
			<footer>
			  <p>Copyright &copy; Ruby Group | <a> Nowlin, Gleason, Lawson, Dron-Smith, Wedelich, Morales, Amundson</a></p>
			</footer>
		</body>
</div>
			</html>"
	end
end

get '/Users_Update_Password.erb' do
	erb :Users_Update_Password
end

get '/Users_Update_Password_Form.erb' do
	$c.user_password_update(params[:userID], params[:newPassword])
	"<html><head><link rel='stylesheet' type='text/css' href='/css/ss-style.css'/></head><body>
		<div id='main'>
				<div id='logo'>
					<div id='logo_text'>
						<h1><a href='SS'>Senior Software: <span class='logo_colour'>Ruby Group</span></a></h1>
						<h2>Simple. Sexy. Smart.</h2>
					</div>
				</div>
				<div id='menu_container'>
					<nav>
						<ul>
							<li><a href='/Home.erb'>Home</a></li>  
							<li><a>Tenants</a>
								<ul>
									<li><a href='/Tenants_List.erb'>List Tenants</a></li>
									<li><a href='/Tenants_Delete.erb'>Delete Tenant</a></li>
									<li><a href='/Tenants_Add.erb'>Add Tenant</a></li>
									<li><a href='/Tenants_Get.erb'>Get Tenant</a></li>
								</ul>
							</li>
							<li><a>Users</a>
								<ul>
									<li><a href='Users_List.erb'>List Users</a></li>
									<li><a href='Users_Delete.erb'>Delete User</a></li>
									<li><a href='Users_Add.erb'>Add User</a></li>
									<li><a href='Users_Get.erb'>Get User</a></li>
									<li><a href='Users_Update_Password.erb'>Update User Password</a></li>
								</ul>
							</li>
							<li><a>Services</a>
								<ul>
									<li><a href='Services_List.erb'>List Services</a></li>
									<li><a href='Services_Delete.erb'>Delete Service</a></li>
									<li><a href='Services_Add.erb'>Add Service</a></li>
									<li><a href='Services_Get.erb'>Get Service</a></li>
								</ul>
							</li>
							<li><a>Endpoints</a>
								<ul>
									<li><a href='Endpoints_List.erb'>List Endpoints</a></li>
									<li><a href='Endpoints_Delete.erb'>Delete Endpoint</a></li>
									<li><a href='Endpoints_Add.erb'>Add Endpoint</a></li>
									<li><a href='Endpoints_Get.erb'>Get Endpoint</a></li>
								</ul>
							</li>
							<li><a>Roles</a>
								<ul>
									<li><a href='Roles_List.erb'>List Roles</a></li>
									<li><a href='Roles_Delete.erb'>Delete Role</a></li>
									<li><a href='Roles_Add.erb'>Add Role</a></li>
									<li><a href='Roles_Get.erb'>Get Role</a></li>
								</ul>
							</li>
						</ul>
					</nav>
				</div>
					<p>&nbsp;</p>
					<p>&nbsp;</p>
					<p>&nbsp;</p>
					<p>&nbsp;</p>
					<p>&nbsp;</p>
					<div id='stylized-form' class='myform'>
			<form id='form' name='form' action='/Home.erb'>  
				 <h1>User Password Update</h1>
				 <p>Password update successful!</p>
				 
				<button type='submit'>Submit</button>	 
				 <div class='space'></div>
			</form>  
		</div>
			<footer>
			  <p>Copyright &copy; Ruby Group | <a> Nowlin, Gleason, Lawson, Dron-Smith, Wedelich, Morales, Amundson</a></p>
			</footer>
		</body>
</div>
			</html>"
end

get '/Users_Get.erb' do
	erb :Users_Get
end

get '/Users_Get_Form.erb' do
	getUser = $c.user_get(params[:userID])
	"<html><head><link rel='stylesheet' type='text/css' href='/css/ss-style.css'/></head><body>
		<div id='main'>
				<div id='logo'>
					<div id='logo_text'>
						<h1><a href='SS'>Senior Software: <span class='logo_colour'>Ruby Group</span></a></h1>
						<h2>Simple. Sexy. Smart.</h2>
					</div>
				</div>
				<div id='menu_container'>
					<nav>
						<ul>
							<li><a href='/Home.erb'>Home</a></li>  
							<li><a>Tenants</a>
								<ul>
									<li><a href='/Tenants_List.erb'>List Tenants</a></li>
									<li><a href='/Tenants_Delete.erb'>Delete Tenant</a></li>
									<li><a href='/Tenants_Add.erb'>Add Tenant</a></li>
									<li><a href='/Tenants_Get.erb'>Get Tenant</a></li>
								</ul>
							</li>
							<li><a>Users</a>
								<ul>
									<li><a href='Users_List.erb'>List Users</a></li>
									<li><a href='Users_Delete.erb'>Delete User</a></li>
									<li><a href='Users_Add.erb'>Add User</a></li>
									<li><a href='Users_Get.erb'>Get User</a></li>
									<li><a href='Users_Update_Password.erb'>Update User Password</a></li>
								</ul>
							</li>
							<li><a>Services</a>
								<ul>
									<li><a href='Services_List.erb'>List Services</a></li>
									<li><a href='Services_Delete.erb'>Delete Service</a></li>
									<li><a href='Services_Add.erb'>Add Service</a></li>
									<li><a href='Services_Get.erb'>Get Service</a></li>
								</ul>
							</li>
							<li><a>Endpoints</a>
								<ul>
									<li><a href='Endpoints_List.erb'>List Endpoints</a></li>
									<li><a href='Endpoints_Delete.erb'>Delete Endpoint</a></li>
									<li><a href='Endpoints_Add.erb'>Add Endpoint</a></li>
									<li><a href='Endpoints_Get.erb'>Get Endpoint</a></li>
								</ul>
							</li>
							<li><a>Roles</a>
								<ul>
									<li><a href='Roles_List.erb'>List Roles</a></li>
									<li><a href='Roles_Delete.erb'>Delete Role</a></li>
									<li><a href='Roles_Add.erb'>Add Role</a></li>
									<li><a href='Roles_Get.erb'>Get Role</a></li>
								</ul>
							</li>
						</ul>
					</nav>
				</div>
					<p>&nbsp;</p>
					<p>&nbsp;</p>
					<p>&nbsp;</p>
					<p>&nbsp;</p>
					<p>&nbsp;</p>
					<div id='stylized-form' class='myform'>
			<form id='form' name='form'>  
				 <h1>User Successfully Gotten</h1>
				 <p>User Information</p>
				 
				<label>Username
				<span class='small'>User's Username</span>
				</label>
				<input type='text' name='username' id='username' value='#{getUser['user']['name']}' readonly/>

				<label>Email
				<span class='small'>User Email</span>
				</label>
				<input type='text' name='userEmail' id='userEmail' value='#{getUser['user']['email']}' readonly/>

				<label>ID
				<span class='small'>User ID</span>
				</label>
				<input type='text' name='userID' id='userID' value='#{getUser['user']['id']}' readonly/>

				<label>ID
				<span class='small'>Tenant ID</span>
				</label>
				<input type='text' name='tenantID' id='tenantID' value='#{getUser['user']['tenantid']}' readonly/>
		

				<button type='button'>Submit</button>	 
				 <div class='space'></div>
			</form>  
		</div>
			<footer>
			  <p>Copyright &copy; Ruby Group | <a> Nowlin, Gleason, Lawson, Dron-Smith, Wedelich, Morales, Amundson</a></p>
			</footer>
		</body>
</div>
			</html>"
end

get '/Users_List.erb' do
	userList = $c.user_list
	prettyTenants = JSON.pretty_generate(userList)
	prettyHTML = prettyTenants.gsub(/\n/, "<br>")
	prettyHTML = prettyHTML.gsub('{', "")
	prettyHTML = prettyHTML.gsub('}', "")
	prettyHTML = prettyHTML.gsub(']', "")
	prettyHTML = prettyHTML.gsub('[', "")
	prettyHTML = prettyHTML.gsub(',', "")
"<html><head><link rel='stylesheet' type='text/css' href='/css/ss-style.css'/></head><body>
		<div id='main'>
				<div id='logo'>
					<div id='logo_text'>
						<h1><a href='SS'>Senior Software: <span class='logo_colour'>Ruby Group</span></a></h1>
						<h2>Simple. Sexy. Smart.</h2>
					</div>
				</div>
				<div id='menu_container'>
					<nav>
						<ul>
							<li><a href='/Home.erb'>Home</a></li>  
							<li><a>Tenants</a>
								<ul>
									<li><a href='/Tenants_List.erb'>List Tenants</a></li>
									<li><a href='/Tenants_Delete.erb'>Delete Tenant</a></li>
									<li><a href='/Tenants_Add.erb'>Add Tenant</a></li>
									<li><a href='/Tenants_Get.erb'>Get Tenant</a></li>
								</ul>
							</li>
							<li><a>Users</a>
								<ul>
									<li><a href='Users_List.erb'>List Users</a></li>
									<li><a href='Users_Delete.erb'>Delete User</a></li>
									<li><a href='Users_Add.erb'>Add User</a></li>
									<li><a href='Users_Get.erb'>Get User</a></li>
									<li><a href='Users_Update_Password.erb'>Update User Password</a></li>
								</ul>
							</li>
							<li><a>Services</a>
								<ul>
									<li><a href='Services_List.erb'>List Services</a></li>
									<li><a href='Services_Delete.erb'>Delete Service</a></li>
									<li><a href='Services_Add.erb'>Add Service</a></li>
									<li><a href='Services_Get.erb'>Get Service</a></li>
								</ul>
							</li>
							<li><a>Endpoints</a>
								<ul>
									<li><a href='Endpoints_List.erb'>List Endpoints</a></li>
									<li><a href='Endpoints_Delete.erb'>Delete Endpoint</a></li>
									<li><a href='Endpoints_Add.erb'>Add Endpoint</a></li>
									<li><a href='Endpoints_Get.erb'>Get Endpoint</a></li>
								</ul>
							</li>
							<li><a>Roles</a>
								<ul>
									<li><a href='Roles_List.erb'>List Roles</a></li>
									<li><a href='Roles_Delete.erb'>Delete Role</a></li>
									<li><a href='Roles_Add.erb'>Add Role</a></li>
									<li><a href='Roles_Get.erb'>Get Role</a></li>
								</ul>
							</li>
						</ul>
					</nav>
				</div>
					<p>&nbsp;</p>
					<p>&nbsp;</p>
					<p>&nbsp;</p>
					<p>&nbsp;</p>
					<p>&nbsp;</p>
					<div id='print-area'><p>hello #{prettyHTML}</p></div>
			<footer>
			  <p>Copyright &copy; Ruby Group | <a> Nowlin, Gleason, Lawson, Dron-Smith, Wedelich, Morales, Amundson</a></p>
			</footer>
		</body>
</div>
			</html>"
end

#SERVICES

get '/Services_Add.erb' do
	erb :Services_Add
end

get '/Services_Add_Form.erb' do
	addService = $c.service_create(params[:serviceName], params[:serviceType], params[:serviceDescription])
	"<html><head><link rel='stylesheet' type='text/css' href='/css/ss-style.css'/></head><body>
		<div id='main'>
				<div id='logo'>
					<div id='logo_text'>
						<h1><a href='SS'>Senior Software: <span class='logo_colour'>Ruby Group</span></a></h1>
						<h2>Simple. Sexy. Smart.</h2>
					</div>
				</div>
				<div id='menu_container'>
					<nav>
						<ul>
							<li><a href='/Home.erb'>Home</a></li>  
							<li><a>Tenants</a>
								<ul>
									<li><a href='/Tenants_List.erb'>List Tenants</a></li>
									<li><a href='/Tenants_Delete.erb'>Delete Tenant</a></li>
									<li><a href='/Tenants_Add.erb'>Add Tenant</a></li>
									<li><a href='/Tenants_Get.erb'>Get Tenant</a></li>
								</ul>
							</li>
							<li><a>Users</a>
								<ul>
									<li><a href='Users_List.erb'>List Users</a></li>
									<li><a href='Users_Delete.erb'>Delete User</a></li>
									<li><a href='Users_Add.erb'>Add User</a></li>
									<li><a href='Users_Get.erb'>Get User</a></li>
									<li><a href='Users_Update_Password.erb'>Update User Password</a></li>
								</ul>
							</li>
							<li><a>Services</a>
								<ul>
									<li><a href='Services_List.erb'>List Services</a></li>
									<li><a href='Services_Delete.erb'>Delete Service</a></li>
									<li><a href='Services_Add.erb'>Add Service</a></li>
									<li><a href='Services_Get.erb'>Get Service</a></li>
								</ul>
							</li>
							<li><a>Endpoints</a>
								<ul>
									<li><a href='Endpoints_List.erb'>List Endpoints</a></li>
									<li><a href='Endpoints_Delete.erb'>Delete Endpoint</a></li>
									<li><a href='Endpoints_Add.erb'>Add Endpoint</a></li>
									<li><a href='Endpoints_Get.erb'>Get Endpoint</a></li>
								</ul>
							</li>
							<li><a>Roles</a>
								<ul>
									<li><a href='Roles_List.erb'>List Roles</a></li>
									<li><a href='Roles_Delete.erb'>Delete Role</a></li>
									<li><a href='Roles_Add.erb'>Add Role</a></li>
									<li><a href='Roles_Get.erb'>Get Role</a></li>
								</ul>
							</li>
						</ul>
					</nav>
				</div>
					<p>&nbsp;</p>
					<p>&nbsp;</p>
					<p>&nbsp;</p>
					<p>&nbsp;</p>
					<p>&nbsp;</p>
					<div id='stylized-form' class='myform'>
			<form id='form' name='form'>  
				 <h1>Service Successfully Created</h1>
				 <p>Service Information</p>
				 
				<label>Name
				<span class='small'>Service Name</span>
				</label>
				<input type='text' name='serviceName' id='serviceName' value='#{addService['services']['name']}' readonly/>

				<label>Type
				<span class='small'>Service Type</span>
				</label>
				<input type='text' name='serviceType' id='serviceType' value='#{addService['services']['type']}' readonly/>

				<label>Description
				<span class='small'>Service Description</span>
				</label>
				<input type='text' name='serviceDescription' id='serviceDescription' value='#{addService['services']['description']}' readonly/>

				<label>ID
				<span class='small'>Service ID</span>
				</label>
				<input type='text' name='serviceID' id='serviceID' value='#{addService['services']['id']}' readonly/>
		

				<button type='button'>Submit</button>	 
				 <div class='space'></div>
			</form>  
		</div>
			<footer>
			  <p>Copyright &copy; Ruby Group | <a> Nowlin, Gleason, Lawson, Dron-Smith, Wedelich, Morales, Amundson</a></p>
			</footer>
		</body>
</div>
			</html>"
end

get '/Services_Delete.erb' do
	erb :Services_Delete
end

get '/Services_Delete_Form.erb' do
	$c.service_delete(params[:serviceID])
	"<html><head><link rel='stylesheet' type='text/css' href='/css/ss-style.css'/></head><body>
		<div id='main'>
				<div id='logo'>
					<div id='logo_text'>
						<h1><a href='SS'>Senior Software: <span class='logo_colour'>Ruby Group</span></a></h1>
						<h2>Simple. Sexy. Smart.</h2>
					</div>
				</div>
				<div id='menu_container'>
					<nav>
						<ul>
							<li><a href='/Home.erb'>Home</a></li>  
							<li><a>Tenants</a>
								<ul>
									<li><a href='/Tenants_List.erb'>List Tenants</a></li>
									<li><a href='/Tenants_Delete.erb'>Delete Tenant</a></li>
									<li><a href='/Tenants_Add.erb'>Add Tenant</a></li>
									<li><a href='/Tenants_Get.erb'>Get Tenant</a></li>
								</ul>
							</li>
							<li><a>Users</a>
								<ul>
									<li><a href='Users_List.erb'>List Users</a></li>
									<li><a href='Users_Delete.erb'>Delete User</a></li>
									<li><a href='Users_Add.erb'>Add User</a></li>
									<li><a href='Users_Get.erb'>Get User</a></li>
									<li><a href='Users_Update_Password.erb'>Update User Password</a></li>
								</ul>
							</li>
							<li><a>Services</a>
								<ul>
									<li><a href='Services_List.erb'>List Services</a></li>
									<li><a href='Services_Delete.erb'>Delete Service</a></li>
									<li><a href='Services_Add.erb'>Add Service</a></li>
									<li><a href='Services_Get.erb'>Get Service</a></li>
								</ul>
							</li>
							<li><a>Endpoints</a>
								<ul>
									<li><a href='Endpoints_List.erb'>List Endpoints</a></li>
									<li><a href='Endpoints_Delete.erb'>Delete Endpoint</a></li>
									<li><a href='Endpoints_Add.erb'>Add Endpoint</a></li>
									<li><a href='Endpoints_Get.erb'>Get Endpoint</a></li>
								</ul>
							</li>
							<li><a>Roles</a>
								<ul>
									<li><a href='Roles_List.erb'>List Roles</a></li>
									<li><a href='Roles_Delete.erb'>Delete Role</a></li>
									<li><a href='Roles_Add.erb'>Add Role</a></li>
									<li><a href='Roles_Get.erb'>Get Role</a></li>
								</ul>
							</li>
						</ul>
					</nav>
				</div>
					<p>&nbsp;</p>
					<p>&nbsp;</p>
					<p>&nbsp;</p>
					<p>&nbsp;</p>
					<p>&nbsp;</p>
					<div id='stylized-form' class='myform'>
			<form id='form' name='form' action='/Home.erb'>  
				 <h1>Service Deleted</h1>
				 <p>Service deletion successful!</p>
				 
				<button type='submit'>Submit</button>	 
				 <div class='space'></div>
			</form>  
		</div>
			<footer>
			  <p>Copyright &copy; Ruby Group | <a> Nowlin, Gleason, Lawson, Dron-Smith, Wedelich, Morales, Amundson</a></p>
			</footer>
		</body>
</div>
			</html>"
end

get '/Services_Get.erb' do
	erb :Services_Get
end

get '/Services_Get_Form.erb' do
	getService = $c.service_get(params[:serviceID])
	"<html><head><link rel='stylesheet' type='text/css' href='/css/ss-style.css'/></head><body>
		<div id='main'>
				<div id='logo'>
					<div id='logo_text'>
						<h1><a href='SS'>Senior Software: <span class='logo_colour'>Ruby Group</span></a></h1>
						<h2>Simple. Sexy. Smart.</h2>
					</div>
				</div>
				<div id='menu_container'>
					<nav>
						<ul>
							<li><a href='/Home.erb'>Home</a></li>  
							<li><a>Tenants</a>
								<ul>
									<li><a href='/Tenants_List.erb'>List Tenants</a></li>
									<li><a href='/Tenants_Delete.erb'>Delete Tenant</a></li>
									<li><a href='/Tenants_Add.erb'>Add Tenant</a></li>
									<li><a href='/Tenants_Get.erb'>Get Tenant</a></li>
								</ul>
							</li>
							<li><a>Users</a>
								<ul>
									<li><a href='Users_List.erb'>List Users</a></li>
									<li><a href='Users_Delete.erb'>Delete User</a></li>
									<li><a href='Users_Add.erb'>Add User</a></li>
									<li><a href='Users_Get.erb'>Get User</a></li>
									<li><a href='Users_Update_Password.erb'>Update User Password</a></li>
								</ul>
							</li>
							<li><a>Services</a>
								<ul>
									<li><a href='Services_List.erb'>List Services</a></li>
									<li><a href='Services_Delete.erb'>Delete Service</a></li>
									<li><a href='Services_Add.erb'>Add Service</a></li>
									<li><a href='Services_Get.erb'>Get Service</a></li>
								</ul>
							</li>
							<li><a>Endpoints</a>
								<ul>
									<li><a href='Endpoints_List.erb'>List Endpoints</a></li>
									<li><a href='Endpoints_Delete.erb'>Delete Endpoint</a></li>
									<li><a href='Endpoints_Add.erb'>Add Endpoint</a></li>
									<li><a href='Endpoints_Get.erb'>Get Endpoint</a></li>
								</ul>
							</li>
							<li><a>Roles</a>
								<ul>
									<li><a href='Roles_List.erb'>List Roles</a></li>
									<li><a href='Roles_Delete.erb'>Delete Role</a></li>
									<li><a href='Roles_Add.erb'>Add Role</a></li>
									<li><a href='Roles_Get.erb'>Get Role</a></li>
								</ul>
							</li>
						</ul>
					</nav>
				</div>
					<p>&nbsp;</p>
					<p>&nbsp;</p>
					<p>&nbsp;</p>
					<p>&nbsp;</p>
					<p>&nbsp;</p>
					<div id='stylized-form' class='myform'>
			<form id='form' name='form'>  
				 <h1>Service Successfully Created</h1>
				 <p>Service Information</p>
				 
				<label>Name
				<span class='small'>Service Name</span>
				</label>
				<input type='text' name='serviceName' id='serviceName' value='#{getService['OS-KSADM:services']['name']}' readonly/>

				<label>Type
				<span class='small'>Service Type</span>
				</label>
				<input type='text' name='serviceType' id='serviceType' value='#{getService['OS-KSADM:services']['type']}' readonly/>

				<label>Description
				<span class='small'>Service Description</span>
				</label>
				<input type='text' name='serviceDescription' id='serviceDescription' value='#{getService['OS-KSADM:services']['description']}' readonly/>

				<label>ID
				<span class='small'>Service ID</span>
				</label>
				<input type='text' name='serviceID' id='serviceID' value='#{getService['OS-KSADM:services']['id']}' readonly/>
		
				<button type='button'>Submit</button>	 
				 <div class='space'></div>
			</form>  
		</div>
			<footer>
			  <p>Copyright &copy; Ruby Group | <a> Nowlin, Gleason, Lawson, Dron-Smith, Wedelich, Morales, Amundson</a></p>
			</footer>
		</body>
</div>
			</html>"
end

get '/Services_List.erb' do
"<html><head><link rel='stylesheet' type='text/css' href='/css/ss-style.css'/></head><body>
		<div id='main'>
				<div id='logo'>
					<div id='logo_text'>
						<h1><a href='SS'>Senior Software: <span class='logo_colour'>Ruby Group</span></a></h1>
						<h2>Simple. Sexy. Smart.</h2>
					</div>
				</div>
				<div id='menu_container'>
					<nav>
						<ul>
							<li><a href='/Home.erb'>Home</a></li>  
							<li><a>Tenants</a>
								<ul>
									<li><a href='/Tenants_List.erb'>List Tenants</a></li>
									<li><a href='/Tenants_Delete.erb'>Delete Tenant</a></li>
									<li><a href='/Tenants_Add.erb'>Add Tenant</a></li>
									<li><a href='/Tenants_Get.erb'>Get Tenant</a></li>
								</ul>
							</li>
							<li><a>Users</a>
								<ul>
									<li><a href='Users_List.erb'>List Users</a></li>
									<li><a href='Users_Delete.erb'>Delete User</a></li>
									<li><a href='Users_Add.erb'>Add User</a></li>
									<li><a href='Users_Get.erb'>Get User</a></li>
									<li><a href='Users_Update_Password.erb'>Update User Password</a></li>
								</ul>
							</li>
							<li><a>Services</a>
								<ul>
									<li><a href='Services_List.erb'>List Services</a></li>
									<li><a href='Services_Delete.erb'>Delete Service</a></li>
									<li><a href='Services_Add.erb'>Add Service</a></li>
									<li><a href='Services_Get.erb'>Get Service</a></li>
								</ul>
							</li>
							<li><a>Endpoints</a>
								<ul>
									<li><a href='Endpoints_List.erb'>List Endpoints</a></li>
									<li><a href='Endpoints_Delete.erb'>Delete Endpoint</a></li>
									<li><a href='Endpoints_Add.erb'>Add Endpoint</a></li>
									<li><a href='Endpoints_Get.erb'>Get Endpoint</a></li>
								</ul>
							</li>
							<li><a>Roles</a>
								<ul>
									<li><a href='Roles_List.erb'>List Roles</a></li>
									<li><a href='Roles_Delete.erb'>Delete Role</a></li>
									<li><a href='Roles_Add.erb'>Add Role</a></li>
									<li><a href='Roles_Get.erb'>Get Role</a></li>
								</ul>
							</li>
						</ul>
					</nav>
				</div>
					<p>&nbsp;</p>
					<p>&nbsp;</p>
					<p>&nbsp;</p>
					<p>&nbsp;</p>
					<p>&nbsp;</p>
					<div id='print-area'><p>hello #{$c.service_list}</p></div>
			<footer>
			  <p>Copyright &copy; Ruby Group | <a> Nowlin, Gleason, Lawson, Dron-Smith, Wedelich, Morales, Amundson</a></p>
			</footer>
		</body>
</div>
			</html>"
end


#ROLES

get '/Roles_Add.erb' do
	erb :Roles_Add
end

get '/Roles_Add_Form.erb' do
	addRole = $c.role_create(params[:roleName])
	"<html><head><link rel='stylesheet' type='text/css' href='/css/ss-style.css'/></head><body>
		<div id='main'>
				<div id='logo'>
					<div id='logo_text'>
						<h1><a href='SS'>Senior Software: <span class='logo_colour'>Ruby Group</span></a></h1>
						<h2>Simple. Sexy. Smart.</h2>
					</div>
				</div>
				<div id='menu_container'>
					<nav>
						<ul>
							<li><a href='/Home.erb'>Home</a></li>  
							<li><a>Tenants</a>
								<ul>
									<li><a href='/Tenants_List.erb'>List Tenants</a></li>
									<li><a href='/Tenants_Delete.erb'>Delete Tenant</a></li>
									<li><a href='/Tenants_Add.erb'>Add Tenant</a></li>
									<li><a href='/Tenants_Get.erb'>Get Tenant</a></li>
								</ul>
							</li>
							<li><a>Users</a>
								<ul>
									<li><a href='Users_List.erb'>List Users</a></li>
									<li><a href='Users_Delete.erb'>Delete User</a></li>
									<li><a href='Users_Add.erb'>Add User</a></li>
									<li><a href='Users_Get.erb'>Get User</a></li>
									<li><a href='Users_Update_Password.erb'>Update User Password</a></li>
								</ul>
							</li>
							<li><a>Services</a>
								<ul>
									<li><a href='Services_List.erb'>List Services</a></li>
									<li><a href='Services_Delete.erb'>Delete Service</a></li>
									<li><a href='Services_Add.erb'>Add Service</a></li>
									<li><a href='Services_Get.erb'>Get Service</a></li>
								</ul>
							</li>
							<li><a>Endpoints</a>
								<ul>
									<li><a href='Endpoints_List.erb'>List Endpoints</a></li>
									<li><a href='Endpoints_Delete.erb'>Delete Endpoint</a></li>
									<li><a href='Endpoints_Add.erb'>Add Endpoint</a></li>
									<li><a href='Endpoints_Get.erb'>Get Endpoint</a></li>
								</ul>
							</li>
							<li><a>Roles</a>
								<ul>
									<li><a href='Roles_List.erb'>List Roles</a></li>
									<li><a href='Roles_Delete.erb'>Delete Role</a></li>
									<li><a href='Roles_Add.erb'>Add Role</a></li>
									<li><a href='Roles_Get.erb'>Get Role</a></li>
								</ul>
							</li>
						</ul>
					</nav>
				</div>
					<p>&nbsp;</p>
					<p>&nbsp;</p>
					<p>&nbsp;</p>
					<p>&nbsp;</p>
					<p>&nbsp;</p>
					<div id='stylized-form' class='myform'>
			<form id='form' name='form'>  
				 <h1>Role Successfully Created</h1>
				 <p>Role Information</p>
				 
				<label>Name
				<span class='small'>Role Name</span>
				</label>
				<input type='text' name='roleName' id='roleName' value='#{addRole['role']['name']}' readonly/>

				<label>ID
				<span class='small'>Role ID</span>
				</label>
				<input type='text' name='roleID' id='roleID' value='#{addRole['role']['id']}' readonly/>
		
				<button type='button'>Submit</button>	 
				 <div class='space'></div>
			</form>  
		</div>
			<footer>
			  <p>Copyright &copy; Ruby Group | <a> Nowlin, Gleason, Lawson, Dron-Smith, Wedelich, Morales, Amundson</a></p>
			</footer>
		</body>
</div>
			</html>"
end

get '/Roles_Delete.erb' do
	erb :Roles_Delete
end

get '/Roles_Delete_Form.erb' do
	$c.role_delete(params[:roleID])
	"<html><head><link rel='stylesheet' type='text/css' href='/css/ss-style.css'/></head><body>
		<div id='main'>
				<div id='logo'>
					<div id='logo_text'>
						<h1><a href='SS'>Senior Software: <span class='logo_colour'>Ruby Group</span></a></h1>
						<h2>Simple. Sexy. Smart.</h2>
					</div>
				</div>
				<div id='menu_container'>
					<nav>
						<ul>
							<li><a href='/Home.erb'>Home</a></li>  
							<li><a>Tenants</a>
								<ul>
									<li><a href='/Tenants_List.erb'>List Tenants</a></li>
									<li><a href='/Tenants_Delete.erb'>Delete Tenant</a></li>
									<li><a href='/Tenants_Add.erb'>Add Tenant</a></li>
									<li><a href='/Tenants_Get.erb'>Get Tenant</a></li>
								</ul>
							</li>
							<li><a>Users</a>
								<ul>
									<li><a href='Users_List.erb'>List Users</a></li>
									<li><a href='Users_Delete.erb'>Delete User</a></li>
									<li><a href='Users_Add.erb'>Add User</a></li>
									<li><a href='Users_Get.erb'>Get User</a></li>
									<li><a href='Users_Update_Password.erb'>Update User Password</a></li>
								</ul>
							</li>
							<li><a>Services</a>
								<ul>
									<li><a href='Services_List.erb'>List Services</a></li>
									<li><a href='Services_Delete.erb'>Delete Service</a></li>
									<li><a href='Services_Add.erb'>Add Service</a></li>
									<li><a href='Services_Get.erb'>Get Service</a></li>
								</ul>
							</li>
							<li><a>Endpoints</a>
								<ul>
									<li><a href='Endpoints_List.erb'>List Endpoints</a></li>
									<li><a href='Endpoints_Delete.erb'>Delete Endpoint</a></li>
									<li><a href='Endpoints_Add.erb'>Add Endpoint</a></li>
									<li><a href='Endpoints_Get.erb'>Get Endpoint</a></li>
								</ul>
							</li>
							<li><a>Roles</a>
								<ul>
									<li><a href='Roles_List.erb'>List Roles</a></li>
									<li><a href='Roles_Delete.erb'>Delete Role</a></li>
									<li><a href='Roles_Add.erb'>Add Role</a></li>
									<li><a href='Roles_Get.erb'>Get Role</a></li>
								</ul>
							</li>
						</ul>
					</nav>
				</div>
					<p>&nbsp;</p>
					<p>&nbsp;</p>
					<p>&nbsp;</p>
					<p>&nbsp;</p>
					<p>&nbsp;</p>
					<div id='stylized-form' class='myform'>
			<form id='form' name='form' action='/Home.erb'>  
				 <h1>Role Deleted</h1>
				 <p>Role Deletion Successful!</p>
				 
				<button type='submit'>Submit</button>	 
				 <div class='space'></div>
			</form>  
		</div>
			<footer>
			  <p>Copyright &copy; Ruby Group | <a> Nowlin, Gleason, Lawson, Dron-Smith, Wedelich, Morales, Amundson</a></p>
			</footer>
		</body>
</div>
			</html>"
end

get '/Roles_Get.erb' do
	erb :Roles_Get
end

get '/Roles_Get_Form.erb' do
	getRole = $c.role_get(params[:roleID])
	"<html><head><link rel='stylesheet' type='text/css' href='/css/ss-style.css'/></head><body>
		<div id='main'>
				<div id='logo'>
					<div id='logo_text'>
						<h1><a href='SS'>Senior Software: <span class='logo_colour'>Ruby Group</span></a></h1>
						<h2>Simple. Sexy. Smart.</h2>
					</div>
				</div>
				<div id='menu_container'>
					<nav>
						<ul>
							<li><a href='/Home.erb'>Home</a></li>  
							<li><a>Tenants</a>
								<ul>
									<li><a href='/Tenants_List.erb'>List Tenants</a></li>
									<li><a href='/Tenants_Delete.erb'>Delete Tenant</a></li>
									<li><a href='/Tenants_Add.erb'>Add Tenant</a></li>
									<li><a href='/Tenants_Get.erb'>Get Tenant</a></li>
								</ul>
							</li>
							<li><a>Users</a>
								<ul>
									<li><a href='Users_List.erb'>List Users</a></li>
									<li><a href='Users_Delete.erb'>Delete User</a></li>
									<li><a href='Users_Add.erb'>Add User</a></li>
									<li><a href='Users_Get.erb'>Get User</a></li>
									<li><a href='Users_Update_Password.erb'>Update User Password</a></li>
								</ul>
							</li>
							<li><a>Services</a>
								<ul>
									<li><a href='Services_List.erb'>List Services</a></li>
									<li><a href='Services_Delete.erb'>Delete Service</a></li>
									<li><a href='Services_Add.erb'>Add Service</a></li>
									<li><a href='Services_Get.erb'>Get Service</a></li>
								</ul>
							</li>
							<li><a>Endpoints</a>
								<ul>
									<li><a href='Endpoints_List.erb'>List Endpoints</a></li>
									<li><a href='Endpoints_Delete.erb'>Delete Endpoint</a></li>
									<li><a href='Endpoints_Add.erb'>Add Endpoint</a></li>
									<li><a href='Endpoints_Get.erb'>Get Endpoint</a></li>
								</ul>
							</li>
							<li><a>Roles</a>
								<ul>
									<li><a href='Roles_List.erb'>List Roles</a></li>
									<li><a href='Roles_Delete.erb'>Delete Role</a></li>
									<li><a href='Roles_Add.erb'>Add Role</a></li>
									<li><a href='Roles_Get.erb'>Get Role</a></li>
								</ul>
							</li>
						</ul>
					</nav>
				</div>
					<p>&nbsp;</p>
					<p>&nbsp;</p>
					<p>&nbsp;</p>
					<p>&nbsp;</p>
					<p>&nbsp;</p>
					<div id='stylized-form' class='myform'>
			<form id='form' name='form'>  
				 <h1>Role Successfully Grabbed</h1>
				 <p>Role Information</p>
				 
				<label>Name
				<span class='small'>Role Name</span>
				</label>
				<input type='text' name='roleName' id='roleName' value='#{getRole['role']['name']}' readonly/>

				<label>ID
				<span class='small'>Role ID</span>
				</label>
				<input type='text' name='roleID' id='roleID' value='#{getRole['role']['id']}' readonly/>
		
				<button type='button'>Submit</button>	 
				 <div class='space'></div>
			</form>  
		</div>
			<footer>
			  <p>Copyright &copy; Ruby Group | <a> Nowlin, Gleason, Lawson, Dron-Smith, Wedelich, Morales, Amundson</a></p>
			</footer>
		</body>
</div>
			</html>"
end

get '/Roles_List.erb' do
		"<html><head><link rel='stylesheet' type='text/css' href='/css/ss-style.css'/></head><body>
		<div id='main'>
				<div id='logo'>
					<div id='logo_text'>
						<h1><a href='SS'>Senior Software: <span class='logo_colour'>Ruby Group</span></a></h1>
						<h2>Simple. Sexy. Smart.</h2>
					</div>
				</div>
				<div id='menu_container'>
					<nav>
						<ul>
							<li><a href='/Home.erb'>Home</a></li>  
							<li><a>Tenants</a>
								<ul>
									<li><a href='/Tenants_List.erb'>List Tenants</a></li>
									<li><a href='/Tenants_Delete.erb'>Delete Tenant</a></li>
									<li><a href='/Tenants_Add.erb'>Add Tenant</a></li>
									<li><a href='/Tenants_Get.erb'>Get Tenant</a></li>
								</ul>
							</li>
							<li><a>Users</a>
								<ul>
									<li><a href='Users_List.erb'>List Users</a></li>
									<li><a href='Users_Delete.erb'>Delete User</a></li>
									<li><a href='Users_Add.erb'>Add User</a></li>
									<li><a href='Users_Get.erb'>Get User</a></li>
									<li><a href='Users_Update_Password.erb'>Update User Password</a></li>
								</ul>
							</li>
							<li><a>Services</a>
								<ul>
									<li><a href='Services_List.erb'>List Services</a></li>
									<li><a href='Services_Delete.erb'>Delete Service</a></li>
									<li><a href='Services_Add.erb'>Add Service</a></li>
									<li><a href='Services_Get.erb'>Get Service</a></li>
								</ul>
							</li>
							<li><a>Endpoints</a>
								<ul>
									<li><a href='Endpoints_List.erb'>List Endpoints</a></li>
									<li><a href='Endpoints_Delete.erb'>Delete Endpoint</a></li>
									<li><a href='Endpoints_Add.erb'>Add Endpoint</a></li>
									<li><a href='Endpoints_Get.erb'>Get Endpoint</a></li>
								</ul>
							</li>
							<li><a>Roles</a>
								<ul>
									<li><a href='Roles_List.erb'>List Roles</a></li>
									<li><a href='Roles_Delete.erb'>Delete Role</a></li>
									<li><a href='Roles_Add.erb'>Add Role</a></li>
									<li><a href='Roles_Get.erb'>Get Role</a></li>
								</ul>
							</li>
						</ul>
					</nav>
				</div>
					<p>&nbsp;</p>
					<p>&nbsp;</p>
					<p>&nbsp;</p>
					<p>&nbsp;</p>
					<p>&nbsp;</p>
					<div id='print-area'><p>hello #{$c.role_list}</p></div>
			<footer>
			  <p>Copyright &copy; Ruby Group | <a> Nowlin, Gleason, Lawson, Dron-Smith, Wedelich, Morales, Amundson</a></p>
			</footer>
		</body>
</div>
			</html>"
end


#Endpoint

get '/Endpoints_Add.erb' do
	erb :Endpoints_Add
end

get '/Endpoints_Add_Form.erb' do
	addEndpoint = $c.endpoint_create(params[:region], params[:serviceID], params[:publiccURL], params[:adminURL], params[:internalURL])
	"<html><head><link rel='stylesheet' type='text/css' href='/css/ss-style.css'/></head><body>
		<div id='main'>
				<div id='logo'>
					<div id='logo_text'>
						<h1><a href='SS'>Senior Software: <span class='logo_colour'>Ruby Group</span></a></h1>
						<h2>Simple. Sexy. Smart.</h2>
					</div>
				</div>
				<div id='menu_container'>
					<nav>
						<ul>
							<li><a href='/Home.erb'>Home</a></li>  
							<li><a>Tenants</a>
								<ul>
									<li><a href='/Tenants_List.erb'>List Tenants</a></li>
									<li><a href='/Tenants_Delete.erb'>Delete Tenant</a></li>
									<li><a href='/Tenants_Add.erb'>Add Tenant</a></li>
									<li><a href='/Tenants_Get.erb'>Get Tenant</a></li>
								</ul>
							</li>
							<li><a>Users</a>
								<ul>
									<li><a href='Users_List.erb'>List Users</a></li>
									<li><a href='Users_Delete.erb'>Delete User</a></li>
									<li><a href='Users_Add.erb'>Add User</a></li>
									<li><a href='Users_Get.erb'>Get User</a></li>
									<li><a href='Users_Update_Password.erb'>Update User Password</a></li>
								</ul>
							</li>
							<li><a>Services</a>
								<ul>
									<li><a href='Services_List.erb'>List Services</a></li>
									<li><a href='Services_Delete.erb'>Delete Service</a></li>
									<li><a href='Services_Add.erb'>Add Service</a></li>
									<li><a href='Services_Get.erb'>Get Service</a></li>
								</ul>
							</li>
							<li><a>Endpoints</a>
								<ul>
									<li><a href='Endpoints_List.erb'>List Endpoints</a></li>
									<li><a href='Endpoints_Delete.erb'>Delete Endpoint</a></li>
									<li><a href='Endpoints_Add.erb'>Add Endpoint</a></li>
									<li><a href='Endpoints_Get.erb'>Get Endpoint</a></li>
								</ul>
							</li>
							<li><a>Roles</a>
								<ul>
									<li><a href='Roles_List.erb'>List Roles</a></li>
									<li><a href='Roles_Delete.erb'>Delete Role</a></li>
									<li><a href='Roles_Add.erb'>Add Role</a></li>
									<li><a href='Roles_Get.erb'>Get Role</a></li>
								</ul>
							</li>
						</ul>
					</nav>
				</div>
					<p>&nbsp;</p>
					<p>&nbsp;</p>
					<p>&nbsp;</p>
					<p>&nbsp;</p>
					<p>&nbsp;</p>
					<div id='stylized-form' class='myform'>
			<form id='form' name='form'>  
				 <h1>Endpoint Successfully Created</h1>
				 <p>Endpont Information</p>
				 
				<label>Region
				<span class='small'>Endpoint Region</span>
				</label>
				<input type='text' name='endpointRegion' id='endpointRegion' value='#{addEndpoint['endpoints']['name']}' readonly/>

				<label>URL
				<span class='small'>Public URL</span>
				</label>
				<input type='text' name='publicURL' id='publicURL' value='#{addEndpoint['endpoints']['publicurl']}' readonly/>

				<label>URL
				<span class='small'>Admin URL</span>
				</label>
				<input type='text' name='adminURL' id='adminURL' value='#{addEndpoint['endpoints']['adminurl']}' readonly/>
			
				<label>URL
				<span class='small'>Internal URL</span>
				</label>
				<input type='text' name='internalURL' id='internalURL' value='#{addEndpoint['endpoints']['internalurl']}' readonly/>

				<label>ID
				<span class='small'>Endpoint ID</span>
				</label>
				<input type='text' name='endpointID' id='endpointID' value='#{addEndpoint['endpoints']['id']}' readonly/>

				<label>ID
				<span class='small'>Service ID</span>
				</label>
				<input type='text' name='serviceID' id='serviceID' value='#{addEndpoint['endpoints']['service_id']}' readonly/>
		

				<button type='button'>Submit</button>	 
				 <div class='space'></div>
			</form>  
		</div>
			<footer>
			  <p>Copyright &copy; Ruby Group | <a> Nowlin, Gleason, Lawson, Dron-Smith, Wedelich, Morales, Amundson</a></p>
			</footer>
		</body>
</div>
			</html>"
end

get '/Endpoints_Delete.erb' do
	erb :Endpoints_Delete
end

get '/Endpoints_Delete_Form.erb' do
	$c.endpoint_delete(params[:enpointID])
	"<html><head><link rel='stylesheet' type='text/css' href='/css/ss-style.css'/></head><body>
		<div id='main'>
				<div id='logo'>
					<div id='logo_text'>
						<h1><a href='SS'>Senior Software: <span class='logo_colour'>Ruby Group</span></a></h1>
						<h2>Simple. Sexy. Smart.</h2>
					</div>
				</div>
				<div id='menu_container'>
					<nav>
						<ul>
							<li><a href='/Home.erb'>Home</a></li>  
							<li><a>Tenants</a>
								<ul>
									<li><a href='/Tenants_List.erb'>List Tenants</a></li>
									<li><a href='/Tenants_Delete.erb'>Delete Tenant</a></li>
									<li><a href='/Tenants_Add.erb'>Add Tenant</a></li>
									<li><a href='/Tenants_Get.erb'>Get Tenant</a></li>
								</ul>
							</li>
							<li><a>Users</a>
								<ul>
									<li><a href='Users_List.erb'>List Users</a></li>
									<li><a href='Users_Delete.erb'>Delete User</a></li>
									<li><a href='Users_Add.erb'>Add User</a></li>
									<li><a href='Users_Get.erb'>Get User</a></li>
									<li><a href='Users_Update_Password.erb'>Update User Password</a></li>
								</ul>
							</li>
							<li><a>Services</a>
								<ul>
									<li><a href='Services_List.erb'>List Services</a></li>
									<li><a href='Services_Delete.erb'>Delete Service</a></li>
									<li><a href='Services_Add.erb'>Add Service</a></li>
									<li><a href='Services_Get.erb'>Get Service</a></li>
								</ul>
							</li>
							<li><a>Endpoints</a>
								<ul>
									<li><a href='Endpoints_List.erb'>List Endpoints</a></li>
									<li><a href='Endpoints_Delete.erb'>Delete Endpoint</a></li>
									<li><a href='Endpoints_Add.erb'>Add Endpoint</a></li>
									<li><a href='Endpoints_Get.erb'>Get Endpoint</a></li>
								</ul>
							</li>
							<li><a>Roles</a>
								<ul>
									<li><a href='Roles_List.erb'>List Roles</a></li>
									<li><a href='Roles_Delete.erb'>Delete Role</a></li>
									<li><a href='Roles_Add.erb'>Add Role</a></li>
									<li><a href='Roles_Get.erb'>Get Role</a></li>
								</ul>
							</li>
						</ul>
					</nav>
				</div>
					<p>&nbsp;</p>
					<p>&nbsp;</p>
					<p>&nbsp;</p>
					<p>&nbsp;</p>
					<p>&nbsp;</p>
					<div id='stylized-form' class='myform'>
			<form id='form' name='form' action='/Home.erb'>  
				 <h1>Role Deleted</h1>
				 <p>Role Deletion Successful!</p>
				 
				<button type='submit'>Submit</button>	 
				 <div class='space'></div>
			</form>  
		</div>
			<footer>
			  <p>Copyright &copy; Ruby Group | <a> Nowlin, Gleason, Lawson, Dron-Smith, Wedelich, Morales, Amundson</a></p>
			</footer>
		</body>
</div>
			</html>"
end

get '/Endpoints_Get.erb' do
	erb :Endpoints_Get
end

get '/Endpoints_Get_Form.erb' do
	getEndpoints = $c.endpoint_get(params[:endpointID])
"<html><head><link rel='stylesheet' type='text/css' href='/css/ss-style.css'/></head><body>
		<div id='main'>
				<div id='logo'>
					<div id='logo_text'>
						<h1><a href='SS'>Senior Software: <span class='logo_colour'>Ruby Group</span></a></h1>
						<h2>Simple. Sexy. Smart.</h2>
					</div>
				</div>
				<div id='menu_container'>
					<nav>
						<ul>
							<li><a href='/Home.erb'>Home</a></li>  
							<li><a>Tenants</a>
								<ul>
									<li><a href='/Tenants_List.erb'>List Tenants</a></li>
									<li><a href='/Tenants_Delete.erb'>Delete Tenant</a></li>
									<li><a href='/Tenants_Add.erb'>Add Tenant</a></li>
									<li><a href='/Tenants_Get.erb'>Get Tenant</a></li>
								</ul>
							</li>
							<li><a>Users</a>
								<ul>
									<li><a href='Users_List.erb'>List Users</a></li>
									<li><a href='Users_Delete.erb'>Delete User</a></li>
									<li><a href='Users_Add.erb'>Add User</a></li>
									<li><a href='Users_Get.erb'>Get User</a></li>
									<li><a href='Users_Update_Password.erb'>Update User Password</a></li>
								</ul>
							</li>
							<li><a>Services</a>
								<ul>
									<li><a href='Services_List.erb'>List Services</a></li>
									<li><a href='Services_Delete.erb'>Delete Service</a></li>
									<li><a href='Services_Add.erb'>Add Service</a></li>
									<li><a href='Services_Get.erb'>Get Service</a></li>
								</ul>
							</li>
							<li><a>Endpoints</a>
								<ul>
									<li><a href='Endpoints_List.erb'>List Endpoints</a></li>
									<li><a href='Endpoints_Delete.erb'>Delete Endpoint</a></li>
									<li><a href='Endpoints_Add.erb'>Add Endpoint</a></li>
									<li><a href='Endpoints_Get.erb'>Get Endpoint</a></li>
								</ul>
							</li>
							<li><a>Roles</a>
								<ul>
									<li><a href='Roles_List.erb'>List Roles</a></li>
									<li><a href='Roles_Delete.erb'>Delete Role</a></li>
									<li><a href='Roles_Add.erb'>Add Role</a></li>
									<li><a href='Roles_Get.erb'>Get Role</a></li>
								</ul>
							</li>
						</ul>
					</nav>
				</div>
					<p>&nbsp;</p>
					<p>&nbsp;</p>
					<p>&nbsp;</p>
					<p>&nbsp;</p>
					<p>&nbsp;</p>
					<div id='stylized-form' class='myform'>
			<form id='form' name='form'>  
				 <h1>Endpoint Successfully Grabbed</h1>
				 <p>Endpont Information</p>
				 
				<label>Region
				<span class='small'>Endpoint Region</span>
				</label>
				<input type='text' name='endpointRegion' id='endpointRegion' value='#{getEndpoints['endpoints']['name']}' readonly/>

				<label>URL
				<span class='small'>Public URL</span>
				</label>
				<input type='text' name='publicURL' id='publicURL' value='#{getEndpoints['endpoints']['publicurl']}' readonly/>

				<label>URL
				<span class='small'>Admin URL</span>
				</label>
				<input type='text' name='adminURL' id='adminURL' value='#{getEndpoints['endpoints']['adminurl']}' readonly/>
			
				<label>URL
				<span class='small'>Internal URL</span>
				</label>
				<input type='text' name='internalURL' id='internalURL' value='#{getEndpoints['endpoints']['internalurl']}' readonly/>

				<label>ID
				<span class='small'>Endpoint ID</span>
				</label>
				<input type='text' name='endpointID' id='endpointID' value='#{getEndpoints['endpoints']['id']}' readonly/>

				<label>ID
				<span class='small'>Service ID</span>
				</label>
				<input type='text' name='serviceID' id='serviceID' value='#{getEndpoints['endpoints']['service_id']}' readonly/>
		

				<button type='button'>Submit</button>	 
				 <div class='space'></div>
			</form>  
		</div>
			<footer>
			  <p>Copyright &copy; Ruby Group | <a> Nowlin, Gleason, Lawson, Dron-Smith, Wedelich, Morales, Amundson</a></p>
			</footer>
		</body>
</div>
			</html>"
end

get '/Endpoints_List.erb' do
"<html><head><link rel='stylesheet' type='text/css' href='/css/ss-style.css'/></head><body>
		<div id='main'>
				<div id='logo'>
					<div id='logo_text'>
						<h1><a href='SS'>Senior Software: <span class='logo_colour'>Ruby Group</span></a></h1>
						<h2>Simple. Sexy. Smart.</h2>
					</div>
				</div>
				<div id='menu_container'>
					<nav>
						<ul>
							<li><a href='/Home.erb'>Home</a></li>  
							<li><a>Tenants</a>
								<ul>
									<li><a href='/Tenants_List.erb'>List Tenants</a></li>
									<li><a href='/Tenants_Delete.erb'>Delete Tenant</a></li>
									<li><a href='/Tenants_Add.erb'>Add Tenant</a></li>
									<li><a href='/Tenants_Get.erb'>Get Tenant</a></li>
								</ul>
							</li>
							<li><a>Users</a>
								<ul>
									<li><a href='Users_List.erb'>List Users</a></li>
									<li><a href='Users_Delete.erb'>Delete User</a></li>
									<li><a href='Users_Add.erb'>Add User</a></li>
									<li><a href='Users_Get.erb'>Get User</a></li>
									<li><a href='Users_Update_Password.erb'>Update User Password</a></li>
								</ul>
							</li>
							<li><a>Services</a>
								<ul>
									<li><a href='Services_List.erb'>List Services</a></li>
									<li><a href='Services_Delete.erb'>Delete Service</a></li>
									<li><a href='Services_Add.erb'>Add Service</a></li>
									<li><a href='Services_Get.erb'>Get Service</a></li>
								</ul>
							</li>
							<li><a>Endpoints</a>
								<ul>
									<li><a href='Endpoints_List.erb'>List Endpoints</a></li>
									<li><a href='Endpoints_Delete.erb'>Delete Endpoint</a></li>
									<li><a href='Endpoints_Add.erb'>Add Endpoint</a></li>
									<li><a href='Endpoints_Get.erb'>Get Endpoint</a></li>
								</ul>
							</li>
							<li><a>Roles</a>
								<ul>
									<li><a href='Roles_List.erb'>List Roles</a></li>
									<li><a href='Roles_Delete.erb'>Delete Role</a></li>
									<li><a href='Roles_Add.erb'>Add Role</a></li>
									<li><a href='Roles_Get.erb'>Get Role</a></li>
								</ul>
							</li>
						</ul>
					</nav>
				</div>
					<p>&nbsp;</p>
					<p>&nbsp;</p>
					<p>&nbsp;</p>
					<p>&nbsp;</p>
					<p>&nbsp;</p>
					<div id='print-area'><p>hello #{$c.endpoint_list}</p></div>
			<footer>
			  <p>Copyright &copy; Ruby Group | <a> Nowlin, Gleason, Lawson, Dron-Smith, Wedelich, Morales, Amundson</a></p>
			</footer>
		</body>
</div>
			</html>"
end


	


