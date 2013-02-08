<cfoutput>
<div class="page-header">
	<h1>Forgot Password </h1>
</div>

<form class="well" action="#event.buildLink('security.doForgotPassword')#" method="POST" name="loginForm">
	#prc.html.textField(label="*Email:",name="email",required="required")#
	<p>
		<input type="submit" value="Submit" name="submit" class="btn btn-primary">
	</p>
</form>
</cfoutput>