<%@ Language=VBScript %>
<%Option Explicit%>
<!--#include file="../../../core/include/bootstrap.asp"-->
<%page.setSecurityLevel(USER_ADMINISTRATOR)%>
<!--#include file = "../../../core/include/secure.asp"-->
<%
page.setTitle("Compact Database")

const Jet_Conn_Partial = "Provider=Microsoft.Jet.OLEDB.4.0; Data source="
dim strDatabase, strFolder, strFileName

'#################################################
'# Edit the following two lines
'# Define the full path to where your database is
strFolder = globals("DB_LOCATION") & "\"  ' dont forget trailing slash
'# Enter the name of the database
strDatabase = globals("PROJECT_NAME") &".mdb"
'# Stop editing here
'##################################################

private sub dbCompact(strDBFileName)
	dim SourceConn
	dim DestConn
	dim oJetEngine
	SourceConn = Jet_Conn_Partial & strFolder & strDatabase
	DestConn = Jet_Conn_Partial & strFolder & "Temp" & strDatabase
	set oJetEngine = Server.CreateObject("JRO.JetEngine")
	with fs
		if not .FileExists(strFolder & strDatabase) then
			Response.Write ("Not Found: " & strFolder & strDatabase)
			stop
		else
			if .FileExists(strFolder & "Temp" & strDatabase) then
				response.write ("Something went wrong last time " _
				& "Deleting old database... Please try again")
				.DeleteFile (strFolder & "Temp" & strDatabase)
			end if
		end if
	end with
	'//need to close the application db object first!
	db.ConnectClose
	'// end custom code insert
	oJetEngine.CompactDatabase SourceConn, DestConn
	fs.DeleteFile strFolder & strDatabase
	fs.MoveFile strFolder & "Temp" _
	& strDatabase, strFolder& strDatabase
	set oJetEngine = nothing
end sub

private sub dbList()
	dim oFolders, item
	response.Write ("<select name=""DBFileName"">")
	for each item In fs.GetFolder(strFolder).Files
		if LCase(Right(item, 4)) = ".mdb" then
			Response.Write ("<option Value=""" & Item.Name _
			& """>" & Item.Name & "</option>")
		end if
	next
	response.write ("</Select>")
	set oFolders = nothing
end sub



function getContent()
	writeln h1("Compact &amp; Repair Database")
	' Compact database and tell the user the database is optimized
	select case request.form("cmd")

		case "Compact"
			dbCompact request.form("DBFileName")
			writeln SuccessMessage("Database " & request.form("DBFileName") & " is optimized.")
			
		case else
			writeln p("Select the database to optimize")
			writeln "<div>"
			writeln "<form method=""post"" action="""">"
			writeln "<div style=""width:400px;"">"
			call dbList
			writeln "&nbsp;<input class=""button inputSubmit"" type=""submit"" value=""Compact"" name=""cmd"">"
			writeln "</div>"
			writeln "</form>"
			writeln "</div>"
			
	end select
end function
%>
<!--#include file="template.inc"-->