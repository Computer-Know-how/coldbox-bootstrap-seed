<!--- All methods in this helper will be available in all handlers,plugins,views & layouts --->

<cffunction name="DateTimeFormat" access="public" returntype="string" output="false" hint="Formats the given date with both a date and time format mask.">
	<!--- Define arguments. --->
	<cfargument name="Date" type="date" required="true" hint="The date/time stamp that we are formatting." />
	<cfargument name="DateMask" type="string" required="false" default="mm/dd/yyyy" hint="The mask used for the DateFormat() method call." />
	<cfargument name="TimeMask" type="string" required="false" default="h:mmTT" hint="The mask used for the TimeFormat() method call." />
	<cfargument name="Delimiter" type="string" required="false" default=" at " hint="This is the string that goes between the two formatted parts (date and time)." />

	<!---
	Return the date/time format by concatenating the date
	and time formatting separated by the given delimiter.
	--->
	<cfreturn (DateFormat(ARGUMENTS.Date,ARGUMENTS.DateMask) & ARGUMENTS.Delimiter & TimeFormat(ARGUMENTS.Date,ARGUMENTS.TimeMask)) />
</cffunction>