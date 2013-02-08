/**
* Our security service
*/
component implements="ISecurityService" singleton{

	// Dependencies
	property name="userService" 	inject="id:security.UserService";
	property name="sessionStorage" 	inject="coldbox:plugin:SessionStorage";
	property name="cookieStorage" 	inject="coldbox:plugin:CookieStorage";
	property name="mailService"		inject="coldbox:plugin:MailService";
	property name="renderer"		inject="coldbox:plugin:Renderer";
	property name="log"				inject="logbox:logger:{this}";

	/**
	* Constructor
	*/
	public SecurityService function init(){
		return this;
	}

	/**
	* Update an user's last login timestamp
	*/
	ISecurityService function updateUserLoginTimestamp(user){
		arguments.user.setLastLogin( now() );
		userService.save( arguments.user );
		return this;
	}

	/**
	* User validator via security interceptor
	*/
	boolean function userValidator(required struct rule,any messagebox,any controller){
		var isAllowed 	= false;
		var user 		= getUserSession();

		// First check if user has been authenticated.
		if( user.isLoaded() AND user.isLoggedIn() ){

			// Check if the rule requires roles
			if( len(rule.roles) ){
				for(var x=1; x lte listLen(rule.roles); x++){
					if( listGetAt(rule.roles,x) eq user.getRole().getRole() ){
						isAllowed = true;
						break;
					}
				}
			}

			// Check if the rule requires permissions
			if( len(rule.permissions) ){
				for(var y=1; y lte listLen(rule.permissions); y++){
					if( user.checkPermission( listGetAt(rule.permissions,y) ) ){
						isAllowed = true;
						break;
					}
				}
			}

			// Check for empty rules and perms
			if( !len(rule.roles) AND !len(rule.permissions) ){
				isAllowed = true;
			}
		}

		if(!isAllowed) {
			var msg = "This section requires that you log in with your account information. If you previously logged in, your session may have timed out, or you may not have access to this information at this time.";
			arguments.messagebox.setMessage("warning",msg);
		}

		return isAllowed;
	}

	/**
	* Get an user from session, or returns a new empty user entity
	*/
	User function getUserSession(){

		// Check if valid user id in session?
		if( sessionStorage.exists("loggedInUserID") ){
			// try to get it with that ID
			var user = userService.findWhere({userID=sessionStorage.getVar("loggedInUserID"),isActive=true});
			// If user found?
			if( NOT isNull(user) ){
				user.setLoggedIn( true );
				return user;
			}
		}

		// return new user, not found or not valid
		return userService.new();
	}

	/**
	* Set a new user in session
	*/
	ISecurityService function setUserSession(required User user){
		sessionStorage.setVar("loggedInUserID", user.getUserID() );
		return this;
	}

	/**
	* Delete user session
	*/
	ISecurityService function logout(){
		sessionStorage.clearAll();
		return this;
	}

	/**
	* Verify if an user is valid
	*/
	boolean function authenticate(required username, required password){
		// hash password
		arguments.password = hash( arguments.password, userService.getHashType() );
		var user = userService.findWhere({username=arguments.username,password=arguments.password,isActive=true});

		//check if found and return verification
		if( not isNull(user) ){
			// Set last login date
			updateUserLoginTimestamp( user );
			// set them in session
			setUserSession( user );
			return true;
		}
		return false;
	}

	/**
	* Send password reminder
	*/
	ISecurityService function sendPasswordReminder(required User user){
		// generate temporary password
		var genPassword = hash( arguments.user.getEmail() & arguments.user.getUserID() & now() );
		// get settings
		var settings = settingService.getAllSettings(asStruct=true);

		// set it in the user and save it
		user.setPassword( genPassword );
		userService.saveUser(user=user,passwordChange=true);

		// get mail payload
		var bodyTokens = {
			genPassword=genPassword,
			name=arguments.user.getName()
		};
		var mail = mailservice.newMail(to=arguments.user.getEmail(),
									   from=settings.cb_site_outgoingEmail,
									   subject="#settings.cb_site_name# Password Reset Issued",
									   bodyTokens=bodyTokens,
									   type="html",
									   server=settings.cb_site_mail_server,
									   username=settings.cb_site_mail_username,
									   password=settings.cb_site_mail_password,
									   port=settings.cb_site_mail_smtp,
									   useTLS=settings.cb_site_mail_tls,
									   useSSL=settings.cb_site_mail_ssl);
		// generate content for email from template
		mail.setBody( renderer.renderView(view="email_templates/password_reminder",module="contentbox") );
		// send it out
		mailService.send( mail );

		return this;
	}

	/**
	* Get remember me cookie
	*/
	any function getRememberMe(){
		return cookieStorage.getVar(name="matchbook_remember_me",default="");
	}

	/**
	* Set remember me cookie
	*/
	ISecurityService function setRememberMe(required username){
		cookieStorage.setVar(name="matchbook_remember_me",value=arguments.username);
		return this;
	}

}
