<!--#include file = "../../../core/include/bootstrap.asp"-->
<!--#include file = "../../../core/include/secure.asp"-->
<!--#include file = "pages_content.asp"-->
<%
page.setFile(request.ServerVariables("URL"))
page.setTitle("Static Pages")
page.addBreadcrumb "Static Pages", globals("ADMINURL") & "/pages"
%>
<!--#include file = "../../../core/include/admin.asp"-->