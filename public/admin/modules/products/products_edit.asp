<%		
function contentEdit()
	page.setName("Edit "& Pcase(strContent) &"")
	myForm.Action = "?update"
	if (myForm.getValue(strKey)<> "") then 
		contentEdit = buildFormContents(myForm.getValue(strKey))
	elseif Request.QueryString("edit") <> "" then 
		contentEdit = buildFormContents(Request.QueryString("edit"))
	else
		strError = "<p>No "& strContent &" was selected for editing. <br/>Would you like to:<ul> "& vbCrLf & _
			"<li><a href='?view'>Select a "& strContent &"</a> to edit</li> " & vbCrLf & _
			"<li><a href='?create'>Create a new "& strContent &"</a></li></ul></p>"
		contentEdit = strError
		debugError(strError)
	end if
end function
%>
