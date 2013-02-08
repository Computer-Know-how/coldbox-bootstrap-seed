component
	mappedsuperclass="true"
	accessors="true" {

	// DI
	property name="securityService" inject="id:security.SecurityService" persistent="false";

	property name="isDeleted" ormtype="boolean" default="0" dbdefault="0";
	property name="dateAdded" ormtype="date";
	property name="dateModified" ormtype="date";
	property name="lastModifiedBy" ormtype="int";

	boolean function preDelete(){
		query = new Query();
		var tableName = getTableName();
		var IDCol = getKey();
		query.setSQL("update #tableName# set isDeleted=1 where #IDCol#=:ID");
		query.addParam(name="ID", value=variables[IDCol]);
		query.execute();
		query.setSQL("update #tableName# set dateModified=#now()# where #IDCol#=:ID");
		query.addParam(name="ID", value=variables[IDCol]);
		query.execute();
		query.setSQL("update #tableName# set lastModifiedBy=:userID where #IDCol#=:ID");
		query.addParam(name="ID", value=variables[IDCol]);
		query.addParam(name="userID", value=getUserID());
		query.execute();
		return true;
	}

	boolean function postUpdate(){
		query = new Query();
		var tableName = getTableName();
		var IDCol = getKey();
		query.setSQL("update #tableName# set dateModified=#now()# where #IDCol#=:ID");
		query.addParam(name="ID", value=variables[IDCol]);
		query.execute();
		query.setSQL("update #tableName# set lastModifiedBy=:userID where #IDCol#=:ID");
		query.addParam(name="ID", value=variables[IDCol]);
		query.addParam(name="userID", value=getUserID());
		query.execute();
		return false;
	}

	boolean function preInsert(entity){
		this.setDateAdded(now());
		this.setDateModified(now());
		this.setLastModifiedBy(getUserID());
		return false;
	}

	private function getTableName(){
		return getMetaData(this).table;
	};

	private function getKey(){
		var md = getMetaData(this);
		//loop through the properties and get the entityID, also see if there is and "listing" or "editable" MD
		for (var i=1;i <= arrayLen(md.properties); i=i+1){
			var prop = md.properties[i];
			if (structKeyExists(prop,"fieldType") and prop.fieldType EQ "id") {
				//@entityID@
				return prop.Name;
			}
		}
	}

	private function getUserID() {
		return securityService.getUserSession().getUserID();
	}

}