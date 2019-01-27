<!--#include file="../users/users_add.asp"-->
<!--#include file="../users/users_create.asp"-->
<!--#include file="../users/users_delete.asp"-->
<!--#include file="../users/users_edit.asp"-->
<!--#include file="../users/users_form.asp"-->
<!--#include file="../users/users_update.asp"-->
<!--#include file="../users/users_view.asp"-->
<!--#include file="../db/db.admin.functions.asp"-->
<%
	dim strSQL, strActive, strMainMenu, strFormAction, strStatus, strError, strWarn, strSuccess, strHeader
	dim variableList, strEven
	dim formContents, formErrors

	const strContent = "user" 'word that identifies the content we are administrating
	const strContentPL = "users"	'text string for plural content
	const strTableName = "tblUsers" 'name of the principle database table to modify
	const strKey = "id"  'name of the primary key field in the database
	const strIdField = "UserID" 'name of the field that uniquely identifies a row from the database
	dim myForm : set myForm = new WebForm
	myForm.Name = Pcase(strContent) &"Creator"

	strActive = ""
	strMainMenu = ""
	strFormAction = ""
	strSuccess = ""
	strStatus = ""
	strError = ""
	strWarn = ""
	variableList = "SITEURL"  'a list of variables (comma-separated) that the editor should pre-decode before displaying in the content editor
	myForm.isForNewContent = false

	if instr(Request.QueryString(),"edit")=1 then	formContents = contentEdit()
	if instr(Request.QueryString(),"update")=1 then	formContents = contentUpdate()
	if instr(Request.QueryString(),"add")=1 then formContents = contentAdd()
	if instr(Request.QueryString(),"create")=1 then	formContents = contentCreate()
	if instr(Request.QueryString(),"delete")=1 then	formContents = contentDelete()
	if instr(Request.QueryString(),"view")=1 or len(Request.QueryString())=0 then formContents = contentView()

	writeln(h1(strHeader))
	checkPageForErrors()
	myForm.printFormErrors()
	writeln(formContents)
%>
<%
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
