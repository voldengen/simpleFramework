<cfcomponent>

  <cfset this.Name = config().name />
  <cfset this.SessionManagement = true />
  <cfset this.ClientManagement = true />
  <cfset this.sessionTimeout = config().sessionTimeout />
  <cfset this.datasource = config().datasource />
  <cfset this.defaultdatasource = this.datasource /> <!--- for Lucee --->
  <cfset this.rootPath = getDirectoryFromPath(getCurrentTemplatePath()) />
  <cfset this.mappings["/inc"] = this.rootPath & "inc" />

  <cffunction name="config" output="false" access="public" returntype="struct">
    <cfif NOT StructKeyExists( this, "_config" )>
      <cfset this["_config"] = {} />

      <cfif listLast(cgi.http_host, ".") EQ "local">
        <cfset this["_config"].name = "localTestApp" />
        <cfset this["_config"].environment = "dev" />
        <cfset this["_config"].datasource = "testDSN"/> 
        <cfset this["_config"].sessionTimeout = CreateTimeSpan( 0, 0, 5, 0 ) />
      <cfelseif listFirst(cgi.http_host, ".") EQ "staging">
        <cfset this["_config"].name = "stagingTestApp" />
        <cfset this["_config"].environment = "staging" />
        <cfset this["_config"].datasource = "testDSN" />
        <cfset this["_config"].sessionTimeout = CreateTimeSpan( 0, 0, 20, 0 ) />
      <cfelse>
        <cfset this["_config"].name = "testApp" />
        <cfset this["_config"].environment = "production" />
        <cfset this["_config"].datasource = "prodDSN" />
        <cfset this["_config"].sessionTimeout = CreateTimeSpan( 0, 0, 20, 0 ) />
      </cfif>
    </cfif>

    <cfreturn this["_config"] />
  </cffunction>

  <cffunction name="onApplicationStart">
    <cfset application.environment = config().environment />
    <cfset application.byPass = "/login.cfm,/logout.cfm,/healthCheck.cfm,/forgotPassword.cfm,/resetPassword.cfm,/maintenance.cfm" />
  </cffunction>

  <cffunction name="OnRequestStart">
    <cfargument name="thePage" type="string" required="true">

    <cfset var local = {} />
    <cfset request.attributes = {} />
    <cfset structappend(request.attributes,url) />
    <cfset structappend(request.attributes,form) />

    <cfif IsDefined("url.reload")>
      <cfset ApplicationStop()>
      <cflocation url="#cgi.script_name#" addtoken="false">
    </cfif>

    <cfif application.environment EQ "production">
      <cfset h = getHttpRequestData() />
      <cfif structKeyExists(h.headers,"x-forwarded-host") And structKeyExists(h.headers,"X-Forwarded-Proto") AND Not h.headers["X-Forwarded-Proto"] EQ "https">
        <cflocation url="https://#server_name#" addtoken="false"/>
      </cfif>
    </cfif>

    <cfset request.user = CreateObject("component", "lib.user").init() />

    <!--- make sure user is signed in, etc --->
    <!---
    <cfinclude template="/inc/userSessionStuff.cfm" />
    --->
  </cffunction>


  <cffunction name="onError">
    <!--- The onError method gets two arguments:
            * An exception structure, which is identical to a cfcatch variable.
            * The name of the Application.cfc method, if any, in which the error happened. --->
    <cfargument name="Except" required="true">
    <cfargument type="String" name = "EventName" required="true">

    <cfif config().environment EQ "production">
      <cfmail to="aws@webapper.net" from="aws@webapper.net" type="html" subject="Errors at #config().name#">
        <cfoutput>#arguments.EventName#</cfoutput>
        <p>
        <cfdump var="#arguments.except#" />
        <cfdump var="#form#" />
        <cfdump var="#url#" />
        <cfdump var="#cookie#" />
        </p>
      </cfmail>
      <cflocation url="/index.cfm" addtoken="false" />
    <cfelse>
        <cfdump var="#arguments.except#" />
        <cfdump var="#cookie#" label="Cookies" />
        <cfdump var="#form#" label="Form" />
        <cfdump var="#url#" label="Query String" />
        <cfdump var="#cgi#" label="CGI" />
    </cfif>
  </cffunction>
</cfcomponent>
