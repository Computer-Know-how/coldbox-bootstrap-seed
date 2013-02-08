/**
* A cool Permission entity
*/
component persistent="true" entityName="permission" table="permissions" cachename="permission" cacheuse="read-write"{

	// Primary Key
	property name="permissionID" fieldtype="id" generator="native" setter="false";

	// Properties
	property name="permission"  ormtype="string" notnull="true" length="255" unique="true" default="";
	// Constructor
	function init(){
		return this;
	}

	/**
	* is loaded?
	*/
	boolean function isLoaded(){
		return len( getPermissionID() );
	}
}