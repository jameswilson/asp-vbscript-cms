<%
function contentCreate()
	page.setName("New " & Pcase(strContent) & "")
	myForm.isForNewContent = true
	myForm.Action = "?add"
	contentCreate = buildFormContents(null)
end function
%>
