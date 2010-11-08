<!--#include file="../bootstrap.asp"--><% 
'dim result : set result = new FastString


'	result.add "<p>"&globals("SITE_OFFLINE_MESSAGE")&"</p>"
'	result.add "<p>"&globals("ERROR_FEEDBACK")&"</p>"
	
'session.contents(CUSTOM_MESSAGE) = session(CUSTOM_MESSAGE) & result.value

%><!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
	"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html>
<head>
<title>Site Unavailable</title>
</head>
<body>
<p><%=globals("SITE_OFFLINE_MESSAGE")%></p>
<p><%=globals("ERROR_FEEDBACK")%></p>
</body>
</html>
