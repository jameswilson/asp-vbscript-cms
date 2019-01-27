<%@ Language=VBScript %>
<% Option Explicit %>
<!--#include file="core/include/bootstrap.asp"-->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Ordered Pages</title>
</head>

<body>

<%
function getChildren(rsPages,arrPages, byval intParentPage)
	set objChildren = Server.CreateObject("Scripting.Dictionary")
	dim indexOrig : indexOrig = rsPages.Index
	rsPages.MoveFirst
	do until rsPages.EOF
	'pass through the child pages first
		strLink =  CreateNavLink(rsPages("PageFileName"), rsPages("PageName"), rsPages("PageLinkHoverText"), null)
		if rsPages("ParentPage") = intParentPage then
			if rsPages("ParentPage") <> 0 then writeln("<ul>")
			writeln("<li>" & rsPages("PageName"))
			getChildren rsPages, arrPages, rsPage("PageID")
			writeln("</li>")
			if rsPages("ParentPage") <> 0 then writeln("</ul>")
		end if
		trapError
		rsPages.MoveNext
	loop
	rsPages.seek indexOrig
end function

%>
</body>
</html>
