<%@ Language=VBScript %>
<%Option Explicit%>
<!--#include file="../core/include/global.asp"-->
<!--#include file="../core/include/secure.asp"-->
<!--#include file="../core/src/functions/functions.system.asp"-->
<%
page.setFile(request.ServerVariables("URL"))
page.setTitle("Dashboard")
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
	"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html>
<head>
<title><%=page.getTitle()%></title>
<meta name="ROBOTS" content="NOINDEX, NOFOLLOW">
<link rel="stylesheet" href="<%=objLinks.item("ADMINURL")%>/styles/admin.css" type="text/css"/>
<link rel="shortcut icon" href="<%=GlobalVarFill("{PROVIDER_FAVICON}")%>"/>
<script type="text/javascript">
	var djConfig = {isDebug: true, debugAtAllCosts: false};
</script>
<script type="text/javascript" src="../core/assets/scripts/dojo/dojo.js"></script>
<script type="text/javascript">
	dojo.require("dojo.widget.TitlePane");
	dojo.hostenv.writeIncludes();
</script>
</head>
<body>
<div id="page"> 
  <div id="header" class="clearfix"> 
    <!--#include file="include/header.asp"-->
  </div>
  <div id="content" class="clearfix"> 
    <div id="main" class="clearfix"> 
			<div class="box threequarterswidth floatleft"> 
				<%=Session.Contents("CustomMessage")%>
				<%Session.contents("CustomMessage") = ""%>
        <h1><%=objLinks.item("PRODUCT_BRANDING")%> Dashboard</h1>
        <p>Here you can edit your site, <%=objLinks.item("TITLE")%>, via the online 
				 maintenence system provided by <%=objLinks.item("PROVIDER_NAME")%>. Use the 
				 navigation bar above to create and modify your site's content.</p>
				<p>If you need asistance, dont hesitate to contact <%=a("mailto:"&objLinks.item("PROVIDER_EMAIL"),objLinks.item("PROVIDER_SHORTNAME") &" support", "contact "&objLinks.item("PROVIDER_NAME") & " support",null)%>.</p>
      	<h2>Frequently Asked Questions:</h2>
				<dl><dt>What does CMS mean?</dt><dd><p>CMS is the acronym for <em>Content Management System</em>, and is 
				a term coined within the web design world to describe an online system for 
				creating and maintaining content in a dynamic way.  It usually, but not always
				entails providing a non-technical way to create web content without any prior 
				knowledge of programming or web technology.  This way any lay person with an 
				interest, product, service, or desire to publish content to the world can do
				so without the interference and headaches of typical web development. Under 
				the hood of most Content Management Systems lies a well planned and thought
				out web application that uses various server technologies to allow real-time
				editing and storing of content in a database or xml or other standard format.</p></dd>
				<dt>What is the difference between dynamic and static web page?</dt><dd><p>A dynamic
				webpage employes various server technologies to present &ldquo;living&rdquo; content in a 
				meaningful and coherent way to the web surfer.  Using dynamic server technology
				allows for the creation of site layout template(s) that keep the presentation or 
				&ldquo;look and feel&rdquo; of a website to remain the same, while
				the content on the pages changes.	Such templates provide the ability to change 
				and customize a site's functionality or presentation at a moments notice, while 
				minimizing duplicate changes across various page. Ultimately, this leads to less
				time and thinking to update site content, which in turn allows for good search
				engine ranking, because search engines love fresh content.</p><p>A static web page
				on the other hand is a simple text file that contains HTML codes that mark-up content
				for display in a web browser. If all of the webpages in a site are static, the bigger
				the site grows the more un-manageable it becomes because a change in the site layout
				implies a change in the mark-up of every single file in your site. Thus, it is 
				typically more difficult to create or change content and presentation of static pages. 
				</p></dd></dl> 
			</div>
      <div class="notes floatright" dojoType="TitlePane" label="Administrator Tip" labelNodeClass="notes-label notes floatright" containerNodeClass="notes-content notes floatright"> 
				<h4>Administrator Tip:</h4>
				<p>Instead of <i>deleting</i> content stored in the database, just un-check 
					the <strong>Active</strong> checkbox when you go to edit an item. 
					This will remove it from display on the public site.</p>
			</div>	
			<div class="notes floatright" dojoType="TitlePane" label="Server Info" labelNodeClass="notes-label notes floatright" containerNodeClass="notes-content notes floatright"> 
				<h4>Admin Info:</h4>
        <dl>
        	<dt><%=PRODUCT_BRANDING%> Version</dt><dd><%=PRODUCT_VERSION%></dd>
          <dt>Server Name:</dt><dd> '<%=getMachineName()%>' (<%=Request.ServerVariables("SERVER_NAME")%>)</dd> 
          <dt>Server Technology:</dt><dd> <%=Request.ServerVariables("SERVER_SOFTWARE")%></dd>
          <dt>Scripting:</dt><dd> <%=ScriptEngine%>  <%=ScriptEngineMajorVersion%>.<%=ScriptEngineMinorVersion%></dd>
          <dt>Server IP:</dt><dd> <%=Request.ServerVariables("LOCAL_ADDR")%></dd>
          <dt>Your IP:</dt><dd> <%=Request.ServerVariables("REMOTE_ADDR")%></dd>
          <dt>CurrentDate:</dt><dd> <%=Date()%></dd>
          <dt>CurrentTime:</dt><dd> <%=Time()%></dd>
       	</dl>
			</div>
    </div>
    <div id="nav"> 
      <!--#include file="include/menubar.asp"-->
      <hr />
    </div>
  </div>
  <!-- end content -->
  <div id="footer" class="clearfix"> 
    <!--#include file="include/footer.asp"-->
  </div>
  <!-- end footer -->
</div>
</body>
</html>
