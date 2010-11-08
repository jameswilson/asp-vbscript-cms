<!--#include file="categories_view.asp"-->
<!--#include file="categories_edit.asp"-->
<!--#include file="categories_update.asp"-->
<!--#include file="categories_add.asp"-->
<!--#include file="categories_create.asp"-->
<!--#include file="categories_form.asp"-->
<!--#include file="categories_delete.asp"-->
<!--#include file="../image_upload.asp"-->
<%
	dim strSQL, strActive, strRecommended, strFormAction, strStatus, strError, strWarn, strSuccess
	dim variableList, strEven
	dim formContents, formErrors 
		
	const strContent = "category" 'word that identifies the content we are administrating
	const strContentPL = "categories"	'text string for plural content
	const strTableName = "tblProducts" 'name of the principle database table to modify
	const strKey = "Key"  'name of the primary key field in the database
	const strIdField = "Category" 'name of the field that uniquely identifies a row from the database
	const strUploadPath = "/images/products"
	const strFileFormats = "image/gif,image/jpeg,image/jpg,image/pjpeg"	
	dim maxFileSize: maxFileSize = Cstr(1024 * 25) ' 25 Kilobytes max file size
	
		
	dim myForm : set myForm = new WebForm
	myForm.Name = Pcase(strContent) &"Creator"
	myForm.isForNewContent = false
	myForm.uploadPath = strUploadPath

	
	strActive = ""
	strRecommended = ""
	strFormAction = ""
	strSuccess = ""
	strStatus = ""
	strError = ""
	strWarn = ""	

	if instr(Request.QueryString(),"edit")=1 then
		formContents = contentEdit()
		set formErrors = myForm.getFormErrors() 
	elseif instr(Request.QueryString(),"update")=1 then
		formContents = contentUpdate()
		set formErrors = myForm.getFormErrors() 
	elseif instr(Request.QueryString(),"add")=1 then
		formContents = contentAdd()
	elseif instr(Request.QueryString(),"create")=1 then
		formContents = contentCreate()
	elseif instr(Request.QueryString(),"delete")=1 then
		formContents = contentDelete()
	else
		formContents = contentView()
	end if
	writeln(h1(page.getName()))
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
