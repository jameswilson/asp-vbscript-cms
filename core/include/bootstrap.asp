<%
'**
'* @file 
'*   Application bootstrap file.
'*
'* This file is responsible for including all the required classes and 
'* functions and initializing the application's global variables. It is also
'* responsible for blocking requests to pages if the site is disabled.
'*

'**
'* Include standard classes and functions.
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
'* Initialize Global constants and objects.
'*
initializeGlobals()

'**
'* Prevent content from being displayed if site is offline.
'*
if globals("SITE_OFFLINE") = "YES" and lcase(page.getName()) <> "unavailable" then
	if page.isAdminPage() = true then 
		'writeln(globals("ADMIN_UNAVAILABLE_URL"))
		server.transfer(globals("ADMIN_UNAVAILABLE_URL"))
	else
		'writeln(globals("UNAVAILABLE_URL"))
		server.transfer(globals("UNAVAILABLE_URL"))
	end if
	response.end
end if
%>