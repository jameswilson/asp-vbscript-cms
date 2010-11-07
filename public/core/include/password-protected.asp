<%
'* @summary  If this file is included on an asp page, then it
'*           requires that a user provide a custom password to 
'*           view/access the page contents.
'* @required Requires the class WebForm be also included!
'* @usage  To set a page password use the following example 
'*           before including this file: \code
'* &lt;!--#include file="core/include/global.asp"--&gt;
'* &lt;% 
'* addGlobal "DEBUG","1",null
'* dim PASSWORD : PASSWORD = "Password" 
'* %&gt; 
'* &lt;!--#include file="core/src/classes/class.form.asp"--&gt;
'* &lt;!--#include file="core/include/password-protected.asp"--&gt;
'* &lt;!--#include file="core/include/template.asp"--&gt;
'* \endcode

page.setFile(request.ServerVariables("URL"))

'**
'*  Implementation of customContent() hook.
'*  Note this is a VERY WEAK PASSWORD PROTECTION SCHEME 
'*  AND SHOULD NOT BE USED FOR TRULY SENSETIVE DATA!!!!
function customContent(section)
	if section <> "main" then exit function
	if session("pass") = PASSWORD then exit function
	err.clear
	on error resume next
	if isNull(PASSWORD) or PASSWORD = "" then err.raise 6,"",""
	if err.number <>0 then 
		debugError("password-protected.asp: you must set the password before using the password-protected.asp script!")
		customContent = ErrorMessage("you must set the password before using the password-protected.asp script!")
		err.clear
		exit function
	end if
	on error goto 0
	
	page.ignoreDBContent = true
	dim the_form : set the_form = new WebForm
	dim user_supplied_password : user_supplied_password = ""
	with the_form
		.name = page.getName+" password protected"
		.action = page.getFileName
		.addfieldset "Login", "This page is password protected."
		.addFormInput "required","Password","pass","password","password","","",""
		.addFormSubmission "left","Submit", "", "", ""
		.endfieldset
		if (.wasSubmitted = true and .hasErrors = false) then
			user_supplied_password = .getValue("pass")
			debug("password-protected.asp: user provided password: "&user_supplied_password)
			session("pass") = user_supplied_password
		end if
		if user_supplied_password = PASSWORD then
			debug("password-protected.asp: the password is valid!")
			exit function
		end if
		debug("password-protected.asp: the passowrd '"&user_supplied_password&"' is invalid!")
		customContent = .getContents
	end with
end function 
%>