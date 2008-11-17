<%
function contentEdit()
	myForm.Action = "?update"
	
	
	if Request.QueryString("edit") <> "" then 
		contentEdit = buildFormContents(Request.QueryString("edit"))
	elseif (myForm.getValue(strKey)<> "") then
		contentEdit = buildFormContents(myForm.getValue(strKey))
		page.setName("Edit Page")
	else
		strError = ErrorMessage("No "&strContent&" was selected for editing. <br/>Would you like to "& vbcrlf & _
			"<a href='?view'>select a "&strContent&" to edit</a> " & vbcrlf & _
			"or <a href='?create'>create a new one</a>?")
		contentEdit = strError
		debugError(strError)
	end if
end function

%>
