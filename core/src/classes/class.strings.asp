<%
'**
'* @file
'*   String functions for the CMS Application.
'*


'**
'* This function takes a string and removes file extensions, converts 
'* underscores to spaces and un-does CamelCase.
'* 
'* @param text (string)
'*   The string to prettify.
'* @return String
'*   A prettified version of the provided text string.
function PrettyText(text) 
	dim anExtension : set anExtension = new RegExp
	dim a : a = cstr(text)
	anExtension.pattern = "(\.asp|\.txt|\.htm|\.html|\.inc|\.jpg|\.jpeg|\.gif|\.png|\.zip|\.gz|\.tar)"
	anExtension.global = true
	dim camel_case : set camel_case = new RegExp
	camel_case.pattern = "([a-z]?)([0-9]+)([A-Z])|([a-z])([A-Z])"
	camel_case.global = true
	
	a = replace(a, "_", " ")
	a = anExtension.replace(a, "")
	a = camel_case.replace(a, "$1$4 $2 $3$5")
	
	set anExtension = nothing
	set camel_case = nothing
	PrettyText = a
end function

'**
'* Convert a string into CamelCase (capitalize each word and remove spaces). 
'* This is useful for creating and referencing Anchor tags within a document 
'* based off of a regular Text heading.
'*
function CamelCase(byval text)
	if (not isnull(text) and (not text = "")) then
		text = replace(pcase(text), " ", "")
	end if
	CamelCase = text
end function


'*
'* This function takes a string and converts to Proper Case.
'* Prototyped by: Brian Shamblen on 3/18/99
'* This version by: ASP 101 Sample Code - http://www.asp101.com/
'*
function PCase(text)
	dim iPosition  ' Our current position in the string (First character = 1)
	dim iSpace     ' The position of the next space after our iPosition
	dim result  ' Our temporary string used to build the function's output

	' Set our position variable to the start of the string.
	iPosition = 1
	
	' We loop through the string checking for spaces.
	' If there are unhandled spaces left, we handle them...
	do while InStr(iPosition, text, " ", 1) <> 0
		' To begin with, we find the position of the offending space.
		iSpace = InStr(iPosition, text, " ", 1)
		
		' We uppercase (and append to our output) the first character after
		' the space which was handled by the previous run through the loop.
		result = result & UCase(Mid(text, iPosition, 1))
		
		' We lowercase (and append to our output) the rest of the string
		' up to and including the current space.
		result = result & LCase(Mid(text, iPosition + 1, iSpace - iPosition))

		' Note:
		' The above line is something you may wish to change to not convert
		' everything to lowercase.  Currently things like "McCarthy" end up
		' as "Mccarthy", but if you do change it, it won't fix things like
		' ALL CAPS.  I don't see an easy compromise so I simply did it the
		' way I'd expect it to work and the way the VB command
		' StrConv(string, vbProperCase) works.  Any other functionality is
		' left "as an exercise for the reader!"
		
		' Set our location to start looking for spaces to the
		' position immediately after the last space.
		iPosition = iSpace + 1
	loop

	' Because we loop until there are no more spaces, it leaves us
	' with the last word uncapitalized so we handle that here.
	' This also takes care of capitalizing single word strings.
	' It's the same as the two lines inside the loop except the
	' second line LCase's to the end and not to the next space.
	result = result & UCase(Mid(text, iPosition, 1))
	result = result & LCase(Mid(text, iPosition + 1))

	' That's it - Set our return value and exit
	PCase = result
end function

'**
'* Convert a string of text to Proper Case (aka, Title Case), capitalizing the
'* first letter of each word.
'* by: <james@elementalidad.com> 10/18/07
function scase(byval text)
	if not isNull(text) and len(text) > 0 then 
		dim rgxSentence, m : set rgxSentence = new RegExp
		rgxSentence.pattern = "[.]\s+?\b([a-z])"
		rgxSentence.ignoreCase = true
		rgxSentence.global = true
		text = UCase(Mid(text, 1, 1)) & LCase(Mid(text, 2, len(text)))
		for each m in rgxSentence.execute(text)
			text = replace(text, m.value, replace(m.value, m.submatches(0), ucase(m.submatches(0))))
		next
	end if
	scase = text
end function

'! @class FastString
'! 
'! Fast String Class:  Use this when you want 
'! to concatenate strings (implemented by an 
'! internal array).
'!
'! Written by Marcus Tucker, July 2004
'! http://marcustucker.com
'!
class FastString
	private m_counter
	private m_array()
	private m_length
	private m_initial_length

	'**
	'* Constructor initializes the class and its variables.
	private sub class_initialize()
		m_counter = 0
		m_initial_length = 128
		redim m_array(m_initial_length - 1)
		m_length = m_initial_length
	end sub
	
	'**
	'* Destructor removes an instance from memory.
	private sub class_terminate()
		erase m_array
	end sub

	'**
	'* Concatenation function adds a new string to the end of the existing one.
	'* 
	'* @param text (string)
	'*   The text string to add.
	public sub add(byref text)
		m_array(m_counter) = text
		m_counter = m_counter + 1
		
		' redim the array if necessary
		if m_counter mod m_length = 0 then
			'redimension
			redim Preserve m_array(m_counter + m_length - 1)
			
			'double the size of the array next time
			m_length = m_length * 2
		end if
	end sub

	'**
	'* Return the concatenated string.
	public property get value
		value = join(m_array, "")
	end property 

	'**
	'* Reset the string to an empty string.
	public function clear()
		m_counter = 0
		
		Redim m_array(m_initial_length - 1)
		m_length = m_initial_length
	end function
end class 

%>

