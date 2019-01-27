<%
function contentCreate()
	page.setName("New " & pcase(strContent) & "")
	myForm.isForNewContent = true
	myForm.Action = "?add"
	contentCreate = buildFormContents(null)
end function
%>
