<%	
function contentAdd()
	if myForm.wasSubmitted() = true then
		myForm.storeFormToSession()
		myForm.Action = "?add"
		set formErrors = myForm.getFormErrors()
		if formErrors.count > 0 then
			debugError("there were errors in the add page form")
			strError = "The testimonial form had the following error:<br/>"& strError &"<br/> Please use your browser's back button to modify the content."
			contentAdd = buildFormContents(null)
		else
			dim active : active = "0"
			dim email : email = "0" 
			myForm.isForNewContent = True
			if myForm.getValue("Active") <> "" Then active = "1"
			if myForm.getValue("ShowEmail") <> "" Then email = "1"
			page.setName("New "& pcase(strContent) &": "& replace(myForm.getValue(strIdField),"'","''"))
			'STEP 1:  add new record into tblPages  
			strSQL = "INSERT INTO "& strTableName &" ("& strIdField &",SortOrder, Comments, Location, Email, TestimonialDate, ShowEmail, Active) " & vbCrLf & _
				 "VALUES ('"& Replace(myForm.getValue(strIdField),"'","''") & "'" &  _
				 ", "& Replace(myForm.getValue("SortOrder"),"'","''") & "" &  _
				 ", '"& Replace(myForm.getValue("Comments"),"'","''") & "'" &  _
				 ", '"& Replace(myForm.getValue("Location"),"'","''") & "'" &  _
				 ", '"& myForm.getValue("Email") & "'" &  _
				 ", #"& CDate(myForm.getValue("TestimonialDate")) & "#" &  _
				 ", "& email &  _
				 ", "& active & ")" 			
			db.execute(strSQL)
			
			strSuccess = "<p>The "& strContent &" by '"& myForm.getValue(strIdField) &"' was added. <br/>" & vbCrLf & _
				"Would you like to <ul><li><a href='?view'>Edit another "& strContent &"</a> (View admin list)</li> " & vbCrLf & _
				"<li><a href='?create'>Create a new "& strContent &"</a></li>" & vbCrLf & _
				"<li><a href='"& globals("SITEURL") &"/testimonials.asp'>Open the public "& strContentPL &" page</a></li></ul></p>"	
			contentAdd = ""
			strError =""
		end if
	else 
		strError = "Oops, there was no form submitted!"
	end if
end function
%>