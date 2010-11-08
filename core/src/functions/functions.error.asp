<%
'**
'* @file
'*   Application and runtime error handling.
'*
'* This file should be used during any Database connectivity in order to skip
'* errors and have them handled in a clean way for the user. Place a call to
'* trapError() after every database transaction, and a call to processErrors()
'* at the end of any that includes this file.
'*
'on error resume next

' Runtime errors are collected in a primitive string type.
dim runtimeErrors : runtimeErrors = ""

' The runtime errors are distinguished by a separator.
const ERROR_STRING_SEPARATOR = "::"

' Boolean type for tracking page errors.
' Typically used at the footer
dim bolErrors : bolErrors = FALSE

'**
'* This function will catch any runtime errors that may result from various
'* operations. Place a call to TrapError after any database or other object
'* prone to throwing runtime errors.
'*
'* Currently the application throws errors through the standard Err object
'* provided by ASP. Application-level errors are denoted with the Err.Number
'* property set to the null string. If a unique ID number is required to
'* identify an application-level error, then its number should be included
'* in the Err.Description property.
'*
function TrapError()
	dim foundError, errString, separator
	separator = ERROR_STRING_SEPARATOR & vbCrLf
	foundError = FALSE
	if err.number <> 0 then
 		select case err.number
			' Handle application errors:
			case ""
				foundError = TRUE
				errString = globals("PRODUCT_BRANDING") &" ERROR: "& err.description &"  SOURCE: "& Err.source
 			
			' Handle general ASP runtime errors.
			case else
				foundError = TRUE
				errString = "VBScript ERROR ["& err.number &"] (Ox"& Hex(err.number) &"): "& vbCrLf _
					& "DESCRIPTION:" & err.description & vbCrLf _
					& "URL: " & request.ServerVariables("URL") & vbCrLf _
					& "SOURCE: " & Err.source
				if isObject(db) then
					dim errCount : errCount = db.Errors.Count
					if errCount > 0 then
						dim e
						for each e in db.Errors
							with e
								errString = errString & separator & "Database ERROR [" _
									& .number & "] (Ox" & Hex(.number) & "): " & vbCrLf _
									& .description & vbCrLf _
									& "URL: " & request.ServerVariables("URL") & vbCrLf _
									& "SOURCE: " & .source & vbCrLf _
									& "SQL STATE: " & .SQLState & vbCrLf _
									& "Native Error: " & .NativeError
							end with
						next
 					end if
				end if
		end select
		call storeRuntimeError(errString)
		err.clear
	end if
	'
	' The following boolean logic sets global bolErrors TRUE only if
	' foundError is TRUE. If global bolErrors is already TRUE then a value of
	' FALSE will not affect it.
	'
	bolErrors = (bolErrors OR foundError)
	TrapError = foundError
end function

'**
'* Subroutine to handle adding error messages to the runtimeErrors string.
'*
'* @param String message
'*   The error message to add
sub storeRuntimeError(byval message)
	debugError(replace(replace(message, ERROR_STRING_SEPARATOR, "<br/><br/>"), vbCrLf, "<br/>"))
	'response.write(p(message))
	runtimeErrors = runtimeErrors & message & ", "
end sub

'**
'* Process runtime errors by gathering them into a string presentable for web
'* and clearing the global runtime error cache.
'*
function ProcessErrors()
	ProcessErrors = ""
	if bolErrors = TRUE and runtimeErrors <> "" then
		debug("Runtime errors were encountered.")
		dim status : status = getRuntimeErrors
		
		' Clear the global errors after processing.
		bolErrors = FALSE
		runtimeErrors = ""
		
		' Return the status message.
		ProcessErrors = status
	end if
end function

'**
'* Helper identifies if there were errors found in the page.
'*
'* @return bool
'*   TRUE if error(s) found in page execution
'*
function pageHasErrors()
	pageHasErrors = bolErrors
end function

'**
'* Return web-formatted list of runtime errors.
'*
'* @return string
'*   The string of runtime error messages, returns empty string if no errors.
function getRuntimeErrors()
	dim separator, status
	separator = "</li>" & vbCrLf & "<li>"
	getRuntimeErrors = "<p class='alert'>An Error has occurred during page load.</p>" & vbCrLf _
		& "<ul><li>" & vbCrLf _
		& replace(replace(runtimeErrors, ERROR_STRING_SEPARATOR, separator), vbCrLf, "<br/>")
end function
%>
