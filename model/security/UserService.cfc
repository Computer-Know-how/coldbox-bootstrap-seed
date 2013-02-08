/**
* Service to handle auhtor operations.
*/
component extends="coldbox.system.orm.hibernate.VirtualEntityService" accessors="true" singleton{

	// User hashing type
	property name="hashType";

	/**
	* Constructor
	*/
	UserService function init(){
		// init it
		super.init(entityName="user");
		setHashType( "SHA-256" );

		return this;
	}

	/**
	* Save an user with extra pizazz!
	*/
	function saveUser(user,passwordChange=false){
		// hash password if new user
		if( !arguments.user.isLoaded() OR arguments.passwordChange ){
			arguments.user.setPassword( hash(arguments.user.getPassword(), getHashType()) );
		}

		// save the user
		save( user );
	}

	/**
	* User search by name, email or username
	*/
	function search(criteria){
		var params = {criteria="%#arguments.criteria#%"};
		var r = executeQuery(query="from user where firstName like :criteria OR lastName like :criteria OR email like :criteria",params=params,asQuery=false);
		return r;
	}

	/**
	* Username checks for users
	*/
	boolean function usernameFound(required username){
		var args = {"username" = arguments.username};
		return ( countWhere(argumentCollection=args) GT 0 );
	}

}