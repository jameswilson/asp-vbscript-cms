<%
Dim objMessage
Dim objConfig
Dim Flds
Dim dictFields : Set dictFields = Server.CreateObject("Scripting.Dictionary")
dim sendSuccess : sendSuccess = "message_sent"
dim sendFailure : sendFailure = "message_not_sent"
dim sendSimulation : sendSimulation = "simulate_send"
Dim MESSAGE_SENT : MESSAGE_SENT = "Thank you, your " & PrettyText(Request.Form("form_name")) & " request has been submitted. Someone from "&objLinks.item("SHORTNAME")&" will be contacting you shortly."
Dim MESSAGE_SIMULATE : MESSAGE_SIMULATE = "DEVELOPERS! Message not actually sent because your server is localhost. On the live site, the message would look like the following:"
Dim MESSAGE_FAILED : MESSAGE_FAILED = "Your message failed to be sent."
function sendFormMail()
			dim message : set message = createMailMessage()
			if debugMode() Then
				Session("MailContents") = getMessageContentsHTML(message)
				Session("CustomMessage") = sendMessage(message)
				Response.redirect("?"&sendSimulation)
			else
				Session("CustomMessage") = sendMessage(message)
				Response.redirect("?"&sendSuccess)
			end if
end function

function formMailWasSent()
	Select Case Request.QueryString()
		Case sendSimulation, sendSuccess, sendFailure
			formMailWasSent = True
	end select
end function

function getFormMailResults()
	dim a : set a = New FastString		
	select case Request.QueryString()
		Case sendSuccess
			a.add "<h2>"&MESSAGE_SENT&"</h2>"
		case sendSimulation
			a.add "<h2>"&MESSAGE_SIMULATE&"</h2>"
			a.add "<p>"&MESSAGE_SENT&"</p>"
			a.add "<p>Go to the real <a href='?"&sendSuccess&"'>message sent page</a>.</p>"
			a.add "<hr/>"
			a.add "<h3>Message Contents</h3> "&Session("MailContents")
			a.add "<hr/>"
			Session("CustomMessage") = MESSAGE_SENT
		case sendFailure
			a.add "<h2 class=""alert"">"&MESSAGE_FAILED&"</h2>"
			a.add "<p>"&Session("CustomMessage")& "</p>"
			a.add "<h3>Message Contents</h3> "&Session("MailContents")
		case Else
			a.add ""
	end select
	Session.Contents.RemoveAll()
	getFormMailResults = a.value
	set a = nothing
end function

'TODO: formmail error checking on send
function sendMessage(objMessage)
	debugInfo("SENDING FORM AS EMAIL...")
	dim a : set a = New FastString
	if Request.ServerVariables("SERVER_NAME") = "localhost" Then 
		a.add "<p>"&MESSAGE_SIMULATE&"</p>"
	Else
		
		objMessage.Send
		'error goes checking here
	end If
	a.add  "<p>"&MESSAGE_SENT&"</p>"
	sendMessage = a.value
	set a = nothing
end function


function createMailMessage()
		debugInfo("CREATING MAIL MESSAGE")
		' Set the SMTP Server
		dim objConfig : set objConfig = server.createobject("cdo.configuration")
		dim flds : set flds = objConfig.Fields
		flds.Item("http://schemas.microsoft.com/cdo/configuration/sendusing") = 2
		flds.Item("http://schemas.microsoft.com/cdo/configuration/smtpserver") = objLinks.item("SMTPHOST")
		debug("SMTP HOST: "&objLinks.item("SMTPHOST"))
		flds.update
		' Create the message object
		dim objMessage : set objMessage = server.createobject("cdo.message")
		set objMessage.Configuration = objConfig
		' Create the message body
		dim emailBody : set emailBody = getEmailBody()
		
		objMessage.To = objLinks.item("ADMINEMAIL")
		objMessage.From = """Webmaster"" <" & objLinks.item("PROVIDER_EMAIL") &">"
		objMessage.ReplyTo = """"& request.form("contact_name") & """ <" & Request.Form("contact_email")&">"
		If objLinks.item("BCC") = "YES" Then objMessage.BCC = objLinks.item("BCCEMAIL")
		If objLinks.item("CCSENDER") = "YES" then objMessage.CC = Request.Form("email")
		objMessage.Subject = objLinks.item("SUBJECTLINE_PREFIX")& " " & PCase("Customer " & PrettyText(Request.Form("form_name")))
		objMessage.TextBody  = emailBody.item("text") 'can be generated automatically if commented out
		objMessage.HTMLBody = emailBody.item("html")
		objMessage.fields.update
		
		set createMailMessage = objMessage
