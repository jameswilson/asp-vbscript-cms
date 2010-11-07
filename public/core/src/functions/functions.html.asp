<%
'------------------------------------------------
' FUNCTIONS FOR WRITING VALID XHTML FROM VBSCRIPT
'------------------------------------------------


'** 
'* Define the global indentation character for printing xHTML to the Response object
'* Possible values could be one (or more) space or tab characters.
const HTML_INDENT = " " 'vbTab

dim emlFormat :	set emlformat = new RegExp
emlformat.pattern = "((mailto:)?\w+([+.-]\w+)*@\w+([.-]\w+)*\.\w{2,8})"
emlformat.ignoreCase = True
emlformat.global = True

'**
'* Write a line of text/html to the response object. A shorthand wrapper 
'* for VBScript `response.write` with trailing VBScript linebreak.
'*
'* @param the text/html string to write to the response buffer.
'*
function writeln(byval str)
	response.write EmailObfuscate(""& str & vbcrlf)
end function

'**
'* Apply the specified indent levels to improve legibility of generated HTML.
'* @param int n the number of indentations to insert
'* @return the number of indentations specified as a chain of VBTAB, or space characters. 
'*
function indent(byval n)
	dim i, a
	set a = new FastString
	a.add ""
	for i = 0 to n-1
		a.add "" & HTML_INDENT
	next
	indent = a.value
	set a = nothing
end function

'**
'* Apply the specified xHTML tag around the specified string of text. 
'* The optional parameters will not be included if they are empty string or null.
'*
'* @param strTag the name of the xHTML tag to create
'* @param strAttributes the string of preformatted attributes to apply to the tag.
'* @param strContent the contents to appear inside the tag.
'* @return a string wrapped in the specified xHTML tag
'* 
'*
'* @todo improve functionality of strAttributes to send a list of 
'*       key/value pairs and do the attribute creation here
'*
function createTag(byval strTag, byval strAttributes,byval strContent)
	dim result : set result = new FastString
	result.add "<"&lcase(strTag)&strAttributes
	if not isNull(strContent) and (strContent <> "") then 
		result.add ">"&GlobalVarFill(strContent)&"</"&lcase(strTag)&">"
	else
		result.add "/>"
	end if
	createTag = result.value
	set result = nothing
end function


