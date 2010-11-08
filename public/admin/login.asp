<%@ Language=VBScript %>
<!--#include file = "../../core/include/bootstrap.asp"-->
<%
  page.setTitle("Login")
	dim uid, pass, remember, target
	'clear session info stored from previous login attempts
	target = session(REQUESTED_PAGE)
	debug("login.asp:  user arrived to this page from "& request.ServerVariables("HTTP_REFERER"))
	'
	' Form Submission:  Login Attempt
	'
	if request.form("action") = "login" then
	
		'
		' 1 - you should only arrive to this page from the admin login page!
		'
		
		if instr(request.ServerVariables("HTTP_REFERER"), globals("ADMINURL")) <> 1 then
			session("CustomMessage") = "Please use the login form to access the ADMIN area."
		else
			'
			' 2 - get user submitted login credentials from form
			'
			uid=request.form("UserID")
			pass=request.form("Password")
			remember=(request.form("RememberMe") <> "")
			'
			' 3 - verify login attempt
			'
			if user.login(uid, pass) = true then
				'store cookies if user requested 'remember me'
				user.rememberMe(remember)
				user.persist(Now()+60)
				if not len(target)>0 then 
					target = globals("ADMINURL") & "/"
				end if
				if isDebugMode() then
					debug("login.asp: user '"& uid &"'Successfully logged in!")
					debugCookies()
					session("CustomMessage") =  SuccessMessage(h3(TXT_NOTE&": "& TXT_DEBUG_MODE) &p(TXT_LOGIN_SUCCESS&" "& TXT_DEBUG_INFO))
					session(REQUESTED_PAGE) = ""
				end if
				if not db.isWritable() then 
					session("CustomMessage") = session("CustomMessage") & WarningMessage(h3(TXT_WARNING) &p(DB_NOT_WRITABLE))
				end if
				if not isDebugMode() then 
					session(REQUESTED_PAGE) = ""
					response.redirect(target)
				end if
			else
				debug("login.asp: failed to login user with id '"& uid &"' and password '"& pass &"'")
				session.timeout
				debug("login.asp: setting session custom message to '" &user.getLastError() &"'")
				session("CustomMessage") = ErrorMessage(user.getLastError())
			end if
		end if
	elseif len(target)>0 then 
		trace("login.asp:  the user requested the page: "& target)
	else
		session.timeout 
	end if
%>


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
	"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<script type="text/javascript"><!--
// <![CDATA[
function placeFocus() {
if (document.forms.length > 0) {
	var field = document.forms[0];
	for (i = 0; i < field.length; i++) {
		var input = field.elements[i]
		if ((input.type == "text") || (input.type == "textarea") ||	(input.type == "password")) {
			if (input.value == "") {
				input.focus();
				break;
			}
		} else if (input.type == "submit") {
			input.focus();
			break;
		}
	}
}
return true;
}  
// ]]>
--></script>
<head>
<title><%=page.getTitle()%></title>
<link rel="stylesheet" href="<%=globals("ADMINURL")%>/styles/admin.css" type="text/css"/>
<link rel="stylesheet" href="<%=globals("ADMINURL")%>/styles/login.css" type="text/css"/>
<link rel="shortcut icon" href="<%=token_replace("{PRODUCT_FAVICON}")%>"/>
</head>
<body onload="placeFocus()">
<div id="page"> 
  <div id="header" class="clearfix"> 
    <!--#include file="./include/header.asp"-->
  </div>
  <div id="content" class="clearfix"> 
    <div id="main" class="clearfix"> 
      <div class="login"> 
        <h1><%=globals("PRODUCT_BRANDING")%>: Site Administrator</h1>
				
				<% if len(session(CUSTOM_MESSAGE))>0 then %>
				<div class="CustomMessage">&nbsp;<%=session("CustomMessage")%>&nbsp; 
					<small class="options">
					<% if user.isloggedIn() then %>
					<a class="button" href="<%=globals("ADMINURL")%>/logout.asp">Logout</a>
          <a class="button" href="<%=globals("ADMINURL")%>">Continue &raquo;</a>
					<% else %>
          <a class="button" href="#" onClick="history.go(-1)">&laquo; Back</a>
					<a class="button" href="<%=globals("ADMINURL")%>">Login &raquo;</a>
					<% end if %></small>
				</div>
				<% else %>
        <p>Access to the <%=globals("SITENAME")%> administration panel is restricted.  You must log in with an account that has site administration rights to edit site content.</p>
        <form class="login" action="login.asp" method="post" id="login">
          <fieldset>
          <legend>Please Login</legend>
          <input name="action" value="login" type="hidden"/>
          <div class="required"> 
            <label for="UserName" title="Please enter your username in the following textbox."> 
            User Name</label>
            <input class="inputText" name="UserID" id="UserID" type="text" value="<%=user.getId()%>"/>
          </div>
          <div class="required"> 
            <label for="Password" title="Please enter your password in the following textbox."> 
            Password</label>
            <input class="inputText" name="Password" id="Password" type="password" value=""/>
          </div>
          <div class="optional"> 
            <label for="RememberMe" class="labelCheckbox" title="Remember my login information on this computer"> 
            <input  name="RememberMe" id="RememberMe" class="inputCheckbox" type="checkbox" value="ON"<% 
if user.exists() then response.write " checked=""checked""" %>/>
            Remember me on this computer.</label>
						<small class="options"><a href="#quick-loans" onclick="window.open('help/cookies.asp','help','scrollbars=no,menubar=no,height=400,width=200,resizable=yes,toolbar=no,location=no,status=no');" title="Find out more about a faster login.">what's this?</a></small>
          </div>
					<div class="submit">
						<div> 
							<input class="button inputSubmit" type="submit" title="submit" value="Enter &raquo;"/>
						</div>
					</div>
          </fieldset>
        </form>
        <% end if %>
      </div>
    </div>
  </div>
  <div id="footer" class="clearfix"> 
    <!--#include file="./include/footer.asp"-->
  </div>
</div>
</body>
</html>
<%
session("CustomMessage") = ""
session.contents.remove("CustomMessage")
if not user.isLoggedIn() and len(target)<1 then Session.Abandon
%>
