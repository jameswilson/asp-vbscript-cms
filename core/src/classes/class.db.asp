<!--#include file="../../include/adovbs.asp"-->
<%
'!
'! Wraps ADO database functionality for ease of use in ASP programs.
'!
'! @usage	
'! \code
'!  dim i, nCount, bReadOK
'!	dim db, varStudent, arrStudent
'!
'!	set db = new ClsDatabase
'!	db.ConnectOpen("dbtest.mdb")
'!
'!	Read record with specified key
'!
'!	set varStudent = db.Init("student")
'!	varStudent("userid") = "aaa@123.com"	
'!	bReadOK = db.Read(varStudent)
'! 
'!	if bReadOK then
'!		response.write varStudent("username") & "<br>"
'!	end if
'!
'!	Build list with specified condition
'!
'!	strCondtion = "sex=1 and age>10 order by age"
'! 	nCount = db.BuildList(arrStudent, "student", "")
'!
'!	for i = 0 to nCount-1
'! 		response.write arrStudent(i)("userid") & "<br>"
'!	next
'!
'!	set varStudent = nothing
'!	db.ConnectClose
'!	set Gdbc=nothing
'! \endcode
'!
'! @class ClsDatabase
'! @file class.db.asp
'!
class ClsDatabase
	private m_bConnected
	private m_bExists
	private m_errorDict
	private m_objConnection
	private m_numCalls
	private m_hasErrors
	private m_inTransaction
	private m_isWritable

	public property get Errors
		if isObject(m_objConnection) then	
			set Errors = m_objConnection.Errors
		end if
	end property
	
	'* Constructor initializes the object and its assets.
	'* @fn class_initialize
	private sub class_Initialize
		set m_errorDict = server.createObject("Scripting.Dictionary")
		m_bConnected = false
		m_inTransaction = false
		m_hasErrors = false
	end sub	
	
	'* Destructor releases the object and its assets when object set to nothing.
	'* @fn class_terminate
	private sub class_Terminate
		set m_objConnection = nothing
		set m_errorDict = nothing
	end sub
	
	'* Open an Access database. eg. "dbtest.mdb" or "C:\Databases\dbtest.mdb".
	'* @fn connectOpen(byval strDBName)
	'* @param str the path to the database
	public function ConnectOpen(byVal strDBName)
		dim strDBFile, strConnect
		debug("class.db.connectOpen:  opening "&strDBName)
		if m_bConnected and isObject(m_objConnection) then
			ConnectClose
			set m_objConnection = nothing
		end if
		if instr(strDBName,":") = 2 then
			strDBFile = strDBName
		else 
			strDBFile = Server.MapPath(".") & "\" & strDBName
		end if
		
		
		strConnect = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" & strDbFile
		
		set m_objConnection = Server.CreateObject("ADODB.Connection")
		on error resume next
		m_objConnection.Open strConnect
		if err.number <> 0 then
			m_bExists = False
			m_bConnected = False
			ConnectOpen = False
			m_isWritable = False
			AddError("The database "&strDBName&" could not be found.")
			debugError("class.db.connectOpen: The database "&strDBName&" could not be found.")
		else
			debug("class.db.ConnectOpen: The database  "&strDBName&" was opened successfully.")
			m_bConnected = True
			m_bExists = True
			' for all we know the db is writable until someone actually tries to write to it!
			' TODO
			m_isWritable = True 
			ConnectOpen = True
		end if
	end function
	
	'* Closes an open database connection.
	'* @fn ConnectClose
	public sub ConnectClose
		if isObject(m_objConnection) then
			m_objConnection.Close
		end if
		set m_objConnection = nothing	
		m_bConnected = false	
	end sub
	
	'* Determine if the database is writable
	'* @fn isWritable
	'* @return true if the databse is writable
	public function isWritable()
	isWritable = m_isWritable
	end function

	'* Create dictionary variable
	'* notice: refVarDic(0) or ("tablename") will store table name
	'* @fn Init
	'* @param string tablename
	public function Init(byVal strTable)
	
		dim rs, refVarDic
		
		' Step 0: Check parameters
		
		set Init = nothing
		if not m_bConnected Or Len(strTable)=0 then 
			exit function
		end if
		
		' Step 1: Connect Database
		
		set refVarDic = Server.CreateObject("Scripting.Dictionary")
		refVarDic.Add "tablename", strTable
		
		set rs = Server.CreateObject("ADODB.Recordset")
		if rsOpen( rs, "SELECT * FROM `"& strTable &"`", null, null) = true then 
		
			' Step 1: Get fields information
			
			dim i
			for i = 1 to rs.Fields.Count
				
				dim nType, varValue
				nType = rs.Fields(i-1).Type
				
				if (nType <> 205) then  '205=adLongBinary
				
					select case nType
						case 2    varValue = 0	 ' 2=adSmallInt
						case 3    varValue = 0	 ' 3=adInteger
						case 202  varValue = ""  ' 202=adVarWChar
						case 203  varValue = ""  ' 203=adLongVarWChar
						case else varValue = ""
					end select
				
					refVarDic.Add rs.Fields(i-1).Name, varValue	
				end if		
			next	
			
			rs.Close
			set rs = nothing
			set Init = refVarDic
		end if
	end function
	
	'* Get keys of a table.
	'* @fn FindKey
	'* @param string tablename
	'* @param vartype key_to_lookup
	'* @param reference to dictionary to hold results
	'* @return count of keys, -1 means error.
	public function FindKey(byVal strTable, byRef varDicKey, byRef varDicType)
	
		dim rs
		dim nCount
		
		' Step 0. Check parameters
		
		if strTable="" then
			FindKey = -1
			exit function
		end if
		
		' Step 1. Construct SQL
	
		set varDicKey = Server.CreateObject("Scripting.Dictionary")
		set rs = m_objConnection.OpenSchema(28)
		rs.Filter="TABLE_NAME='" &  strTable & "'" 
		
		' Step 2. Find keys.
		
		nCount = 0	
		while not rs.Eof 
			
			dim strKey 
			strKey = rs("COLUMN_NAME")
			varDicKey.Add nCount, strKey
			
			rs.Movenext
			nCount = nCount + 1
		wend
		
		' Step 3. Get types.
		
		dim strSQL
		set rs = Server.CreateObject("ADODB.Recordset")
		strSQL = "SELECT * FROM `" & strTable & "`"
		rsOpen rs, strTable, null, null
		
		dim i, nType
		for i=0 to nCount-1
			nType = rs(varDicKey(i)).Type
			
			select case nType
				case 2   nType = 1	' 2=adSmallInt
				case 3   nType = 1	' 3=adInteger
				 case else nType = 0  ' Other type
			end select
			varDicType.Add varDicKey(i), nType
		next
		
		rs.Close
		set rs = nothing	
		FindKey = nCount	
	end function
	
	'* Read a record by specified keys. 
	'* @usage Init() first, populate keys second, Read() last.
	'* @see Init()  
	public function Read(byRef refVarDic)
		
		dim nCount
		dim varDicKey
		dim strTable, strSQL
		dim rs
		
		' Step 0. Check parameters
		
		if (not m_bConnected Or not IsObject(refVarDic))then
			Read = false
			exit function
		end if
		
		strTable = refVarDic("tablename")
		if strTable="" then
			Read = false
			exit function
		end if
			
		' Step 1. Find keys for the table
		
		dim varDicType
		set varDicType = Server.CreateObject("Scripting.Dictionary")
		nCount = FindKey(strTable, varDicKey, varDicType)
		
		if nCount<=0 then
			Read = false
			exit function
		end if
			
		' Step 2. Construct SQL
		
		strSQL = "SELECT * FROM `" & strTable & "`" & " where "
		
		dim i
		for i = 0 to nCount-1
			if i>0 then strSQL = strSQL & " and "
			
			dim strKey, nType, varValue
			strKey = varDicKey(i)
			varValue = Replace(refVarDic(strKey), "'", "''")
			
			nType = varDicType(varDicKey(i))
			if nType=0 then strSQL = strSQL & strKey & " = " & "'" & varValue & "'"
			if nType=1 then strSQL = strSQL & strKey & " = " & varValue
		next
		
		' Step 3. Read.
		
		set rs = Server.CreateObject("ADODB.Recordset")
		rsOpen rs, strSQL, null, null
		
		Read = false
		
		if not rs.Eof then		
			dim j
			for j = 0 to rs.Fields.Count-1
				
				dim strFieldName
				strFieldName = rs.Fields(j).Name
				
				if refVarDic.Exists(strFieldName) then
					refVarDic(strFieldName) = rs.Fields(j).Value
				end if
				
			next	
			Read = True	
		end if
		
		rs.Close
		set rs = nothing
		set varDicType = nothing		
	end function
	
	'* Read a record by index.
	'* @fn ReadbyIndex
	'* @param refVarDic
	'* @param nIndex
	'* @param strCondition
	public function ReadbyIndex(byRef refVarDic, byVal nIndex, byVal strCondition)
		
		dim nCount
		dim strTable, strSQL
		dim rs
		
		' Step 0. Check parameters
		
		if (not m_bConnected Or not IsObject(refVarDic))then
			ReadByIndex = false
			exit function
		end if
	
		if (nIndex<0) then 	
			ReadByIndex = false
			exit function
		end if
		
		strTable = refVarDic("tablename")
		if strTable="" then
			ReadByIndex = false
			exit function
		end if
			
		' Step 1. Construct SQL
		
		strSQL = "SELECT * FROM `" & strTable & "`" 
		if Len(strCondition)>0 then
			strSQL = strSQL & " where " & strCondition
		end if	
		
		' Step 2. Read.
		
		set rs = Server.CreateObject("ADODB.Recordset")
		rsOpen rs, strSQL, null, null
		
		if not rs.Eof then rs.Move nIndex
		
		ReadByIndex = false
		
		if not rs.Eof then
			dim j
			for j = 0 to rs.Fields.Count-1			
				dim strFieldName
				strFieldName = rs.Fields(j).Name
				
				if refVarDic.Exists(strFieldName) then
					refVarDic(strFieldName) = rs.Fields(j).Value
				end if			
			next		
			ReadByIndex = True		
		end if
			
		rs.Close
		set rs = nothing		
	end function
	
	'* Adds a new record.
	'* @fn Add
	'* @usage Init() first, populate values then, Add() last.
	'* @param valVarDic the dictionary containing values to add to the database
	'* @see Init()
	function Add(byVal valVarDic)
		
		dim nCount
		dim strSQL, strTable
		dim varDicKey
		dim rs
		
		' Step 0. Check parameters
		
		if (not m_bConnected Or not IsObject(valVarDic))then
			Add = false
			exit function
		end if
		
		strTable = valVarDic("tablename")
		if strTable="" then
			Add = false
			exit function
		end if
		
		' Step 1. Find keys for the table
	
		dim varDicType
		set varDicType = Server.CreateObject("Scripting.Dictionary")
		nCount = FindKey(strTable, varDicKey, varDicType)
	
		if nCount<=0 then
			Add = false
			exit function
		end if
		
		' Step 2. Construct SQL
		
		strSQL = "SELECT * FROM `" & strTable & "`" & " where "
		
		dim i
		for i = 0 to nCount-1
			dim strKey, strValue, nType
			
			if i>0 then
				strSQL = strSQL & " and "
			end if
			
			strKey = varDicKey(i)
			nType = varDicType(strKey)
			
			strValue = Replace(valVarDic(strKey), "'", "''")
			if nType=1 then strSQL = strSQL & strKey & " = " & strValue
			if nType=0 then strSQL = strSQL & strKey & " = " & "'" & strValue & "'"
		next		
		
		' Step 3. Check if exists already
	
		set rs = Server.CreateObject("ADODB.Recordset")
	
		on error resume next
		
		if not rsOpen(rs, strSQL, adOpenKeyset, adLockPessimistic) then
			Add = false
			set rs=noting
			exit function
		end if
		
		if not rs.Eof then
			Add = false
			rs.Close
			set rs=nothing
			exit function
		end if
		
		' Step 4. Add
		
		rs.AddNew
		
		dim j
		for j = 0 to rs.Fields.Count-1
				
			dim strFieldName
			strFieldName = rs.Fields(j).Name
			rs(strFieldName) = valVarDic(strFieldName)
				
		next
		
		rs.Update
	
		if Err.number<>0 then 
			Add = false
			rs.Close
			set rs=noting
			exit function	
		end if
		
		rs.Close
	
		on error goto 0
		Add = True	
		set rs=nothing
		set varDicType = nothing	
	end function
	
	
	'* Update a record.
	'* @usage Init() first, Read() second, populate new values then, Update() last.
	'*
	public function Update(byVal valVarDic)
		
		dim nCount
		dim strSQL, strTable
		dim varDicKey
		dim rs
		
		' Step 0. Check parameters
		
		if (not m_bConnected Or not IsObject(valVarDic))then
			Update = false
			exit function
		end if
		
		strTable = valVarDic("tablename")	
		if strTable="" then
			Update = false
			exit function
		end if
		
		' Step 1. Find keys for the table
	
		dim varDicType
		set varDicType = Server.CreateObject("Scripting.Dictionary")
		nCount = FindKey(strTable, varDicKey, varDicType)
	
		if nCount<=0 then
			Update = false
			exit function
		end if
		
		' Step 2. Construct SQL
		
		strSQL = "SELECT * FROM `" & strTable & "`" & " where "
		
		dim i
		for i = 0 to nCount-1
			if i>0 then strSQL = strSQL & " and "
					
			dim strKey, nType, varValue
			strKey = varDicKey(i)
			varValue = Replace(valVarDic(strKey), "'", "''")
			
			nType = varDicType(varDicKey(i))
			if nType=0 then strSQL = strSQL & strKey & " = " & "'" & varValue & "'"
			if nType=1 then strSQL = strSQL & strKey & " = " & varValue
		next		
		
		' Step 3. Check if exists.
		
		set rs = Server.CreateObject("ADODB.Recordset")
	
		on error resume next
			
		if not rsOpen(rs, strSQL, adOpenKeyset, adLockPessimistic) then
			Update = false
			set rs=nothing
			exit function
		end if
		
		if rs.Eof then
			Update = false
			rs.Close
			set rs=nothing
			exit function
		end if
		
		' Step 4. Update.
		
		dim j
		for j = 0 to rs.Fields.Count-1
				
			dim strFieldName
			strFieldName = rs.Fields(j).Name
			rs(strFieldName) = valVarDic(strFieldName)
				
		next
		
		rs.Update
	
		if Err.number<>0 then
			Update = false
			set rs=nothing
			exit function
		end if
		rs.Close
	
	on error goto 0
	
		set varDicType = nothing
		set rs=nothing	
		Update = True
	end function
	
	
	'* Get an array of records that meet the condition
	'* @return count of the array returns -1 if there was an error
	'*
	public function BuildList(byRef refArrDic(), byVal strTable, byVal strCondition)
		
		dim strSQL
		dim rs
			
		' Step 0: Check parameters
		
		if (not m_bConnected Or strTable="") then
			BuildList = -1
			exit function
		end if
		
		' Step 1: Contruct SQL statement
		
		strSQL = "SELECT * FROM `" & strTable & "`"
		
		if strCondition<>"" then
			if not instr(trim(lcase(strCondition)),"order by")=1 then strSQL = strSQL & " where "
			strSQL = strSQL & strCondition
		end if
		
		' Step 2. Conduct SQL
		
		set rs = Server.CreateObject("ADODB.Recordset")
		if (rsOpen(rs, strSQL, adOpenKeyset, adLockPessimistic)) = true then 
		
		dim nCount
		nCount = rs.RecordCount
		Redim refArrDic(nCount-1)
	
		' Step 3. Get values from database
			
		dim i
		for i = 0 to nCount-1
		
			set refArrDic(i) = Init(strTable)
	
			dim j
			for j = 0 to rs.Fields.Count-1
				
				dim strFieldName
				strFieldName = rs.Fields(j).Name
				
				if refArrDic(i).Exists(strFieldName) then
					refArrDic(i)(strFieldName) = rs.Fields(j).Value
				end if
			next	
			
			rs.Movenext
		next
		
		rs.Close
		set rs = nothing
		BuildList = nCount
		else
			BuildList = -1
		end if
	end function
	
	
	'* Execute a SQL statement on the current database connection.
	'* @param strSQL the SQL-formatted string to execute
	'*
	public function Execute(byVal strSQL)
		trace("class.db.execute: SQL='"&server.htmlencode(strSQL)&"'")
		if not m_bConnected then
			debugError("class.db.execute: Cannot execute '"&server.htmlencode(strSQL)&" because you are not connected to a database.  Use class.db.ConnectOpen() first.")
			Execute = false
			exit function
		end if
	
		dim bOK : bOK = True
	
		on error resume next
			m_objConnection.Execute strSQL
			if Err.number<>0 then 
				if instr(lcase(strSQL,"update"))=1 then m_isWritable = false
				bOK = false
			'	debugError("class.db.execute: Error executing '"&server.htmlencode(strSQL)&"'<br/> "&err.description)
			end if
			trapDBError
			incrementDBCalls	
		on error goto 0
		
		Execute = bOK
	end function
	
	
	
	'* Delete records according to specified condition
	'* @param strTable the table name from which to delete
	'* @param strCondition the SQL-formatted string contition clause
	'* @warning Will delete all records when condition=""
	'*
	public function Delete(byVal strTable, byVal strCondition)
	
		dim strSQL
		
		' Step 0. Check parameters
		
		if not m_bConnected Or strTable="" then
			Delete = false
			exit function
		end if
		
		' Step 1. Contruct SQL statement
		
		strSQL = "delete from " & strTable 
		
		if strCondition<>"" then
			strSQL = strSQL & " where " & strCondition
		end if
		
		' Step 2. Conduct SQL
	
		dim bOK : bOK = True
	
		on error resume next
			m_objConnection.Execute strSQL
			if Err.number<>0 then bOK = True
			trapError
			incrementDBCalls
		on error goto 0
	
		Delete = bOK
	end function
	
	
	'* Count record number according to the specified condition
	'*
		
	public function Count(strTable, byVal strCondition)
		dim rs, strSQL, nCount
		
		' Step 0: Check parameters
		
		if not m_bConnected Or Len(strTable)=0 then
			Count=-1
			exit function
		end if
			
		' Step 1: Construct SQL statement
		
		strSQL = "select count(*) from " &strTable
		
		if Len(strCondition)>0 then 
			strSQL = strSQL & " where " &strCondition
		end if
		
		' Step 2£ºConduct SQL
		
		set rs = Server.CreateObject("ADODB.Recordset")
		rsOpen rs, strSQL, null, null	
		
		nCount = rs(0)	
		if isNull(nCount) then nCount = 0
		Count = nCount
		
		rs.Close
		set rs = nothing
	end function
		
	public function Space(byVal strTable, byVal strField, byVal strCondition)
		dim rs, strSQL, nTotalSize
		
		' Step 0: Check parameters
		
		if not m_bConnected Or Len(strTable)=0 then
			Space=-1
			exit function
		end if
			
		' Step 1: Construct SQL statement
		
		strSQL = "select sum(mailsize) as totalsize from " &strTable
		if Len(strField)>0 then strSQL = "select sum(" & strField & ") as totalsize from " &strTable
		if Len(strCondition)>0 then  strSQL = strSQL & " where " &strCondition
		
		' Step 2£ºConduct SQL	
		
		set rs = Server.CreateObject("ADODB.Recordset")
		rsOpen rs, strSQL, adOpenKeyset, adLockPessimistic	
		
		nTotalSize = rs("totalsize")	
		if isNull(nTotalSize) then nTotalSize = 0
		Space = nTotalSize
		
		rs.Close
		set rs = nothing
	end function
	
	
	'* @return a page of records according to specified condition
	'*
	public function BuildPage(byRef refArrDic(), byVal strTable, byVal strCondition, byVal nPageIndex, byVal nMsgsPerPage, byRef nPageCount)
		
		dim strSQL
		dim rs
			
		' Step 0. Check parameters
		
		if nPageIndex<0 then nPageIndex = 0
		
		if (not m_bConnected Or strTable="") then
			BuildPage = -1
			exit function
		end if	
		
		' Step 1. Contruct SQL statement
		
		strSQL = "SELECT * FROM `" & strTable & "`"	
		if strCondition<>"" then
			strSQL = strSQL & " where " & strCondition
		end if
		
		' Step 2. Conduct SQL
		
		set rs = Server.CreateObject("ADODB.Recordset")
		rsOpen rs, strSQL, adOpenKeyset, adLockPessimistic
		
		rs.PageSize = nMsgsPerPage
		nPageCount = rs.PageCount
			
		Redim refArrDic(nMsgsPerPage)
		if eval(nPageIndex)>eval(nPageCount) then nPageIndex = nPageCount
		if not rs.Eof then rs.Move nPageIndex * nMsgsPerPage
		
		' Step 3. get values from database
		
		dim nCount
		nCount = 0
		while (nCount<nMsgsPerPage and not rs.Eof)
			set refarrDic(nCount) = Init(strTable)
			
			dim i
			for i = 0 to rs.Fields.Count-1
				dim strFieldName
				strFieldName = rs.Fields(i).Name
			
				if refArrDic(nCount).Exists(strFieldName) then
					refArrDic(nCount)(strFieldName) = rs.Fields(i).Value
				end if
			next			
			
			nCount = nCount + 1
			rs.Movenext
		wend
		incrementDbCalls()
		rs.Close
		set rs = nothing
		BuildPage = nCount
	end function
	
	
	'* @return a closed recordset of the specified table name, stored procedure, or SQL statement
	'*
	public function getRecordSet(byVal storedProcedure)
		dim rs
		set getRecordSet = nothing
		if not m_bConnected Or Len(storedProcedure)=0 then 
			exit function
		end if
		set rs = Server.CreateObject("ADODB.Recordset")
		rsOpen rs, storedProcedure, adOpenKeyset, adLockPessimistic
		set getRecordSet = rs
	end function
	
	
	'* @return an open recordset of the specified table name, stored procedure, or SQL statement
	'*
	public function openRecordSet(byVal sql)
		dim rs
		set openRecordSet = nothing
		if not m_bConnected Or Len(sql)=0 then 
			exit function
		end if
		set rs = Server.CreateObject("ADODB.Recordset")
		With rs
			.ActiveConnection = m_objConnection
			.Source = sql
			.CursorType = adOpenKeyset
			.LockType = adLockOptimistic
			.CursorLocation = adUseServer
		End With
		rsOpen rs, sql, adOpenKeyset, adLockOptimistic
		set openRecordSet = rs
	end function
	
	private sub incrementDBCalls()
		m_numCalls = m_numCalls + 1
	end sub

	
	'* @return the current number of database calls executed at time of page execution.
	'*
	public function getCallCount()
		getCallCount = m_numCalls
	end function
	
	
	
	'* Start a database transaction. A transaction must subsequently be ended in order 
	'* to commit (or rollback, on error) the db call(s).  
	'* @return false if a transaction is already open.
	'*
	public function StartTransaction()
		StartTransaction = false
		if m_inTransaction = true then 
			debugError("class.db.StartTransaction: an existing transaction was already started, please commit the transaction using EndTransaction() before attempting to start another transaction. ")
			exit function
		end if
		m_objConnection.BeginTrans
		m_inTransaction = true
		StartTransaction = true
	end function
	
	
	'* End the current Database transaction. Commit the transaction if no errors were found.
	'* @return false if there was no transaction to commit or if commit failed
	'*
	public function EndTransaction()
		EndTransaction = false
		if m_inTransaction = false then 
			debugError("class.db.EndTransaction: there is no current transaction to end. ")
			exit function
		end if
		if m_hasErrors = true then
			debugInfo("class.db.EndTransaction: the execution had errors! rolling back transaction...")
			m_objConnection.RollbackTrans
			debugInfo("class.db.EndTransaction: ...rollback complete.")
			m_hasErrors = false
		else
			debugInfo("class.db.EndTransaction: committing transaction...")
			m_objConnection.CommitTrans
			debugInfo("class.db.EndTransaction: ...commit complete.")
			EndTransaction = true
		end if
		m_inTransaction = false
	end function
	
	'* wrapper class for opening a recordset
	public function rsOpen(record_set,byVal str_sql, intCursorType, intLockType)
		rsOpen = true
		on error resume next
			err.clear
			trace("class.db.rsOpen '"&str_sql&"' CursorType:"&intCursorType&" LockType:"&intLockType)
			if isNull(intCursorType) and isNull(intLockType) then 
				record_set.open str_sql, m_objConnection
			else
				record_set.open str_sql, m_objConnection, intCursorType, intLockType
			end if
			if (err.number <> 0) or (record_set.state = 0) then 
				rsOpen = false
				debugWarning("class.db.rsOpen: no recordset returned for query '"&str_sql&"'")
			end if
			trapDBError
			incrementDBCalls
		on error goto 0
	end function
	
	
	'* Verifies the existence & connectability of the db file.
	'* @return true if the database defined in ConnectOpen() exists
	'* @see ConnectOpen
	public function Exists()
		Exists = m_bExists
	end function
	
	'* Does the current db connection have errors.
	'* @return true if the open database connection has erros
	public function hasErrors()
		hasErrors = m_objConnection.Errors.Count > 0 
	end function
	'* Get the errors for the current db connection. 
	'* @return Error object of the database
	public function getErrors()
		set getErrors = m_objConnection.Errors
	end function
	
	'* Determine if an error occurred during database operation.
	'* If error occurred then m_hasErrors set to true, and error is printed debug.
	'* @todo error logging to database/email
	private function trapDBError()
		dim i
		trapDBError = false
		if err.number <> 0 Then
			trapDBError = true
			addError err
			debugError("VBScript ERROR [" &  Err.number & "] (Ox"& Hex(Err.number) & "): " & Err.description & vbCrLf _
				& "<br/>URL: "&request.ServerVariables("URL") _
				& "<br/>SOURCE: "&Err.source)
			err.clear
		end if	
		if isObject(m_objConnection) Then
			if m_objConnection.Errors.Count > 0 Then	
				trapDBError = true
				m_hasErrors = true
				trace("The server execution encountered the following database errors:")
				for i = 0 To m_objConnection.Errors.Count
					with m_objConnection.Errors(i)
						addError m_objConnection.Errors(i)
						debugError(.source&" [Ox"& Hex(.number)& "]: " &.description & vbCrLf _
							& "<br/>URL: "&request.ServerVariables("URL") _
							& "<br/>SQL STATE: "&.SQLState _
							& "<br/>Native Error: "&.NativeError )
					end with
				next
			end if
		end if
	end function
end class	
%>
