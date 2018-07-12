<cfparam name="request.attributes.page" default="main" />

<cfinclude template="/inc/header.cfm" />

<cfif len(request.attributes.page)>
	<cfinclude template="#request.attributes.page#.cfm" />	
</cfif>

<cfinclude template="/inc/footer.cfm" />	