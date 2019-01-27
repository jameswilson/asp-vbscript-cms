<%
dim banner_file : banner_file = eval("m_banner_file")
dim strSelected, strActive

debug("mod_banner.fields: the banner file is: " & banner_file)
myForm.addFormInput  "required", "Banner Config File", "mod_banner_file", "text", "", banner_file, DBTEXT,"The path to the banner file (references from the project root /). Change this only if you know what you are doing!"
%>
