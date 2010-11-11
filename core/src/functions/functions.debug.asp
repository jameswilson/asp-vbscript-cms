<%
'**
'* @file
'*   Application-level message logging and debugging.
'*
'* Due to the non-existence of system logging in ASP, this script is used 
'* througout the application for debugging and logging purposes.  It should
'* always be included in any file you write.  There are various log levels, and 

'**
'* Application log levels.
'* 
const TRACE_LEVEL = 1
const DEBUG_LEVEL = 2
const INFO_LEVEL = 3
const WARN_LEVEL = 4
const ERROR_LEVEL = 5

'**
'* Application debugging.
'*
const DISABLED = 0
const ENABLED = 1


function logMessage(message, severity)
	if not isObject(logger) then
		set logger = new CmsLogger
	end if
	call logger.log(message, severity)
end function

function trace(strMessage)
	logger.log "<p class='debug'>TRACE: " & strMessage & "</p>", TRACE_LEVEL
end function

function debug(strMessage)
	logger.log "<p class='debug'>DEBUG: " & strMessage & "</p>", DEBUG_LEVEL
end function

function debugInfo(strInfoMessage)
	logger.log "<p class='info'>INFO: " & strInfoMessage & "</p>", INFO_LEVEL
end function

function debugWarning(strWarnMessage)
	logger.log "<p class='warning'>WARNING: " & strWarnMessage & "</p>", WARN_LEVEL
end function

function debugError(strErrorMessage)
	logger.log "<p class='error'>ERROR: " & strErrorMessage & "</p>", ERROR_LEVEL
end function

public function debugMode() 
	debugMode = (globals("DEBUG") = "1")
end function

public function isDebugMode()
	isDebugMode = debugMode()
end function

'**
'* Log Cookie information at the debug level.
'* 
function debugCookies()
	if request.cookies().count > 0 then 
		debug("debugCookies() { ")
		dim key
		for each key in request.Cookies()
			debug("&nbsp;&nbsp;['"&key&"' -&gt; '"&Server.URLEncode(""&request.cookies(key))&"']")
		next
		debug("} //end debugCookies")
	else 
		debug("debugCookies() {} //no contents")
	end if
end function

'**
'* Log Session information at the debug level.
'* 
function debugSessionContents()
	if session.contents().count > 0 then 
		debug("debugSessionContents() { ")
		dim key
		for each key in session.contents()
			debug("&nbsp;&nbsp;['"&key&"' -&gt; '"&Server.URLEncode(""&session.contents(key))&"']")
		next
		debug("} //end debugSessionContents ")
	else 
		debug("debugSessionContents() {} //no contents")
	end if
end function

'**
'* Application timer is started as soon as this file gets included.
'*
dim startProgram : startProgram = timer

'**
'* Returns the current amount of time that has passed since the program started.
'*
function getProgramTime()
	dim t, unit 	
	t = timer - startProgram
	if t < 1 then
		t = t * 1000
		unit = " milliseconds"
	else
		unit = " seconds"
	end if
	getProgramTime = round(t, 1) & unit
end function

'**
'* Drop-in replacement for ASP Execute() function. Will execute the provided 
'* expression, and log the time it took to perform.
'*
'* @param string expression
'*   The expression to execute.
'* @return int
'*   Returns the time (in seconds) it took to execute expression.
'*
function ExecTimer(byval expression)
	dim t : t = timer
	Execute(expression)
	t = timer - t
	debugInfo(left(expression, 45) & iif(len(expression) > 45, "...", "") & " took " & t & " seconds.")
	ExecTimer = t
end function
%>