'**
'* Create an xHTML Anchor <a> tag with the specified url, title, class, and content
'*
'* @param strURL the relative or absolute url of the image file 
'* @param strContent the visible text/html string contained by the anchor. 
'* @param strTitleText a string description of the anchor used to populate title/alt attributes. 
'* @param strClass a custom class attribute to apply to the anchor. 
'* @return an xHTML anchor tag containing the specified url, title, class, and content 
'*
function anchor(byval strURL,byval strContent,byval strTitleText,byval strClass)
	if not isNull(strURL) and (strURL <> "") then strURL = " href="""&strURL&""""
	if not isNull(strTitleText) and (strTitleText <> "") then strTitleText = " title="""&strTitleText&""""
	if not isNull(strClass) and (strClass <> "") then strClass = " class="""&strClass&""""
	anchor = createTag("a",strURL&strTitleText&strClass,strContent)
end function

'**
'* Create an xHTML Image <img> tag with the specified source, alt, title, and class attributes.
'*
'* @param strURL the relative or absolute url of the image file 
'* @param strAlternateText a string description of the media file/folder used to populate title/alt attributes. 
'* @param strTitleText a string description of the media file/folder used to populate title/alt attributes. 
'* @param strClass a custom class attribute to apply to the image  tag. 
'* @return an xHTML image tag containing the specified url, title, alt and class.  
'*
function image(byval strURL,byval strAlternateText,byval strTitleText,byval strClass)
	'check image source for relative URL
	if instr(strURL,"http") <> 1 then 
		if instr(strURL,"/") = 1 then
			'apply siteurl root to image
			strURL = objLinks.item("SITEURL") & strURL
		else
			'leave relative links alone
		end if
	end if
	if not isNull(strURL) and (strURL <> "") then strURL = " src="""&strURL&""""
	'if not isNull(altAttribute) and (altAttribute <> "") then 
	strAlternateText = " alt="""&strAlternateText&""""
	'if not isNull(titleAttribute) and (titleAttribute <> "") then 
	strTitleText = " title="""&strTitleText&""""
	if not isNull(strClass) and (strClass <> "") then strClass = " class="""&strClass&""""
	image = createTag("img",strClass&strURL&strAlternateText&strTitleText,null)
end function

'**
'* Apply the xHTML paragraph tag around the specified string of text. 
'* The optional parameters will not be included if they are empty string or null.
'*
'* @param strText the contents to appear inside the tag.
'* @param strTitle (optional) a title attribute to apply to the tag.
'* @param strId (optional) a unique id to apply to the tag.
'* @param strClass (optional) a string of class(es) to apply to the tag.
'* @return a string wrapped in xHTML p tag
'*
function paragraph(byval strText,byval strTitle,byval strId,byval strClass)
	if not isNull(strClass) and (strClass <> "") then strClass = " class="""&strClass&""""
	if not isNull(strId) and (strId <> "") then strId = " id="""&strId&""""
	if not isNull(strTitle) and (strTitle <> "") then strTitle = " title="""&strTitle&""""
	paragraph = createTag("p",strClass&strId&strTitle,strText)
end function


'**
'* Apply the xHTML division tag around the specified string of text. 
'* The optional parameters will not be included if they are empty string or null.
'*
'* @param strText the contents to appear inside the tag.
'* @param strTitle (optional) a title attribute to apply to the tag.
'* @param strId (optional) a unique id to apply to the tag.
'* @param strClass (optional) a string of class(es) to apply to the tag.
'* @return a string wrapped in xHTML div tag
'*
function division(byval strText,byval strTitle,byval strId,byval strClass)
	if not isNull(strClass) and (strClass <> "") then strClass = " class="""&strClass&""""
	if not isNull(strId) and (strId <> "") then strId = " id="""&strId&""""
	if not isNull(strTitle) and (strTitle <> "") then strTitle = " title="""&strTitle&""""
	division = createTag("div",strClass&strId&strTitle,strText)
end function

'**
'* Apply the xHTML unordered list tag around the specified string of text --
'* preferably a string of list items <li>. 
'* The optional parameters will not be included if they are empty string or null.
'*
'* @param strText the contents to appear inside the tag.
'* @param strTitle (optional) a title attribute to apply to the tag.
'* @param strId (optional) a unique id to apply to the tag.
'* @param strClass (optional) a string of class(es) to apply to the tag.
'* @return a string wrapped in xHTML div tag
'*
function UnorderedList(byval strText,byval strTitle,byval strId,byval strClass)
	if not isNull(strClass) and (strClass <> "") then strClass = " class="""&strClass&""""
	if not isNull(strId) and (strId <> "") then strId = " id="""&strId&""""
	if not isNull(strTitle) and (strTitle <> "") then strTitle = " title="""&strTitle&""""
	UnorderedList = createTag("ul",strClass&strId&strTitle,strText)
end function

'**
'* Apply the xHTML unordered list tag around the specified string of text --
'* preferably a string of list items <li>. 
'* The optional parameters will not be included if they are empty string or null.
'*
'* @param strText the contents to appear inside the tag.
'* @param strTitle (optional) a title attribute to apply to the tag.
'* @param strId (optional) a unique id to apply to the tag.
'* @param strClass (optional) a string of class(es) to apply to the tag.
'* @return a string wrapped in xHTML div tag
'*
function OrderedList(byval strText,byval strTitle,byval strId,byval strClass)
	if not isNull(strClass) and (strClass <> "") then strClass = " class="""&strClass&""""
	if not isNull(strId) and (strId <> "") then strId = " id="""&strId&""""
	if not isNull(strTitle) and (strTitle <> "") then strTitle = " title="""&strTitle&""""
	OrderedList = createTag("ol",strClass&strId&strTitle,strText)
end function



'**
'* Create an xHTML-formatted message box for the specified string of text. 
'*
'* @param strText the contents to appear inside the tag.
'* @param strMessageTypeClass the type of message to display (error, info, success, warning, etc)
'* @return a string wrapped in xHTML message box
'*
function Message(byval strText,byval strMessageTypeClass)
	if len(trim(strText))>0 then Message = division(strText&brClearAll,null,null,strMessageTypeClass&" message")
end function


'**
'* Create an xHTML-formatted codeblock for the specified string of text. The text will appear
'* as a unified block of preformatted (mono-spaced) programing code. 
'*
'* @param strText the contents to appear inside the tag.
'* @return a string wrapped in xHTML formatted code block
'*
function CodeBlock(byval strText)
	if len(trim(strText))>0 then CodeBlock = createTag("blockquote",null,createTag("code",null,server.htmlencode(strText)))
end function

'**
'* A shorthand wrapper for the xHTML Anchor tag.
'* @param the string contents to appear inside the tag.
'* @see anchor()
'*
function a(byval hrefAttribute,byval content,byval titleAttribute,byval classAttribute)
	a = anchor(hrefAttribute, content, titleAttribute, classAttribute)
end function

'**
'* A shorthand wrapper for the xHTML Image tag.
'*
'* @param strURL the relative or absolute url of the image file 
'* @param strAlternateText a string description of the media file/folder used to populate title/alt attributes. 
'* @param strTitleText a string description of the media file/folder used to populate title/alt attributes. 
'* @param strClass a custom class attribute to apply to the media file tag. 
'* @return an xHTML markup and supporting javascripts for displaying the specified media file 
'* @see image()
'*
function img(byval strURL,byval strAlternateText,byval strTitleText,byval strClass)
	img = image(strURL,strAlternateText,strTitleText,strClass)
end function


'**
'* A shorthand wrapper for the xHTML Division tag.
'*
'* @param strText the contents to appear inside the tag.
'* @param strTitle (optional) a title attribute to apply to the tag.
'* @param strId (optional) a unique id to apply to the tag.
'* @param strClass (optional) a string of class(es) to apply to the tag.
'* @return a string wrapped in xHTML div tag
'* @see division()
'*
function div(byval strText,byval strTitle,byval strId,byval strClass)
	div = division(strText,strTitle,strId,strClass)
end function

'**
'* A shorthand wrapper for the xHTML Paragraph tag.
'*
'* @param the string contents to appear inside the tag.
'* @return a string wrapped in xHTML p tag
'* @see paragraph()
'*
function p(byval str)
	p = paragraph(str,null,null,null)
end function

'**
'* A shorthand wrapper for the xHTML UnorderedList tag.
'*
'* @param the string contents to appear inside the tag.
'* @return a string wrapped in xHTML ul tag
'* @see UnorderedList()
'*
function ul(byval str)
	ul = UnorderedList(str,null,null,null)
end function

'**
'* A shorthand wrapper for the xHTML OrderedList tag.
'*
'* @param the string contents to appear inside the tag.
'* @return a string wrapped in xHTML ol tag
'* @see OrderedList()
'*
function ol(byval str)
	ol = OrderedList(str,null,null,null)
end function


'**
'* Create an informative message displaying the specified string inside a specially formatted Message() box.
'* @param the string contents to appear inside the info box.
'* @return a string wrapped in xHTML-formatted Info Message box
'* @see Message()
'*
function InfoMessage(byval str)
	InfoMessage = Message(str,"info")
end function

'**
'* Create a warning message displaying the specified string inside a specially formatted Message() box.
'* @param the string contents to appear inside the warning box.
'* @return a string wrapped in xHTML-formatted Warning Message box
'* @see Message()
'*
function WarningMessage(byval str)
	WarningMessage = Message(str,"warning")
end function

'**
'* Create an alert message displaying the specified string inside a specially formatted Message() box.
'* @param the string contents to appear inside the alert box.
'* @return a string wrapped in xHTML-formatted Alert Message box
'* @see Message()
'*
function AlertMessage(byval str)
	AlertMessage = Message(str,"warning")
end function

'**
'* Create a success message displaying the specified string inside a specially formatted Message() box.
'* @param the string contents to appear inside the success box.
'* @return a string wrapped in xHTML-formatted Success Message box
'* @see Message()
'*
function SuccessMessage(byval str)
	SuccessMessage = Message(str,"success")
end function

'**
'* Create an error message displaying the specified string inside a specially formatted Message() box.
'* @param the string contents to appear inside the error box.
'* @return a string wrapped in xHTML-formatted Error Message box
'* @see Message()
'*
function ErrorMessage(byval str)
	ErrorMessage = Message(str,"error")
end function

'**
'* Create a mail sent succesfully message displaying the specified string inside a specially formatted Message() box.
'* @param the string contents to appear inside the error box.
'* @return a string wrapped in xHTML-formatted Mail Sent Message box
'* @see Message()
'*
function MailSentMessage(byval str)
	MailSentMessage = Message(str,"mail-success")
end function


'**
'* A helper function for inserting a Clearing Break xHTML BR tag.
'*
function brClearAll()
	brClearAll = "<br clear=""all""/>"
end function

'**
'* Apply the xHTML preformatted tag around the specified string.
'* @param the string contents to appear inside the tag.
'* @return a string wrapped in xHTML pre tag
'*
function pre(byval str)
	pre = ("<pre>"&str&"</pre>"&vbcrlf)
end function

'**
'* Apply the xHTML Heading 1 tag around the specified string.
'* @param the string contents to appear inside the tag.
'* @return a string wrapped in xHTML Heading 1
'*
function h1(byval str)
	h1 = ("<h1>"&str&"</h1>"&vbcrlf)
end function

'**
'* Apply the xHTML Heading 2 tag around the specified string.
'* @param the string contents to appear inside the tag.
'* @return a string wrapped in  xHTML heading 2 
'*
function h2(byval str)
	h2 = ("<h2>"&str&"</h2>"&vbcrlf)
end function

'**
'* Apply the xHTML Heading 3 tag around the specified string.
'* @param the string contents to appear inside the tag.
'* @return an xHTML heading 3 
'* 
function h3(byval str)
	h3 = ("<h3>"&str&"</h3>"&vbcrlf)
end function

'**
'* Apply the xHTML Heading 4 tag around the specified string.
'* @param the string contents to appear inside the tag.
'* @return an xHTML heading 4 
'* 
function h4(byval str)
	h4 = ("<h4>"&str&"</h4>"&vbcrlf)
end function

'**
'* Apply the xHTML Heading 5 tag around the specified string.
'* @param the string contents to appear inside the tag.
'* @return an xHTML heading 5 
'* 
function h5(byval str)
	h5 = ("<h5>"&str&"</h5>"&vbcrlf)
end function

'**
'* Apply the xHTML Heading 6 tag around the specified string.
'* @param the string contents to appear inside the tag.
'* @return an xHTML heading 6 
'* 
function h6(byval str)
	h6 = ("<h6>"&str&"</h6>"&vbcrlf)
end function

'**
'* Apply the xHTML Definition List tag around the specified string.
'* @param the string contents to appear inside the tag.
'* @return a string wrapped in xHTML definition list
'*
function dl(byval str)
	dl = ("<dl>"&str&"</dl>"&vbcrlf)
end function

'**
'* Apply the xHTML Definition Term tag around the specified string.
'* @param the string contents to appear inside the tag.
'* @return a string wrapped in xHTML definition term
'*
function dt(byval str)
	dt = ("<dt>"&str&"</dt>"&vbcrlf)
end function

'**
'* Apply the xHTML Definition Definition tag around the specified string. 
'* @param the string contents to appear inside the tag.
'* @return a string wrapped in  xHTML definition 
'*
function dd(byval str)
	dd = ("<dd>"&str&"</dd>"&vbcrlf)
end function

'**
'* Apply the xHTML Strong tag around the specified string.
'* @param the string contents to appear inside the tag.
'* @return an html-formatted string with xHTML strong tag (ie, "bold" font)
'*
function strong(byval str)
 strong = ("<strong>"&str&"</strong>")
end function


'**
'* A shorthand wrapper for xHTML strong function.
'* @param the string contents to appear inside the tag.
'* @see strong()
'*
function bold(byval str)
 bold = strong(str)
end function

'**
'* A shorthand wrapper for xHTML bold/strong function.
'* @param string the contents to appear inside the tag.
'* @see strong()
'* @see bold()
'*
function b(byval str)
 b = strong(str)
end function


'**
'* Generate a xHTML Link tag for the specified URL having the specified relation and type.
'* @param strURL the link (a Uniform Resource Locator)
'* @param strRelation the relation to the current document (eg, stylesheet,next,previous,etc)
'* @param strType the MIME-type of the linked file (eg, text/css)
'*
function link(byval strURL,byval strRelation,byval strType)
	link = "<link rel="""&strRelation&""" type="""&strType&""" href="""&strURL&""" />"&vbcrlf
end function

'**
'* Generate valid xHTML code for inserting a media file into an xHTML document.  Media content 
'* and supporting javascripts are created based on the file extension of the specified file/folder name. 
'* Current possibile media content formats include:
'* 
'*   - FLASH movie: specify a path to a flash FILE. Supported extensions are (swf).
'*   - SINGLE image : specify a relative or absolute path to the IMAGE FILE. Supported file extensions are (jpg|jpeg|gif|png)
'*   - JPG SLIDESHOW: specify a (relative or absolute) path to the IMAGES FOLDER containing jpg images 
'*
'* @param strFileName the path to the media file/folder 
'* @param strTitle a string description of the media file/folder used to populate title/alt attributes. 
'* @param strClass a custom class attribute to apply to the media file tag. 
'* @param strWidth the height that the media file should ocupy in the document.
'* @param strWidth the width that the media file should ocupy in the document.
'* @return an xHTML markup and supporting javascripts for displaying the specified media file 
'*
function mediaFile(byval strFileName,byval strTitle,byval strClass,byval strWidth,byval strHeight)
	dim result : set result = new FastString
	debug("mediaFile: inserting media file '"&strFileName&"'")
	if instrrev(strFileName, ".swf")=len(strFileName)-3 then
		result.add flash(strFileName,strTitle,strClass,strWidth,strHeight)	
	elseif instrrev(strFileName, ".jpg")=len(strFileName)-3 or instrrev(strFileName, ".jepg")=len(strFileName)-4 or instrrev(strFileName, ".gif")=len(strFileName)-3 or instrrev(strFileName, ".png")=len(strFileName)-3 then
		 result.add img(strFileName,strTitle,strTitle,strClass)
	elseif instrrev(strFileName, "/")=len(strFileName) then 
		result.add slideshow(strFileName,strTitle,strClass,strWidth,strHeight)
	else
		debugError("mediaFile: unknown media type '"&strFileName&"'")
	end if
	mediaFile = result.value
	set result = nothing
end function


'**
'* Generate valid xHTML code for inserting a flash movie into an xHTML 
'* document.  Supports dynamic flash OBJECT insertion with javascript 
'* to avoid annoying popups from Internet Explorer, as well as NOSCRIPT 
'* support for non-javascript-enabled browsers.
'* 
'* Note: dynamic insertion depends on presence of scripts/active_content.js!
'*
'* @param strFileName the path to the media file/folder 
'* @param strTitle a string description of the media file/folder used to populate title/alt attributes. 
'* @param strClass a custom class attribute to apply to the media file tag. 
'* @param strWidth (required) the height that the flash file should ocupy in the document.
'* @param strWidth (required) the width that the flash file should ocupy in the document.
'* @return an xHTML markup and supporting javascripts for displaying the specified flash movie
'*
function flash(byval strFileName,byval strTitle,byval strClass,byval strWidth,byval strHeight)
	dim strFileNoExtension : strFileNoExtension = replace(strFileName,".swf","")
	dim result : set result = new FastString
	strWidth = ""&strWidth
	strHeight= ""&strHeight
	strTitle= ""&strTitle
	strClass= ""&strClass
	'do flash stuff here
	result.add "<script src="""&objLinks("SITEURL")&"/core/assets/scripts/active_content.js"" type=""text/javascript""></script>" & vbcrlf
	result.add "<script type=""text/javascript"">" & vbcrlf
	result.add "<!--" & vbcrlf
	result.add "AC_FL_RunContent( 'codebase','"&FLASH_CODEBASE&"',"
	if len(strWidth)>0 then result.add "'width','"&strWidth&"',"
	if len(strHeight)>0 then result.add "'height','"&strHeight&"',"
	result.add "'title', '"&strTitle&"',"
	result.add "'class', '"&strClass&"',"
	result.add "'src','"&strFileNoExtension&"',"
	result.add "'id','"&strFileNoExtension&"',"
	result.add "'quality','high',"
	result.add "'wmode','transparent',"
	result.add "'pluginspage','http://www.macromedia.com/go/getflashplayer',"
	result.add "'movie','"&strFileNoExtension&"'"
	result.add " );" & vbcrlf
	result.add "-->" & vbcrlf
	result.add "</script><noscript>" & vbcrlf
	result.add  "<object classid="""&FLASH_CLASSID&""" codebase="""&FLASH_CODEBASE&""""
	result.add " id="""&strFileNoExtension&""""
	if len(strWidth)>0 then result.add " width="""&strWidth&""""
	if len(strHeight)>0 then result.add " height="""&strHeight&""""
	if len(strTitle)>0 then result.add " title="""&strTitle&""""
	if len(strClass)>0 then result.add " class="""&strClass&""""
	result.add ">" 
	result.add "<param name=""movie"" value="""&strFileName&""" />" &vbcrlf
	result.add "<param name=""quality"" value=""high"" />" &vbcrlf
	result.add "<param name=""wmode"" value=""transparent"" />" &vbcrlf
	result.add "<embed src="""&strFileName&""" quality=""high"" pluginspage=""http://www.macromedia.com/go/getflashplayer"" type=""application/x-shockwave-flash"""
	if len(strWidth)>0 then result.add " width="""&strWidth&""""
	if len(strHeight)>0 then result.add " height="""&strHeight&""""
	result.add "></embed></object></noscript>" &vbcrlf 
	flash = result.value
	set result = nothing
end function 


'**
'* Create a valid xHTML javascript random-image slideshow that can 
'* stream and animate the presentation of images from the specified
'* folder. For non-javascript-enabled web browsers, the slideshow 
'* degrades cleanly to a randomly-selected image from the specified 
'* folder.
'*
'* The Slideshow 2.0 supports the following features:
'*
'* - Variable slideshow dimensions
'* - Fade, pan, zoom and combo slideshows
'* - Pan and zoom options
'* - Duration of transitions
'* - Wipe and push slideshows
'* - Robert Penner easing transitions
'* - Arrows based navigation
'* - Thumbnail based navigation
'* - Fast mode navigation
'* - Slideshow captions
'*
'* See http://www.electricprism.com/aeron/slideshow/ for details.
'* 
'* Note1:  slideshow currenly only supports jpg file extensions!
'*
'* Note: slideshow depends on presence of the following javascripts:
'*       - scripts/slideshow/mootools.js
'*       - scripts/slideshow/slideshow.js
'*
'* @param strFileName the path to the media file/folder 
'* @param strTitle a string description of the media file/folder used to populate title/alt attributes. 
'* @param strClass a custom class attribute to apply to the media file tag. 
'* @param strWidth (required) the height that the flash file should ocupy in the document.
'* @param strWidth (required) the width that the flash file should ocupy in the document.
'* @return an xHTML markup and supporting javascripts for displaying the slideshow
'*
function slideshow(byval strFolderName,byval strTitle,byval strClass,byval strWidth,byval strHeight)
	if strTitle = "" or isNull(strTitle) then strTitle = "A "& objLinks.item("SHORTNAME") & " Slideshow."
	strClass = "slideshow "&strClass
	dim result : set result = new FastString
	debug("slideshow: inserting slideshow file '"&strFileName&"'")
	result.add "<script src="""&objLinks("SITEURL")&"/core/assets/scripts/slideshow/mootools.js"" type=""text/javascript""></script>" & vbcrlf
	result.add "<script src="""&objLinks("SITEURL")&"/core/assets/scripts/slideshow/slideshow.js"" type=""text/javascript""></script>" & vbcrlf
	'Slideshow expects an HTML image <img> wrapped by a block element, such as a <div>. 
	'Following is an example of how this might appear in your HTML document: 
	result.add "<div id=""js_slideshow"" class=""slideshow"">" & vbcrlf

  dim myFileList : set myFileList = getFilesInFolder(strFolderName,".jpg")
	if myFileList.count = 0 then 
		debugError("html.slideshow:  there are no images in folder '"&strFolderName&"'")
		result.add "<!--  Slideshow disabled! '"&strFolderName&"' contains no images! "& vbcrlf
	else 
		randomize
		dim random: random =int(rnd * myFileList.count)
		result.add "<img src="""&strFolderName&myFileList.keys()(random)&".jpg"""
		if strWidth <> "" and not isNull(strWidth) then result.add " width="""&strWidth&""""
		if strHeight <> "" and not isNull(strHeight) then result.add " height="""&strHeight&""""
		if strTitle <> "" and not isNull(strTitle) then result.add " alt="""&strTitle&""""
		if strClass <> "" and not isNull(strClass) then result.add " class=""slideshow "&strClass&""""
		result.add "/>" & vbcrlf
	end if
	result.add "</div>" & vbcrlf
	
	result.add "<script type=""text/javascript"">" & vbcrlf
	strFolderName = replace(strFolderName,objLinks.item("SITEURL")&"/","")
  result.add "myShow = new Slideshow('js_slideshow', {hu: '"&objLinks.item("SITEROOT")&"/"&strFolderName&"', duration: [700,5000], images: ["
	separator=""
	dim imageFile
	for each imageFile in myFileList
		result.add separator&"'"&imageFile&".jpg'"
		separator=","
		trace("html.slideshow:  added image '"&imageFile&"' to slideshow")
	next
	result.add "]});" & vbcrlf
	result.add "</script>" & vbcrlf
	if myFileList.count = 0 then result.add "-->"  & vbcrlf
	slideshow = result.value
	set result = nothing
