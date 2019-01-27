<%
function contentEdit()
	myForm.setAction("?update")
	myForm.isForNewContent = false
	dim id
	if (myForm.wasSubmitted()) then
		id = myForm.getValue(strKey)
	elseif Request.QueryString("edit") <> "" then
		id =  Request.QueryString("edit")
	end if
	if len(id)>0 then
		page.setName("Edit " & PCase(strContent) &"")
		pageContent.add buildFormContents(Request.QueryString("edit"))
	else
		pageContent.add ErrorMessage("<p>No " & strContent & " was selected for editing. <br/>Would you like to</p> <ul>" & vbCrLf & _
			"<li><a href='?view'>select a " & strContent &"</a> to edit </li>" & vbCrLf & _
			"<li>or <a href='?create'>create a new one</a>?</li></ul>")
	end if
end function
%>
