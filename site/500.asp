<%@ Language=VBScript %>
<%Option Explicit%>
<%response.clear%>
<!--#include file="core/include/global.asp"-->
<!--#include file="core/src/classes/class.form.asp"-->


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Server Error</title>
</head>

<body>
<%

writeln( p("The server encountered the following critical error:"))
dim ASPErr : Set ASPErr = Server.GetLastError()
dim myForm : set myForm = new WebForm
writeln( p("Error Description: "&  ASPErr.ASPDescription ))
writeln( p("Error Code: "& AspErr.ASPCode ))
writeln( p("Error Number: "&AspErr.Number))
writeln( p("Error Source: "&AspErr.Source))
writeln( p("File: "&Server.MapPath(Request.ServerVariables("URL"))))
writeln( p("Category: "&AspErr.Category))
writeln( p("File: "&AspErr.File))
writeln( p("Line: "&AspErr.Line))
writeln( p("Column: "&AspErr.Line))
LogErrorToDatabase()


' here is the data we will log to a database:
'   1. Session ID
'   2. Request Method
'   3. Server Port
'   4. Was it HTTP or HTTPs
'   5. The server's address
'   6. The user's address
'   7. The user's browser type
'   8. The URL that caused the error
'   9. A reference id the customer can use when talking to support
'  10. All of the posted form data
'  11. All of the HTTP headers
'  12. ASPCode
'  13. Number
'  14. Source
'  15. Category
'  16. File
'  17. Line
'  18. Column
'  19. Description
'  20. ASPDescription
'  21. The date and time the error occurred. 
sub LogErrorToDatabase()
	dim con
	dim rs
	dim strErr
	
	set ASPErr = Server.GetLastError()
	set con = Server.CreateObject("ADODB.Connection")
	set rs = Server.CreateObject("ADODB.Recordset")
	
	con.open objLinks.item("DB_MAIN")
	Set rs.ActiveConnection = con
	on error resume next
	rs.Open "Select * From tblErrors",,adOpenStatic,adLockOptimistic '3, 3
	if err.number <> 0 	then
		strErr = "VBScript Runtime Error [" & Err.number & "] (Ox"& Hex(Err.number) & "): " & Err.description
		debug(strErr)
		if err.number = -2147217865 then
			dim sql, ts 'SQL string , text stream
			if fileExists("/core/src/install/create_tblErrors.ddl") then
				response.write("tblErrors doesnt exist!  Creating table...")
				set ts = fs.OpenTextFile("/core/src/install/create_tblErrors.ddl",1,0) 'forReading,TristateFalse
				sql = ts.ReadAll
				con.execute(sql)
			else
				response.write("tblErrors doesnt exist!  Cannot find creation scripts so writing debug to log file...")
								
				'TODO: write error log file here
				set ts = fs.openTextFile("error.log")
				
				
			end if
		else
			response.write(strErr)
		end if	
	elseif rs.state = 0 then
		response.write("Error recordset is empty...")
		
		'TODO: put the create table code here...
	else
	
		rs.AddNew
		
		with rs
			.Fields("SessionID") = Session.SessionID
			.Fields("RequestMethod").Value = Request.ServerVariables("REQUEST_METHOD")
			.Fields("ServerPort").Value = Request.ServerVariables("SERVER_PORT")
			.Fields("HTTPS").Value = Request.ServerVariables("HTTPS")
			.Fields("LocalAddr").Value = Request.ServerVariables("LOCAL_ADDR")
			.Fields("HostAddress").Value = Request.ServerVariables("REMOTE_ADDR")
			.Fields("UserAgent").Value = Request.ServerVariables("HTTP_USER_AGENT")
			.Fields("URL").Value = Request.ServerVariables("URL")
			.Fields("CustomerRefID").Value = mstrCustRefID
			.Fields("FormData").Value = myForm.Form
			.Fields("AllHTTP").Value = Replace(Request.ServerVariables("ALL_HTTP"),vbLf,vbCrLf)
			.Fields("ErrASPCode").Value = AspErr.ASPCode
			.Fields("ErrNumber").Value = AspErr.Number
			.Fields("ErrSource").Value = AspErr.Source
			.Fields("ErrCategory").Value = AspErr.Category
			.Fields("ErrFile").Value = AspErr.File
			.Fields("ErrLine").Value = AspErr.Line
			.Fields("ErrColumn").Value = AspErr.Column
			.Fields("ErrDescription").Value = AspErr.Description
			.Fields("ErrAspDescription").Value = AspErr.AspDescription
			.Fields("InsertDate").Value = Now()
		end with
		dim fld
		for each fld in rs.Fields
			response.write fld.Name &": " & fld.Value
		next
		rs.Update
	end if		
	rs.Close
	con.Close
	set rs = nothing
	set con = nothing
end sub
	
	
%>
</body>
</html>
