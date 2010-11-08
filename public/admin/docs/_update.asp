<%
function contentUpdate()
	
	dim formErrors, i, customSettings, rs
	strheader.add "Upload File"
	if myForm.wasSubmitted() = true then 
'		debugInfo("admin.modules.update: form was submitted, storing to the session.")
'		myForm.storeFormToSession() 
'		debug("admin.modules.update: done")
'		set formErrors = myForm.getFormErrors()
'		debugInfo("admin.modules.update: form had "& formErrors.count &" errors")
'		if formErrors.count = 0 then 
'			dim intSortOrder, strPageIDs
'			debugInfo("admin.modules.update: form had zero errors")
'			strPageIDs = myForm.getValue("PageIDs")
'			debug("admin.modules.update:  there were "& myForm.getCount("PageIDs") &" page ids selected.")
'			debug("admin.modules.update:  the page ids string is: '"& strPageIDs &"'")
'			if strPageIDs <> "" then 
'				strPageIDs = replace(strPageIDs,", ","",1,-1,1)
'				strPageIDs = replace(strPageIDs,"::",":",1,-1,1)
'				debug("admin.modules.update:  the processed page id string is: '"& strPageIDs &"'") 
'			end if
'			dim key, theFormDict
'			
'			strWarn = strWarn & p("Form Contents:") & CodeBlock(urlDecode(replace(myForm.Form,"&",vbCrLf)))
'			CreateDictionary theFormDict, myForm.Form, "&","=",adDictOverwrite
'			
'			if theFormDict.exists("PageIDs") then theFormDict.remove("PageIDs") 
'			theFormDict.add "PageIDs", strPageIDs
'			set customSettings = new FastString
'			for each key in theFormDict
'				if instr(key,"mod_")=1 then
'					customSettings.add replace(key,"mod_","") & CUSTOMSETTINGS_FIELD_DELIMITER
'					customSettings.add server.urlencode(theFormDict(key)) & CUSTOMSETTINGS_RECORD_DELIMITER
'				end if
'			next
'			theFormDict.add "CustomSettings", customSettings.value
'			strWarn = strWarn & p("CustomSettings:") & CodeBlock(customSettings.value)
'			customSettings.clear
'			set customSettings = nothing			
'			
'			dim tmp : set tmp = new FastString
'			for each key in theFormDict 
'				tmp.add key & " " & theFormDict(key) & vbCrLf
'			next
'			strWarn = strWarn & h2("Form Dictionary:") & CodeBlock(replace(tmp.value,";",vbCrLf))
'			debug("admin.modules.update: updating module settings '"& myForm.getValue("PageName") &"'")
'
'		
'			db.execute(CreateSQL("update",strTableName, theFormDict, strKey))
'			if db.hasErrors() = true then 
'				dim dbErr
'				strError = "An error was encountered during "& strContent &" update to database:"
'				for each dbErr in db.getErrors()
'					strError = strError & p(dbErr.description)
'				next
'			else
'				strSuccess = strSuccess & p("The database content for the '"& myForm.getValue("Name") &"' module was updated. <br/>Would you like to:") & vbCrLf & _
'					"<ul>"& vbCrLf & _
'					"<li><a href='?edit="& myForm.getValue("ID") &"'>Edit "& Pcase(strContent) &" '"& myForm.getValue("Name") &"' Again</a></li>" & vbCrLf & _
'					"<li><a href='?view'>View List of All "& Pcase(strContentPL) &" </a></li>" & vbCrLf & _
'					"<li><a href='?create'>Create a New "& Pcase(strContent) &" </a></li>"& vbCrLf & _
'					"<li>View changes on:<ul>" & vbCrLf 
'				if instr(myForm.getValue("PageIDs"),":0:")> 0 then strSuccess = strSuccess &"<li><a href='"& globals("SITEURL") &"'>Home Page</a></li>"
'				set rs = db.getRecordSet("SELECT * FROM tblPages ORDER BY Active, MainMenu, MenuIndex, ParentPage;")
'				if not (rs.EOF and rs.BOF) then
'					rs.movefirst
'					do until rs.EOF
'						if instr(myForm.getValue("PageIDs"),":"& rs("PageId") &":")> 0 then strSuccess = strSuccess &"<li><a href='"& globals("SITEURL") &"/"& rs("PageFileName") &"'>"& rs("PageName") &"</a></li>"
'						rs.movenext
'					loop
'				end if
'				strSuccess = strSuccess &"</ul></li></ul>" & vbCrLf	
'				strError = ""
'			end if
'		else 
'			strError = "The module edit form had the following error:<br/>"& strError &"<br/>"
'			pageContent.add buildFormContents(myForm.getValue(strKey), myForm.getValue("ModType"))
'		end if
	else
		strError = "No "& strContent &"  content to update!  Please <a href='?view'>Select A "& Pcase(strContent) &" </a> to edit."
	end if
end function

	
%>