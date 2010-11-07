<%
function contentUpdate()
	page.setName("Edit "&Pcase(strContent)&"")
	if myForm.wasSubmitted() = false then 
		strError = "No "&strContent&" content to update!  Please go back <a href='?view'>to the list</a> and select a "&strContent&" to edit."
		exit function
	end if 
	debugInfo("admin."&strContent&".update: form was submitted, storing to the session.")
	myForm.storeFormToSession() 
	set formErrors = myForm.getFormErrors()
	contentUpdate = buildFormContents(myForm.getValue(strKey))
	if formErrors.count > 0 then
		strError = "The "&strContent&" form has errors!<br/> Please use your browser's back button to modify the content."
		exit function
	end if 
	dim intMenuIndex, intParentPage, email, active
	debugInfo("admin."&strContent&".update: form had zero errors")
	active = "0"
	email = "0" 
	if myForm.getValue("Active") <> "" then active = "1"
	if myForm.getValue("ShowEmail") <> "" then email = "1"
	strError = "an error was encountered during "&strContent&" data update to database"
	debug("admin."&strContent&".update: updating database content for "&strContent&" id '"&myForm.getValue(strKey)& "' from '"&myForm.getValue(strIdField)&"'")
	dim SQL_UPDATE : SQL_UPDATE =  "UPDATE "&strTableName&" SET " & vbcrlf & _
		""&strTableName&".Active="& active & vbcrlf & _
		", "&strTableName&"."&strIdField&"='"& Replace(myForm.getValue(strIdField),"'","''") & "'" & vbcrlf & _
		", "&strTableName&".Email='"& myForm.getValue("Email") & "'" & vbcrlf & _
		", "&strTableName&".ShowEmail="& email & vbcrlf & _
		", "&strTableName&".SortOrder='"& Replace(myForm.getValue("SortOrder"),"'","''") & "'" & vbcrlf & _
		", "&strTableName&".Comments='"& Replace(myForm.getValue("Comments"),"'","''") & "'" & vbcrlf & _
		", "&strTableName&".Location='"& Replace(myForm.getValue("Location"),"'","''") & "'" & vbcrlf & _
		", "&strTableName&".TestimonialDate=#"& CDate(myForm.getValue("TestimonialDate"))& "#" & vbcrlf & _
		" WHERE "&strTableName&"."&strKey&"="&myForm.getValue(strKey)
	db.execute(SQL_UPDATE)
	
	
	strStatus = "The "&strContent&" by "& myForm.getValue(strIdField) &" was updated. <br/>" & vbcrlf & _
			"Would you like to <ul>"& vbcrlf & _
			"<li><a href='?edit="&myForm.getValue(strKey)&"'>Edit "&strContent&" by '"&myForm.getValue(strIdField)&"' Again</a></li>" & vbcrlf & _
			"<li><a href='"&objLinks.item("SITEURL")&"/testimonials.asp#comment"&myForm.getValue(strKey)&"' target='_blank'>View changes to this "&strContent&" on live site</a></li>" & vbcrlf & _
			"<li><a href='?view'>View list of all "&strContentPL&"</a></li>" & vbcrlf & _
			"<li><a href='?create'>Add a new "&strContent&"</a></li></ul>"
	contentUpdate = ""
	strError = ""
end function
%>