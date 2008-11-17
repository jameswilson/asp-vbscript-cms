<!--#include file="config/globals.asp" -->
<!--#include file="config/strings.asp" -->
<%
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' IMPORTANT NOTICE TO DEVELOPERS:
' When installing the client's database, make sure the file name and folder
' coincide with the SOURCEID specified below. Also ensure that each user in
' gateway.mdb has the same SourceID, else they will be prevented from logging
' into the Admin Area. The SOURCEID should be defined as a three or four-
' letter string of lowercase letters unique to the client. Note that 
'
'                     SPACES ARE NOT ALLOWED
'
' and typically, the string consists of some distinguishable initials
' from the customer's site name or company name. 

	const SOURCEID = "cms"
	const GA_ACCOUNT_ID = "UA-0000000-XXX"
	
' CUSTOMER SPECIFIC SETTINGS
	const HOMEPAGE = "home" 'the homepage to where default.asp redirects.
	const ADMINDIR = "admin" 'folder name of CMS ADMIN panel, must exist in the site-root folder.
	const LANGUAGE = "en" 'the default language code
	
' DATABASE SETTINGS
	const DB_PREFIX = "PROVIDER=MICROSOFT.JET.OLEDB.4.0;DATA SOURCE="
  const DB_FOLDER = "db\{SOURCEID}"  'folder location for DB on webhost
	const DB_LOCAL= "db"  'folder location for DB on localhost testing

' SITE ADMINISTRATION CONTROLS
	const SITE_DISABLED = "NO" '[YES/NO] send all site traffic to the UNAVAILABLE_URL
	const DEBUG_OVERRIDE = "0" '[1/0] if 1, override the site debugging mode stored in the database. 
%>
