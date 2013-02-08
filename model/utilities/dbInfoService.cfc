<cfcomponent>
	<cffunction name="getDBInfo">
		<cfdbinfo type="version" datasource="ckhbootstrap" name="result">
		<cfreturn result.DATABASE_PRODUCTNAME />
	</cffunction>
</cfcomponent>