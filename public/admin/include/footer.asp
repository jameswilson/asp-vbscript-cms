<%	
'admin footer
trace("admin/include/footer.asp: processing footer... ")
writeln("<div>")
writeln(indent(1) & "<div class=""about"">"& globals("PRODUCT_DESCRIPTION") & "</div>")
writeln("</div>")
printDebugHTML()  'only prints if debug.asp was included somewhere on the page, and if site DEBUG is "ON" 
%>