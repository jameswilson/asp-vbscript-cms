<%@ Language=VBScript %>
<%Option Explicit%>
<!--#include file = "../core/include/global.asp"-->
<% 
session(CUSTOM_MESSAGE) = getContent()

function getContent()
	getContent = ""
	if db.exists() then 
		page.setFile(request.ServerVariables("URL"))
		if page.exists() and page.hasContent() then exit function
	end if
	dim sf : set sf = new SiteFile
	sf.path = "/core/include/templates/privacy.html"
	getContent = globalVarFill(sf.readAll())
end function 
%>
<!--#include file = "../core/include/template.asp"-->