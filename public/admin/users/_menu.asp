<%
writeln( indent(4) & ">" & CreateNavLink(globals("ADMIN_DIR") & "/users/users.asp", "Users", "Create and edit website users.", null) & "<ul")
writeln( indent(5) & ">" & CreateNavLink(globals("ADMIN_DIR") & "/users/users.asp?create", "Add A User", "Add a new user.", null) & "</li")
writeln( indent(5) & ">" & CreateNavLink(globals("ADMIN_DIR") & "/users/users.asp?view", "View Users", "Modify an existing user.", null) & "</li")
writeln( indent(4) & "></ul></li")
%>
