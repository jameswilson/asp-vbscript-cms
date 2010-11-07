<%
function contentUpdate()
	page.setName("Edit "&Pcase(strContent)&"")
	if myForm.wasSubmitted() = true then 
		debugInfo("admin."&strContent&".update: form was submitted, storing to the session.")
		myForm.storeFormToSession() 
		set formErrors = myForm.getFormErrors()
		if formErrors.count = 0 then
			dim fileName1 : fileName1 = myForm.fileUp("Image1",strUploadPath,strFileFormats,maxFileSize)
			dim fileName2 : fileName2 = myForm.fileUp("Image2",strUploadPath,strFileFormats,maxFileSize)
			dim dblRetailPrice, dblWholesalePrice, recommended, active
			debugInfo("admin."&strContent&".update: form had zero errors")
			active = "0"
			recommended = "0" 
			dblRetailPrice = 0
			if myForm.getValue("active") <> "" then active = "1"
			if myForm.getValue("Recommended") <> "" then recommended = "1"
			if myForm.getValue("RetailPrice") <> "" and isNumeric(myForm.getValue("RetailPrice")) then 
				dblRetailPrice = cdbl(myForm.getValue("RetailPrice"))
			end if
			if myForm.getValue("WholesalePrice") <> "" and isNumeric(myForm.getValue("WholesalePrice")) then
				dblWholesalePrice = cdbl(myForm.getValue("WholesalePrice"))
			end if 
			strError = "an error was encountered during "&strContent&" data update to database"
			debug("updating database content for "&strContent&" '"&myForm.getValue(strIdField)&"'")
			dim SQL_UPDATE : set SQL_UPDATE = new FastString
			SQL_UPDATE.add "UPDATE "&strTableName&" SET " & vbcrlf 
			SQL_UPDATE.add 	"  "&strTableName&".PID='"& replace(myForm.getValue("PID"),"'","''") & "'" & vbcrlf 
			SQL_UPDATE.add 	", "&strTableName&".Category='"& replace(myForm.getValue("Category"),"'","''") & "'" & vbcrlf 
			SQL_UPDATE.add 	", "&strTableName&".Brand='"& replace(myForm.getValue("Brand"),"'","''") & "'" & vbcrlf 
			SQL_UPDATE.add 	", "&strTableName&".ProductLine='"& replace(myForm.getValue("ProductLine"),"'","''") & "'" & vbcrlf 
			SQL_UPDATE.add 	", "&strTableName&".ProductName='"& replace(myForm.getValue("ProductName"),"'","''") & "'" & vbcrlf
			SQL_UPDATE.add 	", "&strTableName&".Options='"& replace(myForm.getValue("Options"),"'","''") & "'" & vbcrlf 
			SQL_UPDATE.add 	", "&strTableName&".ShortDescription='"& replace(myForm.getValue("ShortDescription"),"'","''") & "'" & vbcrlf
			SQL_UPDATE.add 	", "&strTableName&".LongDescription='"& replace(myForm.getValue("LongDescription"),"'","''") & "'" & vbcrlf 
			if fileName1 <> "" then 
				SQL_UPDATE.add 	", "&strTableName&".Image1='"& strUploadPath & fileName1 & "'" & vbcrlf 
			end if
			if fileName2 <> "" then 
				SQL_UPDATE.add 	", "&strTableName&".Image2='"& strUploadPath & fileName2 & "'" & vbcrlf 
			end if
			SQL_UPDATE.add 	", "&strTableName&".RetailPrice="& dblRetailPrice & vbcrlf 
			SQL_UPDATE.add 	", "&strTableName&".WholeSalePrice="& dblWholesalePrice  & vbcrlf 
			SQL_UPDATE.add 	", "&strTableName&".Active="& active & vbcrlf 
			SQL_UPDATE.add 	", "&strTableName&".Recommended="& recommended & vbcrlf 
			SQL_UPDATE.add 	" WHERE "&strTableName&"."&strKey&"="&myForm.getValue(strKey)
			'writeln("<pre>"&SQL_UPDATE.value&"</pre>")
			db.execute(SQL_UPDATE.value)
			
			
			strStatus = "The '"& myForm.getValue(strIdField) &"' "&strContent&" was successfully updated. <br/>" & vbcrlf & _
					"Would you like to <ul>"& vbcrlf & _
					"<li><a href='"&objLinks.item("SITEURL")&"/products.asp?pid="&myForm.getValue("PID")&"' target='_blank'>View '"&myForm.getValue(strIdField)&"' On Live Site</a></li>" & vbcrlf & _
					"<li><a href='?view'>Return to "&Pcase(strContent)&" List</a></li>" & vbcrlf & _
					"<li><a href='?create'>Create a New "&Pcase(strContent)&"</a></li>"& vbcrlf & _
					"<li><a href='?edit="&myForm.getValue(strKey)&"'>Edit "&Pcase(strContent)&" '"&myForm.getValue(strIdField)&"' Again</a></li></ul>" 
					
			strError = ""
		else 
			strError = "The "&strContent&" edit form had the following error:<br/>"&strError&"<br/>"
			contentUpdate = buildFormContents(myForm.getValue(strKey))
		end if
	else
		strError = "No "&strContent&" was selected to update!  Please <a href='?view'>Select A "&Pcase(strContent)&"</a> to edit."
	end if
end function
%>