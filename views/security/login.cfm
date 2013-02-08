<cfoutput>
<div class="page-header">
	<h1>Login</h1>
</div>

<form class="well" action="#event.buildLink('security.doLogin')#" method="POST" name="loginForm">
	#prc.html.hiddenField(name="_securedurl",value="#event.getValue("_securedurl","")#")#
	#prc.html.textField(label="*Username:",name="username",required="required")#
	#prc.html.passwordField(label="*Password:",name="password",required="required")#
	<p>
		<input type="submit" value="Login" name="submit" class="btn btn-primary">
		<ul class="inline-list pipe-me">
			<!---<li><a href="<cfoutput>#event.buildlink('security.changepassword')#</cfoutput>">change password</a></li>--->
			<li><a href="<cfoutput>#event.buildlink('security.forgotpassword')#</cfoutput>">forgot password ...</a></li>
		</ul>
	</p>
</form>
</cfoutput>