<%	
function contentAdd()
	if user.getRole() < USER_ADMINISTRATOR then 
		strError = "You do not have sufficient priviledges to create new "& strContentPL &"."
		exit function
	end if
	if myForm.wasSubmitted() = true then
		debugInfo("form was submitted, storing to the session.")
		myForm.storeFormToSession()
		myForm.Action = "?add"
		contentAdd = buildFormContents(null)
		set formErrors = myForm.getFormErrors()
		if formErrors.count > 0 then
			strError = "The new "& strContent &" has errors in the form"
			debugError(strError)
		else
			dim pName : pName = replace(myForm.getValue(strIdField),"'","''")
			dim pTitle : pTitle = replace(myForm.getValue("PageTitle"),"'","''")
			dim pHoverText : pHoverText = replace(myForm.getValue("PageLinkHoverText"),"'","''")
			dim pFileName : pFileName = replace(myForm.getValue("PageFileName"),"'","''")
			dim pDescription : pDescription = replace(myForm.getValue("PageDescription"),"'","''")
			dim pKeywords : pKeywords = replace(myForm.getValue("PageKeywords"),"'","''")
			dim pStyle : pStyle = replace(myForm.getValue("Style"),"'","''")
			dim pParent : pParent = 0
			dim pIndex : pIndex = 0
			dim active : active = "0"
			dim menu : menu = "0" 
			myForm.isForNewContent = True
			if myForm.getValue("Active") <> "" then active = "1"
			if myForm.getValue("MainMenu") <> "" then menu = "1"
			if len(myForm.getValue("MenuIndex")) > 0 then pIndex = myForm.getValue("MenuIndex")
			if len(myForm.getValue("ParentPage")) > 0 then pParent = myForm.getValue("ParentPage")
			page.setName(pName)
			page.setTitle("New "& PCase(strContent) &": "& pName)
			
			
			' Step 1:  Get File name.
			if pFileName = "" then 
				pFileName = lcase(pName)
				pFileName = replace(pFileName, "\", "/")
				pFileName = replace(pFileName, " /", "/")
				pFileName = replace(pFileName, "/ ", "/")
				pFileName = replace(pFileName, " ", "-")
				pFileName = replace(pFileName, ":", "-")
				pFileName = replace(pFileName, "}", "-")
				pFileName = replace(pFileName, "{", "-")
				pFileName = replace(pFileName, "[", "-")
				pFileName = replace(pFileName, "]", "-")
				pFileName = replace(pFileName, "=", "-")
				pFileName = replace(pFileName, "*", "-")
				pFileName = replace(pFileName, "&amp;", "-")
				pFileName = replace(pFileName, ",", "")
				pFileName = replace(pFileName, """", "")
				pFileName = replace(pFileName, "'", "")
				pFileName = replace(pFileName, "?", "")
				pFileName = replace(pFileName, "$", "")
				pFileName = replace(pFileName, ":", "")
				pFileName = replace(pFileName, "%", "")
				pFileName = replace(pFileName, "^", "")
				pFileName = replace(pFileName, "#", "")
				pFileName = replace(pFileName, "@", "")
				pFileName = replace(pFileName, "!", "")
				pFileName = trim(pFileName)
			end if
			dim f, path, max, i, path_write, tfile, cfolder, content, destination, urlfile,  separator, sitepath, obFile
			path = split(pFileName, "/")
			max = ubound(path)
			path_write = ""
			cfolder = ""
			separator = ""
			sitepath = globals("SITE_PATH") & "\"
			for i = 0 to max - 1
				if len(path(i)) > 0 then
					path_write = path_write & separator & path(i)
					separator="\"
					if fs.FolderExists(sitepath & path_write) = FALSE then
						debugInfo("folder '"& sitepath & path_write & "' created.")
						set f = fs.CreateFolder(sitepath & path_write)
						set f = nothing
					else
						trace("folder '"& sitepath & path_write&"' exists.")
					end if
					cfolder = cfolder & "../"				
					debugInfo(sitepath & path_write & "<br>")
				end if
			next
			
			destination = (sitepath & path_write & separator & path(max))
			content = ("<"&"%server.Execute("""& cfolder &"404.asp"")%"&">")
			urlfile = ""
			urlfile = replace(path_write & separator & path(max), "\", "/")
			set ObFile = new SiteFile
			if ObFile.write_file(destination, content, adFileIgnore) = FALSE then
				strError = "An error was encountered creating filename '"& pFileName &"'"
				strError = strError & ObFile.GetErrors()
				exit function
			end if
			
			'STEP 2:  add new record into tblPages  
			strSQL = "INSERT INTO "& strTableName &" (PageName, PageTitle, PageFileName, PageLinkHoverText, PageDescription, PageKeywords, Style, MenuIndex, ParentPage, MainMenu, Active) " & vbCrLf & _
				 "VALUES ('"& pName & "'" &  _
				 ", '"& pTitle & "'" &  _
				 ", '"& urlfile & "'" &  _
				 ", '"& pHoverText & "'" &  _
				 ", '"& pDescription & "'" &  _
				 ", '"& pKeywords & "'" &  _
				 ", '"& pStyle & "'" &  _
				 ", "& cInt(pIndex) &  _
				 ", "& cInt(pParent) &  _
				 ", "& menu &  _
				 ", "& active & ")" 			
			db.execute(strSQL)
			'get new page id based on provided name
			dim newPage, id 
			set newPage = new ASPPage
			newPage.setFile(urlfile)
			id = newPage.getId()
			
			if id = "" then 
				debugError("There was an error creating ")
				strError = "Your new "& strContent &" creation had the following error:<br/>There was an error creating a new file with name '"& pName & "'<br/>"& strError &"<br/> It appears that no ID was asigned for '"& page.getName() &"'.  Unable to complete the creation request!"
			else 
				debug("new "& strContent &" id is '"& id &"'")
				'STEP 2: add new record into tblPageContent
				strSQL = "INSERT INTO tblPageContent (PageContent, "& strKey &") " & vbCrLf & _
				 "VALUES ('"&  replace(token_encode(toXHTML(myForm.getValue("PageContent")), variableList), "'", "''") & "'" & ", '"& id & "')"
				
				db.execute(strSQL)

				contentAdd = ""
				strError = ""
				strSuccess = "The "& strContent &" '"& myForm.getValue(strIdField) &"' was added. <br/>" & vbCrLf & _
					"Would you like to  <a href='?view'>view the list</a> of current "& strContentPL &"" & vbCrLf & _
					"or <a href='?create'>create a new one</a>?"
			end if
		end if
	else 
		strError = "Oops, there was no form submitted!"
	end if
end function
%>
