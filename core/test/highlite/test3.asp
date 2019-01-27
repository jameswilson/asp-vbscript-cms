<!--#include file="config/globals.asp" -->
<!--#include file="config/strings.asp" -->
<%
'**
'* @file
'*   Application settings.
'*

'**
'* When assigning a Project name (PROJECT_NAME in the code) please use only
'* lowercase letters ASCII letters, numbers, underscores and dashes. A short
'* string of 3 to 10 characters works best. Spaces are not advised. 

	const PROJECT_NAME = "asp_vbscript_cms"
	const GA_ACCOUNT_ID = "UA-2203039-XXX"

' CUSTOMER SPECIFIC SETTINGS
	const HOMEPAGE = "home" 'the homepage to where default.asp redirects.
	const ADMINDIR = "admin" 'folder name of CMS ADMIN panel, must exist in the site-root folder.
	const LANGUAGE = "en" 'the default language code

' DATABASE SETTINGS
	const DB_PREFIX = "PROVIDER=MICROSOFT.JET.OLEDB.4.0;DATA SOURCE="
	const DB_FOLDER = "data"  'folder location for DB on webhost
	const DB_LOCAL= "data"  'folder location for DB on localhost testing

' SITE ADMINISTRATION CONTROLS
	const SITE_OFFLINE = "NO" '[YES/NO] send all site traffic to the UNAVAILABLE_URL
	const DEBUG_OVERRIDE = "0" '[1/0] if 1, override the site debugging mode stored in the database. 
%>
