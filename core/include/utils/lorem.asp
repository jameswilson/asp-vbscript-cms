<!--#include file="../bootstrap.asp"-->
<%
	dim content : set content = new FastString
	content.add "<h1>Main Content Heading H1</h1>"
	content.add "<p>We're sorry, your website is currently unavailable because the database cannot be found. "
	content.add "" & globals("ERROR_FEEDBACK") & "</p>"
	content.add WarningMessage("You are seeing this page because the database " _
		& token_replace("{DB_LOCATION}\{PROJECT_NAME}.mdb") & " could not be accessed. " _
		& "It is possible that the database does not yet exist, or has not been given appropriate access rights.")
	dim fileDict : set fileDict = getFilesInFolder("/styles/",".css")
	if isObject(fileDict) and not fileDict is nothing then
		debugInfo("404.asp: fileDict.count is " & fileDict.count)
		if fileDict.count > 1 then
			dim filename
			content.add "<ul>"
			for each fileName in fileDict
				content.add "<li><a href=""?css=" & fileName & """>"
				content.add fileName
				content.add "</a></li>" & vbCrLf
			next
			content.add "</ul>"
		end if
	end if
	content.add "<h2>Main Content Heading H2</h2><p>Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. </p>"
	content.add "<ul><li>Duis aute irure dolor in reprehenderit</li><li>in voluptate velit esse cillum dolore eu fugiat , nulla pariatur.</li><li>Excepteur sint occaecat cupidatat non proident,</li><li>sunt in culpa qui officia deserunt mollit anim id est laborum.</li></ul>"
	content.add "<h3>Main Content Heading H3</h3><p>Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. </p>"
	session(CUSTOM_MESSAGE) = content.value
	set content = nothing
  %>
