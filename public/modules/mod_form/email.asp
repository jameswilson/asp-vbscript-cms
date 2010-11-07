<!--#include file="../../core/src/functions/functions.mail.asp"-->
<%
function sendFormMail()
	if myForm.wasSubmitted() then
		dim from : from=myForm.getValue("email")
		if len(myForm.getValue("name"))>0 then from = """"&myForm.getValue("name")&""" <"&from&">"
		dim subject : subject=PCase("Customer " & PrettyText(myForm.getValue("form_name")))
		sendFormMail=sendMail(null,from,subject,myForm.form,p("{INTRO}"), "{INTRO}")
	else 
		sendFormMail=InfoMessage("No form was submitted!")
	end if
end function
%>