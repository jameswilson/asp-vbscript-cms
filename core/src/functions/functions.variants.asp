<%
'**
'* @file
'*   Variant helper functions.
'* 

'**
'* Cast a variable to another variant type.
'*
'* @param thing (variant)
'*   The variable to cast.
'*
'* @param vartyp (int)
'*   The integer representation of the vartype to which to cast.
'*
'* @return Variant
'*   The thing cast to the new variant type.
function cast(byval thing, byval vartyp)
	dim unsafe
	on error resume next
	select case vartyp
		case 0'Empty (uninitialized)
			cast = empty
		case 1'Null (no valid data)
			cast = null
		case 2'Integer
			cast = CInt(thing)
		case 3'Long integer
			cast = CLng(thing)
		case 4'Single precision floating-point number
			cast = CSng(thing)
		case 5'Double precision floating-point number
			cast = CDbl(thing)
		case 6'Currency
			cast = CCur(thing)
		case 7'Date
			cast = Date(thing)
		case 8'String
			cast = CStr(thing)
		case 9'Automation object
			cast = "casting of Automation objects is not implemented!"
		case 10'Error
			cast = error(thing)
		case 11'Boolean
			cast = cbool(thing)
		case 12'Variant (used only with arrays of Variants)
			cast = Array(thing)
		case 13'Data-access object
			cast = "casting of Data-access objects is not implemented!"
			unsafe = true
		case 17'Byte
			cast = CByte(thing)
		case 8192'Array
		case 8204'Variant Array
			cast = Array(thing)
		case else
			cast = "unknown vartype: "& vartyp &""
			unsafe = true
	end select
	if err.number <> 0 then
		on error goto 0
		err.raise 6, "Cast Error", build_message("unable to convert <"&"?"&"> to vartype <"&"?"&">", Array(thing, vartyp))
	elseif unsafe = true then
		on error goto 0
		err.raise 6, "Cast Error", cast
	end if
end function