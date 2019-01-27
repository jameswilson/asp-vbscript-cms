<%
function contentAdd()
	myForm.Action = "?add"
	myForm.isForNewContent = true
	if myForm.wasSubmitted() = true then
		myForm.storeFormToSession()

		dim pImage1 : pImage1 = myForm.fileUp("Image1", null, strFileFormats, maxFileSize)
		debug("saving file1 as '" & pImage1 & "'")
		dim pImage2 : pImage2 = myForm.fileUp("Image2", null, strFileFormats, maxFileSize)
		debug("saving file2 as '" & pImage2 & "'")
		set formErrors = myForm.getFormErrors()
		if formErrors.count > 0 then
			strError = "there were errors in the add " & strContent & " form"
			contentAdd = buildFormContents(null)
			debugError(strError)
		else
			dim pid : pid = replace(myForm.getValue("PID"), "'", "''")
			dim category : category = replace(myForm.getValue("Category"), "'", "''")
			dim brand : brand = replace(myForm.getValue("Brand"), "'", "''")
			dim pLine : pLine = replace(myForm.getValue("ProductLine"), "'", "''")
			dim pName : pName = replace(myForm.getValue(strIdField), "'", "''")
			dim pOptions : pOptions = replace(myForm.getValue("Options"), "'", "''")
			dim pShortDesc : pShortDesc = replace(myForm.getValue("ShortDescription"), "'", "''")
			dim pLongDesc : pLongDesc = replace(myForm.getValue("LongDescription"), "'", "''")
			dim pRetail : pRetail = replace(myForm.getValue("RetailPrice"), "'", "''")
			dim pWholesale : pWholesale = replace(myForm.getValue("WholesalePrice"), "'", "''")
			pImage1 = replace(pImage1, "'", "''")
			pImage2 = replace(pImage2, "'", "''")
			dim pRecommended : pRecommended = "0"
			dim pActive : pActive = "0"
			if myForm.getValue("Active") <> "" then pActive = "1"
			if myForm.getValue("Recommended") <> "" then pRecommended = "1"
			dim insertImage1, insertImage2
			insertImage1 = ""
			insertImage2 = ""
			if pImage1 <> "" then
				insertImage1 = " Image1,"
				pImage1 = "'" & pImage1 & "',"
			end if
			if pImage2 <> "" then
				insertImage2 = " Image2,"
				pImage2 = "'" & pImage2 & "',"
			end if
			page.setName(pName)
			page.setTitle("New " & Pcase(strContent) & ": " & pName)
			'add new record into content table
			strSQL = "INSERT INTO " & strTableName & " (PID, Category, Brand, ProductLine, " & strIdField & ", Options, ShortDescription, LongDescription, RetailPrice, WholesalePrice, " & insertImage1 & insertImage2 & " Recommended, Active) " & vbCrLf & _
			"VALUES ('" & pid & "','" & category & "','" & brand & "','" & pLine & "','" & pName & "','" & pOptions & "','" & pShortDesc & "','" & pLongDesc & "','" & pRetail & "','" & pWholesale & "'," & pImage1 & pImage2 & pRecommended & "," & pActive & ")"
			if debugMode() then strWarn = "Debug Mode SQL Statement:" & codeblock(strSQL)
			db.execute(strSQL)
			if db.hasErrors() = true then
				dim dbErr
				for each dbErr in db.getErrors()
					strError = strError & p(dbErr.description)
				next
			else
				strStatus = "The " & strContent & " was added successfully.<br/>" & vbCrLf & _
					"Would you like to <a href='?view'>view the list</a> of " & strContentPL & vbCrLf & _
					"or <a href='?create'>create a new one</a>?"
				strError = ""
				contentAdd = "" 'only display formContents if there was an error
			end if		end if
	else
		strError = "Oops, there was no form submitted!"
	end if
	'if len(strError)>0 then contentAdd = ErrorMessage(strError)
end function
%>
