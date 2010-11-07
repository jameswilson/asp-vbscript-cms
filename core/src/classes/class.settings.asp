<%
const KEYWORD_PREFIX = "{"
const KEYWORD_SUFFIX = "}"

class SiteSettings
	private sdNamedSettings 'cached scripting dictionary of site settings by name
	private sdIndexedSettings ' cached scripting dictionary of site settings by id
	
	private sub class_Initialize()
		initializeSiteSettings()
	end sub
	
	private sub class_Terminate()
		set sdNamedSettings = nothing
		set sdIndexedSettings = nothing
	end sub
	
	' returns the string value of the site 
	' setting with the specified id.
	public function getItemId(id)
		getItemId = sdIndexedSettings(id)
	end function
	
	public function exists(strName)
		exists = sdNamedSettings.exists(strName)
	end function
	
	' returns the string value of the site 
	' setting with the specified name.
	public function getItem(strName)
		getItem = sdNamedSettings(PCase(PrettyText(strName)))
	end function
	
	public function addItem(strKey,strVal)
		addItem = false
		if not sdNamedSettings.exists(strKey) then 
			sdNamedSettings.add strKey, strVal
			addItem = true
		end if
	end function
	
	public function getIndexedSettings()
		set getIndexedSettings = sdIndexedSettings
	end function
	
	public function updateItem(strKey,strVal)
			updateItem = false
			if sdNamedSettings.exists(strKey) then
				sdNamedSettings.remove(strKey)
				updateItem = addItem(strKey,strVal)
			end if			
	end function
	
	private sub initializeSiteSettings()
		dim rs, id, key, val, counter, i 
		set sdNamedSettings = Server.CreateObject("Scripting.Dictionary")
		set sdIndexedSettings = Server.CreateObject("Scripting.Dictionary")
		on error resume next
		set rs = db.getRecordSet("tblGlobalSettings")
		err.clear
		if rs.state = 0 then
			debugError("unable to process site settings, the database tblGlobalSettings was not found.")
		elseif rs.EOF or rs.BOF then
			debugError("The database table tblGlobalSettings was empty!")
		else
			trace("class.settings.init:  SETTINGS:")
			rs.movefirst
			do until rs.eof
				id=""&rs("SettingId")
				key=""&rs("SettingName")
				val=""&rs("SettingValue")
				if isEmpty(val) or val ="" then 
					trace(" [ "&key&" -> UNDEFINED ]")
				else
					trace(" [ "&key&" -> "&Server.HTMLEncode(""&val)&" ]")
				end if
				if not sdNamedSettings.exists(key) then
					sdNamedSettings.add key, val
					sdIndexedSettings.add id, val
					'trace("class.settings.init: key="&key&" id="&id&" val="&val)
				else
					debugError("class.settings.init: expected '"&key&"' to be a unique setting but encountered a second.")
				end if
				trapError
				rs.movenext
			loop
		end if
		rs.close
		set rs = nothing
	end sub
end class

' Add a global variable to the objLinks object.
' Overwritting any current variable if it already
' exists.
function addGlobal(strKey, strVal, strFallBack)
	strVal = GlobalVarFill(""&strVal)
	if strVal = "" then 
		if GlobalVarFill(strFallBack) <> "" then 
			strVal = GlobalVarFill(strFallBack)
		end if
	end if
	if objLinks.exists(strKey) then 
		objLinks.remove(strKey)
	end if
	objLinks.add strKey, strVal
end function

' Process the provided string, filling in any 
' global variables denoted by {}. For example,
' {SITERURL} would be converted to the real 
' site's url.
dim regex_globalVar : set regex_globalVar = new RegExp
regex_globalVar.pattern = KEYWORD_PREFIX&"([\w_ ]+)"&KEYWORD_SUFFIX
regex_globalVar.global = true



'**
'* Search the specified string for global strings, and replace them with their value.
'* Currently global strings are denoted between currly brackets, eg, {SITEURL} or {Company Name}
'* @param str the string to replace global variables
'* @return a string with all global variables replaced.
function GlobalVarFill(byval str)
	if (str <> "") and (not isnull(str)) then 
	  str = replace(str,server.urlencode(KEYWORD_PREFIX),KEYWORD_PREFIX)
	  str = replace(str,server.urlencode(KEYWORD_SUFFIX),KEYWORD_SUFFIX)
		if instr(str,KEYWORD_PREFIX)>0 then
			dim expr, matched, variableName
			set matched = regex_globalVar.execute(str)
			if matched.count > 0 then
				for each expr in matched
					variableName = Mid(expr.value,2,len(expr.value)-2)
					trace("class.settings.globalVarFill: '"&variableName&"'")
					if objLinks.exists(""&variableName) then 
						str = replace(str,expr.value,objLinks.item(""&variableName))
					elseif not globals is nothing then
							if globals.exists(PrettyText(variableName)) = true then 
								str = replace(str,expr.value, globals.getItem(PrettyText(variableName)))
							'else
'								if Execute(eval(""&variableName)) then 
'								str = eval(""&variableName)
'								end if
							end if
					end if
				next
			end if
		end if
	else
		str = ""
	end if
	GlobalVarFill = str
end function

function GlobalVarDecode(byval str,byval varList)
	on error resume next
	if (str = "") or (isnull(str)) or (varList = "") or isnull(varList) then
		GlobalVarDecode = ""
		exit function
	end if
	trace("class.settings.globalVarDecode: '"&varList&"'")
	varList = split(varList,",")
	trace("class.settings.globalVarDecode: list has "&ubound(varList)&"  items")
	str = replace(str,server.urlencode(KEYWORD_PREFIX),KEYWORD_PREFIX)
	str = replace(str,server.urlencode(KEYWORD_SUFFIX),KEYWORD_SUFFIX)
	dim i : i=0
	do
		trace("class.settings.globalVarDecode: decoding '"&varList(i)&"'")
		trace("class.settings.globalVarDecode: replaceing '"&varList(i)&"' with '"&objLinks.item(""&varList(i)) & "'" )
		str = replace(str,KEYWORD_PREFIX&varList(i)&KEYWORD_SUFFIX,objLinks(""&varList(i)))
	loop until i=ubound(varList)
	trapError
	GlobalVarDecode = str
	
end function

function GlobalVarEncode(byval str, byval varList)
	if (str = "") or (isnull(str)) or (varList = "") or isnull(varList) then
		GlobalVarEncode = ""
		exit function
	end if
	trace("class.settings.GlobalVarEncode: '"&varList&"'")
	varList = split(varList,",")
	trace("class.settings.GlobalVarEncode: list has "&ubound(varList)&"  items")
	str = replace(str,server.urlencode(KEYWORD_PREFIX),KEYWORD_PREFIX)
	str = replace(str,server.urlencode(KEYWORD_SUFFIX),KEYWORD_SUFFIX)
	dim i
	for i=0 to ubound(varList)
		str = replace(str,objLinks(""&varList(i)),KEYWORD_PREFIX&varList(i)&KEYWORD_SUFFIX)
	next
	GlobalVarEncode = str
end function

%>

