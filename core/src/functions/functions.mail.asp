<%
const MESSAGE_SENT = "Thank you, an email has been sent successfully."
const MESSAGE_SIMULATE = "DEVELOPERS! On the live site, the message would look like the following:"
const MESSAGE_FAILED = "Your message failed to be sent."
const TEST_MAIL_WARNING = "NOTE: This email message was sent from someone as a test and therefore was not sent onward to the website's company contact {Contact Email}! "

function sendMail(mail_to,mail_from,mail_subject,mail_Dict,mail_BodyHTML, mail_BodyTEXT)
	dim result : set result = new FastString
	dim bodyHTML : set bodyHTML = New FastString
	dim bodyText : set bodyText = New FastString
	dim oMail : set oMail=Server.CreateObject("cdo.message")
	if request.serverVariables("SERVER_NAME") <> "localhost" then 
		dim objConfig : set objConfig = server.createobject("cdo.configuration")
		dim flds : set flds = objConfig.Fields
		flds.Item("http://schemas.microsoft.com/cdo/configuration/sendusing") = 2
		flds.Item("http://schemas.microsoft.com/cdo/configuration/smtpserver") = globals("SMTPHOST")
		debugInfo("mod_form.email: SMTP HOST: "&globals("SMTPHOST"))
		flds.update
		set oMail.Configuration = objConfig
	end if

	'//prepare message body 
	bodyHTML.add token_replace("{EMAIL_HTML_HEADER}" & "<br/>" & mail_BodyHTML  & "<br/>" & "<br/>")
	bodyText.add token_replace("{EMAIL_TEXT_HEADER}" & vbCrLf & mail_BodyTEXT  & vbCrLf & vbCrLf)
	bodyHTML.add "<table border=""0"" cellpadding=""4"" cellspacing=""0"">" & vbCrLf
	dim fldName, displayName, displayValue, spacer, bolEven, sStyle
	for each fldName in mail_Dict
		if lcase(fldName)="form_name" then
			debugInfo("functions.mail.sendMail: Form Name is '"&Pcase(PrettyText(mail_Dict(fldName)))&"'")
		else
			displayName = Pcase(PrettyText(replace(fldName,"_"," ")))
			displayValue = Server.HTMLEncode(mail_Dict(fldName))
			debugInfo("functions.mail.sendMail: form item '"&displayName&"' has value '"&displayValue&"'")
			bolEven = not bolEven
			spacer = ""
			sStyle = ""
			if bolEven then sStyle = " bgcolor=#EEEEEE"
			bodyHTML.add "<tr valign=""top""" & sStyle & ">"
			bodyHTML.add "<th>" & displayName & "</th>"
			bodyHTML.add "<td>" & displayValue & "</td>"
			bodyHTML.add "</tr>" & vbCrLf
			if len(displayName) < 25 then spacer = String(25-cint(len(displayName)), " ")
			bodyText.add spacer & displayName & ": "& displayValue & vbCrLf
		end if
	next 
	bodyText.add token_replace(vbCrLf & vbCrLf & "{EMAIL_TEXT_FOOTER}")	
	bodyHTML.add token_replace("</table><br/>"& "{EMAIL_HTML_FOOTER}")
	
	'//prepare message subject
	oMail.Subject = token_replace("{SUBJECTLINE_PREFIX} "&mail_subject)
	
	'//prepare message sender and recipients
	if (isNull(mail_to) or len(mail_to)=0) then mail_to ="""{Company Name}"" <{Contact Email}>"
	if (isNull(mail_from) or len(mail_from)=0) then 
		mail_from = """{SITENAME} Administrator"" <{PROVIDER_EMAIL}>"
	elseif instr(mail_from,"test@")=1 then
		mail_to = """{SITENAME} Testing (ADMINEMAIL)"" <{ADMINEMAIL}>"
		bodyText.add token_replace(TEST_MAIL_WARNING)
		bodyHTML.add small(token_replace(TEST_MAIL_WARNING))
	end if
	oMail.From = token_replace(mail_from)
	oMail.To = token_replace(mail_to)
	if globals("BCC") = "YES" then oMail.BCC = token_replace("{BCCEMAIL},{ADMINEMAIL}")
	if globals("CCSENDER") = "1" then oMail.CC = token_replace(mail_from)


	oMail.TextBody = bodyText.value
	oMail.HTMLBody = bodyHTML.value
	
	'//send message!
	oMail.fields.update
	err.clear
	on error resume next
	oMail.Send
	if err.number <> 0 then
		result.add AlertMessage(iif(debugMode(),MESSAGE_FAILED&"Error Was: "& err.description & ".</br> Message Was: "&debugEmail(oMail),MESSAGE_FAILED))
		err.clear
	else
		if debugMode() = true then
			result.add InfoMessage(MESSAGE_SIMULATE)
			result.add MailSentMessage(MESSAGE_SENT)
			result.add debugEmail(oMail)
		else
			result.add MailSentMessage(MESSAGE_SENT)
		end if
	end if
	on error goto 0
	set oMail = nothing
	set bodyText = nothing
	set bodyHTML = nothing
	sendMail = result.value
end function


function debugEmail(objMessage)
	dim a : set a = New FastString
	a.add  "<blockquote><code><strong>To:</strong> " & server.HTMLencode(objMessage.To)&"<br/>"
	a.add  "<strong>From:</strong> " & server.HTMLencode(objMessage.From) &"<br/>"
	a.add  "<strong>Reply To:</strong> " & server.HTMLencode(objMessage.ReplyTo) &"<br/>"
	a.add  "<strong>BCC:</strong> "& server.HTMLencode(objMessage.BCC)&"<br/>"
	a.add  "<strong>CC:</strong> "& server.HTMLencode(objMessage.CC) &"<br/>"
	a.add  "<strong>Subject: </strong> " & server.HTMLencode(objMessage.Subject) &"<br/>"
	a.add  "<strong>Text Body:</strong>  " & server.HTMLencode(objMessage.TextBody) &"<br/>"
	a.add  "<strong>HTML Body: </strong> " & server.HTMLencode(objMessage.HTMLBody) &"<br/></code></blockquote>"
	a.add  "<p><strong>Preview: </strong> " & objMessage.HTMLBody
	debugEmail = a.value
	set a = nothing
end function

%>