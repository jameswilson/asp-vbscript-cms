<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
	"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html>
<head>
<title><%=page.getTitle()%></title>
<link rel="stylesheet" href="<%=objLinks.item("ADMINURL")%>/styles/admin.css" type="text/css"/>
<link rel="shortcut icon" href="<%=globals.getItem("PROVIDER_FAVICON")%>"/>
<!--#include file ="../../admin/include/preloader.js.inc"-->
</head>
<body onLoad="clearPreloadPage()"> 
<div id="page"> 
  <div id="header" class="clearfix"> 
    <!--#include file="../../admin/include/header.asp"-->
  </div>
  <div id="content" class="clearfix"> 
    <div id="main" class="clearfix">
    <!--#include file="../../admin/include/preloader.html.inc"--> 
      <div class="box"> 
        <%=customContent()%>
      </div>
    </div>
    <div id="nav"> 
      <!--#include file="../../admin/include/menubar.asp"-->
      <hr />
    </div>
  </div>
  <!-- end content -->
  <div id="footer" class="clearfix"> 
    <!--#include file="../../admin/include/footer.asp"-->
  </div>
  <!-- end footer -->
</div>
</body>
</html>

