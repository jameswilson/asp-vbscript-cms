<!--#include file="config/globals.asp" -->
<!--#include file="config/strings.asp" -->
<%
'**
'* @file
'*   Project specific application settings.
'* 

'**
'* When assigning a Project name (PROJECT_NAME in the code) please use only
'* lowercase letters ASCII letters, numbers, underscores and dashes. A short
'* string of 3 to 10 characters works best. Spaces are not advised.
const PROJECT_NAME = "cms"

'**
'* Define the location of the current application. This global constant is 
'* used in various ways to determine various configurations for the application
'* including which database to use. 
'* Choose from: [development|staging|production]
const ENVIRONMENT = "development"

'**
'* The CMS has builtin support for Google Analytics tracking. Set this to the
'* empty string to disable tracking.
const GA_ACCOUNT_ID = "UA-0000000-XXX"

'**
'* Some people deem it important for SEO and usability to not use Default.asp
'* as the default homepage. Here you can specify a homepage for the site and
'* all requests to Default.asp will redirect here.
const HOMEPAGE = "home"

'**
'* It is possible although not advisable to move the admin/ folder to another 
'* location.  If you move the folder, update this string with the new URL,
'* relative to SITEROOT.
const ADMINDIR = "admin"


'**
'* This variable is available, however currently poorly supported. 
const LANGUAGE = "en"


'**
'* Database connection preferences. When using database connections in ASP, 
'* you need to specify the Provider and the Data Source.
const DB_PROVIDER = "MICROSOFT.JET.OLEDB.4.0"
const DB_SOURCE = "{SITE_PATH}\..\data\{ENVIRONMENT}.mdb"


const DB_FOLDER = "data"  'folder location for DB on webhost
const DB_LOCAL = "data"  'folder location for DB on localhost testing

'**
'* Control whether the site is offline. If offline, the application will send
'* all site traffic to the UNAVAILABLE_URL. 
const SITE_OFFLINE = "NO" '[YES/NO]

'**
'* Override the debug mode stored in the database. On production this should
'* generally be set to 0, and on development it should be set to 1.
const DEBUG_OVERRIDE = "1" '[1/0]

'**
'* Default Page Encoding.
const DEFAULT_ENCODING  = "iso-8859-1"

'**
'* Breadcrumb dividers.
const BREADCRUMB_DIVIDER = " &raquo; "
%>
