/**
* This simulates the onRequest start for the admin interface
*/
component extends="coldbox.system.Interceptor"{

	// DI
	property name="securityService" inject="id:security.SecurityService";
	property name="htmlHelper" inject="coldbox:myPlugin:HTMLHelper";
	property name="sessionStorage" inject="coldbox:plugin:sessionStorage";
	/**
	* Configure Request
	*/
	function configure(){}

	/**
	* Fired on requests
	*/
	function preProcess(event, interceptData){
		var prc = event.getCollection(private=true);
		var rc	= event.getCollection();

		prc.oUser = securityService.getUserSession();

		prc.html = htmlHelper;
	}

}