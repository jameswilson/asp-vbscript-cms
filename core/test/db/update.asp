<%@ Language=VBScript %>
<%Option Explicit%>
<!--#include file = "../../core/include/bootstrap.asp"-->
<%
addGlobal "DEBUG","1","1"

function customContent(str)
if str="main" then 
user.login "admin", "password"
customContent =  "DB is " &iif(db.isWritable(),"","not")&" Writable."
end if
end function

%>
<!--#include file = "../../core/include/template.asp"-->