end function

'**
'* Retrieve the original value of a url-encoded string.
'* 
'* @param sConvert the url string to decode
'* @return the decoded string
'*
function URLDecode(byval sConvert)
    dim aSplit
    dim sOutput
    dim I
    if isNull(sConvert) or sConvert="" then
       URLDecode = ""
       exit function
    end if
    sOutput = replace(sConvert, "+", " ") ' convert all pluses to spaces
    aSplit = split(sOutput, "%")' next convert %hexdigits to the character
    if isArray(aSplit) then
      sOutput = aSplit(0)
      for I = 0 to UBound(aSplit) - 1
        sOutput = sOutput & _
          chr("&H" & left(aSplit(i + 1), 2)) &_
          right(aSplit(i + 1), len(aSplit(i + 1)) - 2)
      next
    end if
    URLDecode = sOutput
end function


'**
'* Retrieve the original value of an html-encoded string.
'* Special characters and html codes are returned to their original values.
'* 
'* @param sText the string to decode
'* @return the decoded text string
'*
function HTMLDecode(byval sText)
    dim I
		if isNull(sText) or sText="" then
       HTMLDecode = ""
       exit function
    end if
		' convert basic string codes to the real character
    sText = replace(sText, "&quot;", chr(34))
    sText = replace(sText, "&lt;"  , chr(60))
    sText = replace(sText, "&gt;"  , chr(62))
    sText = replace(sText, "&amp;" , chr(38))
    sText = replace(sText, "&nbsp;", chr(32))
		' next convert %hexdigits to the character
    for I = 1 to 255
        sText = Replace(sText, "&#" & I & ";", Chr(I))
    next
    HTMLDecode = sText
