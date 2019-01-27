<%@ Language=VBScript %>
<% on error resume next %>
<!--#include file="../../core/src/functions/functions.html.asp"-->
<!--#include file="../../core/src/classes/class.strings.asp"-->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
 "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Convert String to XHTML</title>
</head>

<body>
<%
dim str : str = "<HTML XMLNS=""http://www.w3.org/1999/xhtml""><HEAD><LINK REL=""stylesheet"" HREf=""http://www.domain.com/style.css""/></HEAD><BODY><!-- This is HTML Comment --><DIV CLASS=""my-Class""><H1 STYLE='font-size:2em;'>Header 1</H1><P style    =		""text-align:justify;""  >Paragraph Text</P><OPTION DISABLED/></DIV></BODY>"
%>

Input is:
<blockquote><%= Server.HtmlEncode(str) %></blockquote>
Output is:
<blockquote><%= Server.HtmlEncode(toXHTML(str)) %></blockquote>
</body>
</html>
