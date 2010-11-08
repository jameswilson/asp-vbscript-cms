<!--#include file="../../../core/src/classes/class.form.asp"-->
<%
function buildFormContents(sPath)
	dim sf, sRoot
	
	'get any path supplied on the url or from post
	sPath = replace(sPath,"\","/")
	
	if len(sPath)>0 then 
		'prepend the path with leading slash
		if instr(sPath,"/")<>1 then sPath = "/" & sPath 
		
		'filter out any hackers
		if instr(sPath,"/~")=1 or instr(sPath,"/..")>0 then 
			strError = "The path provided, '"& sPath &"', is invalid."
			exit function
		end if
	
		'remove double slashes 
		sPath = "/"& FILE_FOLDER &sPath
		sPath = replace(sPath,"//","/") 
	end if
	pageContent.add "<style type=""text/css"">"& vbCrLf
	pageContent.add "div.box div {margin:0 auto;}"& vbCrLf
	pageContent.add "form#"& myForm.Name &", div.context-help {display:block;width:450px;margin:1em auto;clear:both;}"& vbCrLf
	pageContent.add "form#"& myForm.Name &" {background:#ffffe1;border:solid 1px #7F9DB9;text-align:center;}"& vbCrLf
	pageContent.add "form#"& myForm.Name &" input.inputFile{border:0px solid transparent;background:transparent;}"& vbCrLf
	pageContent.add "form#"& myForm.Name &" input.button{font-size:1.1em;padding:0.5em 1em;margin:1em;border-width:1px;}"& vbCrLf
	pageContent.add "form#"& myForm.Name &" div {float:none;}"& vbCrLf
	pageContent.add "form#"& myForm.Name &" div.submit {margin:0 auto;padding:0;}"& vbCrLf
	pageContent.add "form#"& myForm.Name &" div small {margin:1em auto;}"& vbCrLf
	pageContent.add "</style>"& vbCrLf

	with myForm
		.setAdvancedFormWidgets false
		.addFormInput  "required", "Select a File...", "File",  "file", "wide", "", " size=""55""",""
		.addFormSelect "required", "Choose your Upload Directory...", "Dir","selectOne wide",""
			getFolderListOptions myForm,"/"& FILE_FOLDER,sPath,"Dir"
		.endFormSelect("Select the directory where you wish to upload the file.")
		.addFormSubmission "left","Upload","","",""
		pageContent.add .getContents()
	end with
	pageContent.add "<div class=""context-help"">"& vbCrLf
	pageContent.add  h3("Bulk Uploads?")
	pageContent.add  p("Do you have many files to upload at once? Are your uploads taking too long?")
	pageContent.add  p(token_replace("Contact {DEVELOPER_SUPPORT_LINK} to set you up with a dedicated <acronym " _
	&"title=""File Transfer Protocol: a fast & easy way to upload files to your site."">FTP</acronym> account."))
	pageContent.add "</div>"& vbCrLf
end function
%>