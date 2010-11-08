<!--#include file="../../../core/src/functions/functions.mail.asp"-->
<%
const USER_ADDED_SUBJECT = "Your Account Information"
const USER_ADDED_BODY = "An account has been created with the following information at {SITENAME}. If you were not responsible for this addition, please disregard this email."

function contentAdd()
	if user.getRole() < USER_ADMINISTRATOR then 
		strError = "You do not have sufficient priviledges to create new "& strContentPL &"."
		exit function
	end if
	if myForm.wasSubmitted() = true then
		debugInfo("form was submitted, storing to the session.")
		myForm.storeFormToSession()
		myForm.Action = "?add"
		contentAdd = buildFormContents(null)
		set formErrors = myForm.getFormErrors()
		if formErrors.count > 0 then
			strError = "The new "& strContent &" has errors in the form"
			debugError("admin."& strContent &".add:"& strError)
		else
			debugInfo("admin."& strContent &".add: form had zero errors")
			dim strSQL: strSQL = CreateSQL("insert",strTableName, myForm.Form, strKey)
			' Uncomment the two following lines to debug
			'strStatus = strSQL 
			'exit function
			db.execute(strSQL)			
			if db.hasErrors() = true then 
				dim dbErr
				for each dbErr in db.getErrors()
					strError = strError & p(dbErr.description)
				next
			else			
				dim mailFields : set mailFields = server.CreateObject("Scripting.Dictionary")
				mailFields.add "Name", cstr(myForm.getValue("FirstName") &" "& myForm.getValue("SecondName"))
				mailFields.add "User ID", cstr(myForm.getValue("UserID"))
				mailFields.add "Password", cstr(myForm.getValue("Password"))
				
				contentAdd = sendMail(myForm.getValue("Email"), null,USER_ADDED_SUBJECT,mailFields,p(USER_ADDED_BODY),USER_ADDED_BODY)
				
				strStatus = "The "& strContent &" was added successfully.<br/>" & vbCrLf & _
					"Would you like to  <a href='?view'>view the list</a> of "& strContentPL & vbCrLf & _
					"or <a href='?create'>create a new one</a>?"
				strError = ""
			end if
		end if
	else 
		strError = "Oops, there was no form submitted! <a href='?view'>View the list</a> of "& strContentPL
	end if
end function


%>
