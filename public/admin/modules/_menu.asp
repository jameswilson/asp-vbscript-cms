<%		
set modules = new SiteModules
writeln( indent(4) & ">"& CreateNavLink(globals("ADMIN_DIR") &"/modules/", "Modules", "Create and edit site modules.", null) &"<ul")

if modules.isActive("mod_testimonials") then 
writeln( indent(5) & ">"& CreateNavLink(globals("ADMIN_DIR") &"/modules/testimonials/testimonials.asp?view", "Testimonials", "Modify an existing testimonial.", null) &"</li")
end if


if modules.isActive("mod_products") then 
	writeln( indent(5) & ">"& CreateNavLink(globals("ADMIN_DIR") &"/modules/products/products.asp?view", "Products", "View/Edit product lists.", null) &"</li")
	writeln( indent(5) & ">"& CreateNavLink(globals("ADMIN_DIR") &"/modules/products/categories/categories.asp?view", "&raquo; Product Categories", "View/Edit product categories.", null) &"</li")	
end if

writeln( indent(5) & ">"& CreateNavLink(globals("ADMIN_DIR") &"/modules/?view", "Module List", "View all existing modules.","divider") &"</li")
writeln( indent(5) & ">"& CreateNavLink(globals("ADMIN_DIR") &"/modules/?create", "Create New Module", "Add a new module to your site.","divider") &"</li")
if user.getRole() >= USER_ADMINISTRATOR then
	writeln( indent(5) & ">"& CreateNavLink(globals("ADMIN_DIR") &"/modules/admin", "Administer Modules", "Upload &amp deactivate modules.","divider") &"</li")
end if
writeln( indent(4) & "></ul></li")
		
%>