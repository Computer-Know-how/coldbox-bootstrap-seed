<cfoutput>
	<cfif prc.oUser.checkPermission("USER_EDIT")>
		<cfset disabled=false />
	<cfelse>
		<cfset disabled=true />
	</cfif>
	<div class="page-header">
		<h1>Roles <small>List</small></h1>
	</div>
	<table id="role" class="datatable table table-striped">
		<thead>
			<tr>
				<th>Role</th>
				<th></th>
			</tr>
		</thead>
	<tbody>
		<cfloop array="#prc.role#" index="role" >
			<tr>
				<td>#role.getRole()#</td>
				<td class="dt-actions">
					<a href="#event.buildLink(prc.xehEntryForm)#/roleID/#role.getRoleID()#" class="btn btn-mini" rel="tooltip" data-original-title="Edit"><i class="icon-wrench icon-black"></i></a>
					<cfif prc.oUser.checkPermission("USER_DELETE")><a href="#event.buildLink(prc.xehDelete)#/roleID/#role.getRoleID()#" class="btn btn-mini confirm-delete" rel="tooltip" data-original-title="Delete"><i class="icon-remove icon-black"></i></a></cfif>
				</td>
			</tr>
		</cfloop>
	</tbody>
	<tfoot>
		<tr class="add-line">
			<td colspan="20">
				<a class="btn btn-mini" href="#event.buildLink(prc.xehEntryForm)#" rel="tooltip" data-original-title="Add"><i class="icon-plus icon-black"></i></a>
			</td>
		</tr>
	</tfoot>
</table>
</cfoutput>