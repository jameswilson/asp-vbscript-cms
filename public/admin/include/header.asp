<%
'admin header
	trace("admin/include/header.asp: processing header... ")
	writeln( indent(2)& h1(objLinks.item("TITLE")) )
	writeln( indent(1)& "<div class=""provider"">")
	
	dim headerImg : headerImg = objLinks.item("PROVIDER_LOGO")
	if fileExists(headerImg) = true then 
		trace("admin/include/header.asp: adding logo '" & headerImg &"'")
		headerImg = img(headerImg, objLinks.item("PROVIDER_NAME"), objLinks.item("PROVIDER_NAME")&": "&objLinks.item("PROVIDER_SLOGAN"),"provider")
		writeln(indent(2)& a(objLinks.item("PROVIDER_URL"), headerImg,objLinks.item("PROVIDER_NAME"), "logo"))
	end if
	writeln(indent(2)& h1(a(objLinks.item("PROVIDER_URL"), objLinks.item("PRODUCT_BRANDING"),objLinks.item("PROVIDER_NAME"), "logo")&": Site Administrator"))
	writeln(indent(1)& "</div>")
	if user.activeAdminSession() = true then
		writeln(indent(2)& "<div class=""links"">")
		writeln(indent(3)& h2("Administrator-Only Links"))
		writeln(indent(3)& "<ul>")
		writeln(indent(4)& CreateNavLink(objLinks.item("ADMIN_DIR")&"/users/users.asp",user.getFullName(),"Edit your account information",null)&"</li>")
		writeln(indent(4)& CreateNavLink("","View Public Site","Leave the back-end and go to the public front-end website",null)&"</li>")
		writeln(indent(4)& CreateNavLink(objLinks.item("ADMIN_DIR")&"/logout.asp", "Logout", "End your admin session.","last")&"</li>")
		writeln(indent(3)& "</ul>" & vbcrlf & indent(2)& "</div>")
	end if 
%>