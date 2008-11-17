<%
'This file should be used during any Database connectivity in order to
'skip errors and have them handled in a clean way for the user.
'developer should put a call to "trapError" after every database transaction
'developer should put a call to "processErrors" at the end of his asp page 
'that includes this file. 

'On Error Resume Next
const ERROR_STRING_SEPARATOR = "::"
dim strTrappedErrorMessages
dim bolErrors

'Initialize variables
strTrappedErrorMessages = ""
bolErrors = false	

'**
'* call TrapError after any Database or other Object activity prone to throwing errors
'*
function TrapError()
	'trace("TrapError() called...")
	dim foundError,errString,separator
	separator = ERROR_STRING_SEPARATOR&vbcrlf
	foundError = false
	' Error Handler
	if err.number <> 0 then
 		'	Action is sensitive to type of error
 		select case err.number
			'
			'	Custom Error Handling  
			' our custom errors set err.Number property to the null string.
			' if a number is required to diferentiate uniqueness of an error,
			' then please include the number in the description field of the error!
			'
			case ""
				'trace("TrapError: setting error key to true")
				foundError = true
				errString = objLinks.item("PRODUCT_BRANDING") &" ERROR: " & err.description & "  SOURCE: "&err.source
 			
			'	
			' General Error Handling
			' 
			case else
				'trace("TrapError: setting error key to true")
				foundError = true
				'trace("TrapError: setting error string")
				errString = "VBScript ERROR [" &  err.number & "] (Ox"& Hex(Err.number) & "): " &vbcrlf _
						& "DESCRIPTION:" & err.description & vbcrlf _
						& "URL: "&request.ServerVariables("URL") & vbcrlf _
						& "SOURCE: "&err.source
				'trace("TrapError: error string is '"&errString&"'")
				if isObject(db) then
					'trace("TrapError: checking for database errors...") 
					dim errCount : errCount = db.Errors.Count
					'trace("TrapError: There were '"&errCount&"' db errors." )
	 				if errCount > 0 then
						dim e
						'for i = 0 to errCount - 1
						for each e in db.Errors
							with e'db.Errors(i)
								errString = errString&separator&"Database ERROR [" &  .number & "] (Ox"& Hex(.number) & "): " & vbcrlf _
									& .description & vbcrlf _
									& "URL: "&request.ServerVariables("URL") & vbcrlf _
									& "SOURCE: "&.source & vbcrlf _
									& "SQL STATE: "&.SQLState & vbcrlf _
									& "Native Error: "&.NativeError
							end with
						next
 					end if
				end if
			end select
			'trace("TrapError: adding error '"&errString&"'")
			call addToTrappedErrorList(errString)
			err.clear
		else
			'trace("TrapError: no error found.")
		end if
		'
		'The following boolean logic sets global bolErrors true only if foundErrors is true
		'If global bolErrors is already true then a false value here will not affect it.
		'
		bolErrors = (bolErrors OR foundError)
		TrapError = foundError 
end function

sub addToTrappedErrorList(byval strErr)
	debugError(replace(replace(strErr,ERROR_STRING_SEPARATOR,"<br/><br/>"),vbcrlf,"<br/>"))
	'response.write(p(strErr))
	strTrappedErrorMessages = strTrappedErrorMessages & strErr & ", "
end sub


'**
'* If there are any errors, this function will email tech support
'* call this sub after all your database activity is complete 
'* @todo implement actual email send and logging to database!
function ProcessErrors()
  if bolErrors = true and strTrappedErrorMessages <> "" then
		'process all errors up till now, and reset the error chain.
		bolErrors = false
		strTrappedErrorMessages = ""
    'Send the email
    'Dim objCDO
    'Set objCDO = Server.CreateObject("CDONTS.NewMail")

    'objCDO.To = "techsupport@mysite.com"
    'objCDO.From = "techsupport@mysite.com"
    'objCDO.Subject = "AN ADO ERROR OCCURRED"
    'objCDO.Body = "At " & Now & " the following errors occurred on " & _
		'  "the page " & Request.ServerVariables("SCRIPT_NAME") & _
		'  ": " & _
    '              chr(10) & chr(10) & strTrappedErrorMessages
		writeln(p(strTrappedErrorMessages))
		debug("EMAIL SENT TO ADMIN ABOUT ERROR")
    'objCDO.Send

    'Set objCDO = Nothing

    'print out something for the client
		debug("CLIENT INFORMED ABOUT ERROR VIA WEBPAGE")
    ProcessErrors =  "<p class='alert'>There has been an error during page load. Technical Support " & vbCrLf & _
                   "has already been notified.  You will be informed when " &  vbCrLf &_
                   "this issue is resolved.  Thank you for your patience!</p>"
		
  end if
end function
 
'return true if error(s) found in page execution
function pageHasErrors()
	pageHasErrors = bolErrors
end function

'return String of errors.
'return empty string "" if no error(s)
function getErrors()
	getErrors = strTrappedErrorMessages
end function

%>
