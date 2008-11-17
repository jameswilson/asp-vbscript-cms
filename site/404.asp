<%@ Language=VBScript %>
<%Option Explicit%>
<!--#include file="core/include/global.asp"-->
<%

'**
'*  This script is basically the routes file that automatically
'*  pulls any matching page content from the DB based on the URL
'*  and renders the site template. If you cannot customize error 
'*  pages, then all your public site's content pages should execute  
'*  404.asp (see default.asp for an example). This script may be  
'*  used as a custom 404 page. If your webhost provides the ability
'*  to configure custom Error pages, you should use this script. It 
'*  is known to work for IIS 5 and 6 custom error pages. 
'* 
session.contents(CUSTOM_MESSAGE) = ""
dim myURL,myErr,myQuery,myQueryString,myCss
myErr = 0
myUrl = request.ServerVariables("URL")
myCss = ""
myQueryString = request.queryString()

if len(myQueryString) > 0 then
	if instr(myQueryString,";") > 1 then
		myErr = split(myQueryString,";")(0)
		myURL = split(myQueryString,";")(1)
		debugInfo("404.asp: Server error is '"&myErr&"'")
		if instr(myURL,"?") then
			dim tmp : tmp = split(myURL,"?") 
			myURL = tmp(0)
			myQueryString = tmp(1)
		end if
		dim port : set port = new RegExp
		port.pattern = ":(\d+)"
		port.global = false
		myURL = port.replace(myURL,"")
		myURL = lCase(Mid(myURL, len(objLinks.item("SITEURL")) + 1, len(myURL)))
		CreateDictionary myQuery,myQueryString,"&","=",adDictOverwrite
		myCss = myQuery("css")
	else
		set myQuery = request.queryString
		myCss = request.queryString("css")
	end if
	if len(myCss)>0 then debugInfo("404.asp: CSS style override is '"&myCss&"'")
end if
trace("404.asp: Query string is '"&myQueryString&"'")
trace("404.asp: Requested page is '"&myURL&"'")
if len(myCss)>0 then page.overrideStyle(myCss)

'
' Process the request
'
if not db.exists() then
	server.execute("core/include/utils/lorem.asp")
	debugError("404.asp: A homepage was not found in the database for your site. We are going to populate with some error text, for testing/display.")
else
	trace("404.asp: site enabled? "&globals.getItem("Enabled Site"))
	trace("404.asp: Processed URL Request is '"&myURL&"'")
	if globals.getItem("Enabled Site") <> "1" then
		writeln("404.asp: Public site is disabled!")
		'server.transfer("core/include/utils/unavailable.asp")
	else
		dim setFile : setFile = page.setFile(myURL)
		if not setFile OR page.exists = false then
			trace("404.asp: File or DB contents matching '"&myURL&"' does not exist!")
			server.execute("core/include/utils/error404.asp")
		else
			session.contents("Page") = myURL
			trace("404.asp: the page '"&myURL&"' was found in the database.")
		end if

		'
		' Add custom query-string options here
		'

		if myQueryString = "sitemap" or myQueryString = "sitemap.xml" then 
			'show sitemap if it is requested by get or post data (in html or xml format)
			server.transfer("core/include/utils/sitemap.asp") 
		end if
		
		if myQueryString = "version"  then 
			'show sitemap if it is requested by get or post data (in html or xml format)
			server.transfer("core/include/utils/version.asp") 
		end if

		'
		' End custom query-string options
		'

	end if
end if
%>
<!--#include file="core/include/template.asp"-->
