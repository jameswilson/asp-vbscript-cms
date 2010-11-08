<% 
	writeln(h1("Dynamic ASP Includes")&p("this examples shows how to dynamically include code in a second file."))
	writeln(h3("Scripting Blocks")&p("the second file may start with <code>&gt;%</code> and end with <code>%&lt;</code> to signify ASP code, but may not be interspersed with html chunks."))
	writeln(p("if you need to execute a file that has ASP scripting blocks mixed in with HTML code you must wrap all HTML lines in <code>response.write</code> ASP and insert it into the one and only Scripting Block."))
	dim sample : sample = "&lt;% dim myVar : myVar = ""ASP"" %&gt;"& vbCrLf &"&lt;h1&gt;Hello, &lt;%=myVar%&gt;&lt;/h1&gt;"& vbCrLf &"&lt;% myVar = """" %&gt"
	dim sample1 : sample1 = "&lt;%"& vbCrLf &"dim myVar : myVar = ""ASP"" "& vbCrLf &"response.write ""&lt;h1&gt;Hello, ""&myVar&""&lt;/h1&gt;"" "& vbCrLf &"myVar = """" "& vbCrLf &"%&gt;"
	writeln(p("eg. original invalid file:<blockquote><pre>"&sample&"</blockquote></pre>"))
	writeln(p("eg. valid file:<blockquote><pre>"&sample1&"</blockquote></pre>"))
	writeln(h2("Test..."))
%>

