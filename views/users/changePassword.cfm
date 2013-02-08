<cfoutput>
<h2>Change Password "#prc.user.getName()#"</h2>
<p>Let's change your password.</p>
<form class="well" action="#event.buildLink(prc.xehChangePassword)#" method="POST" id="changepassword">
	#prc.html.hiddenField(name="userID", value=rc.userID)#
	#prc.html.hiddenField(name="saveType", id="saveType", value="save")#
	#prc.html.passwordField(label="New Password:",name="newPassword",required="required",wrapper="div class='confirmPassword'")#
	#prc.html.passwordField(label="Confirm Password:",name="newPasswordConfirm",required="required")#
	<p>
		<input type="submit" value="Save" name="submit" class="btn btn-primary">
	</p>
</form>
</cfoutput>