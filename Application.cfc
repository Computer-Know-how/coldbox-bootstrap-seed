/**
Apache License, Version 2.0

Copyright Since [2012] [Luis Majano and Ortus Solutions,Corp]

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
********************************************************************************
*/
component{
	// Application properties, modify as you see fit
	this.name 				= "CKHBootstrap" & hash(getCurrentTemplatePath());
	this.sessionManagement 	= true;
	this.sessionTimeout 	= createTimeSpan(0,0,45,0);
	this.setClientCookies 	= true;

	// Mapping Imports
	import coldbox.system.*;

	// ColdBox Application Specific, Modify if you need to
	COLDBOX_APP_ROOT_PATH 	= getDirectoryFromPath( getCurrentTemplatePath() );
	COLDBOX_APP_MAPPING		= "";
	COLDBOX_CONFIG_FILE 	= "";
	COLDBOX_APP_KEY 		= "";

	// THE DATASOURCE FOR SITE
	this.datasource = "ckhbootstrap";

	// THE LOCATION OF COLDBOX
	this.mappings["/coldbox"] 	 = GetDirectoryFromPath( GetBaseTemplatePath() ) & "coldbox\";
	this.mappings["/model"] = GetDirectoryFromPath( GetBaseTemplatePath() ) & "model\";

	// CONTENTBOX ORM SETTINGS
	this.ormEnabled = true;
	this.ormSettings = {
		cfclocation="model",
		logSQL = true,
		flushAtRequestEnd = false,
		dialect = "MicrosoftSQLServer", //"MySQLwithInnoDB"
		eventHandling = true,
		eventHandler = "model.utilities.ORMEventHandler",
		secondarycacheenabled = true,
		cacheprovider = "ehCache",
		autoManageSession	= false,
		dbcreate = "dropcreate"

	};
	/************************************** METHODS *********************************************/

	// application start
	public boolean function onApplicationStart(){
		application.cbBootstrap = new Coldbox(COLDBOX_CONFIG_FILE,COLDBOX_APP_ROOT_PATH,COLDBOX_APP_KEY);
		application.cbBootstrap.loadColdbox();
		return true;
	}

	// request start
	public boolean function onRequestStart(String targetPage){

		if( structKeyExists(url,"ormReload") ){ ormReload(); }

		// Bootstrap Reinit
		if( not structKeyExists(application,"cbBootstrap") or application.cbBootStrap.isfwReinit() ){
			lock name="coldbox.bootstrap_#this.name#" type="exclusive" timeout="5" throwonTimeout=true{
				structDelete(application,"cbBootStrap");
				application.cbBootstrap = new ColdBox(COLDBOX_CONFIG_FILE,COLDBOX_APP_ROOT_PATH,COLDBOX_APP_KEY,COLDBOX_APP_MAPPING);
			}
		}

		// ColdBox Reload Checks
		application.cbBootStrap.reloadChecks();

		//Process a ColdBox request only
		if( findNoCase('index.cfm',listLast(arguments.targetPage,"/")) ){
			application.cbBootStrap.processColdBoxRequest();
		}

		return true;
	}

	public void function onSessionStart(){
		application.cbBootStrap.onSessionStart();
	}

	public void function onSessionEnd(struct sessionScope, struct appScope){
		arguments.appScope.cbBootStrap.onSessionEnd(argumentCollection=arguments);
	}

	public boolean function onMissingTemplate(template){
		return application.cbBootstrap.onMissingTemplate(argumentCollection=arguments);
	}
}