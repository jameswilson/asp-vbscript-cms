<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
	"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
<title><%=page.getTitle()%></title>
<link rel="stylesheet" href="<%=objLinks.item("ADMINURL")%>/styles/admin.css" type="text/css"/>
</head>
<body>
<div id="page"> 
  <div id="header" class="clearfix"> 
    <!--#include file="../include/header.asp"-->
    <hr/>
  </div>
  <!-- end header -->
  <div id="content" class="clearfix"> 
    <div id="main"  class="clearfix"> 
      <div class="first"><div><div class="wrapper">
			 			 
			 <%=getContent()%>
			 
			 </div></div></div> 
    </div>
    <!--end main-->
    <div id="local"> 
      <div class="box"><%=page.getLocalLinks()%></div>
      <hr />
    </div>
    <div id="nav"> 
      <!--#include file="../include/menubar.asp"-->
      <hr />
    </div>
    <div id="sub"> 
      <hr/>
    </div>
  </div>
  <!-- end content -->
  <div id="footer" class="clearfix"> 
    <!--#include file="../include/footer.asp"-->
  </div>
  <!-- end footer -->
</div>
<!-- end page -->
</body>
</html>