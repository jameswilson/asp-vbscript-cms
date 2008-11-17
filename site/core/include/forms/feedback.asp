<!--#include file="../../src/functions/functions.mail.asp"-->
<!--#include file="../../src/classes/class.form.asp"-->
<%

	dim myForm : set myForm = new WebForm
	myForm.Name = "feedback"
	myForm.Name = "feedback"
	myForm.Action = "?success"

	dim strStatus : strStatus = ""
	dim strTitle : strTitle = trim(request.QueryString("title"))
	dim strInstr : strInstr = trim(request.QueryString("instr"))
	dim strSubject : strSubject = trim(request.QueryString("subject"))
	dim strMessage : strMessage = trim(request.QuerySTring("message"))
	
	writeln(h1(strTitle))
	if myForm.wasSubmitted() then 
		dim from : from =  myForm.getValue("email")
		dim subject : subject = PCase("Customer " & PrettyText(myForm.getValue("form_name")))
		writeln(sendMail(null,from,subject,myForm.form,p("{INTRO}"), "{INTRO}"))
	else 
		writeln(p(strInstr))
		myForm.addFormInput "required", "Your Name", "name",  "text", "", "", DBTEXT,"Please enter your name."
		myForm.addFormInput "required", "Your Email", "email",  "text", "email", "", DBTEXT,"Please enter your valid email address."
		
		if len(strSubject) > 0 then
			myForm.addFormInput "required", "Subject", "subject",  "text", "", strSubject, DBTEXT&READONLY,""
		end if
		myForm.addFormInput "required", "Your Message", "message",  "textarea", "length(10:1000)", "", DBTEXT,"Must be at least 10 characters and less than 1000."
		myForm.addFormSubmission "left","Submit &raquo;","Reset","",""
	
		
		writeln(myForm.getContents())
	end if
%>
