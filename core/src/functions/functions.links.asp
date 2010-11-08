<%
' create an HTML <a> tag link to the specified resource. 
' the src attribute will be absolute, i.e. a fully qualified URL
' formulate page links for the navigation bar if the url 
' matches the current fileName, the link gets <strong>.
function createNavLink(byval url,byval content,byval title,byval liclass)
	content = token_replace(content)
	url = token_replace(url)
	if isNull(title) then 
		title = PCase(content)
	else
		title = token_replace(title)
	end if
	debug("url:" &url& " request:" &request.servervariables("url") & " page.filename:" & page.getFileName() &" page.filepath:"&page.getfilepath)
	if (lcase(page.getFilePath()) = lcase(url)) then
		createNavLink = navListHelper(strong(anchor(urlRelToAbs(url),content,title,"site-nav")),liclass & " current")
	else 
		createNavLink = navListHelper(anchor(urlRelToAbs(url),content,title,"site-nav"),liclass)
	end if
end function

function navListHelper(str,strclass)
	if len(strclass)>0 then
		navListHelper = "<li class="""&strclass&"""><span></span>"&str
	else 
		navListHelper = "<li><span></span>"&str
	end if
	str = null
	strclass = null
end function

'convert a relative path to an absolute path
function urlRelToAbs(relativePath)
'TODO: fix this function to work with real relative paths (eg ../../file.asp)
	if InStr(relativePath,globals("SITEURL")) > 0 then 
		debugWarning("urlRelToAbs(): path '"&relativePath&"' is already absolute")
	elseif InStr(relativePath,"http") = 1 then
		debugWarning("urlRelToAbs(): path '"&relativePath&"' is already absolute")	
	elseif instr(relativePath,"./") > 0 then
		debugError("urlRelToAbs(): relative paths using './' or '../' have not yet been implemented!!!!")
	else
		if left(relativePath,1) <> "/" then relativePath = "/" & relativePath
		relativePath = globals("SITEURL")&relativePath
	end if
	if instrrev(lcase(relativePath),"/default.asp")=len(relativePath)-11 then relativePath = replace(lcase(relativePath),"/default.asp","/")
	urlRelToAbs = relativePath
end function

'return a formated adminedit link with the specified linkUrl and linkHoverText
function adminEditLink(linkUrl, linkText, linkHoverText)
	if user.isAdministrator then
		trace("adminEditLink: user has active admin session... adding link '"&linkText&"'")
		dim url : url = replace(linkUrl,"\","/")
		if InStr(url,globals("ADMINURL"))> 0 then
			trace("adminEditLink: ["&url&"] an absolute link was provided, no modifications applied")
			'do nothing to modify the link
		elseif InStr(url,"http://")>0 then
			debugError("adminEditLink:  ["&url&"] absolute link provided does not link to current admin area ["&globals("ADMINURL")&"]")
		else
			if not InStr(url,"/") = 1 then
				url = "/"&url
			end if
			url = globals("ADMINURL")&url
		end if
		adminEditLink = "<div class=""adminedit"">"&a(url, "<span>"&linkText&"</span>", linkHoverText, null)&"</div>"
	end if
end function
%>