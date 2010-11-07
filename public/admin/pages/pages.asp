<!--#include file = "../../core/include/global.asp"-->
<!--#include file = "../../core/include/secure.asp"-->
<!--#include file = "pages_content.asp"-->
<%
page.setFile(request.ServerVariables("URL"))
page.setTitle("Static Pages")
page.addBreadcrumb "Static Pages",objLinks("ADMINURL")&"/pages"
%>
<!--#include file = "../../core/include/admin.asp"-->