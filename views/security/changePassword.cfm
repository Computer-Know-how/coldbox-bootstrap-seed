<cfoutput>
<div class="page-header">
	<h1>Change Password <cfif prc.oUser.isLoggedIn()>"#prc.oUser.getName()#"</cfif> </h1>
</div>

<form class="well" action="#event.buildLink('security.doChangePassword')#" method="POST" name="loginForm">
	<cfif prc.oUser.isLoggedIn()>#prc.html.hiddenField(name="username", required="required", bind=prc.oUser)#
	<cfelse>#prc.html.textField(label="*Username:",name="username",required="required")#
	</cfif>
	<cfif !prc.oUser.isLoggedIn()>
		#prc.html.passwordField(label="*Current Password:",name="currentPassword",required="required")#
	</cfif>
	#prc.html.passwordField(label="*New Password:",name="newPassword",required="required")#
	#prc.html.passwordField(label="*Confirm Password:",name="newPasswordConfirm",required="required")#
	<p>
		<input type="submit" value="Save" name="submit" class="btn btn-primary">
	</p>
</form>
</cfoutput>