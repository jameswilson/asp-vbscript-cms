<%
function contentUpdate()
	page.setName "Edit " & PCase(strContent) & ""
	if myForm.wasSubmitted() = true then
		debugInfo("admin." & strContent & ".update: form was submitted, storing to the session.")
		myForm.storeFormToSession()
		set formErrors = myForm.getFormErrors()
		if formErrors.count = 0 then
			dim intMenuIndex, intParentPage, menu, active
			debugInfo("admin." & strContent & ".update: form had zero errors")
			active = "0"
			menu = "0"
			intMenuIndex = 0
			if myForm.getValue("active") <> "" then active = "1"
			if myForm.getValue("MainMenu") <> "" then menu = "1"
			if myForm.getValue("MenuIndex") <> "" and isNumeric(myForm.getValue("MenuIndex")) then
				intMenuIndex = cint(myForm.getValue("MenuIndex"))
			end if
			if myForm.getValue("ParentPage") <> "" and isNumeric(myForm.getValue("ParentPage")) then
				intParentPage = cint(myForm.getValue("ParentPage"))
			end if
			strError = "an error was encountered during " & strContent & " data update to database"
			debug("admin." & strContent & ".update: updating database metadata content for " & strContent & "  '" & myForm.getValue(strIdField) & "'")
			dim File_Name,rs
			dim GET_FILE_NAME : GET_FILE_NAME = "SELECT PageFileName FROM " & strTableName & vbCrLf & _
							" WHERE " & strTableName & "." & strKey & "=" & myForm.getValue(strKey)
			Set rs = db.getRecordSet(GET_FILE_NAME)
			if not rs.EOF then
				File_Name = rs(0)
			end if

			if File_Name <> myForm.getValue("PageFileName") then

				'''''''''''''''''''''''''
				dim f, path, max, i, path_write, tfile, cfolder, content, destination, urlfile, separator, sitepath, obFile
				path = split(replace(myForm.getValue("PageFileName"), "/", "\"), "\")
				max = ubound(path)
				path_write = ""
				cfolder = ""
				separator = ""
				sitepath = globals("SITE_PATH") & "\"
				for i = 0 to max - 1
					if len(path(i)) > 0 then
						path_write = path_write & separator & path(i)
						separator = "\"
							if fs.FolderExists(sitepath & path_write) = false then
							debugInfo("Folder '" & sitepath & path_write & "' created!")
								set f = fs.CreateFolder(sitepath & path_write)
								set f = nothing
						else
							Trace("Folder exist!")
						end if
						cfolder = cfolder & "../"
						debugInfo(sitepath & path_write & "<br>")
					end if
				next
				destination = (sitepath & path_write & separator & path(max))
				content = ("<" & "%Server.Execute(""" & cfolder & "404.asp"")%" & ">")
				urlfile = ""
				urlfile = replace(path_write & separator & path(max), "\", "/")
				set ObFile= new SiteFile
				if obFile.move_file(File_Name, destination, content, adFileIgnore) = false then
					strError="An Error was encounter moving filename '" & File_Name & "' to '" & destination
					strError=strError & ObFile.GetErrors()
					exit function
				end if
				File_name = urlfile
				'''''''''''''''''''''''''''''''''
			end if
			dim SQL_UPDATE : SQL_UPDATE = "UPDATE " & strTableName & " SET " & vbCrLf & _
				"" & strTableName & ".Active=" & active & vbCrLf & _
				", " & strTableName & "." & strIdField & "='" & replace(myForm.getValue(strIdField), "'", "''") & "'" & vbCrLf & _
				", " & strTableName & ".PageTitle='" & replace(myForm.getValue("PageTitle"), "'", "''") & "'" & vbCrLf & _
				", " & strTableName & ".PageFileName='" & replace(File_name,"'","''") & "'" & vbCrLf & _
				", " & strTableName & ".PageLinkHoverText='" & replace(myForm.getValue("PageLinkHoverText"), "'", "''") & "'" & vbCrLf & _
				", " & strTableName & ".PageDescription='" & replace(myForm.getValue("PageDescription"), "'", "''") & "'" & vbCrLf & _
				", " & strTableName & ".PageKeywords='" & replace(myForm.getValue("PageKeywords"), "'", "''") & "'" & vbCrLf & _
				", " & strTableName & ".Style='" & replace(myForm.getValue("Style"), "'", "''") & "'" & vbCrLf & _
				", " & strTableName & ".MainMenu=" & menu & vbCrLf & _
				", " & strTableName & ".MenuIndex=" & intMenuIndex & vbCrLf & _
				", " & strTableName & ".ParentPage=" & intParentPage & vbCrLf & _
				" WHERE " & strTableName & "." & strKey & "=" & myForm.getValue(strKey)
			db.execute(SQL_UPDATE)
			strError = "an error was encountered during " & strContent & " data update to database"
			debug("admin." & strContent & ".update: inserting new " & strContent & " into database")
			dim INSERT : INSERT = "INSERT INTO tblPageContent (" & strKey & ", PageContent)" & vbCrLf & _
				"VALUES (" & myForm.getValue(strKey) & ", '" & replace(token_encode(toXHTML(myForm.getValue("PageContent")), variableList), "'", "''") & "')"
			db.execute(INSERT)


			strStatus = "The database content for the '" & myForm.getValue(strIdField) & "' " & strContent & " was updated. <br/>" & vbCrLf & _
					"Would you like to <ul>" & vbCrLf & _
					"<li><a href='?edit=" & myForm.getValue(strKey) & "'>Edit " & PCase(strContent) & " '" & myForm.getValue(strIdField) & "' Again</a></li>" & vbCrLf & _
					"<li><a href='" & globals("SITEURL") & "/" & myForm.getValue("PageFileName") & "' target='_blank'>View Your Updates For " & PCase(strContent) & " '" & myForm.getValue(strIdField) & "' On Live Site</a></li>" & vbCrLf & _
					"<li><a href='?view'>View List of All " & PCase(strContentPL) & "</a></li>" & vbCrLf & _
					"<li><a href='?create'>Create a New " & PCase(strContent) & "</a></li></ul>"
			strError = ""
		else
			strError = "The " & strContent & " edit form had the following error:<br/>" & strError & "<br/>"
			pageContent.add buildFormContents(strKey)
		end if
	else
		strError = "No " & strContent & " content to update!  Please <a href='?view'>Select A " & PCase(strContent) & "</a> to edit."
	end if
end function
%>
