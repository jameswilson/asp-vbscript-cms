<%@ Language=VBScript %>
<!--#include file = "../../core/include/bootstrap.asp"-->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
	"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html>
<head>
<title><%=page.getTitle()%></title>
<link rel="stylesheet" href="<%=globals("ADMINURL")%>/styles/admin.css" type="text/css"/>
<link rel="shortcut icon" href="<%=token_replace("{PRODUCT_FAVICON}")%>"/>
</head>
<body>
<div id="page">
  <div id="header" class="clearfix">
    <!--#include file="./include/header.asp"-->
  </div>
  <div id="content" class="clearfix">
    <div id="main" class="clearfix">
      <div class="login">
        <h1><%=globals("SHORTNAME")%> Online Maintenance System</h1>
        <h2><%=globals("ADMIN_SITE_OFFLINE_MESSAGE")%></h2>
        <p>&nbsp;<%=session("CustomMessage")%>&nbsp;</p>
      </div>
		</div>
	</div>
</div>
</body>
</html>
