<!--#include file="testimonials_view.asp"-->
<!--#include file="testimonials_edit.asp"-->
<!--#include file="testimonials_update.asp"-->
<!--#include file="testimonials_add.asp"-->
<!--#include file="testimonials_create.asp"-->
<!--#include file="testimonials_delete.asp"-->
<!--#include file="testimonials_form.asp"-->
<%
	dim strSQL, strActive, strShowEmail, strFormAction, strStatus, strError, strWarn, strSuccess
	dim variableList, strEven
	dim formContents, formErrors 
	
	const strContent = "testimonial" 'word that identifies the content we are administrating
	const strContentPL = "testimonials"	'text string for plural content
	const strTableName = "tblTestimonials" 'name of the principle database table to modify
	const strKey = "ID"  'name of the primary key field in the database
	const strIdField = "Name" 'name of the field that uniquely identifies a row from the database
	dim myForm : set myForm = new WebForm
	myForm.Name = Pcase(strContent) &"Creator"
	
	strActive = ""
	strShowEmail = ""
	strFormAction = ""
	strSuccess = ""
	strStatus = ""
	strError = ""
	strWarn = ""
	variableList = "SITEURL"  'a list of variables (comma-separated) that the editor should pre-decode before displaying in the content editor
	myForm.isForNewContent = false

	if instr(Request.QueryString(),"edit")=1 then
		formContents = contentEdit()
		set formErrors = myForm.getFormErrors() 
	'UPDATE
	elseif instr(Request.QueryString(),"update")=1 then
		formContents = contentUpdate()
		set formErrors = myForm.getFormErrors() 
	'INSERT NEW
	elseif instr(Request.QueryString(),"add")=1 then
		formContents = contentAdd()
	'CREATE NEW
	elseif instr(Request.QueryString(),"create")=1 then
		formContents = contentCreate()
	'DELETE EXISTING 
	elseif instr(Request.QueryString(),"delete")=1 then
		formContents = contentDelete()
	'VIEW LIST (by default)
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

'function getTableData(strKeyName,strKeyValue,strTableName)
'	dim rs, sd, key, counter, i, sql
'	sql="SELECT * "_
'		 &"FROM "& strTableName &" "_
'		 &"WHERE ("& strTableName &"."& strKeyName &"="& strKeyValue &");"
'	set sd = Server.CreateObject("Scripting.Dictionary")
'	set rs = db.getRecordSet(sql)
'	if rs.EOF and rs.BOF then
'		strError = "There is no "& strContent &" with an "& strKeyName &" of "& strKeyValue &".<br/>" & _
'		"Would you like to  <a href='?view'>go back to the list</a> "& _
'		"or <a href='?create'>create a new one</a>?"
'		debugError("no data found for "& strContent &" with "& strKeyName &" '"& strKeyValue &"'.")
'		
'	else
'		rs.movefirst
'		counter = rs.fields.count		
'		do until rs.EOF
'			debug("getTableData('"& strKeyValue &"')...")				
'			for i=0 to counter-1
'				key = cstr(rs.fields.item(i).name)
'               val = cstr(rs(i))
'				trace("[ "& key &" -&gt; "& Server.HTMLEncode(val) &" ]")
'				if not sd.exists(key) then 
'					sd.add key, val
'				else
'					debugError("expected result set of 1 item but got more!  A value for '"& key &"' already exists!")
'				end if
'			next
'			if rs("Active") then strActive = " checked=checked"
'			if rs("ShowEmail") then strShowEmail = " checked=checked"
'			rs.movenext
'		loop
'		trapError
'		
'	end if
'	set getTableData = sd
'end function

%>
