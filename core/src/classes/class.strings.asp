<%

'************************************************************
' This function takes a string and removes file extensions, 
' converts underscores to spaces and un-does CamelCase
' Prototyped by: Brian Shamblen on 3/18/99
' This version by: ASP 101 Sample Code - http://www.asp101.com/
'************************************************************
function PrettyText(strInput) 
	dim anExtension : set anExtension = new RegExp
	dim a : a = ""&strInput
	anExtension.pattern = "(\.asp|\.txt|\.htm|\.html|\.inc|\.jpg|\.jpeg|\.gif|\.png|\.zip|\.gz|\.tar)"
	anExtension.global = true
	dim camelCase : set camelCase = new RegExp
	camelCase.pattern = "([a-z]?)([0-9]+)([A-Z])|([a-z])([A-Z])"
	camelCase.global = true
	
	a = replace(a,"_"," ")
	a = anExtension.replace(a,"")
	a = camelCase.replace(a,"$1$4 $2 $3$5")
	
	set anExtension = nothing
	set camelCase = nothing
	prettyText = a
end function

'************************************************************
' convert a string into CamelCase (capitalize each word and
' remove spaces). this is useful for creating and referencing
' Anchor tags within a document based off of a regular Text 
' heading.
'************************************************************
function CamelCase(strPhrase)
	if (not isNull(strPhrase) and  ( not strPhrase = "")) then
		strPhrase = replace(PCase(strPhrase), " ", "")
	end if
	CamelCase = strPhrase
end function


'************************************************************
' This function takes a string and converts to Proper Case.
' Prototyped by: Brian Shamblen on 3/18/99
' This version by: ASP 101 Sample Code - http://www.asp101.com/
'************************************************************
function PCase(strInput)
	Dim iPosition  ' Our current position in the string (First character = 1)
	Dim iSpace     ' The position of the next space after our iPosition
	Dim strOutput  ' Our temporary string used to build the function's output

	' Set our position variable to the start of the string.
	iPosition = 1
	
	' We loop through the string checking for spaces.
	' If there are unhandled spaces left, we handle them...
	Do While InStr(iPosition, strInput, " ", 1) <> 0
		' To begin with, we find the position of the offending space.
		iSpace = InStr(iPosition, strInput, " ", 1)
		
		' We uppercase (and append to our output) the first character after
		' the space which was handled by the previous run through the loop.
		strOutput = strOutput & UCase(Mid(strInput, iPosition, 1))
		
		' We lowercase (and append to our output) the rest of the string
		' up to and including the current space.
		strOutput = strOutput & LCase(Mid(strInput, iPosition + 1, iSpace - iPosition))

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
	Loop

	' Because we loop until there are no more spaces, it leaves us
	' with the last word uncapitalized so we handle that here.
	' This also takes care of capitalizing single word strings.
	' It's the same as the two lines inside the loop except the
	' second line LCase's to the end and not to the next space.
	strOutput = strOutput & UCase(Mid(strInput, iPosition, 1))
	strOutput = strOutput & LCase(Mid(strInput, iPosition + 1))

	' That's it - Set our return value and exit
	PCase = strOutput
end function


'************************************************************
' This function takes a string and converts to Proper Case.
' by: James Wilson on 10/18/07
'************************************************************
function SCase(byval strInput)
	if not isNull(strInput) and len(strInput)>0 then 
		dim rgxSentence,m : set rgxSentence = new RegExp
		rgxSentence.pattern = "[.]\s+?\b([a-z])"
		rgxSentence.ignoreCase = true
		rgxSentence.global = true
		strInput = UCase(Mid(strInput, 1, 1))&LCase(Mid(strInput,2,len(strInput)))
		for each m in rgxSentence.execute(strInput)
			strInput = replace(strInput,m.value,replace(m.value,m.submatches(0),ucase(m.submatches(0))))
		next
	end if
	SCase = strInput
end function
'-------------------------------------------
' Fast String Class:  Use this when you want 
' to concatenate strings (implemented by an 
' internal array).
'-------------------------------------------
' Written by Marcus Tucker, July 2004
' http://marcustucker.com
'-------------------------------------------
class FastString
	private StringCounter
	private StringArray()
	private StringLength
	private InitStringLength
	
	'called at creation of instance
	private sub class_Initialize()
		StringCounter = 0
		InitStringLength = 128
		redim StringArray(InitStringLength - 1)
		StringLength = InitStringLength
	end sub
	
	private sub class_Terminate()
		erase StringArray
	end sub

	'add new string to array
	public sub Add(byref NewString)
		StringArray(StringCounter) = NewString
		StringCounter = StringCounter + 1
		
		'ReDim array if necessary
		if StringCounter MOD StringLength = 0 Then
			'redimension
			redim Preserve StringArray(StringCounter + StringLength - 1)
			
			'double the size of the array next time
			StringLength = StringLength * 2
		end if
	end sub
	
	'return the concatenated string
	public Property Get Value
		Value = Join(StringArray, "")
	end Property 
	
	'resets array
	public function Clear()
		StringCounter = 0
		
		Redim StringArray(InitStringLength - 1)
		StringLength = InitStringLength
	end function
end class 

%>

