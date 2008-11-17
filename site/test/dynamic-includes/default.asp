<%@LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<!--#include file="../../core/include/global.asp" -->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Dynamic ASP Includes (example and test)</title>
</head>
<body style="font-size:small">
<!--#include file="explanation.asp"-->
<%
	' dynamic includes:
	' this examples shows how to dynamically include code in a second file
	' executing code in another file 
	'
	on error goto 0
	
	const forReading = 1 
	dim f : set f = new SiteFile
	f.Path = "/test/dynamic-includes/include.asp"
	if f.fileExists() then
		
		writeln(p("file to dynamically include '"&f.VirtualPath&"'"))
		on error goto 0
		dim ts : set ts = fs.openTextFile(f.absolutePath, forReading)
		dim content : content = ts.readAll
		
		writeln(p("contents of file to execute:<blockquote><pre>"&server.htmlencode(content)&"</pre></blockquote>"))
		writeln(p("Acutal Dynamically processed result:"))
		writeln("<div style=""margin:2em;padding:1em;border:1px solid silver;background:#eff;"">")
	
		content = replace(replace(content,"%"&">",""),"<"&"%","")
		if len(trim(content))>0 then
			Execute (content)
		else
			writeln("cannot execute, there were no contents found in the file")
		end if
	'
	'end of code block
	'
		writeln("</div>")
	else
		writeln(p("Cannot execute test because file '"&f.VirtualPath&"' does not exist."))
	end if
%>
</body>
</html>
