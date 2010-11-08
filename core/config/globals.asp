<%

'**
'* @file
'*   Application-level globals variables and objects.
'* 
'*   You have access to these variabls by including the bootstrap.asp.
'*

dim globals : set globals = Server.CreateObject("Scripting.Dictionary")
dim settings : set settings = nothing
dim page : set page = nothing
dim user : set user = nothing
dim modules : set modules = nothing
dim db : set db = nothing


'**
'* Initialize all the global settings.
'*
'* Changing the order of initialization here will have very drastic effects.
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
	debugInfo("config.initGlobals:  initialization completed in "& timer - start &" seconds.") 
end function

'**
'* Initialize the web domain global constants.
'*
'* Changing the order of initialization here will have very drastic effects.
'*
function initDomainGlobals()
	trace("config.initDomainGlobals...")
	globals.add "PROJECT_NAME", PROJECT_NAME
	addGlobal "ENVIRONMENT", ENVIRONMENT, null
	addGlobal "HOME", HOMEPAGE, null 
	addGlobal "ADMIN_DIR", ADMINDIR, null  
	if isLocalServer = true then
		'LOCALHOST settings where site lives in subfolder
		addGlobal "SITEROOT", "/{PROJECT_NAME}", null
			
	elseif Instr(request.ServerVariables("URL"), PROJECT_NAME) > 0 then
		'TEST DOMAIN settings where site lives in subfolder
		addGlobal "SITEROOT", "/{PROJECT_NAME}", null
		
	else
		'NORMAL Live Site settings for public domain
		addGlobal "SITEROOT", "", null
	end if
	addGlobal "SITE_PATH", Server.mappath(token_replace("{SITEROOT}/")), null
	if cint(request.ServerVariables("SERVER_PORT")) <> 80 then
		addGlobal "DOMAINNAME", request.ServerVariables("SERVER_NAME") & ":" & request.ServerVariables("SERVER_PORT") & "{SITEROOT}", null
	else
		addGlobal "DOMAINNAME", request.ServerVariables("SERVER_NAME") & "{SITEROOT}", null
	end if
	if request.ServerVariables("HTTPS") = "on" then 
		addGlobal "SITEURL", "https://{DOMAINNAME}", null
	else
		addGlobal "SITEURL", "http://{DOMAINNAME}", null
	end if
	addGlobal "ADMINURL", "{SITEURL}/{ADMIN_DIR}", null
	addGlobal "DEVELOPER_URL", DEVELOPER_URL, null
	addGlobal "PRODUCT_LOGO", PRODUCT_LOGO, null
	addGlobal "DEVELOPER_NAME", DEVELOPER_NAME, null
	addGlobal "DEVELOPER_SHORTNAME", DEVELOPER_SHORTNAME, null
	addGlobal "DEVELOPER_LINK", DEVELOPER_LINK, null
	addGlobal "DEVELOPER_SLOGAN", DEVELOPER_SLOGAN, null
	addGlobal "DEVELOPER_EMAIL", DEVELOPER_EMAIL, null
	addGlobal "PRODUCT_BRANDING", PRODUCT_BRANDING, null
	addGlobal "DEVELOPER_SUPPORT_LINK", DEVELOPER_SUPPORT_LINK, DEVELOPER_SUPPORT_LINK
	addGlobal "SITE_OFFLINE", SITE_OFFLINE, null 
	addGlobal "SITE_OFFLINE_MESSAGE", SITE_OFFLINE_MESSAGE, null
	addGlobal "ADMIN_SITE_OFFLINE_MESSAGE", ADMIN_SITE_OFFLINE_MESSAGE, null
	addGlobal "UNAVAILABLE_URL", UNAVAILABLE_URL, null
	addGlobal "ADMIN_UNAVAILABLE_URL", ADMIN_UNAVAILABLE_URL, null
	addGlobal "BREADCRUMB_DIVIDER", BREADCRUMB_DIVIDER, null
	addGlobal "DEFAULT_ENCODING", DEFAULT_ENCODING, null
end function

'**
'* Initialize the Database global constants.
'*
'* Changing the order of initialization here will have very drastic effects.
'*
function initDatabaseGlobals()
	trace("config.initDatabaseGlobals...")
	'addGlobal "DB_LOCATION", DB_LOCATION, null
	'addGlobal "DB_MAIN", DB_PREFIX & "{DB_LOCATION}\{ENVIRONMENT}.mdb", null
	addGlobal "DB_PROVIDER", DB_PROVIDER, null
	addGlobal "DB_SOURCE", DB_SOURCE, null
	addGlobal "DB_MAIN", "PROVIDER={DB_PROVIDER};DATA SOURCE={DB_SOURCE}", null
	debugInfo("SITE_PATH: " & globals("SITE_PATH"))
	debugInfo("DB_SOURCE: " & globals("DB_SOURCE"))
	set db = new ClsDatabase
	db.ConnectOpen token_replace("{DB_MAIN}")
