<%

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
''   These are the global objects available to all      ''
''   pages that include /core/include/global.asp        ''
''                                                      ''
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

dim objLinks : set objLinks = Server.CreateObject("Scripting.Dictionary")
dim globals : set globals = nothing
dim page : set page = nothing
dim user : set user = nothing
dim modules : set modules = nothing
dim db : set db = nothing


'**
'* Initialize all the global settings
'*
'* Note:  DO NOT MUCK WITH INITIALIZATION ORDER!!!!
'*
function initializeGlobals()
	dim start : start = timer	
	trace("config.initGlobals...")
	initDomainGlobals()
	initDatabaseGlobals() 
	initSiteGlobals() 
	initDbSiteSettings()
	set user = new ClientUser
	set page = new AspPage
	debugInfo("config.initGlobals:  initialization completed in "&timer - start&" seconds.") 
end function


'**
'* Initialize the web domain global constants.
'*
'* Note:  DO NOT MUCK WITH INITIALIZATION ORDER!!!!
'*
function initDomainGlobals()
	trace("config.initDomainGlobals...")
	objLinks.add "SOURCEID", SOURCEID
	addGlobal "HOME",HOMEPAGE,null 
	addGlobal "ADMIN_DIR",ADMINDIR,null  
	if isLocalServer = true then
		'LOCALHOST settings where site lives in subfolder
		addGlobal "SITEROOT", "/{SOURCEID}",null
			
	elseif Instr(request.ServerVariables("URL"),SOURCEID) > 0 then
		'TEST DOMAIN settings where site lives in subfolder
	  addGlobal "SITEROOT", "/{SOURCEID}",null
		
	else
	  'NORMAL Live Site settings for public domain
		addGlobal "SITEROOT", "",null
	end if
	addGlobal "SITE_PATH", Server.mappath(globalVarFill("{SITEROOT}/")), null
	if cint(request.ServerVariables("SERVER_PORT")) <> 80 then
		addGlobal "DOMAINNAME", request.ServerVariables("SERVER_NAME")&":"&request.ServerVariables("SERVER_PORT")&"{SITEROOT}",null
	else
		addGlobal "DOMAINNAME", request.ServerVariables("SERVER_NAME")&"{SITEROOT}",null
	end if
	if request.ServerVariables("HTTPS") = "on" then 
		addGlobal "SITEURL", "https://{DOMAINNAME}",null
	else
		addGlobal "SITEURL", "http://{DOMAINNAME}",null
	end if
	addGlobal "ADMINURL", "{SITEURL}/{ADMIN_DIR}",null
	addGlobal "PROVIDER_URL", PROVIDER_URL,null
	addGlobal "PROVIDER_LOGO", PROVIDER_LOGO, null
	addGlobal "PROVIDER_NAME", PROVIDER_NAME,null
	addGlobal "PROVIDER_SHORTNAME", PROVIDER_SHORTNAME, null
	addGlobal "PROVIDER_LINK", PROVIDER_LINK, null
	addGlobal "PROVIDER_SLOGAN", PROVIDER_SLOGAN, null
	addGlobal "PROVIDER_EMAIL", PROVIDER_EMAIL, null
	addGlobal "PRODUCT_BRANDING", PRODUCT_BRANDING, null
	addGlobal "PROVIDER_SUPPORT_EMAIL",PROVIDER_SUPPORT_EMAIL,PROVIDER_SUPPORT_EMAIL
	addGlobal "SITE_DISABLED",SITE_DISABLED,null 
	addGlobal "DISABLEDTEXT", DISABLEDTEXT,null
	addGlobal "ADMIN_DISABLEDTEXT", ADMIN_DISABLEDTEXT,null
	addGlobal "UNAVAILABLE",UNAVAILABLE_URL,null
	addGlobal "ADMIN_UNAVAILABLE",ADMIN_UNAVAILABLE_URL,null
	
end function

