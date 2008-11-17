<%	
function contentCreate()
	if user.getRole() < USER_ADMINISTRATOR then
		contentCreate = ""
		strError =  "You do not have sufficient priviledges to create "&strContentPL&". <small class=""more"">"&objLinks("ERROR_FEEDBACK")&"</small>"
		exit function
	end if
	page.setName "New "&PCase(strContent)&""
	myForm.isForNewContent = true
	myForm.Action = "?add"
	pageContent.add buildFormContents(null)
end function
%>
