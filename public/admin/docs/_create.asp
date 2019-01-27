<%
function contentCreate()
	strHeader.add PCase("upload a "& strContent)
	const instructions = "Browse your computer for the file you wish to upload..."
	myForm.isForNewContent = true
	myForm.Action = "?add"
	myForm.Method = "POST"
	pageContent.add p(instructions)
	pageContent.add buildFormContents(Request("create"))
end function
%>
