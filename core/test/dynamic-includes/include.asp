<%
dim myVar : myVar = "ASP"
dim serverName : serverName = Request.ServerVariables("SERVER_NAME")
Response.Write "<h1>Hello, " & myVar & "</h1>" & vbCrLf
Response.Write "<p>your server is '" & serverName & "'</p>" & vbCrLf
%>
