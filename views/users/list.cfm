<cfoutput>
<div class="page-header">
	<h1>User <small>List</small></h1>
</div>
<table id="users" class="datatable table table-striped">
	<thead>
		<tr>
			<th>Name</th>
			<th>Username/Email</th>
			<th>Role</th>
			<th>Last Login</th>
			<th></th>
		</tr>
	</thead>
	<tbody>
		<cfloop array="#prc.users#" index="user" >
			<tr>
				<td>#user.getName()#</td>
				<td>#user.getEmail()#</td>
				<td>#user.getRole().getRole()#</td>
				<td>#user.getDisplayLastLogin()#</td>
				<td class="dt-actions">
					<a href="#event.buildLink(prc.xehEntryForm)#/userID/#user.getUserID()#" class="btn btn-mini" rel="tooltip" data-original-title="Edit"><i class="icon-wrench icon-black"></i></a>
					<cfif prc.oUser.checkPermission("USER_DELETE")><a href="#event.buildLink(prc.xehDelete)#/userID/#user.getUserID()#" class="btn btn-mini confirm-delete" rel="tooltip" data-original-title="Delete"><i class="icon-remove icon-black"></i></a></cfif>
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