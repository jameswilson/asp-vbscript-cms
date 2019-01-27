<!--#include file="_edit.asp"-->
<!--#include file="_view.asp"-->
<!--#include file="_add.asp"-->
<!--#include file="_update.asp"-->
<!--#include file="_create.asp"-->
<!--#include file="_form.asp"-->
<!--#include file="_delete.asp"-->
<!--#include file="../db/db.admin.functions.asp"-->
<%
	'* Standard CMS admin structure and variables
	dim strHeader, strError, strWarn, strStatus, strSuccess, pageContent
	strError = ""
	strStatus =""
	strSuccess = ""
	strWarn = ""
	const connector = " &raquo; "
	const strContent = "file" 'word that identifies the content we are administrating
	const strContentPL = "files"	'text string for plural content
	const strTableName = "tblFiles" 'name of the principle database table to modify
	const strKey = "ID"  'name of the primary key field in the database
	const strIdField = "Name" 'name of the field that uniquely identifies a row from the database
	set strHeader = new FastString
	set pageContent = new FastString
	dim myForm : set myForm = new WebForm
	myForm.Name = Pcase(strContent) &"Creator"


	'* Custom strings for File Manager
	const FILE_FOLDER = "files"
	const CONTENT_TYPE = "image/gif,image/jpeg,image/jpg,image/pjpeg"
	dim MAX_FILE_SIZE:MAX_FILE_SIZE = "" & (1024 * 25) ' 25 Kilobytes max file size


	'*  Custom settings for File Manager
	myForm.isForNewContent = false
	myForm.uploadPath = "/" & FILE_FOLDER


	if instr(Request.QueryString(), "edit") = 1 then
		contentEdit()
	elseif instr(Request.QueryString(), "update") = 1 then
		contentUpdate()
	elseif instr(Request.QueryString(), "add") = 1 then
		contentAdd()
	elseif instr(Request.QueryString(), "create") = 1 then
		contentCreate()
	elseif instr(Request.QueryString(), "delete") = 1 then
		contentDelete()
	else
		contentView()
	end if

	writeln(h1(a(globals("ADMINURL") & "/docs/docs.asp", "File Manager", null, null) & connector & strHeader.value))
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
