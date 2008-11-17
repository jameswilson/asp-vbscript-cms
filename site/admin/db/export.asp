<%@ Language=VBScript %>
<%Option Explicit%>
<!--#include file="../../core/include/global.asp"-->
<% page.setSecurityLevel(USER_ADMINISTRATOR)%>
<!--#include file = "../../core/include/secure.asp"-->
<%
dim dbPath, tableName, tableExists, cat, conn, dbCreate
dim tbl, col, pkey, grp, rs, i, j, k
dim tblName : tblName = request.querystring("tbl")
dim sortBy : sortBy = request.querystring("sort_by")
page.setName("Database Browser &raquo; Export DB")
if len(tblName)>0 then page.setName("Database Export &raquo; "&tblName)


'==============================================================
' Summary: Display a list of all tables in the database. If a 
'          specific table is chosen, export its contents to SQL/DDL.
'
' Notice:  template.inc calls method getContent(), place all content  
'          to be displayed in here...
' 
'---------------------------------------------------------------
function getContent()
	on error goto 0
	set cat = server.createObject("ADOX.Catalog")
	set conn = server.createObject("ADODB.Connection")
	dbPath = globalVarFill("{DB_LOCATION}\{SOURCEID}.mdb")
	debugInfo("db path: "&dbPath)
	dbCreate = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" &dbPath
	err.clear
	conn.open dbCreate 
	cat.activeConnection = conn
	if err.number <> 0 then
		debugError("there was an error in opening the connection to database '"&dbPath&"'")
		debugError("error in "&Err.source&" error code "&err.number&": "&err.description)
	end if
	
	if not len(request.QueryString()) > 0 then
		writeln(h2(page.getName()))
		writeln(p("Select one of the following tables to export.  Currently tables may only be exported in the DDL format."))
		writeln("<ul>")
		for each tbl in cat.tables
			if tbl.type = "TABLE" then
				writeln("<li>"&strong(anchor("?tbl="&tbl.name,tbl.name,null,null))&"</li>")
			end if
		next
		writeln("</ul>")
	elseif len(tblName)>0 then
		writeln(h2(anchor(objLinks.item("ADMINURL")&"/db/","Database Browser",null,null)&" &raquo; "& anchor(objLinks.item("ADMINURL")&"/db/export.asp","Export DB",null,null)&" &raquo; "&tblName)) 
		debug("executing table '"&tblName &"'")
		executeGetDDL(tblName)
	end if

	conn.close 
	set conn = nothing 
	set cat = nothing 
end function	

function executeGetDDL(byVal tableName)
	for each tbl in cat.tables
		if tbl.type = "TABLE" and lcase(tbl.name) = lcase(tableName) then
			debug("getting table DDL string for table '"&tableName&"' ...")
			writeln("<code>"&getTableDdl(tbl)&"</code>")
			writeln("<code>"&GetTableContentDdl(tbl)&"</code>")
			'for each indx in tbl.indexes
			'	writeln(GetIndexDdl(tbl, indx))
			'next
		end if
	next
end function

