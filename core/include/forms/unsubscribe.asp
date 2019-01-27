<%
dim strList : strList = ""
if Session.Contents("SubscriptionList") then strList = trim(Session.Contents("SubscriptionList"))
if Request.QueryString("list") then strList = trim(Request.QueryString("list"))
if Request.Form("list") then strList = trim(Request.Form("list"))

%><p class="warning">Unsubscribe form is not implemented!
	I repeat: <br>
	YOUR NAME WILL NOT BE ADDED OR REMOVED FROM ANY LIST!</p>
<%

if strList <> "" then
	if len(Request.Form("name")) > 0 then

		'TODO: implement unsubscribe from mailing list

		writeln(SuccessMessage("Thank you " & Request.Form("name") & ",  your email (" & Request.Form("email") & ") has been removed from the " & strList & " mailing list."))

	else	%>
	   <p>Please enter your name and email address to be removed to the <%=strList%> mailing list.</p>
			<script type="text/javascript" src="<%= globals("SITEURL") %>/core/assets/scripts/form_validator.js"></script>
			<form action="../../../include/?s=1" method="post" id="feedback" onsubmit="return autocheck(this)" >
				<fieldset>
					<p><input type="hidden" id="list" value="<%= strList %>" /></p>
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
			you are trying to subscribe<%= globals("ERROR_FEEDBACK") %></p>
<% end if %>
