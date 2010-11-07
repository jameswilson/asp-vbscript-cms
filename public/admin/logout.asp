<%@LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<!--#include file = "../core/include/global.asp"-->
<%
		user.logout()
		Session("CustomMessage") = objLinks.item("LOGOUT_SUCCESS")
		Response.Redirect(objLinks.item("ADMINURL"))
%>
