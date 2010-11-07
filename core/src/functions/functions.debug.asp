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
const DEBUG_OFF = 0
const TRACE_LEVEL = 1
const DEBUG_LEVEL = 2
const INFO_LEVEL = 3
const WARN_LEVEL = 4
const ERROR_LEVEL = 5

'**
'* Set the global log level to refine how much information is logged.
'*
dim debugLevel : debugLevel = TRACE_LEVEL

'**
'* 
'*
dim strDebugHTML : set strDebugHTML = new FastString

'**
'*
'*
function logMessage(strMessage,intLevel)
	logMessage = false
	if not (intLevel < debugLevel) then 
		strDebugHTML.add strMessage & vbCrLf
		'response.write(strMessage & vbCrLf)
		logMessage = true
	end if
end function

function trace(strMessage)
	logMessage "<p class='debug'>TRACE: " & strMessage & "</p>",TRACE_LEVEL
end function

function debug(strMessage)
	logMessage "<p class='debug'>DEBUG: " & strMessage & "</p>",DEBUG_LEVEL
end function

function debugInfo(strInfoMessage)
	logMessage "<p class='info'>INFO: " & strInfoMessage & "</p>",INFO_LEVEL
end function

function debugWarning(strWarnMessage)
	logMessage "<p class='warning'>WARNING: " & strWarnMessage & "</p>",WARN_LEVEL
end function

function debugError(strErrorMessage)
	logMessage "<p class='error'>ERROR: " & strErrorMessage & "</p>",ERROR_LEVEL
end function

function printDebugHTML()
	debugInfo("Number of Database Operations: "&db.getCallCount())
	debugInfo("Total Program Execution Time: "&getProgramTime())
	if isDebugMode() and user.isAdministrator() then writeln(getDebugHTML())
end function

function getDebugHTML()
	if isDebugMode() then getDebugHTML = "<div id=""debug"" class=""clearfix"">"& vbcrlf & strDebugHTML.value & "</div><!--end debug-->"
end function

public function debugMode() 
	debugMode = (objLinks.item("DEBUG") = "1")
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
