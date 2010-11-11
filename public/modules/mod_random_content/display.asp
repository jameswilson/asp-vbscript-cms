<!--#include file="../../../core/configuration.asp" -->
<!--#include file="../../../core/src/functions/functions.html.asp" -->
<!--#include file="../../../core/src/functions/functions.debug.asp" -->
<!--#include file="../../../core/src/functions/functions.error.asp" -->
<!--#include file="../../../core/src/classes/class.settings.asp" -->
<!--#include file="../../../core/src/classes/class.modules.asp" -->
<!--#include file="../../../core/src/classes/class.strings.asp" -->
<!--#include file="../../../core/src/classes/class.db.asp" -->
<%
logger.clear
getRandomContent()
'logger.debug_dump

function getRandomContent()
	Randomize
	dim settings, rand, id, sql, rs, result, content_pre, content_post
	CreateDictionary settings,session("ModuleCustomSettings"),CUSTOMSETTINGS_RECORD_DELIMITER,CUSTOMSETTINGS_FIELD_DELIMITER,adDictOverwrite
	rand = int(1000*rnd)+1
	id = settings.item("parent_page_id")
	content_pre = settings.item("content_pre") & "&nbsp;"
	content_post = settings.item("content_post") & "&nbsp;"
	debugInfo("mod_random_content: parent page id is '"&id&"'")
	
	initDomainGlobals()
	initDatabaseGlobals()
	initSiteGlobals() 
	initDbSiteSettings() 
	
%>
<style type="text/css">
<!--
<!--#include file="style.css" -->
-->
</style>
<%
	writeln  indent(2) &"<div class=""random-content clearfix"">" & vbCrLf
	writeln  indent(3) &"<div class=""wrapper clearfix"">" & vbCrLf
	
	trace("mod_random_content: testing id '"&id&"' for validity...")
	if (not isNull(id)) and (id <> "") then 
		dim pName, pContent
		trace("mod_random_content: ... id is valid")
		trace("mod_random_content: getting random child page of parent page id '"&id&"'...")
		
		
		sql = "SELECT TOP 1 Rnd(-1*("&rand&")*Max(tblPages.PageID)) AS RandomNumber, tblPageContent.PageID, Last(tblPages.PageName) AS PageName, Max(tblPageContent.ContentID) AS ContentID, Last(tblPageContent.PageContent) AS PageContent, Max(tblPages.Active) AS Active, Last(tblPages.PageFileName) AS PageFileName, Last(tblPages.PageDescription) AS PageDescription, Last(tblPages.PageLinkHoverText) AS PageLinkHoverText, Last(tblPages.PageKeywords) AS PageKeywords, Last(tblPageContent.ModifiedDate) AS ModifiedDate "_
		&"FROM tblPages INNER JOIN tblPageContent ON tblPages.PageID=tblPageContent.PageID "_
		&"WHERE tblPages.ParentPage="&id&" AND tblPages.Active=True "_
		&"GROUP BY tblPageContent.PageID "_
		&"ORDER BY 1;"

		set rs = db.getRecordSet(sql)
		trace("got a child")
		if rs.EOF or rs.BOF then
			debugError("mod_random_content:  no child pages found with parent id '"&id&"'")
			writeln(ErrorMessage("ERROR 1001:  there is no content to display.  Page at '"&strFilePath&"' has no child pages stored in the db! "&globals("ERROR_FEEDBACK")))
		else
			trace("mod_random_content: the random selection is "&rs("PageName")&" with content id of '"&rs("ContentID")&"' and modification date of '"&rs("ModifiedDate")&"')")
			pName = token_replace(rs("PageName"))
			pUrl = rs("PageFileName")
			pHoverText = "Click here to find out more about "& pName
			pContent = token_replace(rs("PageContent"))
			trace("mod_random_content:  content-pre is '"&server.HTMLEncode(content_pre)&"'")
			debugInfo("mod_random_content: >>Random Child Page Name: "&pName)
			trace("mod_random_content: unedited page content is: ")
			trace(server.HTMLEncode(pContent))
			
			writeln(indent(4) & h2(content_pre & anchor(pUrl,pName,pHoverText, null)))
			dim regex,matched
			set regex = new RegExp
			regex.pattern = "(<(img|IMG).+?>)"
			set matched = regex.execute(pContent)
			if matched.count <> 1 then 
				trace("mod_random_content: no image found in "&pName&" page contents.")
			else
				debugInfo("mod_random_content: >>Random Child Page Image: "&server.htmlencode(matched.item(0).value ))
				writeln(indent(4) & anchor(pUrl, matched.item(0).value, pHoverText, null))
			end if
			trace("mod_random_content: checking content for paragraph")
			regex.global = true
			dim noimages : noimages = regex.replace(pContent, "")
			debug("mod_random_content: content with no images: "&server.htmlencode(noimages))
			set regex = nothing
			set regex = new RegExp
			regex.pattern = "<[pP]>(\s)*(.|\s)*?(\s)*</[pP]>"
			regex.global = false 'only get the first paragraph
			set matched = regex.execute(noimages)
			trapError
			if matched.count <> 1 then 
				debug("mod_random_content:  no content found for "&pName&" page.")
			else
				dim content : content = matched.item(0).value 
				debugInfo("mod_random_content: >>Random Child Page Content: "&server.htmlencode(content))
				writeln (indent(4) & p(content))
			end if
			if len(content_post) > 0 then writeln( indent(4) & p(content_post))
			writeln(indent(4) & "<p class=""more"">"&anchor(pUrl, "more...", "Read more about "&pName, null)&"</p>")
			trace("mod_random_content:  content-post is '"&server.HTMLEncode(content_post)&"'")
			
		end if
		
	else 
		trace("mod_random_content: ... id is not valid")
		debugError("mod_random_content: The Random content module was not provided a valid parent page id.")
		writeln(ErrorMessage("ERROR 1002: The random content module was not setup with a valid parent page id. "&globals("ERROR_FEEDBACK")))
	end if
	writeln(indent(3) &"</div>")
	writeln(indent(2) &"</div>")
end function
	
%>
