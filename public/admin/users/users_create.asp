<%	
function contentCreate()
	if user.getRole() < USER_ADMINISTRATOR then 
		contentCreate = ErrorMessage("You do not have sufficient priviledges to create new "& lcase(strContentPL) &". <small class=""more"">"& globals("ERROR_FEEDBACK") &"</small>")
		exit function
	end if
	strHeader = ("New "& Pcase(strContent))
	myForm.isForNewContent = true
	myForm.Action = "?add"
	contentCreate = buildFormContents(null)
end function
%>
