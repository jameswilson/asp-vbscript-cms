<%
function contentDelete()
	page.setName("Delete " & pcase(strContent) & "")
	dim id : id = Request.QueryString("delete")
	if len(id)=0 then
		strError = "No " & strContent & " to delete!  Please go back <a href='?view'>to the list</a> and select one."
		exit function
	elseif not isNumeric(id) then
		strError = "Invalid " & strContent & ".  Please go back <a href='?view'>to the list</a> and select one."
		exit function
	end if
	id = cint(id)
	debugInfo("admin." & strContent & ".delete: form was submitted, storing to the session.")
	strError = "An error was encountered during " & strContent & " deletion"
	debug("admin." & strContent & ".delete: delete database content for " & strContent & " id '" & id & "'")
	dim SQL_DELETE : SQL_DELETE = "DELETE * from " & strTableName & " " & vbCrLf & _
		" WHERE " & strTableName & ".ID=" & id
	db.execute(SQL_DELETE)
	strSuccess = "The " & strContent & " has been deleted. <br/>" & vbCrLf & _
			"Would you like to <ul>" & vbCrLf & _
			"<li><a href='?view'>View admin list of " & strContentPL & "</a></li>" & vbCrLf & _
			"<li><a href='?create'>Create a new " & strContent & "</a></li></ul>"
	strError = ""
	contentDelete = ""
end function
%>
