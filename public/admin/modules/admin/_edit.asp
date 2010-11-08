<%
function contentEdit()
	myForm.setAction("?update")
	myForm.isForNewContent = false
	dim id : id =  Request.QueryString("edit")
	if len(id)> 0 then 
		strHeader.add "Edit" & connector
		pageContent.add buildFormContents(id)
	else
		pageContent.add ErrorMessage("No "& strContent &" was selected for editing.<br/>Would you like to "& vbCrLf & _
			"<a href='?view'>browse for a "& strContent &"</a> to edit " & vbCrLf & _
			"or <a href='?create'>upload a new one</a>?")
	end if
end function
%>
