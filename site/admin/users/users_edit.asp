<%		
function contentEdit()
	myForm.setAction("?update")
	if (myForm.wasSubmitted()) then
		contentEdit = buildFormContents(myForm.getValue(strKey))
		strHeader = ("Edit "&Pcase(strContent))
	elseif Request.QueryString("edit") <> "" then 
		contentEdit = buildFormContents(Request.QueryString("edit"))
	else
		strError = "No "&strContent&" was selected for editing. <br/>Would you like to "& vbcrlf & _
			"<a href='?view'>select a "&strContent&"</a> to edit " & vbcrlf & _
			"or <a href='?create'>create a new one</a>?</p>"
		contentEdit = strError
		debugError(strError)
	end if
end function
%>
