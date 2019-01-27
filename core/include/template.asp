<%
'**
'*  This is the site-wide public-facing page template.
'*
'*  It is part of CORE because of our design model that
'*  suggests that all sites should use the the same HTML
'*  structure and adjust presentation through our CSS
'*  framework. The CSS framework allows for various layout
'*  posibilities, and each page can be assigned a different
'*  stylesheet layout if so desired.
'*
trace("Applying HTML template 'template.asp'...")

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
	"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
<% ExecTimer "page.display(""meta"")" %>
</head>
<body>
<ul class="a11y">
<li><a href="#nav" title="Skip to navigation" accesskey="n">Skip to navigation</a></li>
<li><a href="#main" title="Skip to content" accesskey="s">Skip to content</a></li>
</ul>
<div id="page">
 <div id="header" class="clearfix">
  <% ExecTimer "page.display(""header"")" %>
  <hr class="a11y"/>
 </div>
 <div id="content" class="clearfix">
  <div id="nav">
   <% ExecTimer "page.display(""nav"")" %>
   <hr class="a11y"/>
  </div>
  <div id="main" class="clearfix">
   <% ExecTimer "page.display(""main"")" %>
   <hr class="a11y"/>
  </div>
  <div id="sub">
   <% ExecTimer "page.display(""sub"")" %>
   <hr class="a11y"/>
  </div>
  <div id="local">
   <% ExecTimer "page.display(""local"")" %>
   <hr class="a11y"/>
  </div>
 </div>
 <div id="footer" class="clearfix">
  <% ExecTimer "page.display(""footer"")" %>
  <% logger.debug_dump %>
 </div>
</div>
<div id="extra1"><% ExecTimer "page.display(""extra1"")" %></div>
<div id="extra2"><% ExecTimer "page.display(""extra2"")" %></div>
<div id="extra3"><% ExecTimer "page.display(""extra3"")" %></div>
<% page.display("analytics") %>
</body>
</html>
<% trace("..end of HTML template") %>
<% Session.Contents("CustomMessage") = "" %>

