<%@ Language=VBScript %>
<!--#include file = "../core/include/global.asp"-->
<%
'redirect to admin home if logged in
if len(session(CUSTOM_MESSAGE)) > 0 then 
	server.transfer("login.asp")
elseif user.isLoggedIn() then
	if len(session(REQUESTED_PAGE))>0 then 
		response.redirect(session(REQUESTED_PAGE))
	else
		server.transfer("admin_home.asp")
	end if
else
	server.transfer("login.asp")
end if
%>