'**
'* Initialize the Database global constants.
'*
'* Note:  DO NOT MUCK WITH INITIALIZATION ORDER!!!!
'*
function initDatabaseGlobals()
	trace("config.initDatabaseGlobals...")
	dim DB_LOCATION : DB_LOCATION = left(objLinks.item("SITE_PATH"),inStrRev(objLinks.item("SITE_PATH"),"\")) & DB_FOLDER
	if isLocalServer = true then
		if instr(DB_LOCAL,":")=2 then 
			DB_LOCATION = DB_LOCAL 'set the db location specific to localhost testing location
		else
			DB_LOCATION = left(objLinks.item("SITE_PATH"),inStrRev(objLinks.item("SITE_PATH"),"\")) & DB_LOCAL
		end if
	end if
	addGlobal "DB_LOCATION",DB_LOCATION,null
	addGlobal "DB_MAIN",DB_PREFIX&"{DB_LOCATION}\{SOURCEID}.mdb",null
	addGlobal "DB_GATEWAY",DB_PREFIX&"{DB_LOCATION}\gateway.mdb",null
	debugInfo("SITEPATH: "&objLinks.item("SITE_PATH"))
	debugInfo("DB_LOCATION: "&globalVarFill("{DB_LOCATION}\{SOURCEID}.mdb"))
	set db = new ClsDatabase
	db.ConnectOpen globalVarFill("{DB_LOCATION}\{SOURCEID}.mdb")
end function


'**
'* Initialize the site's global string constants.
'*
'* Note:  DO NOT MUCK WITH INITIALIZATION ORDER!!!!
'*
function initSiteGlobals()
	trace("config.initSiteGlobals...")
	'Apply the Global Strings
	addGlobal "BCC",DEFAULT_BCC,null
	addGlobal "BCCEMAIL",DEFAULT_BCC_EMAIL,null
	addGlobal "LOGIN_EXPIRED",WarningMessage(LOGIN_EXPIRED),null
	addGlobal "GENERIC_ERROR",GENERIC_ERROR,null
	addGlobal "LOGOUT_SUCCESS",InfoMessage(LOGOUT_SUCCESS),null
	addGlobal "BAD_PASSWORD",BAD_PASSWORD,null
	addGlobal "INVALID_USER",INVALID_USER,null 
	addGlobal "ERROR_FEEDBACK", ERROR_FEEDBACK,null
	addGlobal "BOILERPLATE_WARNING",BOILERPLATE_WARNING,null
	addGlobal "BOILERPLATE_CONTENT",BOILERPLATE_CONTENT,null
end function

'**
'* Initialize the global constants from the Database.
'*
'* Note:  DO NOT MUCK WITH INITIALIZATION ORDER!!!!
'*
function initDbSiteSettings()
	trace("config.initDbSiteSettings...")
	set globals = new SiteSettings
	'General Site Constants
	if DEBUG_OVERRIDE = "1" then 
		addGlobal "DEBUG",DEBUG_OVERRIDE,null
		debugWarning("DEBUG_OVERRIDE is ON!")
	else
		addGlobal "DEBUG",globals.getItem("Debug"),DEBUG_OVERRIDE
	end if
	addGlobal "SITENAME",globals.getItem("Site Name"),DEFAULT_SITENAME
	addGlobal "COMPANY",globals.getItem("Company Name"),"{SITENAME}"
	addGlobal "TITLE", globals.getItem("Site Title"),"{SITENAME}"
	addGlobal "TITLE_DIVIDER",globals.getItem("Title Tag Divider"),DEFAULT_TITLE_DIVIDER
	addGlobal "SHORTNAME",globals.getItem("Site Shortname"),CamelCase(GlobalVarFill("{SITENAME}"))
	addGlobal "SLOGAN",globals.getItem("Site Slogan"),DEFAULT_SLOGAN
	addGlobal "LOGO", globals.getItem("Site Logo"),DEFAULT_LOGO
	addGlobal "BANNER", globals.getItem("Site Banner"),DEFAULT_BANNER
	addGlobal "BANNER_TITLE", globals.getItem("Site Title"),DEFAULT_BANNER_TITLE
	addGlobal "KEYWORDS",globals.getItem("Site Keywords"),null
	addGlobal "DESCRIPTION",globals.getItem("Site Description"),DEFAULT_DESCRIPTION
	addGlobal "DEFAULT_AREA_CODE", globals.getItem("Default Area Code"),DEFAULT_AREA_CODE
	addGlobal "GOOGLE_ANALYTICS", globals.getItem("Google Analytics"),GA_ACCOUNT_ID
	addGlobal "FAVICON", globals.getItem("Bookmark Icon"),PROVIDER_FAVICON
	addGlobal "PROVIDER_FAVICON", PROVIDER_FAVICON, "{FAVICON}"
	
	'Contact Form Variables
	addGlobal "SMTPHOST",globals.getItem("SMTP Host"),DEFAULT_SMTPHOST
	addGlobal "SUBJECTLINE_PREFIX", globals.getItem("Subjectline Prefix"),null
	addGlobal "EMAIL_HEADER_IMG", globals.getItem("Email Header Image"),null
	addGlobal "INTRO", globals.getItem("Email Intro"),null
	addGlobal "ADMINEMAIL",globals.getItem("Admin Email"),PROVIDER_EMAIL
	addGlobal "CCSENDER",globals.getItem("CC Sender"),null
	 
	' site-specific email headers and footers for text & html emails
	addGlobal "EMAIL_HTML_HEADER",EMAIL_HTML_HEADER,null
	addGlobal "EMAIL_HTML_FOOTER",EMAIL_HTML_FOOTER,null
	addGlobal "EMAIL_TEXT_HEADER",EMAIL_TEXT_HEADER,null
	addGlobal "EMAIL_TEXT_FOOTER",EMAIL_TEXT_FOOTER,null
end function

function isLocalServer()
	isLocalServer =  ((request.ServerVariables("SERVER_NAME") = "localhost") _
	               or (request.ServerVariables("SERVER_NAME") = "127.0.0.1"))
end function
%>
