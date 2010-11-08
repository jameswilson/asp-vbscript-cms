<%	
function contentAdd()
	const UPLOAD_ERROR = "Upload Error"
	const UPLOAD_SUCCESS = "Upload Success"
	dim formErrors, i, customSettings, rs
	
	if myForm.wasSubmitted() = false then 
		strheader.add UPLOAD_ERROR
		strError = "No "& strContent &" to upload!  Please <a href='?create'>try again</a> to upload a "& strContent &"."
		debugError("admin.filemanager.add: "& strError)
		exit function
	end if
	
	
	dim sPath, sFileName, sf, sFile

	debugInfo("admin.filemanager.add: form was submitted, storing to the session.")
	myForm.storeFormToSession() 
	
	debugInfo("admin.filemanager.add: form had zero errors")
	sFileName = myForm.getValue("File")
	sPath = myForm.getValue("Dir")
	
	writeln( p("Path is '"& sPath &"'"))
	
	debug("admin.filemanager.add: done")
	set formErrors = myForm.getFormErrors()
	debugInfo("admin.filemanager.add: form had "& formErrors.count &" errors")
	if formErrors.count <> 0 then
		strheader.add UPLOAD_ERROR
		debugError("admin.filemanager.add: "& strError)
		pageContent.add buildFormContents(sPath)
	end if

		
		
	if len(sPath)<1 then 
		strheader.add UPLOAD_ERROR
		strError = "The path specified, '"& sPath &"' is invalid."
		debugError("admin.filemanager.add: "& strError)
		exit function
	end if
	
	set sf = new SiteFile
	sf.Path = sPath
	if not sf.fileExists then
		strheader.add UPLOAD_ERROR
		strError = "The directory you chose, '"& sPath &"', doesnt exist."
		debugError("admin.filemanager.add: "& strError)
		exit function
	end if
	debug("admin.filemanager.add: setting upload path to '"& spath &"'")
	myForm.uploadPath = sPath
	
	
	debug("admin.filemanager.add: checking existence of file...")
	if fs.FileExists(sf.absolutePath&"\"& sFileName) then
		strheader.add UPLOAD_ERROR
		strError = "Sorry a file with the same name ("& sFileName &") already exists in folder '"& sPath &"'"
		debugError("admin.filemanager.add: "& strError)
		exit function
	end if
	debug("admin.filemanager.add: sending file up...")
	sFile = myForm.fileUp("File", null,CONTENT_TYPE,MAX_FILE_SIZE)
	
	if myForm.hasErrors = true then
		debugInfo("admin.filemanager.add: form had "& formErrors.count &" errors")
		strheader.add UPLOAD_ERROR
		pageContent.add buildFormContents(sPath)
		debugError("admin.filemanager.add: "& strError)
		exit function
	end if
	debug("admin.filemanager.add: file up complete.")
	
	strheader.add UPLOAD_SUCCESS
	dim url : url = globals("SITEURL") &sf.virtualPath&"/"& sFileName
	dim link : link = anchor(url,sFileName,sFileName, "")
	strSuccess = strSuccess & p("The file '"& sFileName &"' was uploaded successfully to folder '"& sPath &"'!") & vbCrLf _
		& p("The url of the file is: <code>"& url &"</code>") & vbCrLf _
		& p("A direct link to the file: "& link) & vbCrLf _
		& p("Here is an HTML link that you can use to share your file, such as in a link in an email or on a page of your site.") & vbCrLf _
		& CodeBlock(link) & vbCrLf _
		& p("Would you like to:") & vbCrLf  _
		&	"<ul>"& vbCrLf  _
		&	"<li><a href='?view="& sPath &"/"& sFileName &"'>View your file online '"& myForm.getValue("Name") &"' Again</a></li>" & vbCrLf _
		&	"<li><a href='?view'>View """& sPath &""" Folder contents </a></li>" & vbCrLf _
		&	"<li><a href='?create'>Upload Another "& Pcase(strContent) &" </a></li>"& vbCrLf _
		&"</ul></li></ul>" & vbCrLf	
	strError = ""
end function

%>
