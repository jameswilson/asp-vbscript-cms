<%
'** 
'* Site Global Strings
'*

'**
'* CMS product specifications.
const PRODUCT_BRANDING = "ASP VBScript CMS"
const PRODUCT_VERSION = "0.5"

'**
'* CMS branding.
const PRODUCT_URL = "http://asp-vbscript.cms/googlecode.com"
const PRODUCT_LOGO = "{ADMINURL}/images/cms_logo_transparent.gif"
const PRODUCT_FAVICON = "http://asp-vbscript-cms.googlecode.com/files/favicon.ico"
const PRODUCT_DESCRIPTION = "Powered by <a href=""{PRODUCT_URL}"" title=""{PRODUCT_BRANDING} {PRODUCT_VERSION}"">{PRODUCT_BRANDING}</a>"


'**
'* Fallback settings.
'* In general, there is NO REASON TO CHANGE THESE DEFAULTS because all of 
'* the following have a complimentary setting stored in the DB settings.
'* The DB settings always over-ride these defaults and they exist here 
'* only as a fall-back when the DB values are undefined.  PLEASE log 
'* into the CMS Admin Panel to modify site specific settings.
const DEFAULT_SMTPHOST = "smtp.gmail.com"
const DEFAULT_BCC = "NO"  'Send blind carbon copies of all website email interaction?
const DEFAULT_BCC_EMAIL = "" 'email where to send blind carbon copies, if YES above 
const DEFAULT_LOGO = "{SITEURL}/images/logo.gif"
const DEFAULT_BANNER =  "{SITEURL}/images/banner.gif"
const DEFAULT_SITENAME = "Site Name"
const DEFAULT_TITLE_DIVIDER = " | "
const DEFAULT_SLOGAN = "Site Subheading  (slogan)"
const DEFAULT_DESCRIPTION = "{SITENAME} {SLOGAN}"
const DEFAULT_AREA_CODE = "000"
const DEFAULT_BANNER_ALT = "Banner Image"
const DEFAULT_BANNER_TITLE = "{SITENAME} Banner Image"
const DEFAULT_FAVICON = "/favicon.ico"

'**
'* Site Offline settings
const UNAVAILABLE_URL = "{SITEURL}/core/include/unavailable.asp"
const ADMIN_UNAVAILABLE_URL = "{ADMINURL}/unavailable.asp"

'**
'* Flash settings
const FLASH_CLASSID = "clsid:D27CDB6E-AE6D-11cf-96B8-444553540000"	
const FLASH_CODEBASE = "http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=7,0,19,0"

'**
'* You are not advised to change these settings.
const CUSTOM_MESSAGE = "CustomMessage"
const REQUESTED_PAGE = "RequestedPage"

'**
'* Login interaction  messages.
'* Note, for security, we should leave error messages sufficiently general
'* in order to not give away information to would-be hackers. 
const LOGIN_EXPIRED = "Your Account is expired please contact the <a href='mailto:{ADMINEMAIL}'>administrator</a>."
const LOGOUT_SUCCESS = "You have been successfully logged out. <br/><br/> <a class=""button"" href=""{SITEURL}"">View Site &raquo;</a>"
const GENERIC_ERROR = "An error occurred, please try again."
const INVALID_USER = "The username or password provided was incorrect." 
const BAD_PASSWORD = "The username or password provided was incorrect." 

'**
'* Email message tokens.
'* These tokens are used in email messages from the site.
const EMAIL_HTML_HEADER = "<p><img src=""{EMAIL_HEADER_IMG}"" alt=""{COMPANY_NAME}: {SLOGAN}""><br/>"
const EMAIL_HTML_FOOTER = ""
dim EMAIL_TEXT_HEADER : EMAIL_TEXT_HEADER = "{COMPANY_NAME}" & vbCrLf & "{SLOGAN}" & vbCrLf & "============================="& vbCrLf
const EMAIL_TEXT_FOOTER = ""

'**
'* Customizable messages.
const ERROR_FEEDBACK = "If you feel you've recieved this message in error, please contact {DEVELOPER_SUPPORT_LINK}."
const SITE_OFFLINE_MESSAGE = "This site is currently unavailable."
const ADMIN_SITE_OFFLINE_MESSAGE = "The system is down for scheduled maintenance. Please try back later. If the problem persists for more than 24 hours please contact {DEVELOPER_SUPPORT_LINK}."
const DB_NOT_WRITABLE = "The database does not have write permissions. This means the webmaster has not appropriately setup your website for production use, and while information can be read from the database, any changes made in the admin section will not be saved. Please contact {DEVELOPER_SUPPORT_LINK} to have this issue resolved."

'**
'* Customizable text strings.
const TXT_NOTE = "Please Note"
const TXT_INFO = "Please Remember"
const TXT_SUCCESS = "Congradulations"
const TXT_WARNING = "Warning"
const TXT_ERROR = "Oops"
const TXT_LOGIN_SUCCESS = "Your login credentials passed!"
const TXT_DEBUG_MODE = "Debug mode is enabled"
const TXT_DEBUG_INFO = "Debug mode often contains highly sensitive data about the internal functioning of your website. If you believe debug mode has been inadvertently left enabled, please contact {DEVELOPER_SUPPORT_LINK} as soon as possible."


'**
'* Boilerplate strings. Before a site gets built out, you may have a need to
'* use boilerplate content on various pages, to demonstrate the site styles.
const BOILERPLATE_WARNING = "<h2 class=""alert"">This page needs your attention!</h2><p>This is boilerplate content.  Please log into the <a href=""{ADMINURL}"">web admin tool</a> to create content for this page.</p>"
const BOILERPLATE_CONTENT = "<h1>Section Heading One</h1><p>Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. </p><h2>Section Heading Two</h2><p>Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. </p><h3>Section Heading Three</h3><p>Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. </p><ul><li>Duis aute irure dolor in reprehenderit</li><li>in voluptate velit esse cillum dolore eu fugiat , nulla pariatur.</li><li>Excepteur sint occaecat cupidatat non proident,</li><li>sunt in culpa qui officia deserunt mollit anim id est laborum.</li></ul><p>Enim quis porttitor vulputate, leo elit egestas sem, congue convallis , nulla purus malesuada pede. Nunc ante turpis, consectetuer non, pharetra id, tincidunt non, erat. </p><ol><li>Sed fringilla ultrices purus.</li><li>Pellentesque cursus auctor lectus.</li><li>Sed urna purus, gravida vehicula, bibendum eu, aliquam ut, massa.</li></ol><p>Nam ornare, arcu vel fringilla lobortis, quam odio condimentum libero, ac vulputate tellus sem non augue. Vestibulum nisl. Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Donec eget lorem eu quam nonummy consectetuer. Cras consectetuer varius metus. Nam eleifend rutrum ligula. Duis varius auctor risus. Fusce adipiscing vulputate elit. Suspendisse tortor leo, tincidunt nec, elementum in, ultrices et, felis.</p>"
%>
