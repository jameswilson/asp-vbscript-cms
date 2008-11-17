<%
dim startProgram : startProgram = timer
' DEBUG LEVEL SETTING determines how much junk gets spit out if DebugMode is ON
dim debugLevel : debugLevel = TRACE_LEVEL

' Preset DEBUG levels
const DEBUG_OFF = 0
const TRACE_LEVEL = 1
const DEBUG_LEVEL = 2
const INFO_LEVEL = 3
const WARN_LEVEL = 4
const ERROR_LEVEL = 5

dim strDebugHTML : set strDebugHTML = new FastString
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

'standard debuging functions to present session and cookie information if DEBUG is ON
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

function getProgramTime()
	dim t,unit 
	'for t=0 to 100000
	'	unit = unit&"a"
	'next	
	t = timer - startProgram
	if t<1 then
		t= t*1000
		unit = " milliseconds"
	else
		unit = " seconds"
	end if
	getProgramTime = round(t,1) & unit
end function

function ExecTimer(byval sExpr)
	dim t : t = timer
	Execute(sExpr)
	debugInfo(left(sExpr,45) & iif(len(sExpr)>45,"...","") & " took "& (timer-t) & " seconds.")
end function
%>
