<%		writeln( indent(4)   & ">"&CreateNavLink(objLinks.item("ADMIN_DIR")&"/pages/pages.asp", "Content", "Modify your site content.","")&"<ul")
		writeln( indent(5)    & ">"&CreateNavLink(objLinks.item("ADMIN_DIR")&"/pages/pages.asp", "Static Pages", "View/Edit your site's static pages.",null)&"</li")
		writeln( indent(5)    & ">"&CreateNavLink(objLinks.item("ADMIN_DIR")&"/docs/", "File Manager", "Open the file manager.",null)&"</li")
		writeln( indent(5)    & ">"&CreateNavLink(objLinks.item("ADMIN_DIR")&"/editor/", "Global Content Blocks", "View/Edit the reusable content blocks.",null)&"</li")
		writeln( indent(4)   & "></ul></li")
%>