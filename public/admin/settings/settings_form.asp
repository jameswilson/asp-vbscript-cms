<!--#include file="../../core/src/classes/class.form.asp"-->
<% 
function buildFormContents()
	with myForm
		debugInfo("Building form '"&.getName()&"' (action='"&.getAction()&"')" )
		'.CreateNew(formName, action)
		createFieldsetForCategory("General")
		createFieldsetForCategory("Company")
		createFieldsetForCategory("Correspondence")
		createFieldsetForCategory("Advanced")
				
		dim overlib : overlib = "<script type=""text/javascript"" src="""&objLinks.item("SITEURL")&"/core/assets/scripts/overlib_mini.js""></script>" & vbcrlf
		buildFormContents =  overlib & .getContents()
	end with 
end function	
	
function createFieldsetForCategory(cat)
	dim required, instructions
	dim extraAttributes, valueAttribute, classAttribute
	instructions = "<strong>Bold</strong> fields are required." 
	if(user.getRole() < USER_ADMINISTRATOR and cat="Advanced") then instructions = "<strong>Note:</strong> this information is editable only by the Administrator."
	dim rs : set rs = db.getRecordSet("SELECT * FROM "&strTableName&" WHERE SettingCategory = '"&cat&"' ORDER BY SortOrder, "&strIdField&"")
	if rs.state > 0 then 
		if rs.EOF or rs.BOF then
			strError =  strError& "There are no site "&strContentPL&" for category '"&cat&"'<br/>"
			debugError("createFieldsetForCategory(): no "&strContentPL&" found in database for category '"&cat&"'.")
		else
			dim formLabel
			with myForm
				.addFieldset cat,instructions				
				rs.movefirst
				do until rs.EOF
					extraAttributes = DBMEMO 'all site settings value fields have size of MS access memo
					valueAttribute = rs("SettingValue")
					required = "optional"
					if (rs("ValueType") = "checkbox") or (rs("ValueType") = "checkbox") then
						if user.getRole() < USER_ADMINISTRATOR and cat="Advanced" then extraAttributes=extraAttributes&DISABLED
						if rs("SettingValue") = "1" then 
							extraAttributes = extraAttributes & " checked=""checked"""
						end if
						valueAttribute = "1" 'the default value, if item gets checked.
					else
						if user.getRole() < USER_ADMINISTRATOR and cat="Advanced" then extraAttributes=extraAttributes&READONLY
					end if
					if instr(rs("ValidationRule"),"required") > 0 then 
						required = "required"
					end if
					formLabel = rs(strIdField)&" <a class=""tooltip"" href=""#"" onmouseover=""return overlib('"&encode(""&rs("SettingDescription"))&"');"" onmouseout=""return nd();""><img align=""absmiddle"" src="""&objLinks.item("SITEURL")&"/core/assets/i/tango/small/gif/help-browser.gif"" alt=""?""/>"&"</a>"
					.addFormInput required, formLabel , rs("SettingId"), rs("ValueType"), rs("ValidationRule"), valueAttribute, extraAttributes, null 
					trapError
					rs.movenext
				loop
				.addFormSubmission "left","Update &raquo;","","",""
				.endFieldset()
			end with
		end if
	else
		strError = "Site Settings are not implemented in the database. "&vbcrlf
		strError = strError& "This site will not function correctly without any "&strContentPL&" stored in the database. You must <a href="""&objLinks.item("ADMINURL")&"/db/install.asp?name="&strTableName&"&path=/core/src/install/create_"&strTableName&".ddl"">install "&strContentPL&"</a>."&vbcrlf
	end if
end function
%>
