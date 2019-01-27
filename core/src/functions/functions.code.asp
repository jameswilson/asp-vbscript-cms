<%
'**
'* IIF recreated for VBscript. Its no ternary operator, but still
'* indispensible for efficient VBScript coding.
'*
'* Usage:
'* strFlavor = IIF(strColor="brown", "chocolate", "not chocolate")
'*
'* @param Expression boolean expression to evaluate
'* @param Truepart the value to return if the expression is true
'* @param Falsepart the value to return if the expression is false
'* @returns Truepart if true, Falsepart if false
'* @version 2.0 Now accepts any subtype as an expression
function iif(byref Expression, byval Truepart, byval Falsepart)
	dim e
	select case varType(Expression)
		case 0,1'Empty/Null (uninitialized)/(no valid data)
			e = false
		case 2,3,4,5,6'Integer/Long/Single/Double/Currency
			e = Expression <> 0
		case 7'Date
			e = (Expression <> "")
		case 8'String
			e = (Expression <> "")
		case 9'Automation object
			e = not Expression is nothing
		case 10'Error
			e = Expression.number <> 0
		case 11'Boolean
			e = Expression
		case 12'Variant (used only with arrays of Variants)
			e = ubound(Expression) > 0
		case 13'Data-access object
			e = not Expression is nothing
		case 17'Byte
			e = Expression <> AscB(0)
		case 8192'Array
			e = ubound(Expression) > 0
		case else'unknown type!?!
			e = false
	end select

	if e then
		if isObject(Truepart) then
			set iif = Truepart
		else
			iif = Truepart
		end if
	else
		if isObject(Falsepart) then
			set iif = Falsepart
		else
			iif = Falsepart
		end if
	end if
end function
%>