end function 


'returns a dictionary with two items 
' "html" contains the html body
' "text" contains a text version of the email body
function GetEmailBody()
	dim logoImg : logoImg = objLinks.item("EMAIL_HEADER_IMG")
	dim introTxt : introTxt = objLinks.item("INTRO")
	dim companyTxt : companyTxt = objLinks.item("COMPANY")
	dim sloganTxt : sloganTxt = objLinks.item("SLOGAN")
	dim bodyHTML : set bodyHTML = New FastString
	dim bodyText : set bodyText = New FastString
	
	bodyHTML.add "<p><img src=""" & logoImg & """ alt="""&companyTxt&"""><br/>" & vbCrLf
	bodyHTML.add introTxt & "</p>" & vbCrLf
	bodyHTML.add "<table border=""0"" cellpadding=""4"" cellspacing=""0"">" & vbCrLf
	bodyText.add companyTxt & vbCrLf
	bodyText.add sloganTxt & vbCrLf & vbCrLf
	bodyText.add introTxt & vbCrLf

  dim fldName, displayName, sStyle, spacer
	dim bolEven : bolEven = false
	for each fldName in request.form
		displayName = PCase(Replace(fldName,"_"," "))
		bolEven = not bolEven
		spacer = ""
		sStyle = ""
		if bolEven then sStyle = " bgcolor=#EEEEEE"
		bodyHTML.add "<tr valign=""top""" & sStyle & ">"
		bodyHTML.add "<td><b>" & displayName & "</b></td>"
		bodyHTML.add "<td>" & Request.Form(fldName) & "</td>"
		bodyHTML.add "</tr>" & vbCrLf
		if len(fldName) < 25 then spacer = String(25-cint(len(fldName)), ".")
		bodyText.add displayName & " " & spacer & " " & Request.Form(fldName) & vbCrLf
	next
	
	bodyHTML.add "</table>" & vbCrLf
	
	dim d : set d=Server.CreateObject("Scripting.Dictionary")
	d.add "text",bodyText.value
	d.add "html",bodyHTML.value
	set GetEmailBody = d
	set bodyText = nothing
	set bodyHTML = nothing
	set d = nothing
end function

function getMessageContentsHTML(objMessage)
	dim a : set a = New FastString
	a.add  "<p><strong>To:</strong> <pre>" & server.HTMLencode(objMessage.To)&"</pre>"
	a.add  "<p><strong>From:</strong> <pre>" & server.HTMLencode(objMessage.From) &"</pre>"
	If objLinks.item("BCC") = "YES" Then a.add  "<p><strong>BCC:</strong> <pre>"& server.HTMLencode(objMessage.BCC)&"</pre>"
	If objLinks.item("CCSENDER") = "YES" Then a.add  "<p><strong>CC:</strong> <pre>"& server.HTMLencode(objMessage.CC) &"</pre>"
	a.add  "<p><strong>Subject: </strong> <pre>" & server.HTMLencode(objMessage.Subject) &"</pre>"
	a.add  "<p><strong>Text Body:</strong>  <pre>" & server.HTMLencode(objMessage.TextBody) &"</pre>"
	a.add  "<p><strong>HTML Body: </strong> <pre>" & server.HTMLencode(objMessage.HTMLBody) &"</pre>"
	a.add  "<p><strong>Preview: </strong> " & objMessage.HTMLBody
	'debug("MESSAGE CONTENTS: "&a.value)
	getMessageContentsHTML = a.value
	set a = nothing
end function
%>