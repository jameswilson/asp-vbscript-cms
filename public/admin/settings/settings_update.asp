<%
function settingUpdate()
	dim result, sql
	debug("admin."&strContentPL&".update: processing update...")
	page.setName("Update Site Settings")
	if myForm.wasSubmitted() = true then 
		debugInfo("admin."&strContentPL&".update: form was submitted, storing to the session.")
		myForm.storeFormToSession()
		 
		result = buildFormContents()
		set formErrors = myForm.getFormErrors()
		if formErrors.count = 0 then 
			dim intMenuIndex, intParentPage, email, active
			debugInfo("admin."&strContentPL&".update: form had zero errors")
			strError = "the "&strContentPL&" could not be updated to the database!"
			
			dim settingValue, settingId, bUpdate, bErrors, strErrorList, strStatusList
			bUpdate = false
			strStatus = "<ul>"
			for each settingId in globals.getIndexedSettings()
				settingValue=myForm.getValue(""&settingId)
				if isnumeric(settingId) = true and not isNull(settingValue) then 'only get the numeric ids (others will not be in the database)
					'debug("comparing '"&settingValue&"' to '"&globals.getItemId(""&settingId) &"'")
					if settingValue <> globals.getItemId(""&settingId) then 
						
						debugInfo("admin."&strContentPL&".update: updating "&strContent&" '"&settingId&"' with value '"&settingValue& "'")
						sql= "UPDATE "&strTableName&" SET SettingValue='"& Replace(settingValue,"'","''") &"', ModifiedDate=#"&now()&"# WHERE "&strKey&"="&settingId
						if isDebugMode() and user.isAdministrator() then strError = strError & "</p><p class=""debug"">SQL: "&sql
						dim bExecute : bExecute = db.execute(sql)
						if bExecute then 
							strStatusList = strStatusList & "<li> Field #"&settingId&" updated with value '"&settingValue&"'</li>" &vbcrlf
						else
							strErrorList = strErrorList & "<li> Field #"&settingId&" could not be updated with value '"&settingValue&"'</li>" &vbcrlf
						end if
						if db.hasErrors() = true then 
							dim dbErr
							bErrors = true
							for each dbErr in db.getErrors()
								strError = strError & p(dbErr.description)
							next
						end if
						bUpdate = bUpdate or (bExecute and not bErrors)
					else
						trace("admin."&strContentPL&".update: no change in "&strContent&" '"&settingId&"'")
					end if
				end if
			next
			if bUpdate = true then 
				strSuccess = "The "&strContentPL&" were updated successfully." & ul(strStatusList) 
				strStatus = ""
				strError = ""
			elseif bErrors = true then
				strSuccess = ""
				strStatus = ""
				strError = h3(TXT_ERROR)&p(scase(strError)&"An error was encountered during "&strContent&" update:<br/>") & ul(strErrorList)
			else
				strStatus = "No "&strContentPL&" were changed."
				strError = ""
			end if
			result = "<p  class=""more""><a href=""settings.asp"">Return to Site "&Pcase(strContentPL)&"</a></p>"
			
		else 
			strError  = "An error has occurred:<br/>"&strError&"<br/>"
		end if
	else
		debugInfo("admin."&strContentPL&".update: form was not submitted!")
		strError = "No "&strContent&" content was submitted to update!"
	end if
	settingUpdate = result
end function
%>
