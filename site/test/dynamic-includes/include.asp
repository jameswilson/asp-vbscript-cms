<%
dim myVar : myVar = "ASP" 
dim serverName : serverName = request.ServerVariables("SERVER_NAME")
response.write "<h1>Hello, "&myVar&"</h1>" &vbcrlf
response.write "<p>your server is '"&serverName&"'</p>"&vbcrlf
%>
