<!--#include file="../../../core/include/bootstrap.asp" -->
<!--#include file="../../../core/src/classes/class.form.asp" -->
<%
dim myForm
strDebugHTML.clear
getContent()
'printDebugHTML()

function getContent()
	dim settings, content
	CreateDictionary settings,session("ModuleCustomSettings"),CUSTOMSETTINGS_RECORD_DELIMITER,CUSTOMSETTINGS_FIELD_DELIMITER,adDictOverwrite
	debug("mod_html_snippet.display: starting mod_html_snippet module....")
	if settings.exists("content") then 
		content = settings("content")
		debug("mod_html_snippet.display: content to display: "&codeblock(server.htmlencode(content)) )
		writeln(token_replace(content))
	else
		debug("mod_html_snippet.display: no content found in this snippet.") 
	end if
end function
%>