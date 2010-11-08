<%

'=============================================================
' Summary:  If this file is included on an asp page, then it
'           ensures that a user must be logged in and must 
'           have sufficient priviledges to view/access the 
'           page.
' 
' Notice:   Include this file on all admin pages. By default,
'           the user must have a security clearance of 
'           `USER_MANAGER` or greater to view/acces the 
'           page.  Optionally, you may set the security level BEFORE
'           including this file, to further restrict (or lessen)
'           the file's access level. 
'
' Usage:    To set different page access levels use the following
'           examples:
'             page.setSecurityLevel(USER_ADMINISTRATOR) ' restrict page to only ADMINISTRATOR users
'             page.setSecurityLevel(USER_MANAGER) ' restrict page to MANAGERS and above (DEFAULT)
'             page.setSecurityLevel(USER_EDITOR) ' restrict page to EDITORS and above
'             page.setSecurityLevel(USER_REGISTERED)  ' restrict page to REGISTERED users and above.
'
dim errMsg, requested_url, redirect_target
if page.getSecurityLevel = 0 then page.setSecurityLevel(USER_MANAGER) 'initialize default security level
trace("Secure File:  user.roleLevel="&user.getRole()&" page.secureitylevel="&page.getSecurityLevel())
requested_url = ""
if user.getRole() >= page.getSecurityLevel() then
	debug("secure.asp: user has sufficient rights to access secured file.")
	if (user.isLoggedIn()) then
		debugInfo("secure.asp: user is logged in.")
	else 
		requested_url = request.ServerVariables("URL")
		if len(request.querystring())>0 then requested_url = requested_url & "?" & request.querystring()
		errMsg = WarningMessage("Your session has expired! Please login again to view this page.")
		redirect_target = globals("ADMINURL")&"/"
	end if
else
	'Session.Timeout
	requested_url = request.ServerVariables("URL")
	errMsg = WarningMessage(user.getRoleName()&"s are not allowed to view the page '"&requested_url&"'.")
	redirect_target = globals("ADMINURL")&"/"
end if
if len(errMsg)>0 then Session(CUSTOM_MESSAGE) = errMsg
if len(requested_url)>0 then Session(REQUESTED_PAGE) = requested_url
if len(redirect_target)>0 then 	Response.Redirect(redirect_target)
%>