<%		writeln( indent(4)   & ">"&CreateNavLink(objLinks.item("ADMIN_DIR")&"/users/users.asp", "Users", "Create and edit website users.",null)&"<ul")
		writeln( indent(5)    & ">"&CreateNavLink(objLinks.item("ADMIN_DIR")&"/users/users.asp?create", "Add A User", "Add a new user.",null)&"</li")
		writeln( indent(5)    & ">"&CreateNavLink(objLinks.item("ADMIN_DIR")&"/users/users.asp?view", "View Users", "Modify an existing user.",null)&"</li")
		writeln( indent(4)   & "></ul></li")
%>