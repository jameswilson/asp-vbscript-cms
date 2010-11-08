<!--#include file="_edit.asp"-->
<!--#include file="_view.asp"-->
<!--#include file="_add.asp"-->
<!--#include file="_update.asp"-->
<!--#include file="_create.asp"-->
<!--#include file="_form.asp"-->
<!--#include file="_delete.asp"-->
<!--#include file="../db/db.admin.functions.asp"-->
<%
	dim strHeader, strError, strWarn, strStatus, strSuccess, pageContent
	strError = ""
	strStatus =""
	strSuccess = ""
	strWarn = ""
	const connector = " &raquo; "
	const strContent = "module" 'word that identifies the content we are administrating
	const strContentPL = "modules"	'text string for plural content
	const strTableName = "tblModules" 'name of the principle database table to modify
	const strKey = "ID"  'name of the primary key field in the database
	const strIdField = "Name" 'name of the field that uniquely identifies a row from the database
	dim myForm : set myForm = new WebForm
	myForm.Name = Pcase(strContent) &"Creator"
	set strHeader = new FastString
	set pageContent = new FastString

if instr(Request.QueryString(),"edit")=1 then contentEdit()
if instr(Request.QueryString(),"update")=1 then contentUpdate()
if instr(Request.QueryString(),"add")=1 then contentAdd()
if instr(Request.QueryString(),"create")=1 then contentCreate()
if instr(Request.QueryString(),"delete")=1 then contentDelete()
if instr(Request.QueryString(),"view")=1 or len(Request.QueryString())=0 then contentView()
	
	
	writeln(h1(a(globals("ADMINURL") &"/modules/modules.asp","Site Modules", null, null) & connector & strHeader.value))
	checkPageForErrors()
	myForm.printFormErrors()
	writeln(pageContent.value)

function checkPageForErrors()
	if bolErrors then	processErrors
	if strError <> "" then writeln(ErrorMessage(strError))
	if strWarn <> "" then	writeln(WarningMessage(strWarn))
	if strStatus <> "" then	writeln(InfoMessage(strStatus))
	if strSuccess <> "" then writeln(SuccessMessage(strSuccess))
end function
%>