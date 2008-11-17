<%
'admin menubar
trace("admin/include/menubar.asp: processing menubar... ")
if user.activeAdminSession() = true then 
	writeln( vbcrlf )
	writeln( indent(2) & "<div class=""pre"">&nbsp;</div>")
	writeln( indent(2) & "<div class=""wrapper clearfix"">")
	writeln( indent(3)  & h2("Site Links"))
	writeln( indent(3)  & "<ul id=""mainnav""")
	writeln( indent(4)   & ">"&CreateNavLink(objLinks.item("ADMIN_DIR")&"/default.asp", "Dashboard", objLinks.item("PRODUCT_BRANDING")&": Site Administrator - dashboard",null)&"</li")
	
	if user.getRole() >= USER_EDITOR then 
	%><!--#include file="../content/_menu.asp"--><%
	end if
	if user.getRole() >= USER_MANAGER then
	'//Settings Tab
	%><!--#include file="../settings/_menu.asp"--><%
	'//Users Tab
	%><!--#include file="../users/_menu.asp"--><%
	'//Modules Tab	
	%><!--#include file="../modules/_menu.asp"--><%
	end if
	writeln( indent(3)  &	"></ul>" & vbcrlf)
	writeln( indent(2) & "</div>" & vbcrlf )
	writeln( indent(2) & "<div class=""post clearfix"">&nbsp;</div>" & vbcrlf )

end if
%>
