<cfoutput>
	<cfif prc.oUser.checkPermission("USER_EDIT")>
		<cfset disabled=false />
	<cfelse>
		<cfset disabled=true />
	</cfif>
	<div class="users">
		<div class="page-header">
			<h1>User <cfif prc.user.isLoaded()>"#prc.user.getName()#" <small>Edit</small><cfelse><small>Add</small></cfif></h1>
		</div>
		<form id="form" action="#event.buildLink(prc.xehSave)#" method="post" autocomplete="off">
			<div class="form-group">
				<div class="form-group-label">User Information</div>
				#prc.html.hiddenField(name="userID", bind=prc.user)#
				#prc.html.hiddenField(name="saveType", id="saveType", value="save")#
				<div class="row-fluid">
					<div class="span4">
						#prc.html.textField(name="firstname", label="First Name", bind=prc.user,required="required",disabled=disabled)#
					</div>
					<div class="span4">
						#prc.html.textField(name="lastname", label="Last Name", bind=prc.user,required="required",disabled=disabled)#
					</div>
				</div>
				<div class="row-fluid">
					<div class="span4">
						#prc.html.textField(name="email", label="Email", bind=prc.user,required="required",disabled=disabled)#
					</div>
				</div>
					<div class="control-group">
						<cfif prc.user.isLoaded()>
							<a href="#event.buildLink('users.changePassword')#/userID/#rc.userID#" tabindex="0" class="btn btn-primary">Change Password</a>
						</cfif>
					</div>
					<cfif !prc.user.isLoaded()>
					#prc.html.passwordField(name="password", label="Password", required="required")#
					</cfif>
					#prc.html.select(name="roleID", label="Role <span>inherited permissions will update after save.</span>", options=prc.roles, nameColumn="role", column="roleID", bind=prc.user.getRole(),required="required",disabled=disabled)#
			</div>

				<div class="control-group">
					<cfif prc.user.hasRole()>
						<label for="permission">Inherited Permissions <span>hover over permission for description</span></label>
						<div class="inherited-permissions">
							<cfset i = 0>
							<cfloop array="#prc.user.getRole().getPermissions()#" index="permission">
								<cfset i++ />
								<span title="#permission.getPermission()#: #permission.getDescription()#" rel="tooltip">#permission.getPermission()#</span><cfif i NEQ arrayLen(prc.user.getRole().getPermissions())>, </cfif>
							</cfloop>
						</div>
					</cfif>
				</div>
				#prc.html.select(name="Permissions", label="Permissions", options=prc.permissions, nameColumn="Permission", column="PermissionID", multiple=true, selectedValue=arrayToList(prc.selected))#
			<div class="form-actions">
				#prc.html.submitButton(name="saveButton", value="Save", class="btn btn-primary", id="saveButton")#
				#prc.html.submitButton(name="cancelButton", value="Cancel", class="btn", id="cancelButton", onClick="location.href='#event.buildLink(prc.xehList)#'; return false;")#
			</div>
		</form>
	</div>

	<script type="text/javascript">
	$(document).ready(function () {
		$('##form').validate({
			highlight: function(element) {
				$(element).parent().parent().addClass("error");
			},
			unhighlight: function(element) {
				$(element).parent().parent().removeClass("error");
				//clean up previous errors
				$(element).parent().find('.error').each(function(){
					$(this).remove();
				});
			},
			#prc.rules#
		});
	});
	</script>
</cfoutput>