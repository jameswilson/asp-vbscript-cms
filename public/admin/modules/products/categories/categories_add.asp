<%	
function contentAdd()
	myForm.Action = "?add"
	myForm.isForNewContent = true
	if myForm.wasSubmitted() = true then
		myForm.storeFormToSession()
		set formErrors = myForm.getFormErrors()
		if formErrors.count > 0 then
			strError = "there were errors in the add product form"
			contentAdd = buildFormContents(null)
			debugError(strError)
		else
			dim pid : pid = replace(myForm.getValue("PID"),"'","''")
			dim category : category = replace(myForm.getValue("Category"),"'","''")
			dim pShortDesc : pShortDesc = replace(myForm.getValue("ShortDescription"),"'","''")
			dim pLongDesc : pLongDesc = replace(myForm.getValue("LongDescription"),"'","''")
			dim pImage1 : pImage1 = replace(myForm.getValue("Image1"),"'","''")
			dim pActive : pActive = "0"
			if myForm.getValue("Active") <> "" then pActive = "1"
			page.setName(category)
			page.setTitle("New "& Pcase(strContent) &": "& category)
			'add new record into tblProducts  
			strSQL = "INSERT INTO "& strTableName &" (PID, Category, ShortDescription, LongDescription, Image1, Active) " & vbCrLf & _			
			"VALUES ('"& pid &"','"& category &"','"& pShortDesc &"','"& pLongDesc &"','"& pImage1 &"',"& pActive &")" 			
			db.execute(strSQL)
			if db.hasErrors() = true then 
				dim dbErr
				for each dbErr in db.getErrors()
					strError = strError & p(dbErr.description)
				next
			else
				strStatus = "The "& strContent &" was added successfully.<br/>" & vbCrLf & _
					"Would you like to  <a href='?view'>view the list</a> of "& strContentPL & vbCrLf & _
					"or <a href='?create'>create a new one</a>?"
				strError = ""
				contentAdd = "" 'only display formContents if there was an error
			end if
			'get new product id based on provided name
		end if
	else 
		strError = "Oops, there was no form submitted!"
	end if
end function
%>
