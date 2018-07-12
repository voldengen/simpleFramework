<cfif IsDefined("cookie.userID")>
  <cfset request.user.init(cookie.userID)>
  <cfset request.userID = cookie.userID>

  <cfif Not request.user.isActive() And CGI.SCRIPT_NAME NEQ "/logout.cfm">
    <cflocation url="/logout.cfm" addtoken="false">
  </cfif>

  <cfif request.user.isAdmin()>
    <!--- some settings for admin users --->
  <cfelse>
    <!--- same settings for regular users --->
  </cfif>
</cfif>

<cfif NOT listFindNoCase(application.byPass,cgi.script_name)>
  <cfif IsDefined("request.attributes.userName") AND request.attributes.userName NEQ "">
    <cfset local.validateUser = request.user.validateUser(request.attributes.userName, request.attributes.password)>
    <cfif NOT local.validateUser.success>
      <cfset request.errorMessage = "User validation failed">
    <cfelse>
      <cfif IsDefined("request.attributes.remember")>
        <cfcookie name="userNameRemembered" value="#request.attributes.userName#" expires="Never">
      </cfif>
      <cflocation url="/index.cfm" addtoken="false">
    </cfif>
  </cfif>
</cfif>

<cfif request.user.isLoggedIn() OR NOT listFindNoCase(application.byPass,cgi.script_name)>
  <!--- <cfdump var="#request.user#"><cfabort> --->
<cfelseif listfirst(cgi.script_name, "/") EQ "jobs")>
    <cfset request.user.init(1)><!--- Need an admin user here --->
    <cfset request.user.loginWithoutPassword()><!--- Need an admin user here --->
    <cfset request.userID = 1><!--- Need an admin user here --->
<cfelse>
    <cflocation url="/login.cfm" addtoken="false">
</cfif>