public function GetTableDdl(mytdef) 'As TableDef) 'As String
		dim myfld, sql
		dim Seperator, a 
		dim myFields
		set sql = new FastString
		set rs = server.createObject("ADODB.RecordSet")
		rs.ActiveConnection = conn
		rs.open ""&mytdef.name, conn 
		sql.add "CREATE TABLE " & QuoteObjectName(mytdef.Name) & " ("
		Seperator = vbcrlf
		for each myfld in mytdef.columns
			 sql.add Seperator & " " & QuoteObjectName(myfld.Name) & " "
			 select case myfld.Type
			 case adBoolean   'Boolean
					sql.add "BIT"
			 case adUnsignedTinyInt, adTinyInt   'Byte
					sql.add "BYTE"
			 case adCurrency  'Currency
					sql.add "MONEY"
			 case adDate 'Date / Time
					sql.add "DATE"
			 case adDBTimeStamp
					sql.add "DATETIME"
			 case adDouble    'Double
					sql.add "DOUBLE"
			 case adInteger, adSmallInt   'Integer
					if rs.Fields(""&myfld.name).properties("IsAutoIncrement") then 
						sql.add "COUNTER "
					else
						sql.add "INTEGER"
					end if
			 case adLongVarChar, adLongVarWChar 'Memo
					sql.add "MEMO"
			 case adSingle    'Single
					sql.add "SINGLE"
			 case adVarChar, adVarWChar 'Text
					sql.add "VARCHAR(" & rs.Fields(""&myfld.name).DefinedSize & ")"
			 case adGUID 'Text
					sql.add "GUID"
			 case Else
					MsgBox "Field " & mytdef.Name & "." & myfld.Name & _
								" of type " & myfld.Type & " has been ignored!!!"
			 end select
			 if (myfld.Attributes = 0) then
					sql.add " NOT NULL"
			 end if
			 Seperator = ", " & vbCrLf
		next
		for each myfld in mytdef.keys
			if myfld.columns.count = 1 then
				sql.add Seperator & " "
				sql.add "CONSTRAINT "&myfld.Name&" "
				select case myfld.Type
					case adKeyPrimary
						sql.add " PRIMARY KEY ("&myfld.columns(0)&")"
					case adKeyForeign
						sql.add " FOREIGN KEY ("&myfld.columns(0)&") REFERENCES "&QuoteObjectName(myFld.RelatedTable) 
					case adKeyUnique
						sql.add " UNIQUE ("&myfld.columns(0)&")"
					case else
						MsgBox " An unsupported key type '"&myfld.Type&"' was found for key: "&myFld.name
				end select
				select case myfld.UpdateRule 
					case adRINone
						'do nothing this is default
					case adRISetNull
						sql.add " ON UPDATE SET NULL"
					case adRISetDefault
						sql.add " ON UPDATE SET DEFAULT"
					case adRICascade
						sql.add " ON UPDATE CASCADE"
					case else
						MsgBox " An unsupported update rule '"&myfld.UpdateRule&"' was found for key: "&myFld.name
				end select
				select case myfld.DeleteRule 
					case adRINone
						'do nothing this is default
					case adRISetNull
						sql.add " ON DELETE SET NULL"
					case adRISetDefault
						sql.add " ON DELETE SET DEFAULT"
					case adRICascade
						sql.add " ON DELETE CASCADE"
					case else
						MsgBox " An unsupported update rule '"&myfld.UpdateRule&"' was found for key: "&myFld.name
				end select
			else
				response.write(" columns count: "& myfld.columns.count)
			end if
			Seperator = ", " & vbCrLf
		next

		sql.add vbCrLf & ");"
		GetTableDdl = sql.value
		rs.close
end function

public function GetTableContentDdl(mytdef) 'As TableDef) 'As String
	dim myfld, sql
	dim Separator, Divider, a 
	dim myFields, sqlFields, sqlContents
	set sql = new FastString
	
	set rs = server.createObject("ADODB.RecordSet")
	rs.ActiveConnection = conn
	rs.open "SELECT * FROM "&mytdef.name, conn 
	if rs.state>0 then 
		
		Divider = vbcrlf
		do until rs.EOF
			sql.add Divider & "INSERT INTO "&mytdef.name
			sqlFields = ""
			sqlContents = ""
			Separator = ""
for each myfld in mytdef.columns
		skip = false
		sqlValue = rs(myfld.Name)
		debug("db.admin.functions.CreateSQL: field "&myfld&" has value "&sqlValue)
		if isNull(sqlValue) or sqlValue <> "" or myfld.name <> strPKid then 
			skip = true
		else
			select case myfld.Type
				case adBoolean   'Boolean
					if (len(sqlValue)>0) and (CStr(sqlValue) <> Cstr(0)) and (CStr(sqlValue) <> CStr(false)) then 
						sqlValue = "1"
					else
						sqlValue = "0"
					end if
					
					
				case adDate, adDBTimeStamp 'Date / Time
					if isDate(sqlValue) = true then 
						sqlValue = "#"&Date(sqlValue)&"#"
					else
						strError = strError & "The "&myfld.Name&" field value '"&sqlValue&"' is not a valid date format."
						exit function
					end if
				
									
				case adLongVarChar, adLongVarWChar, adVarChar, adVarWChar 'Memo and Text fields
					sqlValue = "'" & replace(sqlValue,"'","''") & "'"		
					
							
				case adUnsignedTinyInt, adTinyInt,adCurrency, adDouble, adSingle, adInteger, adSmallInt
					if not isNumeric(sqlValue) then
						strError = strError & "The value '"&sqlValue&"' for field "&myfld.Name&" is not numeric."
						exit function
					end if			
					
							
				case else
					strError = strError & "The value '"&sqlValue&"' for for field "&myfld.Name&"  could not be processed due to an unknown field type '"&myfld.Type&"'"
					exit function
					
			end select
			if not skip then
				sqlFields.add    separator & quot(myfld.Name)
				sqlContents.add  separator & sqlValue
				separator = ", "
			end if 
		end if
	next
			sql.add "("&sqlFields.value&")"
			sql.add " VALUES ("&sqlContents.value&")"
			Divider = ";" & vbcrlf
			rs.movenext
		loop
	end if
	rs.close
	GetTableContentDdl = sql.value
