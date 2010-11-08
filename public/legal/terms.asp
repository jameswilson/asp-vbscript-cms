<%@ Language=VBScript %>
<%Option Explicit%>
<!--#include file = "../core/include/bootstrap.asp"-->
<% 
session(CUSTOM_MESSAGE) = getContent()

function getContent()
	getContent = ""
	if db.exists() then 
		page.setFile(request.ServerVariables("URL"))
		if page.exists() and page.hasContent() then exit function
	end if
	dim sf : set sf = new SiteFile
	sf.path = "/core/include/templates/terms.html"
	getContent = token_replace(sf.readAll())
end function
%>
<!--#include file = "../core/include/template.asp"-->