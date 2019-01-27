<%

'SUMMARY: create a dictionary object based from a string of key/value pairs.  you must specify
' the key/value delimiter, and the item delimiter that separates individual items
' in the string and key/value delimiter separates each item's key from its value.

' COLLISION RESOLUTION:  if you provide an existing dictionary as the objDict, it is useful to
' also provide the appropriate setting if a key provided in the strList already exists in the
' provided dictionary.  The possible collisionResolution options are:
'   0 : Leave the existing value in place   [DEFAULT, same as "", or , null]
'   1 : Overwrite the existing value with the new value provided in the strList.
'   2 : Append the new value provided in the strList to the existing value found in the
'       provided dictionary object.

'
' RETURNS:  a dictionary object filled with the key:value pairs in the supplied strList
' NOTICE:  if null or empty string delimiters are provided then the defaults (;) and (:)
'     will be used respectively.  ALSO:  the delimiters specified must not be the same!
const adDictIgnore = 0
const adDictOverwrite = 1
const adDictAppend = 2

function CreateDictionary(objDict,strList,strItemDelimiter,strKeyValDelimiter,collisionResolution)
	'trace("functions.lists.createDictionary: proplist='" & Server.HtmlEncode(strList) & "'")
	if not isObject(objDict) then
		trace("functions.lists.createDictionary: objDict provided is not an object, creating new dictionary")
		set objDict = nothing 'clear pre existing object contents
		set objDict = Server.CreateObject("Scripting.Dictionary")
	else
		trace("functions.lists.createDictionary: inserting items into dictionary...")
	end if
	if strItemDelimiter = "" or isNull(strItemDelimiter) then
		'trace("functions.lists.createDictionary: property delimiter not specified using default ';'")
		strItemDelimiter = ";"
	end if
	if strKeyValDelimiter = "" or isNull(strKeyValDelimiter) then
		'trace("functions.lists.createDictionary: key/value delimiter not specified using default ':'")
		strItemDelimiter = ":"
	end if
	if strItemDelimiter = strKeyValDelimiter then exit function
	dim propsArray : propsArray = split(strList, "" & strItemDelimiter)
	dim i,prop,val,key
	for i = 0 to ubound(propsArray)
		if instr(propsArray(i), "" & strKeyValDelimiter) > 0 then
			prop = split(propsArray(i), "" & strKeyValDelimiter)
			on error resume next
			key = prop(0)
			val = prop(1)
			if err.number <> 0 then
				debugError("functions.lists.createDictionary: an error occurred durring key/value separation for string '" & Server.HtmlEncode(propsArray(i)) & "'")
				debugError("functions.lists.createDictionary: key is '" & key & "'")
				debugError("functions.lists.createDictionary: value is '" & val & "'")
				debugError("functions.lists.createDictionary: Key/Value Delimiter is '" & strKeyValDelimiter & "'")
				debugError("functions.lists.createDictionary: Record Delimiter is '" & strItemDelimiter & "'")
				trapError
				on error goto 0
			else
				if objDict.exists(key) then
					'we have a collision
					select case collisionResolution
						case adDictOverwrite
							objDict.remove(key)
							objDict.add key, urldecode(val)
						case adDictAppend
							key = objDict.item(key) & "," & val
							objDict.remove(key)
							objDict.add key, urldecode(val)
						case else
							'leave existing key in place
					end select
				else
					objDict.add key, urldecode(val)
				end if
				trace(" [ " & key & " -> " & Server.HtmlEncode("" & objDict.item(key)) & "]")
			end if
		end if
	next
end function
%>
