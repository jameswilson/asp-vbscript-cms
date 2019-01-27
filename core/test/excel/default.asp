<%
' This Code is Copyright Katy Whitton
' You are free to use this code on any site
' But Please Keep This Copyright Statement In
' Place
' For more ASP and JavaScripts, please visit
' http://www.katywhitton.com


' Set Up our Database connection via DSNLess Connection
' You May be able to use Server.MapPath for you connection
' Or alternatively connect via ODBC, Please contact your
' Hosting provider for more information

' Dimension our Variables for the Dabase Connection

dim objConn, strCon, objRS, strSQL
Set objConn = Server.CreateObject("ADODB.Connection")

'Change the Line below to point to the location of the database

strCon = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" & Server.MapPath("sampleDB.mdb")
objConn.connectionstring = strCon
objConn.Open
Set objRS = Server.CreateObject("ADODB.Recordset")
on error resume next

' Set the SQL Statement to get the information from the database
strSQL="SELECT * FROM TBLCompany"
' Open the Database
objRS.Open strSQL, objConn

' Open up the page as an Excel File

Response.ContentType = "application/vnd.ms-excel"

' Set up the Table we wish to Populate
%>
<table border="1">
<tr>
<td><b>ID</b></td>
<td><b>CompanyName</b></td>
<td><b>CompanyAddress1</b></td>
<td><b>CompanyAddress2</b></td>
<td><b>CompanyAddress3</b></td>
<td><b>CompanyAddress4</b></td>
<td><b>CompanyPostCode</b></td>
<td><b>CompanyTel</b></td>
<td><b>CompanyFax</b></td>
<td><b>CompanyEmail</b></td>
<td><b>CompanyWebsite</b></td>
</tr>
<%
' Cycle through the database and populate the table

DO WHILE NOT objRS.EOF%>
<tr>
<td><%=objRS("ID")%></td>
<td><%=objRS("CompanyName")%></td>
<td><%=objRS("CompanyAddress1")%></td>
<td><%=objRS("CompanyAddress2")%></td>
<td><%=objRS("CompanyAddress3")%></td>
<td><%=objRS("CompanyAddress4")%></td>
<td><%=objRS("CompanyPostCode")%></td>
<td><%=objRS("CompanyTel")%></td>
<td><%=objRS("CompanyFax")%></td>
<td><%=objRS("CompanyEmail")%></td>
<td><%=objRS("CompanyWebsite")%></td>
</tr>
<%
objRS.MoveNext
Loop%>
</table>
<br>
<br>
<b>So as you can see we can export the data quite easily into Excel from <br>Access on the Fly and format it using standard HTML!</b>
