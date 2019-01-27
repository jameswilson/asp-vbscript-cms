<%@ LANGUAGE="VBSCRIPT" CODEPAGE="1252" %>
<!--#include file = "../../core/include/bootstrap.asp"-->
<%
		user.logout()
		Session("CustomMessage") = globals("LOGOUT_SUCCESS")
		Response.Redirect(globals("ADMINURL"))
%>
