<%	
function contentCreate()
	page.setName("New "&Pcase(strContent))
	myForm.isForNewContent = true
	myForm.Action = "?add"
	myForm.PrimaryKey = null
	myForm.PrimaryKeyVal = null 
	contentCreate = buildFormContents(null)
end function
%>
