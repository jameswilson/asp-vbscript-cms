<%
function contentUpdate()
	page.setName("Edit "& Pcase(strContent))

	if myForm.wasSubmitted() = true then 
		debugInfo("admin."& strContentPL &".update: form was submitted, storing to the session.")
		myForm.storeFormToSession() 
		set formErrors = myForm.getFormErrors()
		if formErrors.count = 0 then
			dim active
			debugInfo("admin."& strContentPL &".update: form had zero errors")
			active = "0"
			if myForm.getValue("active") <> "" then active = "1"
			strError = "an error was encountered during category update to database"
			debug("updating database content for category '"& myForm.getValue("Category") &"'")
			dim SQL_UPDATE : set SQL_UPDATE = new FastString
			SQL_UPDATE.add "UPDATE "& strTableName &" SET " & vbCrLf 
			SQL_UPDATE.add 	"  "& strTableName &".PID='"& replace(myForm.getValue("PID"),"'","''") & "'" & vbCrLf 
			SQL_UPDATE.add 	", "& strTableName &".Category='"& replace(myForm.getValue("Category"),"'","''") & "'" & vbCrLf 
			SQL_UPDATE.add 	", "& strTableName &".ShortDescription='"& replace(myForm.getValue("ShortDescription"),"'","''") & "'" & vbCrLf
			SQL_UPDATE.add 	", "& strTableName &".LongDescription='"& replace(myForm.getValue("LongDescription"),"'","''") & "'" & vbCrLf 
			if fileName1 <> "" then 
				SQL_UPDATE.add 	", "& strTableName &".Image1='"& strUploadPath & fileName1 & "'" & vbCrLf 
			end if
			SQL_UPDATE.add 	", "& strTableName &".Active="& active & vbCrLf 
			SQL_UPDATE.add 	" WHERE "& strTableName &"."& strKey &"="& myForm.getValue(strKey)
			'writeln("<pre>"& SQL_UPDATE.value &"</pre>")
			db.execute(SQL_UPDATE.value)
			
			
			strStatus = "The database content for the '"& myForm.getValue("Category") &"' category was updated. <br/>" & vbCrLf & _
					"Would you like to <ul>"& vbCrLf & _
					"<li><a href='"& globals("SITEURL") &"/products.asp?pid="& myForm.getValue("PID") &"' target='_blank'>View '"& myForm.getValue("Category") &"' On Live Site</a></li>" & vbCrLf & _
					"<li><a href='?view'>Return to "& Pcase(strContentPL) &" List</a></li>" & vbCrLf & _
					"<li><a href='?create'>Create a New "& Pcase(strContent) &"</a></li>"& vbCrLf & _
					"<li><a href='?edit="& myForm.getValue(strKey) &"'>Edit "& Pcase(strContent) &" '"& myForm.getValue("Category") &"' Again</a></li></ul>" 
					
					
		  trace("admin."& strContentPL &".update: start file upload...")
		  dim duration : duration = timer
		  dim fileName1 : fileName1 = myForm.fileUp("Image1",strUploadPath,strFileFormats,maxFileSize)
		  trace("admin."& strContentPL &".update: ...end file upload,  duration:"& timer - duration)

			strError = ""
		else 
			strError = "The "& strContent &" edit form had the following error:<br/>"& strError &"<br/> Please use your browser's back button to modify the content."
		end if
	else
		strError = "No "& strContent &" content to update!  Please <a href='?view'>Select A "& Pcase(strContent) &"</a> to edit."
	end if
end function
%>