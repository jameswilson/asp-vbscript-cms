<%
	dim logo : set logo = new SiteFile
	dim title : title = globals("TITLE")
	dim slogan : slogan = globals("SLOGAN")
	dim logoTitle : logoTitle = title&": "&slogan
	logo.Path = globals("LOGO")
	if logo.fileExists then 
		writeln(indent(2)& a(globals("SITEURL"), mediaFile(logo.Url,logoTitle,"logo","","") ,logoTitle, "logo"))
	end if
	'writeln(indent(2)& h1(title))
	'writeln(indent(2)& h2(slogan))
	if user.isAdministrator() then
		writeln(indent(2)& "<div id=""admin-links""><div><div class=""wrapper"">")
		'writeln(indent(3)& h2("Site Admin Links"))
		writeln(indent(3)& "<ul>")
		if page.isAdminPage() then
			writeln(indent(4)& CreateNavLink(globals("ADMIN_DIR")&"/users/users.asp?edit="&user.getId(), user.GetFullName(),"Edit your account.", null)&"</li>")		
			writeln(indent(4)& CreateNavLink("","View Public Site","Leave the back-end and go to the public front-end website", null)&"</li>")
			writeln(indent(4)& CreateNavLink(globals("ADMIN_DIR")&"/logout.asp", "Logout", "End your admin session.","last")&"</li>")
		else
			writeln(indent(4)& "<li>"&user.GetFullName()&" </li>")		
			writeln(indent(4)& CreateNavLink(globals("ADMIN_DIR"),"Site Admin","Log into "&globals("PRODUCT_BRANDING")&": Administration Panel","last")&"</li>")
		end if
		writeln(indent(3)& "</ul>" & vbCrLf & indent(2)& "</div></div></div>")
	end if 

%>