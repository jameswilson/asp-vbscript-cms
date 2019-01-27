<%
function contentAdd()

	dim formErrors, i, customSettings, rs
	strheader.add "Add Module"
	strWarn = "Modules Administration is still under construction. You will see some debugging statements."
	if myForm.wasSubmitted() = true then
		debugInfo("admin.modules.add: form was submitted, storing to the session.")
		myForm.storeFormToSession()
		debug("admin.modules.add: done")
		set formErrors = myForm.getFormErrors()
		debugInfo("admin.modules.add: form had " & formErrors.count & " errors")
		if formErrors.count = 0 then
			dim intSortOrder, strPageIDs
			debugInfo("admin.modules.add: form had zero errors")
			strPageIDs = myForm.getValue("PageIDs")
			debug("admin.modules.add:  there were " & myForm.getCount("PageIDs") & " page ids selected.")
			debug("admin.modules.add:  the page ids string is: '" & strPageIDs & "'")
			if strPageIDs <> "" then
				strPageIDs = replace(strPageIDs,", ","",1,-1,1)
				strPageIDs = replace(strPageIDs,"::",":",1,-1,1)
				debug("admin.modules.add:  the processed page id string is: '" & strPageIDs & "'")
			end if
			dim key, theFormDict

			strWarn = strWarn & p("Form Contents:") & CodeBlock(urlDecode(replace(myForm.toString(), "&", vbCrLf)))
			CreateDictionary theFormDict, myForm.toString(), "&", "=",adDictOverwrite

			if theFormDict.exists("PageIDs") then theFormDict.remove("PageIDs")
			theFormDict.add "PageIDs", strPageIDs
			set customSettings = new FastString
			for each key in theFormDict
				if instr(key, "mod_") = 1 then
					customSettings.add replace(key, "mod_", "") & CUSTOMSETTINGS_FIELD_DELIMITER
					customSettings.add Server.UrlEncode(theFormDict(key)) & CUSTOMSETTINGS_RECORD_DELIMITER
				end if
			next
			theFormDict.add "CustomSettings", customSettings.value
			strWarn = strWarn & p("CustomSettings:") & CodeBlock(replace(customSettings.value, "}", "}" & vbCrLf))
			customSettings.clear
			set customSettings = nothing

			dim tmp : set tmp = new FastString
			for each key in theFormDict
				tmp.add key & " " & theFormDict(key) & vbCrLf
			next
			strWarn = strWarn & h2("Form Dictionary:") & CodeBlock(replace(tmp.value, ";", vbCrLf))
			debug("admin.modules.add: updating module settings '" & myForm.getValue("PageName") & "'")


			db.execute(CreateSQL("insert",strTableName, theFormDict, strKey))
			if db.hasErrors() = true then
				dim dbErr
				strError = "An error was encountered during " & strContent & " add to database:"
				for each dbErr in db.getErrors()
					strError = strError & p(dbErr.description)
				next
			else
			dim res
				set res = db.getRecordSet("Select MAX (Id) from tblModules where Name='" & myForm.getValue("Name") & "'")
				strSuccess = strSuccess & p("The database content for the '"& myForm.getValue("Name") &"' module was added. <br/>Would you like to:") & vbCrLf & _
					"<ul>" & vbCrLf & _
					"<li><a href='?edit=" & res(0) & "'>Edit " & Pcase(strContent) & " '" & myForm.getValue("Name") & "' Again</a></li>" & vbCrLf & _
					"<li><a href='?view'>View List of All " & Pcase(strContentPL) & " </a></li>" & vbCrLf & _
					"<li><a href='?create'>Create a New " & Pcase(strContent) &" </a></li>" & vbCrLf & _
					"<li>View changes on:<ul>" & vbCrLf
				if instr(myForm.getValue("PageIDs"), ":0:") > 0 then strSuccess = strSuccess & "<li><a href='" & globals("SITEURL") &"'>Home Page</a></li>"
				set rs = db.getRecordSet("SELECT * FROM tblPages ORDER BY Active, MainMenu, MenuIndex, ParentPage;")
				if not (rs.EOF and rs.BOF) then
					rs.movefirst
					do until rs.EOF
						if instr(myForm.getValue("PageIDs"), ":" & rs("PageId") & ":") > 0 then
							strSuccess = strSuccess & "<li><a href='" & globals("SITEURL") &"/" & rs("PageFileName") & "'>" & rs("PageName") & "</a></li>"
						end if
						rs.movenext
					loop
				end if
				strSuccess = strSuccess & "</ul></li></ul>" & vbCrLf
				strError = ""
			end if
		else
			strError = "The module edit form had the following error:<br/>" & strError & "<br/>"
			pageContent.add buildFormContents(myForm.getValue(strKey), myForm.getValue("ModType"))
		end if
	else
		strError = "No " & strContent & " content to add!  Please <a href='?create'>try again from scratch</a> to create a " & strContent & "."
	end if
end function

%>
