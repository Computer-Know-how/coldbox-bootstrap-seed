/**
* Manage users
*/
component extends="base"{

	// pre handler
	function preHandler(event,action,eventArguments){
		var rc 	= event.getCollection();
		var prc = event.getCollection(private=true);
		// Tab control
		prc.tabUsers = true;
		prc.xehEntryForm = 'users.entryForm';
		prc.xehList = 'users.list';
		prc.xehSave = 'users.save';
		prc.xehDelete = 'users.delete';
		prc.xehValidate = 'users.validate';
		prc.xehRemovePermission = 'users.removePermission';
		prc.xehChangePassword = 'users.doChangePassword';
	}

	function index(event,rc,prc){
		setNextEvent(prc.xehList);
	}

	// list
	function list(event,rc,prc){
		// paging
		event.paramValue("page",1);

		// exit Handlers
		rc.xehUserRemove 	= "users.remove";
		prc.xehUsersearch = "users.users";

		prc.users		= userService.list(sortOrder="lastName desc",asQuery=false);
		prc.userCount 	= userService.count();


		// View
		event.setView("users/list");
	}

	// username check
	function usernameCheck(event,rc,prc){
		var found = true;

		event.paramValue("username","");

		// only check if we have a username
		if( len(username) ){
			found = userService.usernameFound( rc.username );
		}

		event.renderData(type="json",data=found);
	}

	// user editor
	public void function entryForm (event,rc,prc) {
		param name="rc.userID" default=0;

		prc.user = userService.get(rc.userID);


		// get roles
		prc.roles = roleService.list(sortOrder="role",asQuery=false);
		var role = roleService.new({roleID=0,role="-- Please choose a role --"});
		arrayPrepend(prc.roles,role);
		prc.permissions = permissionservice.list(sortOrder="permission",asQuery=false);

		//get selected permissions
		prc.selected = [];
		for(var p in prc.permissions) {
			if(prc.user.hasPermission(p)){
				arrayAppend(prc.selected,p.getPermissionID());
			}
		}

		prc.rules = validationService.createjQueryRules(prc.user,event.buildLink(prc.xehValidate));

		event.setView("users/entryForm");
	}

	// save user
	public void function save (event,rc,prc) {
		param name="rc.userID" default=0;
		var oUser = userService.get(rc.userID);

		if(event.valueExists('email')){
			rc.username = rc.email;
		}

		userService.populate(target=oUser,memento=rc,exclude="permissions");
		//assign Role
		oUser.setRole( roleService.get( rc.roleID ) );

		var vResults = validateModel(oUser);

		// create criteria for uniqueness
		var c = userService.newCriteria()
			.isEq( "username", rc.username );

		// Existing user, don't include it in the check
		if( oUser.isLoaded() ){
			c.ne( "userID", javacast("int",rc.userID) );
		}

		// validate uniqueness
		if( c.count() GT 0 ){
			//throw the error and send them back to the form
			getPlugin("MessageBox").error( "The username #rc.username# already exists!" );
			setNextEvent(event=prc.xehEntryForm,queryString="userID=#rc.userID#");
		}
		else {
			//save
			userService.saveUser(oUser);

			//remove all existing permisions so we can add the list
			if(oUser.hasPermission()) {
				oUser.deleteAllPermissions();
			}

			if(structKeyExists(rc,'permissions')){
				var arpermission = rc.permissions;
				for(var pID in arpermission){
					var oPermission = permissionService.get(pID);
					oUser.addPermission(oPermission);
				}
			}

			userService.saveUser(oUser);
			getPlugin("MessageBox").info( "Data Saved!" );

			if(rc.saveType == "new"){
				setNextEvent(prc.xehEntryForm);
			}else{//save
				setNextEvent(prc.xehList);
			}
		}
	}

	public void function delete (event,rc,prc) {
		param name="rc.userID" default=0;

		var oUser = userService.get(rc.userID);

			roleService.evictEntity(oUser.getRole());
			oUser.deleteAllPermissions();

			userService.delete(oUser);

			getPlugin("MessageBox").info( "Delete Successful!" );
			setNextEvent(prc.xehList);

	}

	// Save permission to the user and gracefully end.
	function savePermission(event,rc,prc){
		var oUser 	= userService.get( rc.userID );
		var oPermission = permissionService.get( rc.permissionID );

		// Assign it
		if( !oUser.hasPermission( oPermission) ){
			oUser.addPermission( oPermission );
			// Save it
			userService.saveUser( oUser );
		}
		// Saved
		event.renderData(data="true",type="json");
	}

	public void function removePermission (event,rc,prc) {
		param name="rc.userID" default=0;
		var oUser = userService.get(rc.userID);
		var oPermission = permissionService.get(rc.permissionID);

		oUser.removePermission(oPermission);
		userService.saveUser(oUser);
		getPlugin("MessageBox").info( "Delete Successful!" );

		event.renderData(data=true,type="JSON");

	}

	function changePassword(event,rc,prc){
		prc.htmlID = "login";
		prc.user = userService.get(rc.userID);
		event.setView(view='users/changePassword');
	}

	function doChangePassword(event,rc,prc){
		//if everything is on the up and up...make the change
		if( (rc.newPassword == rc.newPasswordConfirm) ){
			user = userService.get(rc.userID);
			user.setPassword(rc.newPassword);
			userService.saveUser(user,true);
			getPlugin("MessageBox").setMessage("info",'The password has changed.');
			setNextEvent(event=prc.xehEntryForm,querystring="userID=#rc.userID#");
		} else {
			// user is null or passwords do not match
			if (rc.newPassword != rc.newPasswordConfirm) {
				getPlugin("MessageBox").setMessage("error","The new password and confirm password did not match, please try again.");
			} else {
				getPlugin("MessageBox").setMessage("error","An unknown error has occured.");
			}
			setNextEvent(event=prc.xehEntryForm,querystring="userID=#rc.userID#");
		}
	}

	public void function validate (event,rc,prc) {
		var result = "validation ERROR!!";

		var oUser = userService.new();
		userService.populate(oUser,rc);
		var vResults = validateModel(target=oUser,fields=rc.field);
		if(vResults.hasErrors()) {
			result = vResults.getAllErrors()[1];
		} else {
			result = true;
		}

		event.renderData(data=result,type="JSON");
	}
}
