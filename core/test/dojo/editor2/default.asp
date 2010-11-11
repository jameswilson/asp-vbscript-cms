<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file="../../../core/include/bootstrap.asp"-->
<!--#include file="../../../core/src/classes/class.form.asp"-->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Xdomain Dojo Editor Test</title>
</head>

<body>

<%
addGlobal "DEBUG", "1", null
dim frm : set frm = new WebForm
frm.setName "test1"
frm.setAction "?"
frm.setMethod "POST"
frm.addFieldset "Comments",""
frm.addFormInput "required", "Your Name", "name", "text", "length(0,30)", "Joe Tester", "", "Enter your name in the field above."
frm.addFormInput "optional", "Your Email", "email", "text", "email", "test@example.com", "", "Enter your valid email address in the field above."
frm.addFormInput "optional", "Your Message", "message", "textarea", "length(10,1000)", "<h1>Test Message</h1>"& vbCrLf &"<p>This is the default message text... feel free to change it.</p>", "style=""border: 1px solid grey;""", "Enter your message, must be at least 10 and no more than 1000 characters."
frm.addFormSubmission "left","Submit &raquo;","Cancel","",""
frm.endFieldset
frm.addFieldset "Extra Info",""
frm.addFormInput "optional", "Your SSN", "ssn", "text", "ssn length(0,30)", "", "", "Enter your name in the field above."
frm.addFormInput "optional", "Your Phone", "phone", "text", "phone", "", "", "Enter your valid email address in the field above."
frm.addFormInput "optional", "Your Birthday", "birth", "text", "date", "", "", "Enter your message, must be at least 10 and no more than 1000 characters."
frm.addFormSubmission "left","Submit &raquo;","Cancel","",""
frm.endFieldset
writeln(frm.getContents)
logger.debug_dump
%>
</body>
</html>
