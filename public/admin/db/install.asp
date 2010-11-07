<%@ Language=VBScript %>
<%Option Explicit%>
<!--#include file="../../core/include/global.asp"-->
<!--#include file = "../../core/include/secure.asp"-->
<% 
'==============================================================
' Summary: This Script is used to import a database table into 
'          the CMS's Main database. A `path` to the file 
'          containing DDL instruction set form importing should
'          be provided on the query string along with the table
'          or tables (comma-separated-list) the script will import.
'          The format for the file containing DDL instructions
'          should have an instruction (with no line breaks) on each line
'          Comment lines are allowed if they begin with `--`.
'
' Notice:  template.inc calls method getContent(), place all content  
'          to be displayed in here...
' 
'---------------------------------------------------------------
function getContent()			 
	writeln(createTable(request.querystring("name"), request.querystring("path")))
end function


'==================================
' TABLE CREATION FUNCTION
' Notice: the table name and path to 
'  the SQL install file must be passed
'  to this script on the querystring
function createTable(byVal strName,byVal strPath)
	if strName = ""  or strPath = "" then 
		createTable = ErrorMessage("An error occurred.  A name and installation file path are required to install a table.")
		debugError("when calling this page, you must pass a name and path-to-sql-create-file on the querystring")
		exit function
	end if
	if not db.Init(strName) is nothing then 
		createTable = ErrorMessage("Cannot install table '"&strName&"' because it already exists!")
		debugError("the table '"&strName&"' already exists in database '"&dbPath&"'")
		exit function
	end if
	dim installFile : set installFile = new SiteFile
	installFile.Path = strPath
	if installFile.fileExists() = false then
		createTable = ErrorMessage("The installation file '"&strPath&"' could not be found.")
		debugError("please specify an existing file for the sql instructions, '"&strPath&"' does not exist.")
		exit function
	end if
	
	dim dbPath, conn
	set conn = server.createObject("ADODB.Connection")
	dbPath = globalVarFill("{DB_LOCATION}\{SOURCEID}.mdb")
	debugInfo("db path: "&dbPath)
	db.ConnectOpen(dbPath)
	'if not fs.fileExists(dbPath) then createDB(dbPath)
	'conn.open "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" &dbPath 
	on error resume next
	debug("opening text file '"&installFile.AbsolutePath&"'")
	dim ts, sql
	set ts = fs.OpenTextFile(installFile.AbsolutePath,1,0) 'forReading,TristateFalse
	createTable = ""
	do until ts.atendOfStream
		sql = sql & trim(ts.ReadAll)
		trapError
		if len(sql)>0 and not instr(sql,"--")=1 then
			debug("instrrev(sql,';') = "&instrrev(sql,";")&"")
			debug("len(sql) = "&len(sql)&"")
			if instrrev(sql,";")>0 then
				debug("executing SQL: '"&sql&"'...")
				if not db.execute(sql) then
					createTable = createTable &ErrorMessage("The server encountered an error during installation. '"&strName&"' could not be created.")
					debugError("there was an error in creating table '"&strName&"' with SQL ("&sql&")")
					if err.number <> 0 then debugError("error in "&err.source&" error code "&err.number&": "&err.description)
				else
					createTable = createTable &InfoMessage("<strong>Success!</strong> The table was created successfully. <a href="""&request.ServerVariables("HTTP_REFERER")&""">Return to the previous page</a>.")
				end if
				sql = ""
			end if
		end if
	loop
end function
 %>
<!--#include file="template.inc"-->
