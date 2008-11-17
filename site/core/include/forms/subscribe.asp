<%
dim strList : strList = ""
if session.contents("SubscriptionList") then strList = trim(session.contents("SubscriptionList"))
if request.queryString("list") then strList = trim(request.queryString("list"))
if request.form("list") then strList = trim(request.form("list"))

%><p class="warning">Subscription form is not implemented! 
	I repeat: <br>
	YOUR NAME WILL NOT BE ADDED OR REMOVED FROM ANY LIST!</p>
<%

if strList <> "" then 
	if len(request.form("name")) > 0 then 
	
	'TODO:  implement subscribe to mailing list
	
	writeln(SuccessMessage("Thank you "&request.form("name")&",  your email ("&request.form("email")&") has been added to the "&strList&" mailing list."))
	else	%>
	   <p>Please enter your name and email address to be added to the <%=strList%> mailing list.</p>
			<script type="text/javascript" src="<%=objLinks.item("SITEURL")%>/core/assets/scripts/form_validator.js"></script>
			<form action="../../../include/?s=1" method="post" id="feedback" onsubmit="return autocheck(this)" >
				<fieldset>
					<p><input type="hidden" id="list" value="<%=strList%>" /></p>
					<div class="required"> 
						<label for="name">Your Name</label>
						<input class="required inputText" name="name" id="name" type="text" value="" onblur="requireValue(this)"/>
					</div>
					<div class="required"> 
						<label for="name">Your Email</label>
						<input class="requred email inputText" name="email" id="email"  type="text" value="" onblur="requireValue(this)*checkEmail(this)"/>
					</div>
					<div class="submit">
						<div><input class="inputSubmit" type="submit" title="submit" value="&raquo; SUBMIT"/></div>
					</div>
				</fieldset>
			</form>
	<% end if
else %>
	   <p class="error">The server cannot determine the list to which 
			you are trying to subscribe<%=objLinks.item("ERROR_FEEDBACK")%></p>
<% end if %>
