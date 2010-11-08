<%
'admin header
	trace("admin/include/header.asp: processing header... ")
	writeln( indent(2) & h1(globals("TITLE")) )
	writeln( indent(1) & "<div class=""provider"">")
	
	dim headerImg : headerImg = globals("PRODUCT_LOGO")
	if fileExists(headerImg) = true then 
		trace("admin/include/header.asp: adding logo '" & headerImg &"'")
		headerImg = img(headerImg, globals("DEVELOPER_NAME"), globals("DEVELOPER_NAME") &": "& globals("DEVELOPER_SLOGAN"),"provider")
		writeln(indent(2) & a(globals("DEVELOPER_URL"), headerImg,globals("DEVELOPER_NAME"), "logo"))
	end if
	writeln(indent(2) & h1(a(globals("DEVELOPER_URL"), globals("PRODUCT_BRANDING"),globals("DEVELOPER_NAME"), "logo") &": Site Administrator"))
	writeln(indent(1) & "</div>")
	if user.activeAdminSession() = true then
		writeln(indent(2) & "<div class=""links"">")
		writeln(indent(3) & h2("Administrator-Only Links"))
		writeln(indent(3) & "<ul>")
		writeln(indent(4) & CreateNavLink(globals("ADMIN_DIR") &"/users/users.asp",user.getFullName(),"Edit your account information", null) &"</li>")
		writeln(indent(4) & CreateNavLink("","View Public Site","Leave the back-end and go to the public front-end website", null) &"</li>")
		writeln(indent(4) & CreateNavLink(globals("ADMIN_DIR") &"/logout.asp", "Logout", "End your admin session.","last") &"</li>")
		writeln(indent(3) & "</ul>" & vbCrLf & indent(2) & "</div>")
	end if 
%>