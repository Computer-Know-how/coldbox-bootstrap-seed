﻿<cfoutput>
<div class="page-header">
	<h1>Permission <small>List</small></h1>
</div>
<table id="permissions" class="datatable table table-striped">
	<thead>
		<tr>
			<th>Permission</th>
			<th>Description</th>
			<th></th>
		</tr>
	</thead>
	<tbody>
		<cfloop array="#prc.permissions#" index="permission" >
			<tr>
				<td>#permission.getPermission()#</td>
				<td>#permission.getDescription()#</td>
				<td class="dt-actions">
					<a href="#event.buildLink(prc.xehEntryForm)#/permissionID/#permission.getPermissionID()#" class="btn btn-mini" rel="tooltip" data-original-title="Edit"><i class="icon-wrench icon-black"></i></a>
					<cfif prc.oUser.checkPermission("USER_DELETE")><a href="#event.buildLink(prc.xehDelete)#/permissionID/#permission.getPermissionID()#" class="btn btn-mini confirm-delete" rel="tooltip" data-original-title="Delete"><i class="icon-remove icon-black"></i></a></cfif>
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