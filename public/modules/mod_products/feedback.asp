<%@ Language=VBScript %>
<%Option Explicit%>
<!--#include file="../../../core/include/bootstrap.asp"-->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
	"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
<meta name="ROBOTS" content="NONE"/>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Product Feedback</title>
<link rel="stylesheet" href="../../styles/main-1col.css" type="text/css"/>
<link rel="stylesheet" href="../mod_form/form.css" type="text/css"/>
</head>

<body style="width:400px;">
<div class="popupClose"><a href="" onclick="javascript:window.close();" title="Close Window">[x]</a> Close Window</div>
<h1>Product Feedback</h1>
<h4><%=request.QueryString("subject")%></h4>
<p><img class="floatleft" src="<%=globals("SITEURL")%>/<%=request.QueryString("image")%>" />To better assist you we have created this feedback form for inquiries
 about our products. Please fill in your name, a valid email address, 
 and your question.  Make sure that the product name is mentioned in 
 the message. Then click submit.</p> 

<!--#include file="../../../core/include/forms/feedback.asp"-->
<!--#include file="../../../core/include/utils/google-analytics.asp"-->
</body>
</html>
