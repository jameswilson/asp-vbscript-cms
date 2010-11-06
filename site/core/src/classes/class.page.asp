
<%
'class AspPage encapsulates Page Data as stored in database tblPages and tblPageContent

const DEFAULT_ENCODING  = "iso-8859-1"
const TDIV = " &raquo; "

'dim customMessage : customMessage = session.contents("CustomMessage")
'session.contents("CustomMessage")=""

class AspPage
	
	private myFilePath
	private myPageName
	private myPageId
	private myPageTitle
	private myFileName
	private myPathArray
	private myPageDataDict
	private myMetaData
	private myCharSet
	private myPageErrorsDict
	private myModulesDict
	private bolExists
	private modules
	private hasModules
	private mySecurityLevel
	private myStyleSheet
	private hasStyleOverride
	private myBreadcrumbs
	private myCrumbDivider
	private m_useCustomContent
	
	'============================
	'    INITIALIZATION CODE
	'============================

	'called at creation of instance
	private sub class_Initialize()
		set myPageErrorsDict = Server.CreateObject("Scripting.Dictionary") 
		set myModulesDict = Server.CreateObject("Scripting.Dictionary")
		set myPageDataDict = Server.CreateObject("Scripting.Dictionary")
		set modules = new SiteModules
		mySecurityLevel = 0 'default security level is public
		myStyleSheet = "main"
		hasStyleOverride = false
		redim myBreadcrumbs(2,0)
		setCrumbDivider(TDIV)
		'default filepath is the url of the ASP file that includes the Page class.
		setFile(request.ServerVariables("URL"))
	end sub
	
	'called when object instance is set to nothing
	private sub class_Terminate()
		set myPageDataDict = nothing
		set myPageErrorsDict = nothing
		set myMetaData = nothing
		set modules = nothing
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
	private function initialize(filePath)
		debugInfo("initializing file at path "&filePath)
		bolExists = false
		initialize = false
		setCharEncoding(DEFAULT_ENCODING)
		myPathArray = split(filePath, "/")
		myFileName = myPathArray(ubound(myPathArray))
		myFilePath = replace(filePath,objLinks.item("SOURCEID")&"/","")
		if left(myfilePath,1) = "/" then 	myFilePath = mid(myFilePath,2,len(myFilePath))
		myPageName = PCase(PrettyText(myFileName)) 'default page name unless otherwise specified
		myPageTitle = myPageName
		set myPageDataDict = Server.CreateObject("Scripting.Dictionary")
		dim id
		if isnull(myFilePath) or myFilePath = "" then 
			debugWarning("class.page.init: filepath must be non-null")
		else 
			if lcase(myFilePath) = "default.asp" then
				set myPageDataDict =  getHomepageData()
			else
				set myPageDataDict = getPageDataByFileName(myFilePath)
			end if
			debug("class.page.init: page data dict size "&myPageDataDict.count)
			id = myPageDataDict.item("PageID")
			if myPageDataDict.count = 0 or id = "" then
				debugWarning("class.page.init: no id found for filepath '"&myFilePath&"'")
				initialize = true
			else
				trace("class.page.init: obtaining page data for id '"&id&"'")
				hasModules = modules.setPage(id)
				if hasModules = true then
					debugInfo("class.page.init: page has "&modules.count&" custom modules to display")
				else
					debugInfo("class.page.init: page has NO custom modules to display!")
				end if 
				myPageName = myPageDataDict.item("PageName")
				myFilePath = myPageDataDict.item("PageFileName")
				myPageId =  myPageDataDict.item("PageID")
				myPageTitle = iif(len(trim(myPageDataDict.item("PageTitle")))>0,myPageDataDict.item("PageTitle"),myPageName)
				bolExists = true
				initialize = true
			end if		
		end	if
		myPageTitle = trim(myPageTitle) & objLinks.item("TITLE_DIVIDER") & objLinks.item("TITLE")
		initPageGlobals()		
		trace(toString)
	end function
	
	private function initPageGlobals()
		addGlobal "PAGENAME",getName,null 
		addGlobal "FILENAME",getFileName,null
		addGlobal "FILEPATH",getFilePath,null
		addGlobal "PAGE_ENCODING",getCharEncoding,null
		addGlobal "PAGE_TITLE",getTitle,null
	end function

	private function addError(strErrorMessage)
		myPageErrorsDict.add ""&myPageErrorsDict.count, strErrorMessage
	end function
	
	'return the dictionary object of Errors for this page
	public function getErrors()
		set getErrors = myPageErrorsDict
	end function	
	
	're-initialize this Page with the specified file
	'returns FALSE if an error was encountered
	public function setFile(filename)
		dim result
		debug("class.page.setFile: '"&filename&"'")
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
		mySecurityLevel = cint(intLevel)	
	end function
	
	public function getSecurityLevel()
		getSecurityLevel = mySecurityLevel
	end function
	
	'change the character encoding of this class.page.
	'RETURNS FALSE if an error was encountered
	public function setCharEncoding(strCharSet)
		trace("class.page.setCharEncoding: '"&strCharSet&"'")
		myCharSet = strCharSet
	end function

	public function getCharEncoding()
		getCharEncoding = myCharSet
	end function

	'return the meta data formatted for display inside the HTML <head> tag
	public function getMetaData()
		dim a : set a = new FastString
		a.add "<meta http-equiv=""content-type"" content=""text/html; charset="&getCharEncoding&""" />" & vbcrlf
		if getDescription <> "" then	a.add "<meta name=""description"" content="""&getDescription& """ />" & vbcrlf
		if getKeywords <> "" then	a.add "<meta name=""keywords"" content="""&getKeywords & """ />" & VbCrLf
		getMetaData = a.value
		set a = nothing
	end function
	
	'return the page description string for display in the HTML <meta name="description"> tag
	public function getDescription()
		getDescription = objLinks.item("DESCRIPTION")
		if myPageDataDict.item("PageDescription") <> "" then 
			getDescription = getDescription & " " & replace(myPageDataDict.item("PageDescription"),"""","'")
		end if
	end function
	
	
	'return the page keywords string for display in the HTML <meta name="keywords"> tag
	public function getKeywords()
		getKeywords = objLinks.item("KEYWORDS") 
		if myPageDataDict.item("PageKeywords") <> "" then 
			getKeywords = getKeywords & " " & replace(myPageDataDict.item("PageKeywords"),"""","'")
		end if
	end function
	
	
	'This function returns the page name to be displayed in the title and elsewhere.
	'Page name is a formatted and capitalized version of the filename without a file extension (.asp)
	public function getName()
		getName = myPageName
	end function
	
	'change the default page name (the calling page's asp filename) to the specified name.
	public function setName(strName)
		myPageName = strName
	end function
	
	' return a Dictionary object of the Parent Page
	public function getParentPage()
		set getParentPage = getPageDataById(myPageDataDict.item("ParentPage"))
	end function 
	
	'return the parent page name string of the current Page 
	public function getParentPageName()
		getParentPageName = getParentPage.item("PageName")
	end function
	
	'return the parent page id string of this Page 
	'return "0" if page has no parent
	'return the empty string if page doesnt exist
	public function getParentPageId()
		getParentPageId = myPageDataDict.item("ParentPage")
	end function
	
	'return the file name with no formatting, including the file extension (.asp)
	public function getFileName()
		getFileName = myFileName
	end function
	
	'TODO: move this functionality to globals or somewhere else because it 
	' has nothing to do with a page, but more has to do with the site.
	public function getRootPath()
		getRootPath = objLinks.item("ROOT_PATH")
	end function 
	
	'returns the relative path/filename of the Page, based off of the site root.
	public function getFilePath()
		getFilePath = myFilePath
	end function 
	
	'return the page title as it should be displayed in the HTML <title> tag
	public function getTitle()
		getTitle = encode(myPageTitle)
		if isAdminPage = true then getTitle = " Admin"& TDIV & myPageTitle & objLinks("TITLE_DIVIDER")&objLinks("TITLE") &" ["&PRODUCT_BRANDING&" "&PRODUCT_VERSION&"]"
	end function
	
	public function setTitle(title)
		myPageTitle = title
	end function
	
	public function addBreadcrumb(strName,strURL)
		debugInfo("adding BREADCRUMB: '"&strName&"' url '"&strURL&"'")
		dim lastCrumb : lastCrumb = ubound(myBreadCrumbs,2)
		debugInfo("number of crumbs is  '"&lastCrumb&"'")
		if lastCrumb = 0 and len(myBreadcrumbs(0,lastCrumb))>0 and len(myBreadcrumbs(1,lastCrumb))>0 then
			lastCrumb = lastCrumb+1
		end if
		redim preserve myBreadcrumbs(2,lastCrumb)
		myBreadcrumbs(0,lastCrumb)=strURL
		myBreadcrumbs(1,lastCrumb)=strName
	end function
	
	public function setCrumbDivider(strDivider)
		myCrumbDivider = " " & trim(strDivider) & " "
	end function

	public function getBreadcrumbs()
		dim str,i
		on error resume next
		for i=0 to ubound(myBreadcrumbs,2)
			debugInfo("adding crumb '"&i&"'")
			debugInfo("... url '"&myBreadcrumbs(0,i)&"', name '"&myBreadcrumbs(1,i)&"'")
			str = str & a(myBreadcrumbs(0,i),myBreadcrumbs(1,i),"Open "&myBreadcrumbs(1,i),null) & myCrumbDivider
		next
		getBreadcrumbs = str & getName 
	end function
	
	public function getId()
		getId = myPageId
	end function
	
	public function getStyle()
		if not hasStyleOverride then
			if len(myPageDataDict.item("Style")) > 0 then
				if fileExists("/styles/"&myPageDataDict.item("Style")&".css") then
					myStyleSheet = myPageDataDict.item("Style")
				end if
			end if
		end if
		writeln( link(objLinks.item("SITEURL")&"/styles/"&myStyleSheet&".css","stylesheet","text/css"))
		if (isIE60() = true) and (fileExists("/styles/css-framework/ie.css") = true) then
			response.write "<style type=""text/css"">" &vbcrlf & "<!--"& vbcrlf 
			%><!--#include file="../../../styles/css-framework/ie.css"--><%
			response.write "-->" &vbcrlf & "</style>"
		end if
		if isDebugMode() = true then writeln( link(objLinks.item("SITEURL")&"/core/assets/style/debug.css","stylesheet","text/css") )
		if isIE() = true then writeln( "<script type=""text/javascript"" src="""&objLinks.item("SITEURL")&"/core/assets/scripts/sfhover.js""></script>" )
	end function
	
	
	' Apply a specific style sheet to this page. The 
	' specified string must be the name of a single file 
	' with no extension (no .css at the end). The file
	' must exist in the styles/ folder.
	'   Returns true if the file exists.
	public function setStyle(byval strStyleSheetName)
		setStyle = false
		if fileExists("/styles/"&strStyleSheetName&".css") then
			trace("class.page.setStyle:  style set to '"&strStyleSheetName&"'")
			myStyleSheet = strStyleSheetName
			setStyle = true
		end if
	end function

	' Override all other styles applied (eg, from page info in DB) 
	' with the following stylesheet (must be a single file 
	' name, with no extension), and must exist in the styles/
	' folder.
	'   Returns true if the override is successful (if file exists).
	public function overrideStyle(byval strStyleSheetName)
		overrideStyle = false
		trace("class.page.overrideStyle:  attempting to override stylesheet with '"&strStyleSheetName&"'")
		if setStyle(strStyleSheetName) = true then
			hasStyleOverride = true
			overrideStyle = true
		end if	
	end function
		
	'return the content of this Page with HTML formatting
	public function getContent()
		ignoreDBContent = false
		dim divOpen : divOpen = vbcrlf&"<div class=""first""><div><div class=""wrapper"">"&vbcrlf
		dim divClose : divClose = vbcrlf&"<br clear=""all""/>"&vbcrlf&"</div></div></div>"&vbcrlf
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
			a.add vbcrlf & msg & vbcrlf
		end if
		if pageHasErrors = true then
			processErrors
		end if
		if exists then
			if user.isAdministrator then 
				a.add  vbcrlf & "<div class='adminedit'><a title='Edit This Page' href='"&objLinks.item("ADMINURL")&"/pages/pages.asp?edit="&myPageDataDict.item("PageID")&"'><span>Edit</span></a></div>" &vbcrlf
			end if
			a.add myPageDataDict.item("PageContent")
		end if
		if len(cnt) > 0 then 
			if m_useCustomContent = true then a.clear
			a.add vbcrlf & cnt & vbcrlf
		end if
		getContent = divOpen & EmailObfuscate(GlobalVarFill(a.value)) & divClose
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
	public sub executeMod(strHandler,strCustomSettings)
		modules.executeMod strHandler,strCustomSettings
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
		dim result : result = (myPageDataDict.item("PageContent") <> "")
		hasContent = result
		trace("class.page.hasContent: "&result)
	end function
	
	public function exists()
		exists = bolExists
		trace("class.page.exists: "&bolExists)
	end function 
	
	'returns true if the ADMIN_DIR is included in the file path of the current page
	public function isAdminPage()
		dim result : result = cbool(instr(getFilePath,objLinks.item("ADMIN_DIR")) > 0)
		trace("class.page.isAdminPage: getfilepath="&getFilePath)
		trace("class.page.isAdminPage: adminDir="&objLinks.item("ADMIN_DIR"))
		trace("class.page.isAdminPage: "&result)
		isAdminPage = result
	end function
	
	' return a scripting dictionary of page data for this class.page.
	' the keys in the dictionary are the database column names 
	' from tblPages and tblPageContent
	public function getPageData()
		set getPageData = myPageDataDict
	end function
	

	' return a scripting dictionary of page data for the specified page id.  This page data is 
	' a combination of page metadata from tblPages and the most recent modification from 
	' tblPagesContent.  The keys in the scripting dictionary are the field names from the 
	' returned database query. 
	public function getPageDataById(id)
		dim rs, sd, key, val, counter, i, sql
		set sd = Server.CreateObject("Scripting.Dictionary")
		debug("class.page.getPageDataById:  getting page data for id '"&id&"'...")
		if isnull(id) or id = "" then 
			debugWarning("class.page.getPageDataById: non-null id required")
		else 
			sql = "SELECT TOP 1 tblPages.*, tblPageContent.ContentID, tblPageContent.PageContent, tblPageContent.ModifiedDate "_
			&"FROM tblPages LEFT JOIN tblPageContent ON tblPages.PageID = tblPageContent.PageID "_
			&"WHERE (((tblPages.PageID)="&id&")) "_
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
		modules.getModuleById(id)
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
		if rs.state > 0 then
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
		if isnull(strFilePath) or strFilePath = "" then 
			debugWarning("class.page.getPageDataByFileName: non-null path required")
		else 
			sql = "SELECT TOP 1 tblPages.*, tblPageContent.ContentID, tblPageContent.PageContent, tblPageContent.ModifiedDate "_
			&"FROM tblPages LEFT JOIN tblPageContent ON tblPages.PageID = tblPageContent.PageID "_
			&"WHERE (((tblPages.PageFileName)='"&strFilePath&"')) "
			if instrrev(strFilePath,"/") = len(strFilePath) then sql = sql & "OR (((tblPages.PageFileName)='"&left(strFilePath,len(strFilePath)-1)&"')) OR (((tblPages.PageFileName)='"&strFilePath&"default.asp'))  OR (((tblPages.PageFileName)='"&strFilePath&"Default.asp'))"
			sql = sql &"ORDER BY tblPageContent.ContentId DESC;"
			set rs = db.getRecordSet(sql)
			
			
			if (rs is nothing) then
				debugError("class.page.getPageDataByFileName: no database content found for page with path '"&strFilePath&"'.")
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
		if isnull(strName) or strName = "" then 
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
		'if isnull(strFilePath) or strFilePath = "" then 
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
		a.add "class.page.PageId = '"&myPageId&"'"&vbcrlf
		a.add "class.page.PageName = '"&myPageName&"'"&vbcrlf
		a.add "class.page.FilePath = '"&myFilePath&"'"&vbcrlf
		a.add "class.page.FileName = '"&myFileName&"'"&vbcrlf
		toString = a.value
		set a = nothing
	end function
	

	
	
	'Summary:  
	'          Process this page's modules registered at the specified location. 
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
		modules.display(strLocation)
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
					a.add vbcrlf 
					a.add indent(3) &	"<ul>" & vbcrlf 
					rsLocalPages.MoveFirst
					do until rsLocalPages.EOF
						strLocalLink = indent(3) & CreateNavLink(rsLocalPages("PageFileName"), rsLocalPages("PageName"), rsLocalPages("PageLinkHoverText"),"") & "</li>" & vbcrlf
						a.add strLocalLink 
						trapError
						rsLocalPages.MoveNext
					Loop
					a.add indent(3) &	"</ul>" & vbcrlf
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
			a.add indent(2) & "<div class=""banner"">" & vbcrlf
			a.add indent(2) & img(objLinks.item("BANNER"),"Banner Image",objLinks.item("BANNER_TITLE"),"banner")
			a.add indent(2) & "</div>"
			getBanner = a.value
			set a = nothing
		else
			getBanner = ""
		end if
	end function
		
	public function getHeader()
		%><!--#include file="../../../include/header.asp" --><%	
	end function
	
	public function getFooter()
		%><!--#include file="../../../include/footer.inc" --><%
	end function
	
	public function getNavBar()
		%><!--#include file="../../../include/menubar.asp"--><%
	end function
	
	public function getMeta()
		%><!--#include file="../../../include/meta.inc"--><%
		writeln(getStyle())
	end function
	
	public function getAnalytics()
		%><!--#include file="../../include/utils/google-analytics.asp"--><%
	end function
	
	public function getSampleContent(strLocation)
		select case strLocation
			case "local", "sub" 
				getSampleContent = "<div><div><div class=""wrapper"">"&replace(objLinks("BOILERPLATE_CONTENT"),"Section",PCase(strLocation))&"</div></div></div>"
			case else
				getSampleContent = ""
		end select
	end function
end class
%>

