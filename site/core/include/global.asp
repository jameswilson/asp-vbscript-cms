<%
'**
'* @file Global bootstrap.
'*

'**
'* Include standard classes and functions
'*
%><!--#include file="../src/functions/functions.debug.asp"--><%
%><!--#include file="../src/functions/functions.error.asp"--><%
%><!--#include file="../src/functions/functions.links.asp"--><%
%><!--#include file="../src/functions/functions.lists.asp"--><%
%><!--#include file="../src/functions/functions.crypt.asp"--><%
%><!--#include file="../src/functions/functions.date.asp"--><%
%><!--#include file="../src/functions/functions.code.asp"--><%
%><!--#include file="../src/functions/functions.html.asp"--><%
%><!--#include file="../src/functions/functions.user.agent.asp"--><%
%><!--#include file="../src/functions/functions.utf8.asp"--><%
%><!--#include file="../src/classes/class.file.asp"--><%
%><!--#include file="../src/classes/class.strings.asp"--><%
%><!--#include file="../src/classes/class.db.asp"--><%
%><!--#include file="../src/classes/class.settings.asp"--><%
%><!--#include file="../src/classes/class.modules.asp"--><%
%><!--#include file="../src/classes/class.page.asp"--><%
%><!--#include file="../src/classes/class.user.asp"--><%

'**
'* Include site settings.
'* 
%><!--#include file="../configuration.asp"--><%

'**
'* Initialize Global objects available to all pages
'*
initializeGlobals()

'**
'* Check to see that the site is not disabled.
'*
if objLinks.item("SITE_DISABLED") = "YES" and lcase(page.getName()) <> "unavailable" then
	if page.isAdminPage() = true then 
		writeln(objLinks.item("ADMIN_UNAVAILABLE"))
		'server.transfer(objLinks.item("ADMIN_UNAVAILABLE"))
	else
		writeln(objLinks.item("UNAVAILABLE"))
		'server.transfer(objLinks.item("UNAVAILABLE"))
	end if
	response.end
end if
%>