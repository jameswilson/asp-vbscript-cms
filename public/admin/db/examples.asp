<%
'**
'* Table Creation Example
'*
sub tableCreationExample()
	tableExists = false
	for each tbl in cat.tables
			if tbl.type = "TABLE" and lcase(tbl.name) = lcase(tableName) then
					tableExists = true
					debug("table " & tableName & " already exists")
			end if
			if err.number <> 0 then
				debugError("there was an error in table detection")
				debugError("error in " & Err.source & " error code " & err.number & ": " & err.description)
				err.clear
			end if
	next
	if not tableExists then
		dim tableCreate
		tableCreate = "CREATE TABLE " & tableName & "(" & _
				"Key AUTOINCREMENT," & _
				"PID VARCHAR(50)," & _
				"Category VARCHAR(50)," & _
				"PID VARCHAR(50)," & _
				"PID VARCHAR(50)," & _
				"PID VARCHAR(50)," & _
				"ProductName VARCHAR(50)," & _
				"ProductName VARCHAR(50)," & _
				"IntegerColumn INT," & _
				"VarcharColumn VARCHAR(50)," & _
				"MemoColumn MEMO DEFAULT '')"
		conn.execute tableCreate, , 129
		if err.number <> 0 then
			debugError("there was an error in table creation with SQL (" & tableCreate & ")")
			debugError("error in " & Err.source & " error code " & err.number & ": " & err.description)
			err.clear
		end if
	end if
end sub
%>
