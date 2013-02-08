<cfcomponent output="false" hint="CKH Bootstrap Configuration">
<cfscript>
	// Configure ColdBox Application
	function configure(){

		// coldbox directives
		coldbox = {
			//Application Setup
			appName 				= "ckhbootstrap",
			eventName 				= "event",

			//Development Settings
			debugMode				= false,
			debugPassword			= "1",
			reinitPassword			= "1",
			handlersIndexAutoReload = false,

			//Implicit Events
			defaultEvent			= "General.index",
			requestStartHandler		= "Main.onRequestStart",
			applicationStartHandler = "Main.onAppInit",

			//Extension Points
			UDFLibraryFile 				= "includes/helpers/ApplicationHelper.cfm",

			//Error/Exception Handling
			exceptionHandler		= "",
			onInvalidEvent			= "",
			customErrorTemplate		= "includes/templates/generic_error.cfm",

			//Application Aspects
			handlerCaching 			= true,
			eventCaching			= true,
			proxyReturnCollection 	= false
		};

		// custom settings
		settings = {
			//Override ColdBox Message Box CSS
			messagebox_style_override = true
		};

		// environment settings, create a detectEnvironment() method to detect it yourself.
		// create a function with the name of the environment so it can be executed if that environment is detected
		// the value of the environment is a list of regex patterns to match the cgi.http_host.
		environments = {
			//development = "^cf8.,^railo."
			local = ".local$,^localhost,^dev"   //,^dev
		};

		// Module Directives
		modules = {
			//Turn to false in production
			autoReload = false,
			// An array of modules names to load, empty means all of them
			include = [],
			// An array of modules names to NOT load, empty means none
			exclude = []
		};

		//LogBox DSL
		logBox = {
			// Define Appenders
			appenders = {
				coldboxTracer = { class="coldbox.system.logging.appenders.ColdboxTracerAppender" }
			},
			// Root Logger
			root = { levelmax="INFO", appenders="*" },
			// Implicit Level Categories
			info = [ "coldbox.system" ]
		};

		//Layout Settings
		layoutSettings = {
			defaultLayout = "Layout.Main.cfm",
			defaultView   = ""
		};

		//Interceptor Settings
		interceptorSettings = {
			throwOnInvalidStates = false,
			customInterceptionPoints = ""
		};

		//Register interceptors as an array, we need order
		interceptors = [
			//SES
			{class="coldbox.system.interceptors.SES",
			 properties={}
			},
			// Security
			{class="coldbox.system.interceptors.Security",
			 name="security",
			 properties={
			 	 rulesSource 	= "model",
			 	 rulesModel		= "model.security.SecurityRuleService",
			 	 rulesModelMethod = "getSecurityRules",
			 	 validatorModel = "model.security.SecurityService"}
			},
			//Request
			{class="interceptors.request",
			 name="request"
			}
		];

		// Object & Form Validation
		validation = {
			// manager = "class path" or none at all to use ColdBox as the validation manager
			// The shared constraints for your application.
			sharedConstraints = {
				// EX
				// myForm = { name={required=true}, age={type="numeric",min="18"} }
			}
		};

		// ORM services, injection, etc
		orm = {
			// entity injection
			injection = {
				// enable it
				enabled = true,
				// the include list for injection
				include = "",
				// the exclude list for injection
				exclude = ""
			}
		};

	}

	/**
	* Executed whenever the local environment is detected
	*/
	function local(){
		// Override coldbox directives
		coldbox.handlerCaching = false;
		coldbox.handlersIndexAutoReload = true;
		coldbox.eventCaching = false;
		coldbox.debugPassword = "";
		coldbox.reinitPassword = "";
		coldbox.debugMode = false;
		//coldbox.customErrorTemplate = "";
		models.objectCaching = false;
		wireBox.singletonReload = true;
		mailSettings = {
			protocol = {
				class = "coldbox.system.core.mail.protocols.FileProtocol",
				properties = {
					filePath = "/Applications/railo/mailspool",
					autoExpand = false
				}
			}
		};
	}

</cfscript>
</cfcomponent>