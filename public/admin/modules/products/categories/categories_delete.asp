<%
function contentDelete()
	page.setName("Delete "& Pcase(strContent))
	if user.getRole() < USER_ADMINISTRATOR then 
		strError = "You do not have sufficient priviledges to delete "& strContentPL &"."
		exit function
	end if
	dim key : key = request.querystring("delete")
	if len(key)=0 then
		strError = "No "& strContent &" to delete!  Please go back <a href='?view'>to the list</a> and select one."
		exit function
	elseif not isNumeric(key) then
		strError = "Invalid  "& strContent &".  Please go back <a href='?view'>to the list</a> and select one."
		exit function
	end if
	key = cint(key)
	debugInfo("admin."& strContentPL &".delete: form was submitted, storing to the session.")
	strError = "An error was encountered during "& strContent &" deletion"
	debug("admin."& strContentPL &".delete: delete database content for "& strContent &" id '"& key & "'")
	dim SQL_DELETE : SQL_DELETE =  "DELETE * from "& strTableName &" WHERE "& strKey &"="& key
	db.execute(SQL_DELETE)
	strStatus = "The "& strContent &" has been deleted. <br/>" & vbCrLf & _
			"Would you like to <ul>"& vbCrLf & _
			"<li><a href='?view'>View list of lll "& Pcase(strContent) &"</a></li>" & vbCrLf & _
			"<li><a href='?create'>Create a new "& Pcase(strContent) &"</a></li></ul>"
	strError = ""
	contentDelete = ""
end function
%>