<%
function contentEdit()
	myForm.setAction("?update")
	myForm.isForNewContent = false
	dim id : id =  Request.QueryString("edit")
	if len(id)> 0 then 
		strHeader.add "Edit" & connector
		pageContent.add buildFormContents(id,null)
	else
		pageContent.add ErrorMessage("No module was selected for editing.<br/>Would you like to "& vbcrlf & _
			"<a href='?view'>select a module</a> to edit " & vbcrlf & _
			"or <a href='?create'>create a new one</a>?")
	end if
end function
%>
