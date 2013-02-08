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
		prc.xehEntryForm = 'permissions.entryForm';
		prc.xehList = 'permissions.list';
		prc.xehSave = 'permissions.save';
		prc.xehDelete = 'permissions.delete';
		prc.xehValidate = 'permissions.validate';
		prc.xehRemovePermission = 'permissions.removePermission';
	}

	function index(event,rc,prc){
		setNextEvent(prc.xehList);
	}

	// list
	function list(event,rc,prc){
		// paging
		event.paramValue("page",1);

		// exit Handlers
		rc.xehPermissionRemove 	= "permission.remove";
		prc.xehPermissionSearch = "permission.users";

		prc.permissions		= permissionService.list(sortOrder="permission desc",asQuery=false);
		prc.permissionCount 	= permissionService.count();


		// View
		event.setView("permissions/list");
	}

	// permission check
	function permissionsCheck(event,rc,prc){
		var found = true;

		event.paramValue("permission","");

		// only check if we have a username
		if( len(username) ){
			found = permissionService.permissionFound( rc.permission );
		}

		event.renderData(type="json",data=found);
	}

	// permission editor
	public void function entryForm (event,rc,prc) {
		param name="rc.permissionID" default=0;

		prc.permission = permissionService.get(rc.permissionID);
		prc.permissionID = rc.permissionID;

		prc.rules = validationService.createjQueryRules(prc.permission,event.buildLink(prc.xehValidate));

		event.setView("permissions/entryForm");
	}

	// save permission
	public void function save (event,rc,prc) {
		param name="rc.permissionID" default=0;
		param name="rc.permission" default="";

		var oPermission = permissionService.get(rc.permissionID);
		permissionService.populate(oPermission,rc);

		var vResults = validateModel(oPermission);

		// create criteria for uniqueness
		var c = permissionService.newCriteria()
			.isEq( "permission", rc.permission );

		// Existing permission, don't include it in the check
		if( oPermission.isLoaded() ){
			c.ne( "permissionID", javacast("int",rc.permissionID) );
		}
		// validate uniqueness
		if( c.count() GT 0 ){
			//throw the error and send them back to the form
			getPlugin("MessageBox").error( "The permission #rc.permission# already exists!" );
			setNextEvent(event=prc.xehEntryForm,queryString="permissionID=#rc.permissionID#");
		}
		if(vResults.hasErrors()) {
			//throw the error and send them back to the form
			getPlugin("MessageBox").error( messageArray=vResults.getAllErrors() );
			rc.isReload = true;   //trigger to reload the rc fields after the redirect
			setNextEvent(event=prc.xehEntryForm,queryString="permissionID=#rc.permissionID#", persistStruct=rc);
		} else {
			//save
			permissionService.save(oPermission);
			getPlugin("MessageBox").info( "Data Saved!" );
			if(rc.saveType == "new"){
				setNextEvent(prc.xehEntryForm);
			}else if(rc.saveType == "report"){
				setNextEvent(event=prc.xehreport,persistStruct=rc);
			}else{//save
				setNextEvent(prc.xehList);
			}
		}
	}

	public void function delete (event,rc,prc) {
		param name="rc.permissionID" default=0;
		try{
			permissionService.deletePermission(rc.permissionID);

			getPlugin("MessageBox").info( "Delete Successful!" );
			setNextEvent(prc.xehList);
		} catch (any e) {
			getPlugin("MessageBox").error( "Could not delete, please remove any associated data and try again!" );
			setNextEvent(prc.xehList);
		}

	}

	public void function validate (event,rc,prc) {
		var result = "validation ERROR!!";

		var o = permissionService.new();
		permissionService.populate(o,rc);

		var vResults = validateModel(target=o,fields=rc.field);
		if(vResults.hasErrors()) {
			result = vResults.getAllErrors()[1];
		} else {
			result = true;
		}

		event.renderData(data=result,type="JSON");
	}
}
