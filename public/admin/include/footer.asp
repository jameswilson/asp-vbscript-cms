<%	
'admin footer
trace("admin/include/footer.asp: processing footer... ")
writeln("<div>")
writeln(indent(1) & "<div class=""about"">"& globals("PRODUCT_DESCRIPTION") & "</div>")
writeln("</div>")
logger.debug_dump
%>