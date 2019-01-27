<!--#include file="../../../../core/src/classes/class.form.asp"-->
<%
function buildFormContents(sPath)
	pageContent.add InfoMessage(h1("We're Sorry") & p("This functionality is not yet available because " & Pcase(strContent) & " administration is currently under development."))

	with myForm
		.setAdvancedFormWidgets false
'		.addFormInput "required", "Select a File...", "File", "file", "wide", "", " size=""55""",""
'		.addFormSelect "required", "Choose your Upload Directory...", "Dir","selectOne wide",""
'			getFolderListOptions myForm, "/" & FILE_FOLDER, sPath, "Dir"
'		.endFormSelect("Select the directory where you wish to upload the file.")
'		.addFormSubmission "left", "Upload", "", "", ""
'		pageContent.add .getContents()
	end with

end function
%>
