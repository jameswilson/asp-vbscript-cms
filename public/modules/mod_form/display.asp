<!--#include file="../../../core/include/bootstrap.asp" -->
<!--#include file="../../../core/src/classes/class.form.asp" -->
<!--#include file="email.asp"-->
<!--#include file="subscribe.asp"-->
<%
dim myForm
strDebugHTML.clear
getForm()
'printDebugHTML()

function getForm()

	dim settings, rand, id, sql, rsForm, result, css, url, default
	dim formName, myFormAction, sRequired, sName, sId, sFieldType, sClass, sDefaultVal, sCustomTags, sMessage

	CreateDictionary settings,session("ModuleCustomSettings"),CUSTOMSETTINGS_RECORD_DELIMITER,CUSTOMSETTINGS_FIELD_DELIMITER,adDictOverwrite
	debug("mod_form.display: starting mod_form module....")
	
	if settings.exists("form_id") then 
		id = settings("form_id")
		css = settings("external_css")
		debug("mod_form.display: query string was '"&request.QueryString()&"'")
	end if
	
	sql = "SELECT * FROM tblForms WHERE FormID="&id&" ORDER BY FieldSortOrder"
	set rsForm = db.getRecordset(sql)
	
	if rsForm.state = 0 then
		debugError("mod_form.display: there was an error getting form from database")
		exit function
	end if
	
	if rsForm.EOF or rsForm.BOF then
		debugError("mod_form.display: no form with id '"&id&"' exists in database")
		exit function
	end if

	debug("mod_form.display: creating form '"&id&"' from database...")
	set myForm = new WebForm
	rsForm.movefirst
	do until rsForm.EOF
		'process the form data.
		sRequired = "optional"
		if instr(rsForm("FieldValidation"),"required")> 0 then sRequired = "required"
		sName = rsForm("FieldLabel")
		sId = rsForm("FieldName")
		sFieldType = rsForm("FieldType")
		sClass = rsForm("FieldValidation")
		sDefaultVal = rsForm("FieldValue")
		sCustomTags = rsForm("CustomAttributes")
		sMessage = token_replace(rsForm("FieldDescription"))
		trace("mod_form.display: fieldId="&sId)
		trace("mod_form.display: fieldName="&sName)
		trace("mod_form.display: fieldType="&sFieldType)
		trace("mod_form.display: fieldValue="&sDefaultVal)
		trace("mod_form.display: fieldValidation="&sClass)
		trace("mod_form.display: fieldCustomTags = '"&sCustomTags&"'")
		if sId = "form_name" then 
			debugInfo("mod_form.display: initializing '"&sName&"' ...")
			myForm.setName(sName)
			myForm.setAction("?success")
			myFormAction = sDefaultVal
			myForm.setAdvancedFormWidgets instr(sClass,"advanced")>0
			writeln( sMessage )
		else 
			select case sFieldType
			 case "text","password","hidden","textarea"
					myForm.addFormInput sRequired,sName,sId,sFieldType,sClass,sDefaultVal,sCustomTags,sMessage
				case "select"
					dim options : options = split(rsForm("FieldValue"),";")
					if ubound(options) > 0 then
						myForm.addFormSelect sRequired, sName, sId, sClass, sCustomTags
						for i=0 to ubound(options)
							myForm.addFormOption options(i), options(i), options(i), ""
						next
						myForm.endFormSelect("")
					end if
				case "submit"
					myForm.addFormSubmission "",sName, "", sClass, sMessage
				case "reset"
					myForm.addFormSubmission "","", sName, sClass, sMessage
				case "button"
					myForm.addFormButton "button",sName, sClass, sCustomTags, sMessage 
				case else
					debugError("there was an error processing field of type: "&sFieldType)
			end select
		end if
		rsForm.movenext
	loop
	insertFormCSS(css)
	
	if instrrev(myFormAction,".asp")=len(myFormAction)-3 OR instrrev(myFormAction,".cgi")=len(myFormAction)-3 then 
		myForm.setAction(myFormAction)
	end if
	if myForm.wasSubmitted() and not myForm.hasErrors() then
		myForm.storeFormToSession()
		trace("mod_form.display: executing form processing...")
		select case myFormAction
			case "email"
				writeln(sendFormMail())
			case "subscribe"
				writeln(sendSubscription())
			case else
				writeln(ErrorMessage("Form Module Error:  "&myFormAction&" form submission is not yet implemented!"))
		end select
		exit function
	elseif myForm.hasErrors() then
		myForm.printFormErrors()
	end if	
	writeln( myForm.getContents() )
end function


function insertFormCSS(cssFile)
	dim myCssFile : set myCssFile = new SiteFile
	if instrrev(cssFile,".css")=len(cssFile)-3 then
		myCssFile.Path = cssFile
		if myCssFile.fileExists = false then
			'check an absolutely referenced file.
			myCssFile.Path = "/"&cssFile
			if myCssFile.fileExists = false then cssFile = ""
			'if neither exists use the default form.css included in the mod_form folder
		end if
	else 
		debug("mod_form.display: external css '"&cssFile&"' not a valid css file!")
		cssFile = ""
	end if
	if cssFile = "" then 
		%>
		<style type="text/css">
		<!--
		<!--#include file="form.css"-->
		-->
		</style>
		<%
	else 
		'writeln( "<link href="""&myCssFile.Url&""" type=""text/css"" rel=""stylesheet"">")
		writeln( link(myCssFile.Url,"stylesheet","text/css"))
	end if
end function
%>