/**
* Manage roles
*/
component extends="base"{

	// pre handler
	function preHandler(event,action,eventArguments){
		var rc 	= event.getCollection();
		var prc = event.getCollection(private=true);
		// Tab control
		prc.tabUsers = true;
		prc.xehEntryForm = 'role.entryForm';
		prc.xehList = 'role.list';
		prc.xehSave = 'role.save';
		prc.xehDelete = 'role.delete';
		prc.xehValidate = 'role.validate';
	}

	function index(event,rc,prc){
		setNextEvent(prc.xehList);
	}

	// list
	function list(event,rc,prc){

		prc.role		= roleService.list(sortOrder="role desc",asQuery=false);

		// View
		event.setView("role/list");
	}

	// role check
	function roleCheck(event,rc,prc){
		var found = true;
		event.paramValue("role","");

		// only check if we have a role
		if( len(role) ){
			found = roleService.roleFound( rc.role );
		}

		event.renderData(type="json",data=found);
	}

	// role editor
	public void function entryForm (event,rc,prc) {
		param name="rc.roleID" default=0;

		prc.role = roleService.get(rc.roleID);

		// get roles
		prc.roles = roleService.list(sortOrder="role",asQuery=false);
		prc.permissions = permissionservice.list(sortOrder="permission",asQuery=false);

		//get selected permissions
		prc.selected = [];
		for(var p in prc.permissions) {
			if(prc.role.hasPermission(p)){
				arrayAppend(prc.selected,p.getPermissionID());
			}
		}

		prc.rules = validationService.createjQueryRules(prc.role,event.buildLink(prc.xehValidate));

		event.setView("role/entryForm");
	}

	// save role
	public void function save (event,rc,prc) {
		param name="rc.roleID" default=0;

		var oRole = roleService.get(rc.roleID);

		roleService.populate(target=oRole,memento=rc,exclude="permissions");

		var vResults = validateModel(oRole);

		// create criteria for uniqueness
		var c = roleService.newCriteria()
			.isEq( "role", rc.role );

		// Existing role, don't include it in the check
		if( oRole.isLoaded() ){
			c.ne( "roleID", javacast("int",rc.roleID) );
		}

		// validate uniqueness
		if( c.count() GT 0 ){
			//throw the error and send them back to the form
			getPlugin("MessageBox").error( "The role #rc.role# already exists!" );
			setNextEvent(event=prc.xehEntryForm,queryString="roleID=#rc.roleID#");
		}

		if(vResults.hasErrors()) {
			//throw the error and send them back to the form
			getPlugin("MessageBox").error( messageArray=vResults.getAllErrors() );
			setNextEvent(event=prc.xehEntryForm,queryString="roleID=#rc.roleID#");
		} else {

			//save
			roleService.save(oRole);
			//remove all existing permissions so we can add the list

			oRole.deleteAllPermissions();
			if(structKeyExists(rc,'permissions')){
				var arpermission = rc.permissions; //listtoarray(rc["permissions[]"]);
				for(var pID in arpermission){
					var oPermission = permissionService.get(pID);
					oRole.addPermission(oPermission);
				}
			}
			roleService.save(oRole);
			getPlugin("MessageBox").info( "Data Saved!" );

			if(rc.saveType == "new"){
				setNextEvent(prc.xehEntryForm);
			}else{//save
				setNextEvent(prc.xehList);
			}
		}
	}

	public void function delete (event,rc,prc) {
		param name="rc.roleID" default=0;
		try{
			var oRole = roleService.get(rc.roleID);

			oRole.deleteAllPermissions();
			roleService.delete(oRole);
			getPlugin("MessageBox").info( "Delete Successful!" );
			setNextEvent(prc.xehList);
		} catch (any e) {
			getPlugin("MessageBox").error( "Could not delete, please remove any associated data and try again!" );
			setNextEvent(prc.xehList);
		}
	}

	// Save permission to the role and gracefully end.
	function savePermission(event,rc,prc){
		var oRole 	= roleService.get( rc.roleID );
		var oPermission = permissionService.get( rc.permissionID );

		// Assign it
		if( !oRole.hasPermission( oPermission) ){
			oRole.addPermission( oPermission );
			// Save it
			roleService.saveRole( oRole );
		}
		// Saved
		event.renderData(data="true",type="json");
	}

		public void function removePermission (event,rc,prc) {
		param name="rc.roleID" default=0;
		var oRole = roleService.get(rc.roleID);
		var oPermission = permissionService.get(rc.permissionID);

		oRole.removePermission(oPermission);
		roleService.saveRole(oRole);
		getPlugin("MessageBox").info( "Delete Successful!" );

		event.renderData(data=true,type="JSON");

	}

	public void function validate (event,rc,prc) {
		var result = "validation ERROR!!";

		var oRole = roleService.new();
		roleService.populate(oRole,rc);

		var vResults = validateModel(target=oRole,fields=rc.field);
		if(vResults.hasErrors()) {
			result = vResults.getAllErrors()[1];
		} else {
			result = true;
		}

		event.renderData(data=result,type="JSON");
	}
}