end function


'**
'* Initialize the site's global string constants.
'*
'* Changing the order of initialization here will have very drastic effects.
'*
function initSiteGlobals()
	trace("config.initSiteGlobals...")
	'Apply the Global Strings
	addGlobal "BCC", DEFAULT_BCC, null
	addGlobal "BCCEMAIL", DEFAULT_BCC_EMAIL, null
	addGlobal "LOGIN_EXPIRED", WarningMessage(LOGIN_EXPIRED), null
	addGlobal "GENERIC_ERROR", GENERIC_ERROR, null
	addGlobal "LOGOUT_SUCCESS", InfoMessage(LOGOUT_SUCCESS), null
	addGlobal "BAD_PASSWORD", BAD_PASSWORD, null
	addGlobal "INVALID_USER", INVALID_USER, null 
	addGlobal "ERROR_FEEDBACK", ERROR_FEEDBACK, null
	addGlobal "BOILERPLATE_WARNING", BOILERPLATE_WARNING, null
	addGlobal "BOILERPLATE_CONTENT", BOILERPLATE_CONTENT, null
end function

'**
'* Initialize the global constants from the Database.
'*
'* Changing the order of initialization here will have very drastic effects.
'*
function initDbSiteSettings()
	trace("config.initDbSiteSettings...")
	set settings = new SiteSettings
	'General Site Constants
	if DEBUG_OVERRIDE = "1" then 
		addGlobal "DEBUG", DEBUG_OVERRIDE, null
		debugWarning("DEBUG_OVERRIDE is ON!")
	else
		addGlobal "DEBUG", settings.getItem("Debug"), DEBUG_OVERRIDE
	end if
	addGlobal "SITENAME", settings.getItem("Site Name"), DEFAULT_SITENAME
	addGlobal "COMPANY_NAME", settings.getItem("Company Name"), "{SITENAME}"
	addGlobal "TITLE", settings.getItem("Site Title"), "{SITENAME}"
	addGlobal "TITLE_DIVIDER", settings.getItem("Title Tag Divider"), DEFAULT_TITLE_DIVIDER
	addGlobal "SHORTNAME", settings.getItem("Site Shortname"), CamelCase(token_replace("{SITENAME}"))
	addGlobal "SLOGAN", settings.getItem("Site Slogan"), DEFAULT_SLOGAN
	addGlobal "LOGO", settings.getItem("Site Logo"), DEFAULT_LOGO
	addGlobal "BANNER", settings.getItem("Site Banner"), DEFAULT_BANNER
	addGlobal "BANNER_TITLE", settings.getItem("Site Title"), DEFAULT_BANNER_TITLE
	addGlobal "KEYWORDS", settings.getItem("Site Keywords"), null
	addGlobal "DESCRIPTION", settings.getItem("Site Description"), DEFAULT_DESCRIPTION
	addGlobal "DEFAULT_AREA_CODE", settings.getItem("Default Area Code"), DEFAULT_AREA_CODE
	addGlobal "GOOGLE_ANALYTICS", settings.getItem("Google Analytics"), GA_ACCOUNT_ID
	addGlobal "FAVICON", settings.getItem("Bookmark Icon"), PRODUCT_FAVICON
	addGlobal "PRODUCT_FAVICON", PRODUCT_FAVICON, "{FAVICON}"
	
	'Contact Form Variables
	addGlobal "SMTPHOST", settings.getItem("SMTP Host"), DEFAULT_SMTPHOST
	addGlobal "SUBJECTLINE_PREFIX", settings.getItem("Subjectline Prefix"), null
	addGlobal "EMAIL_HEADER_IMG", settings.getItem("Email Header Image"), null
	addGlobal "INTRO", settings.getItem("Email Intro"), null
	addGlobal "ADMINEMAIL", settings.getItem("Admin Email"), DEVELOPER_EMAIL
	addGlobal "CCSENDER", settings.getItem("CC Sender"), null
	 
	' site-specific email headers and footers for text & html emails
	addGlobal "EMAIL_HTML_HEADER", EMAIL_HTML_HEADER, null
	addGlobal "EMAIL_HTML_FOOTER", EMAIL_HTML_FOOTER, null
	addGlobal "EMAIL_TEXT_HEADER", EMAIL_TEXT_HEADER, null
	addGlobal "EMAIL_TEXT_FOOTER", EMAIL_TEXT_FOOTER, null
end function

function isLocalServer()
	isLocalServer =  ((request.ServerVariables("SERVER_NAME") = "localhost") _
	               or (request.ServerVariables("SERVER_NAME") = "127.0.0.1"))
end function
%>
