component {

	// Dependencies
	property name="validationService" 				inject="model:validationService";
	property name="userService"						inject="id:security.UserService";
	property name="roleService"						inject="id:security.RoleService";
	property name="permissionService"				inject="id:security.PermissionService";
	property name="securityService" 				inject="model:security.SecurityService";
	property name="utilityService"					inject="id:utilities.utilityService";

}