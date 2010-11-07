<!--#include file="../settings/settings_update.asp"-->
<!--#include file="../settings/settings_form.asp"-->
<%
	dim strSQL, strActive, strMainMenu, strFormAction, strStatus, strError, strWarn, strSuccess
	dim variableList, strEven
	dim formContents, formErrors 
	
	const strContent = "setting" 'word that identifies the content we are administrating
	const strContentPL = "settings"	'text string for plural content
	const strTableName = "tblGlobalSettings" 'name of the principle database table to modify
	const strKey = "SettingId"  'name of the primary key field in the database
	const strIdField = "SettingName" 'name of the field that uniquely identifies a row from the database
	dim myForm : set myForm = new WebForm
	myForm.Name = Pcase(strContent)&"Creator"
	myForm.Action = "?update"
	page.setName("Site Settings")
	
	strSuccess = ""
	strStatus = ""
	strError = ""
	strWarn = ""

	'UPDATE
	if instr(Request.QueryString(),"update")=1 then
		formContents = settingUpdate()
		set formErrors = myForm.getFormErrors() 
	'VIEW LIST (by default)
	else
		formContents =  buildFormContents()
	end if
	writeln(h1(page.getName()))
	checkPageForErrors()
	myForm.printFormErrors()
	writeln(formContents)

'========================================================
'       FUNCTIONS
'========================================================	
	
function checkPageForErrors()
	' Error processing and debug
	if bolErrors then	processErrors
	if strError <> "" then writeln(ErrorMessage(strError))
	if strWarn <> "" then	writeln(WarningMessage(strWarn))
	if strStatus <> "" then	writeln(InfoMessage(strStatus))
	if strSuccess <> "" then writeln(SuccessMessage(strSuccess))
end function
%>
