<%
'**
'* Build a SQL statement for the specified queryType (insert,update,delete) to apply on the 
'* specified tableName. If the querytype is "insert" or "update" then the values contained 
'* in the specified ContentDict dictionary will be added or updated (respective) to the table.
'* If the querytype is "update" or "delete" then the strPKid is the name of the primary key 
'* column to match up for the update/delete. 

'* NOTE: This function uses ADOX.Catalog to determine the column names and data types such
'* that valid SQL can be generated on the fly with no extra meta-data dictionary necessary.
'* ADOX.Catalog is assumed to work with Microsoft JET DB Engine in concert with Microsoft 
'* Access Databases. This will likely not work if a mySQL database is implemented. 
'*
'* @param queryType a string representation of the type of query (currently supports insert,update,delete)
'* @param strTableName the name of the table that will receive the new values
'* @param objContentDict an object that contains the contents of what will be 
'*        inserted into the specified table.  Each key of the object must be
'*        a column name in the specified table and each corresponding value 
'*        item for said key must be the new content to be inserted.
'* @param strPkid the Primary Key id (this column will be ignored by the 
'*        insert, assuming its assigned automatically by the database)
'* @return the SQL INSERT string for the new content
'*
public function CreateSQL(byval queryType, byref strTableName,byref objContentDict,byval strPKid)
	dim cat : set cat = server.createObject("ADOX.Catalog")
	dim con : set con = server.createObject("ADODB.Connection")
	dim dbPath : dbPath = globalVarFill("{DB_LOCATION}\{SOURCEID}.mdb")
	dim dbConString : dbConString = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" &dbPath
	con.open dbConString 
	cat.activeConnection = con
	dim tbl, tblList
	for each tblList In cat.tables
      if tblList.Name = strTableName then
				set tbl = tblList
				exit for
			end if
  next
	if isObject(tbl) = false then
		strError = strError & "Could not find table '"&strTableName&"' in database."
		exit function
	end if
	
	dim separator : separator = " "
	dim sqlValue, sqlFields, sqlContents

	dim myfld, skip
	dim sqlInsertFields : set sqlInsertFields = new FastString
	dim sqlInsertContents : set sqlInsertContents = new FastString
	dim sqlUpdateContent : set sqlUpdateContent = new FastString
	for each myfld in tbl.columns
		
		skip = false
		sqlValue = objContentDict(myfld.Name)
		debug("db.admin.functions.CreateSQL: field "&myfld&" has value "&sqlValue)
		if myfld.name <> strPKid then 
			select case myfld.Type
				case adBoolean   'Boolean
					if (len(sqlValue)>0) and (CStr(sqlValue) <> Cstr(0)) and (CStr(sqlValue) <> CStr(false)) then 
						sqlValue = "1"
					else
						sqlValue = "0"
					end if
					
					
				case adDate, adDBTimeStamp 'Date / Time
					if not isNull(sqlValue) and sqlValue <> "" then 
						if isDate(sqlValue) = true then 
							sqlValue = "#"&Date(sqlValue)&"#"
						else
							strError = strError & "The "&myfld.Name&" field value '"&sqlValue&"' is not a valid date format."
							exit function
						end if
					else
						skip = true
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
				sqlInsertFields.add    separator & quot(myfld.Name)
				sqlInsertContents.add  separator & sqlValue
				sqlUpdateContent.add   separator & quot(tbl.name) & "." & quot(myfld.Name) & "=" & sqlValue 
				separator = ", "
			end if 
		end if
	next
	select case lcase(queryType)
		case "insert"
			CreateSQL = "INSERT INTO " & quot(tbl.name) & " (" &sqlInsertFields.value &")  VALUES (" & sqlInsertContents.value & ");"
		case "update"
			CreateSQL = "UPDATE " & quot(tbl.name) & " SET " & sqlUpdateContent.value &" WHERE (" & quot(tbl.name) &"." & quot(strPKid)& "="& objContentDict(strPKid) &");"
		case "delete"
			CreateSQL = "DELETE * FROM " & quot(tbl.name) & " WHERE (" & quot(tbl.name) &"." & quot(strPKid) & "="& objContentDict(strPKid) &");"
		case else
			strError = "There is no such query type '"&queryType&"' for database manipulation."
	end select
	
	set sqlInsertFields = nothing
	set sqlInsertContents = nothing
	set sqlUpdateContent = nothing
end function


'**
'* Helper function to wrap the specified SQL token in SQL quotations.
'*
function quot(byval str)
	const SQL_OPEN_QUOTE = "`"
	const SQL_CLOSE_QUOTE = "`"
	quot = SQL_OPEN_QUOTE & str & SQL_CLOSE_QUOTE
end function

public function createDB(ByVal filePath)
	on error resume next
	dim myPath : myPath = filePath
	dim myParent : myParent = fs.getParentFolderName(myPath)
	dim result
	debug("does "&myPath&" exist? "& fs.fileExists(myPath))
	if fs.fileExists(myPath) = true then
		result = true
	elseif fs.folderExists(myParent) = true then
		debug("creating database file "&myPath)
		cat.create  dbCreate
		if err.number <> 0 then
			debugError("there was an error in database creation at filepath ("&myPath&")")
			debugError("error in "&Err.source&" error code "&err.number&": "&err.description)
			err.clear
		end if
		result = true
	else 
		debug("parent folder doesnt exist,  building parent folder "&myParent)
		call buildDirectories(myParent, 1)
		result = true
	end if
	debug("result is "&result& " for "& myPath)
end function

public sub buildDirectories(ByVal folderPath, ByRef counter)
	on error resume next
	dim i : i = folderPath
	dim p : p = fs.getParentFolderName(i)
	debug(""&counter&" does "&i&" exist? "& fs.folderExists(i))
	debug(""&counter&" does "&p&" exist? "& fs.folderExists(p))
	if not fs.folderExists(p) then 
		call buildDirectories(p,counter + 1)
	end if
	debug("creating "&i)
	fs.createFolder(i)
	if err.number <> 0 then
		debugError("there was an error in recursion at filepath ("&i&")")
		if err.number = 70 then debugError("the IUSR_ doesnt have write permissions in folder "&p)
		debugError("error was "&err.number&": "&err.description)
		err.clear
	end if
	i = null
end sub
%>