end function





public function GetIndexDdl(mytdef, myIndex) 'As TableDef, myindex As index) As String
		dim sql 'As String
		dim Seperator 'As String
		dim myfld 'As Field

		if Left(myindex.Name, 1) = "{" then
			 'ignore, GUID-type indexes - bugger them
		elseif myindex.Foreign then
			 'this index was created by a relation.  recreating the
			 'relation will create this for us, so no need to do it here
		else
			 Seperator = vbCrLf
			 sql = "CREATE "
			 if myindex.Unique then
					 sql = sql & "UNIQUE "
			 end if
			 sql = sql & "INDEX " & QuoteObjectName(myindex.Name) & " ON " & _
						 QuoteObjectName(mytdef.Name) & "("
			 for each myfld in myindex.Fields
					sql = sql & Seperator & QuoteObjectName(myfld.Name)
					Seperator = ", " & vbCrLf
			 next
			 sql = sql & vbCrLf & ")"
			 if myindex.primary then
					sql = sql & vbCrLf & " WITH PRIMARY"
			 elseif myindex.IgnoreNulls then
					sql = sql & vbCrLf & " WITH IGNORE NULL"
			 elseif myindex.Required then
					sql = sql & vbCrLf & " WITH DISALLOW NULL"
			 end if
			 sql = sql & ";"
		end if
		GetIndexDdl = sql
end function

' Returns the SQL DDL to add a relation between two tables.
' Oddly, DAO will not accept the ON DELETE or ON UPDATE
' clauses, so the resulting sql must be executed through ADO
public function GetRelationDdl(myrel )'As Relation) As String
		dim mytdef 'As TableDef
		dim myfld 'As Field
		dim sql 'As String
		dim Seperator 'As String

		with myrel
			 sql = "ALTER TABLE " & QuoteObjectName(.ForeignTable) & _
						 " ADD CONSTRAINT " & QuoteObjectName(.Name) & " FOREIGN KEY ("
			 Seperator = vbCrLf
			 for each myfld in .Fields 'ie fields of the relation
					sql = sql & Seperator & "   " & QuoteObjectName(myfld.ForeignName)
					Seperator = "," & vbCrLf
			 next
			 sql = sql & ")" & vbCrLf & "REFERENCES " & _
						 QuoteObjectName(.Table) & "("
			 Seperator = vbCrLf
			 for each myfld in .Fields
					sql = sql & Seperator & "   " & QuoteObjectName(myfld.Name)
					Seperator = "," & vbCrLf
			 next
			 sql = sql & ")"
			 if (myrel.Attributes And dbRelationUpdateCascade) then _
						 sql = sql & vbCrLf & "ON UPDATE CASCADE"
			 if (myrel.Attributes And dbRelationDeleteCascade) then _
						 sql = sql & vbCrLf & "ON DELETE CASCADE"
			 sql = sql & ";"
		end with
		GetRelationDdl = sql
end function

private function QuoteObjectName(byVal Str )'As String) As String
		 ' Handle metadata object names with spaces, reserved words,
		 ' or other odd stuff.
		 ' Other flavors of sql use quotes for this
		 QuoteObjectName = "[" & Str & "]"
end function 
%><!--#include file="template.inc"-->
