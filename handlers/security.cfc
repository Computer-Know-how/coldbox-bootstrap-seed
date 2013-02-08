/**
* I handle security credentials for the administrator panel
*/
component extends="base" {

	property name="sessionStorage" inject="coldbox:plugin:sessionStorage";

	// login form
	function login(event,rc,prc){
		prc.htmlID = "login";
		prc.rememberMe = securityService.getRememberMe();

		if(event.valueExists("_securedurl")) {
			sessionStorage.setVar("_securedurl",rc._securedurl);
		}

		if(!event.valueExists("_securedurl") && sessionStorage.exists("_securedurl")) {
			rc._securedurl = sessionStorage.getVar("_securedurl");
		}

		event.setView(view="security/login");
	}

	// do login
	function doLogin(event,rc,prc){
		event.paramValue("username","");
		event.paramValue("password","");
		event.paramValue("rememberMe",false);

		// authenticate users
		if( securityService.authenticate(rc.username,rc.password) ){

			// set remember me
			if( rc.rememberMe ){
				securityService.setRememberMe( rc.username );
			} else {
				securityService.setRememberMe( "" );
			}

			getPlugin("MessageBox").setMessage("info","Login successful!");

			// check if securedURL came in?
			if( len(event.getValue("_securedURL","")) ){
				setNextEvent(uri=rc["_securedURL"]);
			}
			else{
				setNextEvent("general");
			}


		}
		else{
			getPlugin("MessageBox").setMessage("error","Login failed!");
			setNextEvent("security.login");
		}
	}

	// logout
	function doLogout(event,rc,prc){
		securityService.logout();
		getPlugin('messageBox').setMessage('info','Logout successful!');
		setNextEvent("security.login");
	}

	function changePassword(event,rc,prc){
		prc.htmlID = "login";
		event.setView(view='security/changePassword');
	}

	function doChangePassword(event,rc,prc){
		if (prc.oUser.isLoggedIn()){
			var authenticated = true;
		} else {
			var authenticated = securityService.authenticate(rc.username,rc.currentPassword);
		}
		//if everything is on the up and up...make the change
		if( authenticated && (rc.newPassword == rc.newPasswordConfirm) ){
			user = userService.findWhere({username=rc.username});
			user.setPassword(rc.newPassword);
			userService.saveUser(user,true);
			getPlugin("MessageBox").setMessage("info",'Your password has been changed.  Please login with your new credentials.');
			setNextEvent("security.login");
		} else {
			// user is null or passwords do not match
			if( !authenticated ){
				getPlugin("MessageBox").setMessage("error","We could not authenticate the account that you are trying to change.");
			} else if (rc.newPassword != rc.newPassword_Confirm) {
				getPlugin("MessageBox").setMessage("error","The new password and confirm password did not match, please try again.");
			} else {
				getPlugin("MessageBox").setMessage("error","An unknown error has occured.");
			}
			setNextEvent(event="security.changepassword");
		}
	}

	/**
	* forgotPassword
	*/
	function forgotPassword(event,rc,prc){

		event.setView("security/forgotPassword");
	}

	/**
	* doForgotPassword
	*/
	any function doForgotPassword(event,rc,prc){
		param name="rc.username" default="";
		param name="rc.email" default="";

		var user = userService.findWhere({username=rc.email,email=rc.email});
		prc.user = user;

		if(isNull(user)){
			getPlugin("MessageBox").setMessage("error","There is no user with that email address.");
			setNextEvent(event="security.forgotPassword");
		}

		prc.newPassword = utilityService.getRandString(7);
		user.setPassword(prc.newPassword);
		userService.saveUser(user,true);
		getPlugin("MessageBox").setMessage("info",'Your password has been changed and emailed to you.  Please login with your new credentials.');

		message.recipient = rc.email;
		message.sender = getSetting('fromAddress');
		message.subject = "Updated Account Information";
		message.content = renderView('emails/forgotPassword');
		emailerService.send(message);

		setNextEvent("security.login");

	}

}
