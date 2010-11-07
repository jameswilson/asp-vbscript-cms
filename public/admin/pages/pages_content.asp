<!--#include file="pages_view.asp"-->
<!--#include file="pages_edit.asp"-->
<!--#include file="_delete.asp"-->
<!--#include file="pages_update.asp"-->
<!--#include file="pages_add.asp"-->
<!--#include file="pages_create.asp"-->
<!--#include file="pages_form.asp"-->
<!--#include file="../db/db.admin.functions.asp"-->
<%
'addGlobal "DEBUG","1",null
	dim strHeader, strSQL, strActive, strMainMenu, strFormAction, strStatus, strError, strWarn, strSuccess, pageContent
	dim variableList, strEven
	dim formContents, formErrors
	set strHeader = new FastString
	set pageContent = new FastString
	const connector = " &raquo; "
	const strContent = "page" 'word that identifies the content we are administrating
	const strContentPL = "pages"	'text string for plural content
	const strTableName = "tblPages" 'name of the principle database table to modify
	const strKey = "PageID"  'name of the primary key field in the database
	const strIdField = "PageName" 'name of the field that uniquely identifies a row from the database
	dim myForm : set myForm = new WebForm
	
	const CSS_FOLDER = "/styles/"

function customContent()	
	strActive = ""
	strMainMenu = ""
	strFormAction = ""
	strSuccess = ""
	strStatus = ""
	strError = ""
	strWarn = ""
	variableList = "SITEURL"  'a list of variables (comma-separated) that the editor should pre-decode before displaying in the content editor
	myForm.Name = Pcase(strContent)&"Creator"
	myForm.isForNewContent = false

	if instr(Request.QueryString(),"edit")=1 then 
		contentEdit()
	elseif instr(Request.QueryString(),"update")=1 then 
		contentUpdate()
	elseif instr(Request.QueryString(),"add")=1 then 
		contentAdd()
	elseif instr(Request.QueryString(),"create")=1 then 
		contentCreate()
	elseif instr(Request.QueryString(),"delete")=1 then 
		contentDelete()
	else 
		contentView()
	end if
	
	writeln(h1(page.getBreadcrumbs))
	checkPageForErrors()
	myForm.printFormErrors()
	writeln(pageContent.value)
end function
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
