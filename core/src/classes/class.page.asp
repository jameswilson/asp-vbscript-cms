
<%
'class AspPage encapsulates Page Data as stored in database tblPages and tblPageContent

'dim customMessage : customMessage = session.contents("CustomMessage")
'session.contents("CustomMessage")=""

class AspPage
	
	private m_filepath
	private m_name
	private m_PID
	private m_title
	private m_filename
	private m_path
	private m_info
	private m_metadata    
	private m_charset
	private m_Errors
	private m_moduleList
	private m_exists
	private m_modules
	private m_hasModules
	private m_securityLevel
	private m_stylesheet
	private m_hasStyleOverride
	private m_breadcrumbs
	private m_breadcrumbDivider
	private m_useCustomContent
	
	'============================
	'    INITIALIZATION CODE
	'============================

	'called at creation of instance
	private sub class_Initialize()
		set m_Errors = Server.CreateObject("Scripting.Dictionary") 
		set m_moduleList = Server.CreateObject("Scripting.Dictionary")
		set m_info = Server.CreateObject("Scripting.Dictionary")
		set m_modules = new SiteModules
		m_securityLevel = 0 'default security level is public
		m_stylesheet = "main"
		m_hasStyleOverride = false
		redim m_breadcrumbs(2,0)
		setCrumbDivider(globals("BREADCRUMB_DIVIDER"))
		'default filepath is the url of the ASP file that includes the Page class.
		setFile(request.ServerVariables("URL"))
	end sub
	
	'called when object instance is set to nothing
	private sub class_Terminate()
		set m_info = nothing
		set m_Errors = nothing
		set m_metadata = nothing
		set m_modules = nothing
	end sub

	' set the internal scripting dictionary of 
	' page data from the Database for this Page object.
	' The dictionary contains a combination of page
	' metadata from tblPages as well as the latest page
	' content from tblPagesContent.  The keys in the 
	' dictionary are the field names from the recordset
	' returned by the database query. 
	' RETURN true if page was initialized correctly
	' RETURN false if no content found or there was an error
	private function initialize(filepath)
		debugInfo("initializing file at path " & filepath)
		m_exists = false
		initialize = false
		setCharEncoding(DEFAULT_ENCODING)
		m_path = split(filepath, "/")
		m_filename = m_path(ubound(m_path))
		m_filepath = replace(filepath, globals("PROJECT_NAME") & "/","")
		if left(m_filepath,1) = "/" then 
			m_filepath = mid(m_filepath, 2, len(m_filepath))
		end if
		
		set m_info = Server.CreateObject("Scripting.Dictionary")
		dim id
		if isNull(m_filepath) or m_filepath = "" then 
			debugWarning("class.page.init: filepath must be non-null")
		else 
			if lcase(m_filepath) = "default.asp" then
				set m_info =  getHomepageData()
			else
				set m_info = getPageDataByFileName(m_filepath)
			end if
			debug("class.page.init: page data dict size "&m_info.count)
			id = m_info.item("PageID")
			if m_info.count = 0 or id = "" then
				debugWarning("class.page.init: no id found for filepath '"&m_filepath&"'")
				initialize = true
			else
				trace("class.page.init: obtaining page data for id '"&id&"'")
				m_hasModules = m_modules.setPage(id)
				if m_hasModules = true then
					debugInfo("class.page.init: page has "&m_modules.count&" custom m_modules to display")
				else
					debugInfo("class.page.init: page has NO custom m_modules to display!")
				end if 
				m_name = m_info.item("PageName")
				m_filepath = m_info.item("PageFileName")
				m_PID =  m_info.item("PageID")
				m_title = iif(len(trim(m_info.item("PageTitle")))>0,m_info.item("PageTitle"),m_name)
				m_exists = true
				initialize = true
			end if		
		end	if
		m_title = trim(m_title) & globals("TITLE_DIVIDER") & globals("TITLE")
		initPageGlobals()		
		trace(toString)
	end function
	
	private function initPageGlobals()
		addGlobal "PAGENAME", getName, null 
		addGlobal "FILENAME", getFileName, null
		addGlobal "FILEPATH", getFilePath, null
		addGlobal "PAGE_ENCODING", getCharEncoding, null
		addGlobal "PAGE_TITLE", getTitle, null
	end function

	private function addError(strErrorMessage)
		m_Errors.add "" & m_Errors.count, strErrorMessage
	end function
	
	'return the dictionary object of Errors for this page
	public function getErrors()
		set getErrors = m_Errors
	end function
	
	're-initialize this Page with the specified file
	'returns FALSE if an error was encountered
	public function setFile(filename)
		dim result
		debug("class.page.setFile: '"& filename &"'")
		if isNull(filename) or filename = "" then 
			debugWarning("class.page.setFile: non-null filename required")
			result = false
		else
			result = initialize(filename)
			if result = true then
				trace("class.page.setFile: page initialized successfully")
			else
				debugError("class.page.setFile: There was an error initializing the page")
			end if
		end if
		setFile = result
	end function
	
	public function setSecurityLevel(intLevel)
		m_securityLevel = cint(intLevel)	
	end function
	
	public function getSecurityLevel()
		getSecurityLevel = m_securityLevel
	end function
	
	'**
	'* Change the Page's character encoding.
	'* @return (bool)
	'*   Returns FALSE if an error was encountered.
	public function setCharEncoding(strCharSet)
		trace("class.page.setCharEncoding: '"&strCharSet&"'")
		m_charset = strCharSet
	end function

	'**
	'* Retrieve the Page's character encoding.
	'* @return string 
	'*   Returns the current Page's character encoding.
	public function getCharEncoding()
		getCharEncoding = m_charset
	end function

	'**
	'* Retrieve the Page's metadata formatted for display in the HEAD tag.
	'*
	public function getMetaData()
		dim a : set a = new FastString
		a.add "<meta http-equiv=""content-type"" content=""text/html; charset="& getCharEncoding &""" />"& vbCrLf
		if getDescription <> "" then
			a.add "<meta name=""description"" content="""& getDescription &""" />"& vbCrLf
		end if
		if getKeywords <> "" then
			a.add "<meta name=""keywords"" content="""& getKeywords &""" />"& vbCrLf
		end if
		getMetaData = a.value
		set a = nothing
	end function
	
	'**
	'* Retrieve the Page's description.
    '* Useful for display in the description metadata HTML tag.
	'*
	public function getDescription()
		getDescription = globals("DESCRIPTION")
		if m_info.item("PageDescription") <> "" then 
			getDescription = getDescription &" "& replace(m_info.item("PageDescription"), """", "'")
		end if
	end function

	'**
	'* Retrieve the Page's keywords.
    '* Useful for display in the keywords metadata HTML tag.
	'*
	public function getKeywords()
		getKeywords = globals("KEYWORDS") 
		if m_info.item("PageKeywords") <> "" then 
			getKeywords = getKeywords & " " & replace(m_info.item("PageKeywords"),"""","'")
		end if
	end function

	'**
	'* Retrieve the Page's name, useful for display in the title and elsewhere.
	'* If no page name has been specifically set, then the name defaults to a
    '* formatted and capitalized version of the filename without the file 
	'* extension. 
	'* 
	'* For example:   our_services.asp => Our Services
	'* 
	'* @return string
	'*   The current Page's name.
	'*
	public function getName()
		if m_name <> "" then
			getName = m_name
		else
			getName = PCase(PrettyText(m_filename)) 
		end if
	end function

	'**
	'* Change the Name of the current page.
	'* If no pagename is specifically set, then the pagename defaults to the 
	'* filename, without a file extension.
	'* 
	'* @param string name
	'*    the current Page's name.
	'* @see Page.getName()  
	public function setName(name)
		m_name = name
	end function

	'**
	'* Retrieve the Page's title. Useful for display in the TITLE tag.
	'* If no page title is specifically set, then the title defaults to the 
	'* Page's name. There is a special case for formatting the Page titles of 
	'* administration pages.
	'* @return string title
	'*   the current Page's title.
	'* @see Page.getName()
	public function getTitle()
		
		' Use pagename if title doesnt exist.
		if m_title = "" then
			m_title = getName()
		end if
		
		' The title must be entity-encoded.
		getTitle = encode(m_title)
		
		' Special case handling for administrative pages.
		if isAdminPage = TRUE then
			getTitle = " Administer " & m_title & globals("TITLE_DIVIDER") & globals("TITLE") &" ["&PRODUCT_BRANDING&" "&PRODUCT_VERSION&"]"
		end if
	end function
	
	public function setTitle(title)
		m_title = title
	end function

	' return a Dictionary object of the Parent Page
	public function getParentPage()
		set getParentPage = getPageDataById(m_info.item("ParentPage"))
	end function
	
	'return the parent page name string of the current Page 
	public function getParentPageName()
		getParentPageName = getParentPage.item("PageName")
	end function
	
	'return the parent page id string of this Page 
	'return "0" if page has no parent
	'return the empty string if page doesnt exist
	public function getParentPageId()
		getParentPageId = m_info.item("ParentPage")
	end function
	
	'return the file name with no formatting, including the file extension (.asp)
	public function getFileName()
		getFileName = m_filename
	end function
	
	'TODO: move this functionality to globals or somewhere else because it 
	' has nothing to do with a page, but more has to do with the site.
	public function getRootPath()
		getRootPath = globals("ROOT_PATH")
	end function
	
	'returns the relative path/filename of the Page, based off of the site root.
	public function getFilePath()
		getFilePath = m_filepath
	end function
	
	public function addBreadcrumb(strName, strURL)
		debugInfo("adding BREADCRUMB: '" & strName & "' url '" & strURL & "'")
		dim lastCrumb : lastCrumb = ubound(m_breadcrumbs, 2)
		debugInfo("number of crumbs is  '"&lastCrumb&"'")
		if lastCrumb = 0 and len(m_breadcrumbs(0, lastCrumb)) > 0 and len(m_breadcrumbs(1, lastCrumb)) > 0 then
			lastCrumb = lastCrumb + 1
		end if
		redim preserve m_breadcrumbs(2, lastCrumb)
		m_breadcrumbs(0, lastCrumb) = strURL
		m_breadcrumbs(1, lastCrumb) = strName
	end function
	
	public function setCrumbDivider(strDivider)
		m_breadcrumbDivider = " " & trim(strDivider) & " "
	end function

	public function getBreadcrumbs()
		dim i, url, name, title, str
		on error resume next
		for i=0 to ubound(m_breadcrumbs, 2)
			url = m_breadcrumbs(0, i)
			name = m_breadcrumbs(1, i)
			title = "Open "& name
			debugInfo("adding breadcrumb '"&i&"'")
			debugInfo("... url '"& url &"', name '"& name &"'")
			str = str & a(url, name, title, null) & m_breadcrumbDivider
		next
		getBreadcrumbs = str & getName 
	end function
	
	public function getId()
		getId = m_PID
	end function
	
	public function getStyle()
		if not m_hasStyleOverride then
			if len(m_info.item("Style")) > 0 then
				if fileExists("/styles/" & m_info.item("Style") & ".css") then
					m_stylesheet = m_info.item("Style")
				end if
			end if
		end if
		writeln(link(globals("SITEURL") & "/styles/" & m_stylesheet & ".css", "stylesheet", "text/css"))
		if (isIE60() = true) and (fileExists("/styles/css-framework/ie.css") = true) then
			writeln("<!--[if lt IE 7]>")
			writeln(link(globals("SITEURL") & "/styles/css-framework/ie.css", "stylesheet", "text/css"))
			writeln("<![endif]-->")
		end if
		if isDebugMode() = true then 
			writeln(link(globals("SITEURL") & "/core/assets/style/debug.css", "stylesheet", "text/css") )
		end if
		if isIE() = true then 
			writeln("<script type=""text/javascript"" src=""" & globals("SITEURL") &"/core/assets/scripts/sfhover.js""></script>" )
		end if
	end function
	
	
	' Apply a specific style sheet to this page. The 
	' specified string must be the name of a single file 
	' with no extension (no .css at the end). The file
	' must exist in the styles/ folder.
	'   Returns true if the file exists.
	public function setStyle(byval strStyleSheetName)
		setStyle = false
		if fileExists("/styles/" & strStyleSheetName & ".css") then
			trace("class.page.setStyle:  style set to '" & strStyleSheetName & "'")
			m_stylesheet = strStyleSheetName
			setStyle = true
		end if
	end function

	' Override all other styles applied (eg, from page info in DB) 
	' with the following stylesheet (must be a single file 
	' name, with no extension), and must exist in the styles/
	' folder.
	'   Returns true if the override is successful (if file exists).
	public function overrideStyle(byval strStyleSheetName)
		overrideStyle = FALSE
		trace("class.page.overrideStyle:  attempting to override stylesheet with '"&strStyleSheetName&"'")
		if setStyle(strStyleSheetName) = TRUE then
			m_hasStyleOverride = TRUE
			overrideStyle = TRUE
		end if	
	end function
		
	'return the content of this Page with HTML formatting
	public function getContent()
		ignoreDBContent = FALSE
		dim divOpen : divOpen = vbCrLf &"<div class=""first""><div><div class=""wrapper"">"& vbCrLf
		dim divClose : divClose = vbCrLf &"<br clear=""all""/>"& vbCrLf &"</div></div></div>"& vbCrLf
		dim a, msg, cnt 
		set a = New FastString
		on error resume next
		msg = ""&session.contents(CUSTOM_MESSAGE) 'has page provided a custom message?
		cnt = ""&session.contents("main") 'has page provided session contents for current section?
		cnt = customContent("main") 'has page implemented the customContent() function?
		on error goto 0
		session.contents.remove("main")
		session.contents.remove(CUSTOM_MESSAGE)'clear custom message once its been grabbed
		if len(msg) > 0 then 
			a.add vbCrLf & msg & vbCrLf
		end if
		if pageHasErrors = true then
			processErrors
		end if
		if exists then
			if user.isAdministrator then 
				a.add  vbCrLf & "<div class='adminedit'><a title='Edit This Page' href='"& globals("ADMINURL") &"/pages/pages.asp?edit="& m_info.item("PageID") &"'><span>Edit</span></a></div>" & vbCrLf
			end if
			a.add m_info.item("PageContent")
		end if
		if len(cnt) > 0 then 
			if m_useCustomContent = true then a.clear
			a.add vbCrLf & cnt & vbCrLf
		end if
		getContent = divOpen & EmailObfuscate(token_replace(a.value)) & divClose
		set a = nothing
		ignoreDBContent = false
	end function
	
	' set this property to true if the current page has DB content that you 
	' wish to suppress and use only the content from your customContent() implementation
	public property let ignoreDBContent(byval bIgnore) 
		m_useCustomContent = bIgnore
	end property
	
	'return an HTML formatted string of the db 
	'content found for the specified strFilePath 
	public function getContentFor(strFilePath)
		dim p : set p = new AspPage
		p.setFile(strFilePath)
		getContentFor = p.getContent
		set p = nothing
	end function

	' a wrapper function that executes functionality of Class
	' SiteModules.executeMod() subroutine.
	public sub executeMod(strHandler, strCustomSettings)
		m_modules.executeMod strHandler, strCustomSettings
	end sub	 	

	' return an HTML formatted string "summary" of content
	' from a randomly selected child element of the page at
	' the specified strFilePath
	public function getRandomChildPageContent(strFilePath)
		debugError("class.page.getRandomChildPageContent:  this method is deprecated, please use module mod_random_content instead!")
	end function
	
	
	' return true if the page has a parent
	public function hasParent()
		dim result : result = false
		if exists then
			if (getParentPageId <> "0") then
				result = true
			end if
		end if
		trace("class.page.hasParent: "&result)
		hasParent = result
	end function
	
	public function hasContent()
		dim result : result = (m_info.item("PageContent") <> "")
		hasContent = result
		trace("class.page.hasContent: "& result)
	end function
	
	public function exists()
		exists = m_exists
		trace("class.page.exists: "& m_exists)
	end function
	
	'returns true if the ADMIN_DIR is included in the file path of the current page
	public function isAdminPage()
		dim result : result = cbool(instr(getFilePath,globals("ADMIN_DIR")) > 0)
		trace("class.page.isAdminPage: getfilepath="& getFilePath)
		trace("class.page.isAdminPage: adminDir="& globals("ADMIN_DIR"))
		trace("class.page.isAdminPage: "& result)
		isAdminPage = result
	end function
	
	' return a scripting dictionary of page data for this class.page.
	' the keys in the dictionary are the database column names 
	' from tblPages and tblPageContent
	public function getPageData()
		set getPageData = m_info
	end function
	

	'**
	'* Retrieve the Page Data of the page specified by id.  The page data is 
	'* a combination of page metadata from tblPages and the most recent 
	'* modification from tblPagesContent.  The keys in the scripting dictionary
	'* are the field names from the returned database query.  
	'*
	'* @param String pageID
	'*   The PageID who's PageData you want to retrieve.
	'* @return Scripting Dictionary
	'*   The PageData object.
	public function getPageDataById(pageID)
		dim rs, sd, key, val, counter, i, sql
		set sd = Server.CreateObject("Scripting.Dictionary")
		debug("class.page.getPageDataById:  getting page data for pageID '"& pageID &"'...")
		if isNull(pageID) or pageID = "" then 
			debugWarning("class.page.getPageDataById: non-null pageID required")
		else 
			sql = "SELECT TOP 1 tblPages.*, tblPageContent.ContentID, tblPageContent.PageContent, tblPageContent.ModifiedDate "_
			&"FROM tblPages LEFT JOIN tblPageContent ON tblPages.PageID = tblPageContent.PageID "_
			&"WHERE (((tblPages.PageID)="& pageID &")) "_
			&"ORDER BY tblPageContent.ContentId DESC;"
			set rs = db.getRecordSet(sql)
			
			
			if rs.state > 0 then
				if rs.EOF and rs.BOF then
					debugError("class.page.getPageDataById: no database content found for page with id '"&id&"'.")
					addError("There is no page for id '"&id&"'.<br/>" & _
					"Would you like to  <a href='?view'>go back to the list</a> "& _
					"or <a href='?create'>create a new one</a>?")
				else
					rs.movefirst
					counter = rs.fields.count		
					do until rs.EOF
						trace("class.page.getPageDataById: the following database content found for page with id '"&id&"':")				
						for i=0 to counter-1
							key = ""&rs.fields.item(i).name
							val = ""&rs(i)
							trace("[ "&key&" -&gt; "&Server.HTMLEncode(""&val)&" ]")
							if not sd.exists(key) then
								sd.add key, val
							else
								debugWarning("class.page.getPageDataById: id '"&id&"' is not unique!")
								debugError("class.page.getPageDataById: expected a single record but found that the recordset has multiple when field '"&rs.fields.item(i).name&"' returned a second value.")
							end if
						next
						rs.movenext
					loop
					trapError
				end if
			end if
		end if
		set getPageDataById = sd
	end function
	
	public function getModuleById(id)
		m_modules.getModuleById(id)
	end function
	
	public function getHomepageData()
		dim rs, sd, key, val, counter, i, sql
		set sd = Server.CreateObject("Scripting.Dictionary")
		debug("class.page.getHomepageData:  getting homepage data...")
		sql = "SELECT TOP 1 tblPages.*, tblPageContent.ContentID, tblPageContent.PageContent, tblPageContent.ModifiedDate "_
			&"FROM tblPages "_
			&"LEFT JOIN tblPageContent ON tblPages.PageID = tblPageContent.PageID "_
			&"WHERE ( "_
			&"  (tblPages.PageFileName='Default.asp') "_
			&"  OR (tblPages.PageFileName='default.asp') "_
			&"  OR (Active=True AND MenuIndex=0 AND ParentPage=0) "_
			&" ) "_
			&"ORDER BY tblPages.PageID, tblPageContent.ContentId DESC;"
		set rs = db.getRecordSet(sql)
		if rs is nothing then 
			debugError("class.page.getHomepageData: database could not be found.")
		elseif rs.state > 0 then
			if rs.EOF and rs.BOF then
				debugError("class.page.getHomepageData: no homepage could be found in the database.")
			else
				rs.movefirst
				counter = rs.fields.count		
				do until rs.EOF
					trace("class.page.getHomepageData: the following homepage content was found:")				
					for i=0 to counter-1
						key = ""&rs.fields.item(i).name
						val = ""&rs(i)
						trace("[ "&key&" -&gt; "&Server.HTMLEncode(""&val)&" ]")
						if not sd.exists(key) then
							sd.add key, val
						else
							debugError("class.page.getHomepageData: expected a single record but found that the recordset has multiple when field '"&rs.fields.item(i).name&"' returned a second value.")
						end if
					next
					rs.movenext
				loop
				trapError
			end if
		end if
		set getHomepageData = sd	
	end function
	
	
	public function getPageDataByFileName(strFilePath)
		dim rs, sd, key, val, counter, i, sql
		set sd = Server.CreateObject("Scripting.Dictionary")
		debug("class.page.getPageDataByFileName:  getting page data for path '"&strFilePath&"'...")
		if isNull(strFilePath) or strFilePath = "" then 
			debugWarning("class.page.getPageDataByFileName: non-null path required")
		else 
			sql = "SELECT TOP 1 tblPages.*, tblPageContent.ContentID, tblPageContent.PageContent, tblPageContent.ModifiedDate "_
			&"FROM tblPages LEFT JOIN tblPageContent ON tblPages.PageID = tblPageContent.PageID "_
			&"WHERE (((tblPages.PageFileName)='"&strFilePath&"')) "
			if instrrev(strFilePath,"/") = len(strFilePath) then sql = sql & "OR (((tblPages.PageFileName)='"&left(strFilePath,len(strFilePath)-1)&"')) OR (((tblPages.PageFileName)='"&strFilePath&"default.asp'))  OR (((tblPages.PageFileName)='"&strFilePath&"Default.asp'))"
			sql = sql &"ORDER BY tblPageContent.ContentId DESC;"
			set rs = db.getRecordSet(sql)
			
			
			if (rs is nothing) then
				debugError("class.page.getPageDataByFileName: database returned no result for query: " & sql)
			elseif rs.state > 0 then
				if rs.EOF and rs.BOF then
					debugError("class.page.getPageDataByFileName: no database content found for page with path '"&strFilePath&"'.")
					addError("There is no page for path '"&strFilePath&"'.<br/>" & _
					"Would you like to  <a href='?view'>go back to the list</a> "& _
					"or <a href='?create'>create a new one</a>?")
				else
					rs.movefirst
					counter = rs.fields.count		
					do until rs.EOF
						trace("class.page.getPageDataByFileName: the following database content found for page with path '"&strFilePath&"':")				
						for i=0 to counter-1
							key = ""&rs.fields.item(i).name
							val = ""&rs(i)
							trace("[ "&key&" -&gt; "&Server.HTMLEncode(""&val)&" ]")
							if not sd.exists(key) then
								sd.add key, val
							else
								debugWarning("class.page.getPageDataByFileName: filePath '"&strFilePath&"' is not unique!")
								debugError("class.page.getPageDataByFileName: expected a single record but found that the recordset has multiple when field '"&rs.fields.item(i).name&"' returned a second value.")
							end if
						next
						rs.movenext
					loop
					trapError
				end if
			end if
		end if
		set getPageDataByFileName = sd	
	end function
	
	'return the unique database ID string for the page with the specified name
	private function getPageIdByName(strName)
		dim rs, sql
		if isNull(strName) or strName = "" then 
			debugWarning("class.page.getPageIdByName: non-null name required")
		else 
			sql="SELECT tblPages.PageID "_
				 &"FROM tblPages "_
				 &"WHERE (((tblPages.PageName)='"&strName&"'));"

			set rs = db.getRecordSet(sql)
			if rs.EOF and rs.BOF then
				debugWarning("class.page.getPageIdByName: no id for page with name '"& strName& "'.")
				getPageIdByName = ""
			else
				debug("class.page.getPageIdByName: relative file path '"&strFilePath&"' found with id '"&rs(0)& "'.")
				getPageIdByName = rs(0)
			end if
		end if
	end function
	
	'return the unique database ID string for the page with the specified relative file path 
	public function getPageIdByFilePath(strFilePath) 
		debugWarning("page.class.getPageIdByFilePath: this method is deprecated,  please create a new page and use the getId() method")
		'dim rs
		'if isNull(strFilePath) or strFilePath = "" then 
			'debugWarning("class.page.getPageIdByFilePath: non-null filepath required")
		'else 
			'debug("class.page.getPageIdByFilePath: query database for PageId by FilePath '"&strFilePath&"'")
			'set rs = db.getRecordSet("SELECT * FROM tblPages WHERE PageFileName LIKE '"&strFilePath&"'")
			'if nCount = -1 then
				'debugError("class.page.getPageIdByFilePath: database error occurred while retrieving id for '"&strFilePath&"'.")
			'elseif nCount = 0 then
				'debugWarning("class.page.getPageIdByFilePath: no id for page with relative file path '"& strFilePath& "'.")
				'getPageIdByFilePath = ""
			'else
					'debug ("class.page.getPageIdByFilePath: relative file path '"&strFilePath&"' found with id '"&rs(0)("PageID")& "'.")
					'getPageIdByFilePath = rs(0)("PageID")
			'end if
			
		'end if
	end function

	public function toString()
		dim a : set a = new FastString 
		a.add "class.page.PageId = '"&m_PID&"'"& vbCrLf
		a.add "class.page.PageName = '"&m_name&"'"& vbCrLf
		a.add "class.page.FilePath = '"&m_filepath&"'"& vbCrLf
		a.add "class.page.FileName = '"&m_filename&"'"& vbCrLf
		toString = a.value
		set a = nothing
	end function
	

	
	
	'Summary:  
	'          Process this page's m_modules registered at the specified location. 
	'
	'Example: 
	'          Provided the following locations 'main,sub,local' exist as valid 
	'          module locations registered in the database.
	' 
	'            <html>
	'            <body>
	'             <div id="main">
	'               <%=page.display("main") % >
	'             </div>
	'             <div id="sub">
	'               <%=page.display("sub") % >
	'             </div>
	'             <div id="local">
	'               <%=page.display("local") % >
	'             </div>
	'            </body>
	'            </html>
	'
	public function display(strLocation)
		if not db.exists() then response.write(getSampleContent(strLocation))
		trace("class.page.display('"&strLocation&"') ...")
		if strLocation = "main" then response.write(getContent)
		'temporary fixes to make sure default information displays in the correct places
		if strLocation = "local" then response.write(getLocalLinks)
		if strLocation = "footer" then getFooter
		if strLocation = "header" then getHeader
		if strLocation = "nav" then getNavBar
		if strLocation = "meta" then getMeta
		if strLocation = "analytics" then getAnalytics
		if strLocation = "banner" then response.write(getBanner)
		m_modules.display(strLocation)
		trace("...end class.page.display('"&strLocation&"')")
	end function
	
	
  ' return a string of the html formatted link structure 
	' of children and siblings of this Page
	public function getLocalLinks()
		dim a, id, sql
		set a = New FastString
		dim rsLocalPages, strLocalLink, objLocalList, strHeading
		if not exists then 
			debugWarning("class.page.getLocalLinks: no local links to get for non-existent page")
		else 
			if hasParent then 
				'get siblings having same parent page id
				id = getParentPageId
				strHeading = getParentPageName
				debug("class.page.getLocalLinks: obtaining siblings of "&getName&" also having ParentPage id '"&id&"'")
			else
				'get children that have my id as a parent page
				id = getId
				strHeading = getName
				debug("class.page.getLocalLinks: obtaining children of "&strHeading&" with id '"&id&"'")
			end if 
			sql = "SELECT tblPages.* FROM tblPages WHERE (((tblPages.ParentPage)="&id&") AND (Active=True));"
			set rsLocalPages = db.getRecordSet(sql)
			if rsLocalPages.state > 0 then 
				if rsLocalPages.EOF and rsLocalPages.BOF then
					debug("class.page.getLocalLinks: there are no children or siblings to list for this page")
				else
					set objLocalList = Server.CreateObject("Scripting.Dictionary")
					a.add vbCrLf 
					a.add indent(3) &	"<ul>" & vbCrLf 
					rsLocalPages.MoveFirst
					do until rsLocalPages.EOF
						strLocalLink = indent(3) & CreateNavLink(rsLocalPages("PageFileName"), rsLocalPages("PageName"), rsLocalPages("PageLinkHoverText"),"") & "</li>" & vbCrLf
						a.add strLocalLink 
						trapError
						rsLocalPages.MoveNext
					Loop
					a.add indent(3) &	"</ul>" & vbCrLf
				end if
			end if
			
		end if
		if len(a.value)>0 then 
			getLocalLinks = "<div id=""local-links""><div><div class=""wrapper"">"&a.value&"</div></div></div>"
		else
			getLocalLinks = ""
		end if
		set a = nothing
	end function
	
	public function getBanner()
		if fileExists(DEFAULT_BANNER) then 
			dim a : set a = new FastString
			a.add indent(2) & "<div class=""banner"">" & vbCrLf
			a.add indent(2) & img(globals("BANNER"),"Banner Image",globals("BANNER_TITLE"),"banner")
			a.add indent(2) & "</div>"
			getBanner = a.value
			set a = nothing
		else
			getBanner = ""
		end if
	end function
		
	public function getHeader()
		%><!--#include file="../../../public/include/header.asp" --><%	
	end function
	
	public function getFooter()
		%><!--#include file="../../../public/include/footer.inc" --><%
	end function
	
	public function getNavBar()
		%><!--#include file="../../../public/include/menubar.asp"--><%
	end function
	
	public function getMeta()
		%><!--#include file="../../../public/include/meta.inc"--><%
		writeln(getStyle())
	end function
	
	public function getAnalytics()
		%><!--#include file="../../include/utils/google-analytics.asp"--><%
	end function
	
	public function getSampleContent(strLocation)
		select case strLocation
			case "local", "sub" 
				getSampleContent = "<div><div><div class=""wrapper"">"&replace(globals("BOILERPLATE_CONTENT"),"Section",PCase(strLocation))&"</div></div></div>"
			case else
				getSampleContent = ""
		end select
	end function
end class
%>

