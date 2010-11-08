<%@ Language=VBScript %>
<%Option Explicit%>
<!--#include file="../../../core/include/bootstrap.asp"-->
<%page.setSecurityLevel(USER_ADMINISTRATOR)%>
<!--#include file = "../../../core/include/secure.asp"-->
<%

dim dbPath, tableName, tableExists, cat, conn, dbCreate
dim tbl, col, pkey, grp, rs, i, j, k
dim tblName : tblName = request.querystring("tbl")
dim sortBy : sortBy = request.querystring("sort_by")
page.setName("Database Browser")
if len(tblName)>0 then page.setName("Database Browser &raquo; "& tblName)


'==============================================================
' Summary: Display a list of all tables in the database. if a 
'          specific table is chosen, list its contents in a table.
'
' Notice:  template.inc calls method getContent(), place all content  
'          to be displayed in here...
' 
'---------------------------------------------------------------
function getContent()
	set cat = server.createObject("ADOX.Catalog")
	set conn = server.createObject("ADODB.Connection")
	dbPath = token_replace("{DB_LOCATION}\{PROJECT_NAME}.mdb")
	debugInfo("db path: "& dbPath)
	dbCreate = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" &dbPath
	'tableName = "tblProducts"
	
	'if not fs.fileExists(dbPath) then createDB(dbPath)
	conn.open dbCreate 
	cat.activeConnection = conn
	if err.number <> 0 then
		debugError("there was an error in opening the connection to "& dbCreate)
		debugError("error in "& Err.source &" error code "& err.number &": "& err.description)
		err.clear
	end if
			
	
	'==================================
	' LIST ALL TABLES
	if not len(request.QueryString()) > 0 then
		writeln(h2("Database Browser"))
		writeln(WarningMessage("The database browser functionality is currently in beta testing.  It is not ready for full time, dependable use, and lacks lots of functionality. For questions or concerns please contact "& globals("DEVELOPER_LINK")))
		writeln("<ul class='list'>")
		for each tbl in cat.tables
			if tbl.type = "TABLE" then
				writeln("<li>"& strong(tbl.name) &": "& anchor("?tbl="& tbl.name,"View", null,"button") &" "& anchor("export.asp?tbl="& tbl.name,"Export", null,"button"))
				'dim prop
				'writeln("<ul>")
				'for each prop in tbl.properties
				'	writeln("<li>"& prop.name &"["& prop.type &"]: '"& prop.value &"'</li>")
				'next	
				'writeln("</ul>")
				writeln("</li>")
				
			end if
		next
		writeln("</ul>")
		
	'==================================
	' TABLE CONTENTS LISTING
	elseif len(tblName) > 0 then
		writeln(h2(anchor(globals("ADMINURL") &"/db/","Database Browser", null, null) &" &raquo; "& tblName))
		dim table, column, content, strCondition, strEven
		set table = db.Init(tblName)
		page.setName("Database Browser: "& tblName)
		if len(sortBy)> 0 then strCondition = " ORDER BY "& sortBy
		response.write(table.count&" columns in this table")
		writeln("<table class='list' width=""100%"" cellspacing=""0"" cellpadding=""3"" border=""0"">")
		writeln("<tr>")
		i=0
		for each column in table.keys
			if column <> "tablename" then
				if column = "" then column = i
				writeln("<th><a href=""?tbl="& tblName &"& sort_by="& column &""">"& PrettyText(column) &"</a></th>")
			end if
			i=i+1
		next
		writeln("</tr>")
		for i=0 to db.BuildList(content, tblName, strCondition)-1
			strEven = ""
			if (i MOD 2 = 0) = true then strEven = "even"			
			writeln("<tr class="""& strEven &""">")
			for each column in table.keys
				if column <> "tablename" then	writeln("<td> "& content(i)(column) &" </td>")
			next
			writeln("</tr>")		
		next
		writeln("</table>")
	end if
	
	set rs = nothing
	conn.close 
	set conn = nothing 
	set cat = nothing 
	set fs = nothing 
end function
%>
<!--#include file="template.inc"-->
