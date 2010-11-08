<%
const TOKEN_PREFIX = "{"
const TOKEN_SUFFIX = "}"

'* Regular expression for detecting tokens.
dim TOKEN_REGEX : set TOKEN_REGEX = new RegExp
TOKEN_REGEX.pattern = TOKEN_PREFIX & "([\w_ ]+)" & TOKEN_SUFFIX
TOKEN_REGEX.global = true


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
				sid = cstr(rs("SettingId"))
				key = cstr(rs("SettingName"))
				val = cstr(rs("SettingValue"))
				if isEmpty(val) or val = "" then
					trace(" [ "&key&" -> UNDEFINED ]")
				else
					trace(" [ "&key&" -> "&Server.HTMLEncode(val)&" ]")
				end if
				if not sdNamedSettings.exists(key) then
					sdNamedSettings.add key, val
					sdIndexedSettings.add sid, val
					'trace("class.settings.init: key="&key&" sid="&sid&" val="&val)
				else
					debugError("class.settings.init: expected '"& key &"' to be a unique setting but encountered a second.")
				end if
				trapError
				rs.movenext
			loop
		end if
		rs.close
		set rs = nothing
	end sub
end class

'**
'* Add a global variable to the globals object, overwritting the current value
'* if the variable already exists.
'*
'* @param name
'*   the name of the global variable.
'* @param value
'*   the value to assign to the global
'* @param fallback
'*   the default value, used when value is empty
sub addGlobal(name, value, fallback)
	value = token_replace(cstr(value))
	if value = "" then
		if token_replace(fallback) <> "" then
			value = token_replace(fallback)
		end if
	end if
	if globals.exists(name) then
		globals.remove(name)
	end if
	globals.add name, value
end sub

'**
'* Search the specified string for global strings, and replace them with their value.
'* Currently global strings are denoted between currly brackets.
'*   eg, {SITEURL} or {Company Name}
'*
'* @param str the string to replace global variables
'* @return a string with all global variables replaced.
function token_replace(byval str)
	if (str <> "") and (not isNull(str)) then
	  str = replace(str, server.urlencode(TOKEN_PREFIX), TOKEN_PREFIX)
	  str = replace(str, server.urlencode(TOKEN_SUFFIX), TOKEN_SUFFIX)
		if instr(str, TOKEN_PREFIX) > 0 then
			dim expr, matched, variableName
			set matched = TOKEN_REGEX.execute(str)
			if matched.count > 0 then
				for each expr in matched
					variableName = Mid(expr.value, 2, len(expr.value) - 2)
					trace("class.settings.token_replace: '" & variableName & "'")
					if globals.exists("" & variableName) then
						str = replace(str, expr.value, globals("" & variableName))
					elseif not settings is nothing then
							if settings.exists(PrettyText(variableName)) = true then
								str = replace(str, expr.value, settings.getItem(PrettyText(variableName)))
							'else
							'	if Execute(eval(""&variableName)) then
							'	str = eval(""&variableName)
							'	end if
							end if
					end if
				next
			end if
		end if
	else
		str = ""
	end if
	token_replace = str
end function

'**
'* Convert a tokenized string into a plain-text string. Decoding is done by
'* removing the token identifiers (TOKEN_PREFIX and TOKEN_SUFFIX) from around
'* each instance of each variable found in the string.
'*
'* @param plaintext (String)
'*   The plain-text string to decode.
'* @param variables (String)
'*   A comma-separated list of variables to decode.
'* @return 
'*   The token-encoded string.
function GlobalVarDecode(byval plaintext, byval variables)
	on error resume next
	if (plaintext = "") or (isNull(plaintext)) or (variables = "") or isNull(variables) then
		GlobalVarDecode = ""
		exit function
	end if
	trace("class.settings.globalVarDecode: '"& variables &"'")
	variables = split(variables, ",")
	trace("class.settings.globalVarDecode: list has "& ubound(variables) &"  items")
	plaintext = replace(plaintext, server.urlencode(TOKEN_PREFIX), TOKEN_PREFIX)
	plaintext = replace(plaintext, server.urlencode(TOKEN_SUFFIX), TOKEN_SUFFIX)
	dim i : i = 0
	do
		trace("class.settings.globalVarDecode: decoding '"& variables(i) &"'")
		trace("class.settings.globalVarDecode: replaceing '"& variables(i) &"' with '"& globals(cstr(variables(i))) & "'")
		plaintext = replace(plaintext, TOKEN_PREFIX & variables(i) & TOKEN_SUFFIX, globals(cstr(variables(i))))
	loop until i = ubound(variables)
	trapError
	GlobalVarDecode = plaintext
end function

'**
'* Convert a plain-text string into a tokenized string. Encoding is done by
'* wrapping token identifiers (TOKEN_PREFIX and TOKEN_SUFFIX) around each 
'* instance of each variable found in the string.
'*
'* @param plaintext (String)
'*   The plain-text string to encode.
'* @param variables (String)
'*   A comma-separated list of variables to encode.
'* @return 
'*   The token-encoded string.
function GlobalVarEncode(byval plaintext, byval variables)
	if (plaintext = "") or isNull(plaintext) or (variables = "") or isNull(variables) then
		GlobalVarEncode = ""
		exit function
	end if
	trace("class.settings.GlobalVarEncode: '"& variables &"'")
	variables = split(variables, ",")
	trace("class.settings.GlobalVarEncode: list has "& ubound(variables) &"  items")
	plaintext = replace(plaintext, server.urlencode(TOKEN_PREFIX), TOKEN_PREFIX)
	plaintext = replace(plaintext, server.urlencode(TOKEN_SUFFIX), TOKEN_SUFFIX)
	dim i
	for i = 0 to ubound(variables)
		plaintext = replace(plaintext, globals(cstr(variables(i))), TOKEN_PREFIX & variables(i) & TOKEN_SUFFIX)
	next
	GlobalVarEncode = plaintext
end function

%>

