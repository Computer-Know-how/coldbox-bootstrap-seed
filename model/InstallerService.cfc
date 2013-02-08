/**
* Initializes Roles & Permissions
*/
component accessors="true"{

	// DI
	property name="userService"			inject="id:security.UserService";
	property name="roleService"			inject="id:security.RoleService";
	property name="permissionService"	inject="id:security.PermissionService";
	property name="securityRuleService"	inject="id:security.SecurityRuleService";
	property name="appPath"				inject="coldbox:setting:applicationPath";
	property name="securityInterceptor"	inject="coldbox:interceptor:security";
	property name="coldbox"				inject="coldbox";

	/**
	* Constructor
	*/
	InstallerService function init(){
		permissions = {};
		return this;
	}

	/**
	* Execute the installer
	*/
	function execute(resetPermission=false) transactional{
		var c = userService.count();
		if (c == 0) {
			// create roles
			var roles = createRoles();
			// create User
			var user = createUser( roles );
			// create all security rules
			createSecurityRules();
			// Reload Security Rules
			securityInterceptor.loadRules();
		}
		if(resetPermission){
			// create roles
			var roles = createRoles();
			// create all security rules
			createSecurityRules();
			// Reload Security Rules
			securityInterceptor.loadRules();
		}
	}

	function createSecurityRules(){
		securityRuleService.resetRules();
	}

	/**
	* Create permissions
	*/
	function createPermissions(){
		var perms = {
			"SETTINGS_ADMIN" = "Access to the system settings",
			"MAIN_DASHBOARD" = "Access to the main dashboard page",
			"USER_VIEW" = "Access to the users, roles, and permissions data input view only",
			"USER_EDIT" = "Access to the users, roles, and permissions data input",
			"USER_DELETE" = "Access to the users, roles, and permissions data delete",
		};

		var allperms = [];
		for(var key in perms){
			var p = permissionService.findWhere({permission = key});
			if(isNull(p)){
				var props = {permission=key, description=perms[key]};
				permissions[ key ] = permissionService.new(properties=props);
				arrayAppend(allPerms, permissions[ key ] );

			} else {
				permissions[ key ] = p;
			}
		}
		permissionService.saveAll( allPerms );
	}

	/**
	* Create roles and return the admin
	*/
	function createRoles(){
		// Create Permissions
		createPermissions();

		var results = {};

		// Create User
		var oRole = roleService.new(properties={role="User",description="A CKH Bootstrap User"});
		// Add User Permissions
		oRole.addPermission( permissions["MAIN_DASHBOARD"] );
		roleService.save(entity=oRole, transactional=false);

		results.userRole = oRole;

		// Create Admin
		var oRole = roleService.new(properties={role="Administrator",description="A CKH Bootstrap Administrator"});
		// Add All Permissions To Admin
		for(var key in permissions){
			oRole.addPermission( permissions[key] );
		}
		roleService.save(entity=oRole, transactional=false);

		results.adminRole = oRole;

		return results;
	}

	/**
	* Create user
	*/
	function createUser(required roles){
		var oUser = userService.new(properties=getAdminUserData());
		oUser.setIsActive( true );
		oUser.setRole( roles.adminRole );
		userService.saveUser( oUser );

		var oUser = userService.new(properties=getUserData());
		oUser.setIsActive( true );
		oUser.setRole( roles.userRole );
		userService.saveUser( oUser );

		return oUser;
	}

	function getAdminUserData(){
		var results = {
			firstname = "Admininstator",
			lastName = "Admin",
			email = "admin@compknowhow.com",
			username = "admin",
			password = "admin"
		};
		return results;
	}

	function getUserData(){
		var results = {
			firstname = "User",
			lastName = "User",
			email = "user@compknowhow.com",
			username = "user",
			password = "user"
		};
		return results;
	}
}