<cfparam name="request.attributes.page" default="main" />
<cfif listFindNoCase("noLayout,whatever",request.attributes.page)>
	<cfset request.attributes.noLayout = true />
	<!--- or you could pass noLayout in as a url param instead --->
</cfif>

<cfinclude template="/inc/header.cfm" />

<cfif len(request.attributes.page)>
	<cfinclude template="#request.attributes.page#.cfm" />	
</cfif>

<cfinclude template="/inc/footer.cfm" />	