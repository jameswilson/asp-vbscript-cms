<%@ Language=VBScript %>
<!--#include file = "../../core/include/bootstrap.asp"-->
<%
'redirect to admin home if logged in
if len(session(CUSTOM_MESSAGE)) > 0 then
	Server.Transfer("login.asp")
elseif user.isLoggedIn() then
	if len(session(REQUESTED_PAGE))>0 then
		Response.Redirect(session(REQUESTED_PAGE))
	else
		Server.Transfer("admin_home.asp")
	end if
else
	Server.Transfer("login.asp")
end if
%>
