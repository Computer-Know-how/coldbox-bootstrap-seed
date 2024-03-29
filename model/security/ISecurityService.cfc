﻿interface{

	/**
	* User validator via security interceptor
	*/
	boolean function userValidator(required struct rule,any messagebox,any controller);

	/**
	* Get an user from session, or returns a new empty user entity
	*/
	User function getUserSession();

	/**
	* Set a new user in session
	*/
	ISecurityService function setUserSession(required User user);

	/**
	* Delete user session
	*/
	ISecurityService function logout();

	/**
	* Verify if an user has valid credentials in our system.
	*/
	boolean function authenticate(required username, required password);

	/**
	* Send password reminder for an user
	*/
	ISecurityService function sendPasswordReminder(required User user);


}