end function

'**
'* Encode the specified text string as HTML paragraph text. 
'* Convert the common non-alpha-numeric characters to html-encoded strings. 
'*
'* @param the text string to convert to html
'* @return the html-encoded version of the string
'*
function encode(str)
  str = replace(str,"'","&rsquo;")
	str = replace(str,"""","&#34;")
	str = replace(str,"& ","&amp; ")
	str = replace(str,"<","&lt;")
	str = replace(str,">","&gt;")
	encode = str
end function

function EmailObfuscate(str)
	dim result, m
	result = str

	for each m in emlformat.execute(str)
		debug( "function.html.emailObfuscate:" & m.value & " was matched at position " & m.FirstIndex)
		result = replace(result,m.value,Obfuscate(m.value))
	next
	EmailObfuscate = result
end function

'**
'* Convert a plaintext string into the same string of HTML escaped Ascii codes
'* that will render as text by the client browser. Each character in the string is 
'* encoded in either Decimal (eg, &#123; )  or Hex (eg, &#xA8; ) format which 
'* is chosen randomly at execution time.
'*
function Obfuscate(str)
	randomize
	dim seed,result,ascii,i
	for i = 1 to len(str)
		seed=int(rnd * 10)
		ascii=int(Asc(Mid(str, i, 1)))
		if ascii<256 and seed>5 then
			result = result&"&#x"&CStr(Hex(int(ascii)))&";" 
		else
			result = result&"&#"&ascii&";"
		end if
	next
	Obfuscate = result
end function

'**
'* Convert a plaintext string into HTML Ascii codes in Decimal format.
'*
function AsciiDecEncode(str)
	dim result
	for i = 1 to len(str)
		result = result&"&#"&Asc(Mid(str, i, 1))&";"
	next
	AsciiDecEncode = result
end function


'**
'* Convert a plaintext string into HTML Ascii codes in Hex format.
'*   
function AsciiHexEncode(str)
	dim result, ascii
	for i = 1 to len(str)
		ascii = int(Asc(Mid(str, i, 1)))
		if ascii<256 then
			result = result&"&#x"&CStr(Hex(int(ascii)))&";"
		else
			result = result&"&#"&ascii&";"
		end if
	next
	AsciiHexEncode = result
end function

function toXHTML(str)
	toXHTML = str
	dim html, tag, attr, emptyAttr
	dim h, t, a
	
	'any html
	set html = new RegExp
	html.pattern = "<(.|\n)+?>"
	html.IgnoreCase = false
	html.global = true
	
	'submatches(0) returns the tagname
	set tag = new RegExp
	tag.pattern = "^</?([^!]\w*)"
	tag.IgnoreCase = false
	tag.global = true
	
	'an html attribute
	'submatches(0) gives the attribute name
	set attr = new RegExp	
	attr.pattern = "(\w*)\s*?=\s*?((""([^""]*)"")|('([^']*)'))"
	attr.IgnoreCase = false
	attr.global = true
	
		
	dim result 
	for each h in html.execute(str)
		'response.write("<blockqoute>")
		'response.write(p("'"&server.htmlencode(h.value) & "' is an html tag"))
		result = h.value
		for each t in tag.execute(h.value)
			'response.write("<blockquote>'"&server.htmlencode(t.value) & "' matches html tag profile</blockquote>")
			'response.write("<blockquote>'"&server.htmlencode(t.submatches(0)) & "' is the tag name</blockquote>")
		  result = replace(result,t.value,lcase(t.value))
		next
		for each a in attr.execute(h.value)
			'response.write("<blockquote>'"&server.htmlencode(a.value) & "'  matches html tag attribute profile</blockquote>")
			'response.write("<blockquote>'"&server.htmlencode(a.submatches(0)) & "' is the attribute name</blockquote>")
			result = replace(result,a.value,replace(a.value,a.submatches(0),lcase(a.submatches(0))))
		next		
		'response.write("<blockquote>Resulting XHTML '"&server.htmlencode(result) & "'</blockquote>")		
		'response.write("</blockquote>")	
		str = replace(str,h.value,result)
	next
	toXHTML = str
end function

%>
