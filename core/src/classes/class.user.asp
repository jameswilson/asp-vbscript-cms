
<%
const USER_GUEST = 0
const USER_REGISTERED = 20
const USER_EDITOR = 30
const USER_MANAGER = 50
const USER_ADMINISTRATOR = 100
const USER_COOKIE  = "-"
const DEFAULT_PERSISTENCE_POLICY = false
dim   DEFAULT_USER_STRING : DEFAULT_USER_STRING = "|Guest|Guest User|0|" & date()

class ClientUser
	private myUserId
	private myUserName
	private myFullName
	private hasAdminRights
	private isPersistent
	private myLastLogin
	private myUserDataArray
	private myUserDataString
	private bolExists
	private myUserErrorsDict
	private myRoleLevel

	'============================
	'    INITIALIZATION CODE
	'============================

	'called at creation of instance
	private sub class_Initialize()
		set myUserErrorsDict = Server.CreateObject("Scripting.Dictionary")
		if session(USER_COOKIE) <> "" then
			myUserDataString = decrypt(session(USER_COOKIE))
			bolExists = true
			debugInfo("class.user.init: aknowledged active user session")
		elseif Request.Cookies(USER_COOKIE) <> "" then
			myUserDataString = decrypt(Request.Cookies(USER_COOKIE))
			bolExists = true
			debugInfo("class.user.init: aknowledged user from cookies")
			rememberMe(true)
		else
			myUserDataString = DEFAULT_USER_STRING
			bolExists = false
			debug("class.user.init: No user data was found for this client session, using defaults.")
			rememberMe(DEFAULT_PERSISTENCE_POLICY)
		end if
		trace("class.user.init: un-encrypted user data '" & myUserDataString & "'")
		myUserDataArray = split(myUserDataString,"|")
		if ubound(myUserDataArray) >= 0 then setId(myUserDataArray(0))
		if ubound(myUserDataArray) >= 1 then setName(myUserDataArray(1))
		if ubound(myUserDataArray) >= 2 then setFullName(myUserDataArray(2))
		if ubound(myUserDataArray) >= 3 then setRole(myUserDataArray(3))
		if ubound(myUserDataArray) >= 4 then setLastLogin(myUserDataArray(4))
	end sub


	private sub initUserGlobals()
		addGlobal "USERNAME", user.getName(), null
		addGlobal "USERID", user.getId(), null
		addGlobal "USERFULLNAME", user.getFullName(), null
	end sub

	'called when object instance is set to nothing
	private sub class_Terminate()
		erase myUserDataArray
	end sub

	public function getId()
		getId = myUserId
	end function

	public function setId(userId)
		trace("class.user.setId: '" & userId & "'")
		myUserId = userId
	end function

	public function getName()
		getName = myUserName
	end function

	public function setName(userName)
		trace("class.user.setName: '" & userName & "'")
		myUserName = userName
	end function

	public function getFullName()
		getFullName = myFullName
	end function

	public function setFullName(userNameFull)
		trace("class.user.setFullName: '" & userNameFull & "'")
		myFullName = userNameFull
	end function

	public function getRoleName()
		if myRoleLevel >= USER_ADMINISTRATOR then
			getRoleName = "Administrator"
		elseif myRoleLevel >= USER_MANAGER then
			getRoleName = "Manager"
		elseif myRoleLevel >= USER_EDITOR then
			getRoleName = "Editor"
		elseif myRoleLevel >= USER_REGISTERED then
			getRoleName = "Registered"
		elseif myRoleLevel >= USER_GUEST then
			getRoleName = "Guest"
		end if
	end function

	public function isAdministrator()
	trace("class.user.isAdministrator: '" & (getRole()>=50) & "'")
		isAdministrator = (getRole()>=50)
	end function

	public function setAdmin(isApproved)
		trace("class.user.setAdmin:'" & isApproved & "'")
		debugWarning("class.user.setAdmin: THIS METHOD Has been deprecated.  you should not ever have to setAdmin(), use setRole(intValue) instead.")
		hasAdminRights = cbool(isApproved)
	end function

	public function setRole(byVal roleLevel)
		on error resume next
		trace("class.user.setRole: '" & roleLevel & "'")
		if (roleLevel = "") or (isNull(roleLevel)) then
			myRoleLevel = 0
		else
			myRoleLevel = cint(roleLevel)
		end if
		if (err.number <> 0) or (myRoleLevel < 0) then
			debugError("class.user.setRole: bad role '" & roleLevel & "'.  Must specify an integer greater than 0.")
		end if
	end function

	public function getRole()
		getRole = myRoleLevel
	end function

	public function getLastLogin()
		getLastLogin = myLastLogin
	end function

	public function setLastLogin(strDate)
		trace("class.user.setLastLogin: '" & strDate & "'")
		myLastLogin = strDate
		db.execute("UPDATE tblUsers SET LastLogin=#" & CDate(myLastLogin) & "# WHERE UserID='" & myUserId & "'")
	end function

	public function rememberMe(bolRemember)
		trace("class.user.rememberMe: '" & bolRemember & "'")
		isPersistent = cbool(bolRemember)
	end function

	public function exists()
		exists = cbool(bolExists)
	end function

	'the mechanism for detecting an active session
	'depends on the existence of an encrypted session
	'variable who's key is the user's id and the value
	'is todays date
	public function isLoggedIn()
		trace("class.user.isLoggedIn: session logged-in date: " & cdate(decrypt(session(getId()))))
		if cdate(decrypt(session(getId()))) = date() then
			debugInfo("class.user.isLoggedIn: User '" & myUserId & "' is logged in.")
			isLoggedIn = true
		else
			debugInfo("class.user.isLoggedIn: User '" & myUserId & "' is not logged in.")
			isLoggedIn = false
		end if
	end function

	public function setLoggedIn(bool)
		trace("class.user.setLoggedIn: '" & cbool(bool) & "'")
		if getId() <> "" then
			if cbool(bool) = true then
				session("" & getId()) = encrypt("" & date())
			else
				trace("setting session cookie to " & date() - 91)
				session("" & getId()) = encrypt("" & date() - 91)
			end if
		end if
	end function

	'to use this function you are responsible for
	'including the functions/user_login.asp file
	public function login(userId, password)
		err.clear
		dim rs, nCount
		dim loginstatus : loginstatus = false
		setId(userId)
		if isLoggedIn() then
			debugWarning("class.user.login: user '" & userId & "' is already logged in")
			loginstatus = true
		else
			trace("class.user.login: Logging in as user '" & userId & "'...")
			'Execute the verification process
			set rs = db.getRecordSet("SELECT * FROM tblUsers WHERE UserID='" & userId & "'")

			if rs.state > 0 then
				'1 - Password check
				debug("class.user.login: userid=" & userId)
				debug("class.user.login: password=" & password)

				if rs("Password") <> password then
					addError globals("BAD_PASSWORD")
				'2 - Active user check
				elseif rs("Disabled")  then
					addError globals("LOGIN_EXPIRED")
				else
					setName(rs("FirstName"))
					setFullName(rs("FirstName") & " " & rs("SecondName"))
					setRole(rs("Role"))
					setLastLogin(date())
					loginstatus = true


					debug("class.user.login: disabled=" & rs("Disabled"))
					debug("class.user.login: firstname=" & rs("FirstName"))
				end if
			elseif nCount = 0 then
				addError globals("INVALID_USER")
			elseif nCount < 0 then
				addError ErrorMessage("Site access is temporarily unavailable. " & globals("ERROR_FEEDBACK"))
			end if

			' Error processing
			trapError
			if err.number <> 0 then
				debugWarning("class.user.login(): Trapped an error during DB record set processing")
				processErrors
				loginstatus = false
			end if
		end if
		setLoggedIn(loginstatus)
		login = loginstatus
	end function


	public function logout()
		Session.Contents.RemoveAll()
		Session.Timeout
		setLoggedIn(false)
	end function

	public function persist(expirationTime)
		dim a : a = getId() & "|" & getName() & "|" & getFullName() & "|" & getRole() & "|" & date()
		trace("Persisting user data for User '" & getName() & "'...")
		trace("...data string: '" & a & "'")
		session(USER_COOKIE)= encrypt(a)
		trace("...encrypted session cookies: '" & Server.UrlEncode("" & session(USER_COOKIE)) & "'")

		if (isPersistent = true) then
			Response.Cookies(USER_COOKIE) = session(USER_COOKIE)
			trace("...encrypted client cookies: '" & Server.UrlEncode("" & session(USER_COOKIE)) & "'")
			Response.Cookies(USER_COOKIE).expires = expirationTime
			trace("...the cookie '" & USER_COOKIE & "' expires '" & expirationTime & "'")
		else
			unpersist()
		end if
	end function

	public function unpersist()
		trace("User requested to not retain Cookies...")
		debug("... the cookie '" & USER_COOKIE & "' set to expire on '" & Date() - 1 & "'")
		Response.Cookies(USER_COOKIE) = ""
		Response.Cookies(USER_COOKIE).expires = Date() - 1
	end function

	public function activeAdminSession()
		activeAdminSession = isAdministrator() and isLoggedIn()
	end function

	public function hasAdminCredentialCookies()
		hasAdminCredentialCookies = isAdministrator()
	end function

	public function toString()
		dim a : set a = new FastString
		a.add "[UserId -> " & myUserId & "]" & vbCrLf
		a.add "[UserName -> " & myUserName & "]" & vbCrLf
		a.add "[FullName -> " & myFullName & "]" & vbCrLf
		a.add "[Role -> " & getRole & "]" & vbCrLf
		a.add "[LastLogin -> " & myLastLogin & "]" & vbCrLf
		toString = a.value
		set a = nothing
	end function

		'return the dictionary of errors
	public function getErrors()
		set getErrors = myUserErrorsDict
	end function

	public function getLastError()
		getLastError = myUserErrorsDict.item("" & myUserErrorsDict.count-1)
	end function

	private function addError(strErrorMessage)
		debugError("class.user.Error: " & Server.HtmlEncode(strErrorMessage))
		myUserErrorsDict.add "" & myUserErrorsDict.count, strErrorMessage
	end function
end class
%>
