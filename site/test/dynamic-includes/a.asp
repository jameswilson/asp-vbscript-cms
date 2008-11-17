<%@LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<!--#include file="../core/include/global.asp" -->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>CMS Testbed</title>
</head>

<body>
<% 

'dynamic includes
'this examples shows how to dynamically include code in a second file
'executing code in another file 
const forReading = 1 
dim f : set f = new SiteFile
f.Path = "/testing/b.asp"
if f.fileExists() then
	debug("file absolute path is "&f.absolutePath)
	dim ts : set ts = fs.openTextFile(f.absolutePath, forReading)
	writeln(p("a says hello Mr. B"))
	dim content : content = ts.readAll
	debug("file be contents are: "&content)
	Execute content
end if
printDebugHTML()
%>

</body>
</html>
