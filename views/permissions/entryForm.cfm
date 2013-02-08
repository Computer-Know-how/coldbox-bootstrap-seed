<cfoutput>
	<cfif prc.oUser.checkPermission("USER_EDIT")>
		<cfset disabled=false />
	<cfelse>
		<cfset disabled=true />
	</cfif>
	<div id="permissions">
		<div class="page-header">
			<h1>Permission <cfif prc.permission.isLoaded()>"#prc.permission.getPermission()#" <small>Edit</small><cfelse><small>Add</small></cfif></h1>
		</div>
		<form id="form" action="#event.buildLink(prc.xehSave)#" method="post" autocomplete="off">
			#prc.html.hiddenField(name="permissionID", bind=prc.permission)#
			#prc.html.hiddenField(name="saveType", id="saveType", value="save")#
			#prc.html.textField(label="Permission Name", name="permission", bind=prc.permission,required="required",disabled=disabled)#
			#prc.html.textField(label="Description", name="description", bind=prc.permission,required="required",disabled=disabled)#
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