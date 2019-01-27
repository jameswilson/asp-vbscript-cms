<%
'PUBLIC CONSTANTS:  FORM ELEMENT ATTRIBUTES
const DBTEXT = " maxlength=""255""" '*< default Text size in MS Access
const DBMEMO = " maxlength=""65535"""  '*< default Memo size in MS Access
const READONLY = " readonly=""readonly"""  '*< readonly by default
const DISABLED = " disabled=""disabled"""  '*< readonly by default
const CHECKED = " checked=""checked"""  '*< readonly by default
const SELECTED = " selected=""selected""" '*< selected attribute
const OPTION_DIVIDER = "divider" '*< if the current option starts a new section in the select list.
const MULTIPART = " enctype=""multipart/form-data"""
const DOJO_PATH = "/core/assets/scripts/dojo/"
const DOJO_SCRIPT_NAME = "dojo.js"
const DOJO_DATEPICKER = " dojoType=""DropdownDatePicker"" dateFormat=""%m/%d/%Y"""
const DOJO_SMP_EDITOR = "Editor" '*< Simple dojo editor
const DOJO_ADV_EDITOR = "Editor2" '*< Advanced dojo editor
const DOJO_SMP_EDITOR_CONF = " items=""formatBlock;textGroup;|;listGroup;|;indentGroup;|;createlink;htmltoggle"""
const DOJO_ADV_EDITOR_CSS = "src/EditorToolbar.css"'"src/widget/templates/Editor2/EditorToolbarFullFeature.css" '
const DOJO_ADV_EDITOR_TOOLBAR = "src/EditorToolbarCustom.html"'"src/widget/templates/Editor2/EditorToolbarFullFeature.html" '
const DOJO_TAB_CONTAINER = " id=""mainTabContainer"" dojoType=""TabContainer"" selectedChild=""tab1"" doLayout=""false"""
const DOJO_CONTENT_PANE = " dojoType=""ContentPane"" layoutAlign=""client"""
const DOJO_RICH_TEXT_FRAME = "src/richtextframe.html"

const FILE_UP_DISABLED_WARNING = "Important Note! A file upload component is not enabled on this server therefore any value in this field will not be uploaded."



'* regular expressions used for string validations from form submission
dim aDecimel : set aDecimel = new RegExp
aDecimel.pattern = "^[0-9]*\.[0-9]*$"
aDecimel.ignoreCase = true
aDecimel.global = true

dim anInteger : set anInteger = new RegExp
anInteger.pattern = "^\d*$"
anInteger.ignoreCase = true
anInteger.global = true

dim nonNumeric : set nonNumeric = new RegExp
nonNumeric.pattern = "\D"
nonNumeric.ignoreCase = true
nonNumeric.global = true

'! Encapsulates the creation, submission, and validation of form data.
'! @class WebForm
'! @file class.form.asp
class WebForm
	public isForNewContent
	public PrimaryKey
	public PrimaryKeyVal

	private m_Name
	private m_Action
	private m_Method
	private m_UploadPath

	private m_Request
	private m_Form
	private m_dictErrors
	private m_fieldNames
	private m_dictNotes
	private currentGroupId
	private currentSelectGroup
	private isGrouped
	private isMultiSelect
	private isSubmissionChecked
	private isSessionChecked
	private m_contents
	private m_accessKeyIndex
	private m_errorAccessKeyIndex
	private m_tabIndex

	private m_Dijitize  '*< bool: should we use Dojo Widget components (Dijits) ?
	private m_DatePicker '*< string: the attributes necessary for using Dijit Date Picker
	private m_Editor     '*< string: the version of the Dijit Editor (posiblilities are 'Editor' or 'Editor2')
	private m_EditorConfig '*< string: the attributes necessary for using Dijit Editor
	private m_hasTextarea '*< bool: does the form contain any textareas?
	private m_hasDatePicker '*< bool: does the form contain any datepickers?
	private m_hasFieldCounter '*< bool: does the form contain any fields with length counters?
	private m_isUploadEnabled '*< bool: does the form support the File Uploads?
	private m_encryptionType '*< string: form attribute defining the encryption type for use with FileUp object

	'*
	'* Constructor initializes object and allocates assets.
	'*
	private sub class_Initialize()
		' when incorporating file uploads, one must replace normal request object
		' with our "m_Request" wrapper object created in the case that the SoftArtisans
		' FileUp module is available on the server, and then use the according
		' functions for accessing (getting and setting) the form fields/values
		on error resume next
		set m_Request = Server.CreateObject("SoftArtisans.FileUp")
		if err.number <> 0 then
			'
			' if SoftArtisans not installed an error will be generated when trying to
      ' create the object, in which case we use regular request object instead.
      '
			err.clear
			debugWarning("class.form.init: form upload functionality is disabled (SoftArtisans.FileUp module not found)")
			set m_Request = request
			m_encryptionType = ""
			m_isUploadEnabled = FALSE
		else
			'
			' Setup the required SoftArtisans custom propeties here...
			'
			m_encryptionType = MULTIPART
			m_isUploadEnabled = true
		end if
		UploadPath = ""
		if len(m_Request.Form("form_name")) > 0 then
			debugInfo("class.form.init: form was submitted with " & m_Request.Form.count & " fields.")
			debugInfo("class.form.init: setting form name to submitted form name.... ")
			setName(m_Request.Form("form_name"))
		end if

		TrapError
		processErrors

		'
		' setup global objects here
		'
		set m_dictErrors = Server.CreateObject("Scripting.Dictionary")
		set m_fieldNames = Server.CreateObject("Scripting.Dictionary")
		set m_dictNotes = nothing
		set m_contents = New FastString
		'
		' setup global properties here
		'
		currentGroupId = ""
		currentSelectGroup = ""
		m_Name = ""
		m_Method = "POST" ' post by default
		isGrouped = FALSE
		isSubmissionChecked = FALSE
		isSessionChecked = FALSE
		m_tabIndex=0
		m_accessKeyIndex= 0
		m_errorAccessKeyIndex=65
		initializeAdvancedWidgets()
	end sub

	'*
	'* Destructor releases the object and its assets when object set to nothing.
	'*
	private sub class_Terminate()
		set m_Request = nothing
		set m_dictErrors = nothing
		set m_fieldNames = nothing
		set m_dictNotes = nothing
		set m_contents = nothing
	end sub

	'*
	'* Configure the default form widgets settings
	'* as defined in the Admin > Settings > "Enrich Form Widgets"
	'*
	private sub initializeAdvancedWidgets()
		setAdvancedFormWidgets( settings.getItem("Enrich Form Widgets") = "1" )
		m_hasTextarea = FALSE
		m_hasDatePicker = FALSE
	end sub

	'*
	'* Helper function gets the path of the calling file.
	'*
	private function getDefaultPath()
		dim currentFilePath : currentFilePath = Request.ServerVariables("URL")
		currentFilePath = left(currentFilePath,inStrRev(currentFilePath,"/"))
		trace("class.form.getDefaultPath: '" & currentFilePath & "'")
		getDefaultPath = currentFilePath
	end function

	'*
	'* Apply advanced form widget functionality (using the Dojo Toolkit)
	'*
	public function setAdvancedFormWidgets(boolStatus)
		m_Dijitize = boolStatus
		if boolStatus = true then
			m_DatePicker = DOJO_DATEPICKER
			m_Editor = DOJO_ADV_EDITOR 'DOJO_SMP_EDITOR 'uncomment the following for simple editor
			'm_EditorConfig = DOJO_SMP_EDITOR_CONF 'uncommend for SIMPLE EDITOR and cooment out the following (advanced editor configuration)
			dim tmplPath, cssPath
			set tmplPath = new SiteFile
			set cssPath = new SiteFile
			tmplPath.Path = DOJO_PATH & DOJO_ADV_EDITOR_TOOLBAR
			cssPath.Path = DOJO_PATH & DOJO_ADV_EDITOR_CSS
			m_EditorConfig = " toolbarTemplatePath='" & tmplPath.virtualPath & "'"
			m_EditorConfig = " templateCssPath='" & cssPath.virtualPath & "'" & m_EditorConfig
			m_EditorConfig = " dojoType='" & m_Editor & "'" & m_EditorConfig
		else
			m_DatePicker = ""
			m_Editor = ""
			m_EditorConfig = ""
		end if
		if isIE() = true then
			'm_Editor = ""
			'm_EditorConfig = ""
		end if

	end function

	'*
	'* Apply a customized name to the form. If no name is provided a
	'* random name is applied to the form name attribute before
	'* returning the contents.
	'* @param strName a string Name for the form; spaces will be converted to underscores!
	'*
	public function setName(byval strName)
		setName = FALSE
		if isEmpty(strName) or isNull(strName) or strName="" then
			debugWarning("class.form.setName: '" & strName & "'")
			exit function
		end if
		debugInfo("class.form.setName: '" & strName & "'")
		m_Name = formatName(strName)
		setName = true
	end function

	public property let Name(strName)
		setName(strName)
	end property

	public property get Name()
		Name = m_Name
	end property

	public function getName()
		getName = m_Name
	end function

	public function setAction(strAction)
		debugInfo("class.form.setAction: '" & strAction & "'")
		m_Action = "" & strAction
	end function

	public property let Action(strAction)
		setAction(strAction)
	end property

	public property get Action()
		Action = m_Action
	end property

	public function getAction()
		getAction = m_Action
	end function

	public function setMethod(strMethod)
		debugInfo("class.form.setName: '" & strMethod & "'")
		m_Method = strMethod
	end function

	public property let Method(strMethod)
		setMethod(strMethod)
	end property

	public property get Method()
		Method = m_Method
	end property

	public function getMethod()
		getMethod = m_Method
	end function

	'*
	'* Define the upload directory. The path string may be:
	'*
	'*  - virtual path relative to site root:
	'*     - "/uploads"
	'*     - "\uploads"
	'*  - virtual path relative to the calling asp file's directory:
	'*     - "uploads"
	'*     - "uploads/"
	'*
	'*  In any case, a trailing slash is optional. Also, the path separator
	'*  may be forward "/" or backward slash "\".
	'* @attention Physical Absolute Paths NOT ALLOWED!, eg. "C:\Uploads\"  are customarily
	'*          prohibited because we only allow uploads to virtual webspace. This
	'*          may be changed in the future but for now, this is the rule!
	'*
	public property let UploadPath(strPath)
		if instr(strPath,":\") > 0 then
			debugError("class.form.uploadPath: '" & strPath & "' is Absolute, and is not allowed using this script!")
			m_UploadPath = getDefaultPath()
			debugError("class.form.uploadPath: using '" & m_UploadPath & "' (default) instead.")
		elseif (instr(strPath, "\") = 1) or (instr(strPath, "/") = 1) then
			trace("class.form.uploadPath: '" & strPath & "' is relative to the site root.")
			m_UploadPath = strPath
		else
			 'removes the filename from the path
			trace("class.form.uploadPath: '" & strPath & "' is realtive to this file's location (" & getDefaultPath() & ")")
			m_UploadPath = getDefaultPath() & "\" & strPath
		end if
		m_UploadPath = replace(m_UploadPath,"/","\")'remove mixed path separators  eg, 'path/to\file.txt'
		m_UploadPath = replace(m_UploadPath,"\\","\") 'remove duplicate path separators eg, 'path//to//file.txt'
		if instrrev(m_UploadPath,"\") <> len(m_UploadPath) then m_UploadPath = m_UploadPath & "\" ' Ensure the folder path includes a trailing slash
		if instr(m_UploadPath,"\") <> 1 then m_UploadPath = "\" & m_UploadPath ' Ensure the folder path includes a leading slash
		debugInfo("class.form.uploadPath: '" & m_UploadPath & "'")
	end property

	public property get UploadPath()
		UploadPath = m_UploadPath
	end property

	'* Access the raw Form object this WebForm encapsulates.
	'* @return the Form
	public property get Form
		set Form = m_Request.Form
	end property

	'* Return this WebForm as a querystring.
	'* @return string form as a querystring, eg, "item1=val1 & item2=val2"
	public function toString()
		dim result,separator,fld
		set result = new FastString
		separator = ""
		if m_isUploadEnabled = true then
			for each fld in m_Request.Form
				result.add separator & fld & "=" & Server.UrlEncode(getValue(fld))
				separator = "&"
			next
			toString = result.value
			set result = nothing
		else
			toString = "" & m_Request.Form
		end if
	end function


	'* Replacement (Encapsulation) for Request.Form(item)
	'* @return the value of the specified item in the submitted form
	'* @param string item_name
	public function getValue(strItemName)
		'on error resume next
		trace("class.form.getValue: raw value for " & strItemName & " is ")
		on error resume next
		trace("class.form.getValue: '" & m_Request.Form("" & strItemName) & "'")
		TrapError

		'
		'test to verify if the field is a SoftArtisans.FileUp file object or not
		'
		dim isEmptyFile : isEmptyFile = m_Request.Form("" & strItemName).IsEmpty
		if err.number <> 0 then
			err.clear
			getValue = m_Request.Form("" & strItemName)
			trace("class.form.getValue: " & strFormWidgetName & "= '" & m_Request.Form("" & strItemName) & "'")
		else
			getValue = m_Request.Form("" & strItemName).ShortFilename
			trace("class.form.getValue: " & strItemName & "= '" & m_Request.Form("" & strItemName).ShortFilename & "' (filename)")
		end if
	end function


	'* Get the number of values returned in a multi-select list or other form group.
	'* @return the count of the specified form widget.
	'* @return -1 if the specified form item is not grouped
	public function getCount(strItemName)
		on error resume next
		err.clear
		dim result : result = m_Request.Form("" & strItemName).count
		if err.number <> 0 then
			err.clear
			result = -1
		end if
		getCount = result
	end function

	'* Get the code for the form.
	'* @return the count of the specified form widget.
	'* @return -1 if the specified form item is not grouped
	public function getContents()
		dim result : set result = New FastString
		result.add "<script type=""text/javascript"" src=""" & globals("SITEURL") & "/core/assets/scripts/display.js""></script>" & vbCrLf
		result.add "<script type=""text/javascript"" src=""" & globals("SITEURL") & "/core/assets/scripts/form_validator.js""></script>" & vbCrLf
		if m_hasFieldCounter = true then
			result.add "<script type=""text/javascript"" src=""" & globals("SITEURL") & "/core/assets/scripts/form_field_count.js""></script>" & vbCrLf
		end if
		dim separator : separator = "," & vbCrLf & vbTab
		if m_Dijitize then
			result.add "<script type=""text/javascript""> " & vbCrLf
			result.add "<!--// <![CDATA["  & vbCrLf
			result.add "var djConfig = {" & vbCrLf & vbTab & "debugAtAllCosts: FALSE"
			if debugMode() = true then
				result.add separator & "isDebug: true"
			end if
			result.add separator & "baseRelativePath: """ & globals("SITEURL") & DOJO_PATH & """"
			dim txtFrame : set txtFrame = new SiteFile
			txtFrame.Path = DOJO_PATH & DOJO_RICH_TEXT_FRAME
			result.add separator & "dojoRichTextFrameUrl: """ & txtFrame.URL & """ //for xdomain "
			result.add vbCrLf & "};" & vbCrLf
			result.add "// ]]>-->" & vbCrLf
			result.add "</script>" & vbCrLf

			if fileExists(DOJO_PATH & DOJO_SCRIPT_NAME) then
				result.add "<script type=""text/javascript"" src=""" & globals("SITEURL") & DOJO_PATH & DOJO_SCRIPT_NAME & """></script>" & vbCrLf
			elseif fileExists("/../dojo/" & DOJO_SCRIPT_NAME) then
				dim dojoPath : set dojoPath = new SiteFile
				dojoPath.Path = "/../dojo/" & DOJO_SCRIPT_NAME
				result.add "<script type=""text/javascript"" src=""" & dojoPath.URL & """></script>" & vbCrLf
			elseif Request.ServerVariables("SERVER_NAME") = "localhost" then
				result.add "<script type=""text/javascript"" src=""http://localhost/dojo/dojo.js""></script>" & vbCrLf
			end if

			result.add "<script type=""text/javascript"">" & vbCrLf
			result.add "<!-- // <![CDATA["  & vbCrLf
			if m_hasTextarea = true then result.add "dojo.require(""dojo.widget." & m_Editor & """);" & vbCrLf
			if m_hasDatePicker = true then result.add "dojo.require(""dojo.widget.DropdownDatePicker"");" & vbCrLf
			result.add "dojo.require(""dojo.widget.TabContainer"");" & vbCrLf
			'result.add "dojo.require(""dojo.widget.LinkPane"");" & vbCrLf
			'result.add "dojo.require(""dojo.widget.ContentPane"");" & vbCrLf
			'result.add "dojo.require(""dojo.widget.LayoutContainer"");" & vbCrLf
			'result.add "dojo.require(""dojo.widget.Checkbox"");" & vbCrLf
			result.add "// ]]>-->" & vbCrLf
			result.add "</script>" & vbCrLf
		end if
		result.add "<div"
		if m_Dijitize then result.add DOJO_TAB_CONTAINER
		result.add ">" & vbCrLf
		if isNull(m_Name) or m_Name = "" then
			Randomize()
			dim rand : rand = int(10000000*rnd)+1
			setName("form" & rand)
			debug("class.form.getContents: a name for this form was never specified, applying a random name '" & m_Name & "'")
		end if
		result.add "<form action=""" & m_Action & """ method=""" & m_Method & """ id=""" & m_Name & """" & m_encryptionType & " class=""autocheck"" onsubmit=""return autocheck(this)"" onreset=""return confirm('Really reset all form fields?')"">" & vbCrLf
		result.add  "<div style=""display:none""><input type=""hidden"" name=""form_name""  id=""form_name"" value=""" & m_Name & """/></div>" & vbCrLf
		result.add   m_contents.value
		result.add "</form>" & vbCrLf
		result.add "</div>" & vbCrLf
		getContents = result.value
		set result = nothing
	end function
	public function Clear()
		m_contents.clear
	end function
	public function CreateNew(aName, anAction)
		debugWarning("DEPRICATED: class.form.createNew is marked for removal in the upcomming release!")
		setName(aName)
		setAction(anAction)
		debugSessionContents()
		if (not wasSubmitted()) and (not wasStoredToSession(m_Name)) Then
			clearFormFromSession(m_Name)
		end if
		CreateNew = true
	end function

	'* Clears the form object currently under construction.
	public function clearContents()
		m_contents.clear()
	end function

	'* Add a fieldset to the form object.
	'* @param string legend  the name of the fieldset (appears in the legend tag)
	'* @param string instructions
	public function addFieldset(sLegendName, sInstructions)
		m_tabIndex = m_tabIndex + 1
		m_contents.add "<div id=""tab" & m_tabIndex & """ class=""tab clearfix"""
		if m_Dijitize then m_contents.add " label=""" & sLegendName & """" & DOJO_CONTENT_PANE
		m_contents.add ">" & vbCrLf
		m_contents.add "<fieldset class=""clearfix"">" & vbCrLf
		if len(sLegendName) > 0 then m_contents.add  indent(1) & "<legend>" & sLegendName & "</legend>" & vbCrLf
		if len(sInstructions) > 0 then m_contents.add  indent(1) & "<div class=""instructions"">" & vbCrLf & indent(1) & "<p>" & sInstructions & "</p>" & vbCrLf & indent(1) & "</div>" & vbCrLf
	end function

	'* Close an open fieldset
	function endFieldset()
		m_contents.add "</fieldset>" & vbCrLf
		m_contents.add "</div>" & vbCrLf
	end function

	'* Start a Note section. Notes are descriptive named paragraphs that
	'* describe actions in the form.
	function startNoteSection()
		set m_dictNotes = Server.CreateObject("Scripting.Dictionary")
		m_contents.add indent(1) & "<div class=""notes"">" & vbCrLf
	end function

	'* Add a note to an open Note section
	'* @see startNoteSection()
	'* @see endNoteSection()
	function addNote(sHeading,sContent)
		m_dictNotes.add sHeading, sContent
		AddNote = ""
	end function

	'* End an open Note section.
	'* @see startNoteSection()
	'* @see endNoteSection()
	function endNoteSection()
		dim i 'counter
		debug("class.form.endNoteSection: There are " & m_dictNotes.count & " notes.")
		for i=0 to m_dictNotes.count-1
			debug("FORM NOTE " & i+1 & ": '" & m_dictNotes.keys()(i) & "' '" & m_dictNotes.items()(i) & "'")
			m_contents.add  indent(2) & "<h4>" & m_dictNotes.keys()(i) & "</h4>" & vbCrLf
			m_contents.add  indent(2) & "<p"
			if (i = m_dictNotes.count-1)then
				m_contents.add  " class=""last"""
			end if
			m_contents.add  ">" & m_dictNotes.items()(i) & "</p>" & vbCrLf
		next
		m_contents.add  indent(1) & "</div>" & vbCrLf
	end function

	function addFormSubmission(sAlignment,sSubmitText, sResetText, sClass, sDescriptionText)
		debug("FORM SUBMIT BUTTON: text='" & sSubmitText & "' reset='" & sResetText & "' description='" & sDescriptionText & "'")
		m_contents.add  indent(1) & "<div class=""button submit " & sClass & """>" & vbCrLf
		if sAlignment = "right" then	m_contents.add  indent(1) & "<div>" & vbCrLf
		if (len(sSubmitText)>0) then m_contents.add  indent(2) & "<input type=""submit"" class=""button inputSubmit " & sClass & """ value=""" & sSubmitText & """/>" & vbCrLf
		if (len(sResetText)>0) then m_contents.add  indent(2) & "<input type=""reset"" class=""button inputReset " & sClass & """ value=""" & sResetText & """/>" & vbCrLf
		if sAlignment = "right" then	m_contents.add  indent(1) & "</div>" & vbCrLf
		m_contents.add  indent(1) & "</div>" & vbCrLf
		if (sDescriptionText <> "") then
			m_contents.add  indent(1) & "<div class=""disclaimer"">" & vbCrLf
			m_contents.add  indent(2) & "<small>" & sDescriptionText & "</small>" & vbCrLf
			m_contents.add  indent(1) & "</div>" & vbCrLf
		end if
	end function

	function addFormButton(sType,sButtonText,sClass,sCustomTags,sDescriptionText)
		sClass = sClass & " input" & Pcase(sType)
		debug("FORM BUTTON: text='" & sButtonText & "' description='" & sDescriptionText & "'")
		m_contents.add  indent(1) & "<div class=""button " & sClass & """>" & vbCrLf
		if sAlignment = "right" then	m_contents.add indent(1) & "<div>" & vbCrLf
		if (len(sButtonText)>0) then m_contents.add indent(2) & "<input type=""" & sType & """ class=""button " & sClass & """ value=""" & sSubmitText & """ " & sCustomTags & "/>" & vbCrLf
		if sAlignment = "right" then	m_contents.add indent(1) & "</div>" & vbCrLf
		m_contents.add indent(1) & "</div>" & vbCrLf
		if (sDescriptionText <> "") then
			m_contents.add indent(1) & "<div class=""disclaimer"">" & vbCrLf
			m_contents.add indent(2) & "<small>" & sDescriptionText & "</small>" & vbCrLf
			m_contents.add indent(1) & "</div>" & vbCrLf
		end if
	end function

	function addFormInput(sRequired, sName, sId,  sFieldType, sClass, sDefaultVal, sCustomTags, sMessage)
		dim sError : sError = ""
		dim sAccess : sAccess = nextAccessKey()
		dim sLabelClass : sLabelClass = "label" & pcase(sFieldType) & " " & sClass
		dim sExtraContent : sExtraContent = ""
		dim sGroup : sGroup = sid
		Dim sChecked : sChecked = ""
		dim sDivClass : sDivClass = ""
		dim isChecked : isChecked =  ((instr(sCustomTags,"checked") > 0) Or (instr(sCustomTags,"selected")) > 0)
		dim isRequired : isRequired = (sRequired = "required")
		dim a : set a = New FastString
		sClass = sRequired & " " & sClass & " input" & PCase(sFieldType)
		sLabelClass = sLabelClass & iif(isNull(sName) or len(sName) = 0, " empty", "")
		if (not isNull(currentGroupId)) and (currentGroupId <> "") then
			sGroup = currentGroupId
			sid = currentGroupId & "_" & sid
		end if

		dim tmp, max, min, i : tmp = split(sClass," ")
		for i=0 to ubound(tmp)
			if instr(tmp(i), "wide") > 0 then sDivClass = sDivClass & "wide "
			if instr(tmp(i), "narrow") > 0 then sDivClass = sDivClass & "narrow "
			if instr(tmp(i), "length:") > 0 then
				tmp(i) = replace(tmp(i), "length:", "")
				if instr(tmp(i),",") then
					min = cint(split(tmp(i), ",")(0))
					max = cint(split(tmp(i), ",")(1))
				else
					min = -1
					max = cint(tmp(i))
				end if
				if (max>0) then
					sCustomTags = sCustomTags & " onKeyDown=""textCounter(this," & max & ");"" onKeyUp=""textCounter(this," & max & ");"""
					sExtraContent = "<small>(<span id=""" & sId & "_count"">" & max-len(sDefaultVal) & "</span> characters left)</small>" & vbCrLf
					m_hasFieldCounter = true
				end if
			end if
		next

		trace("")
		trace(UCASE(sFieldType) & " FIELD: required='" & isRequired & "' name='" & sGroup & "' id='" & sId & "' class='" & sClass & "' value='" & Server.HtmlEncode("" & sDefaultVal) & "' tags='" & sCustomTags & "'")
		select case sFieldType
			case "text","password","file"
				if not (validateFormField(sRequired, sName, sId, sFieldType, sClass)) then
					sError = " error"
					sAccess = nextErrorAccessKey()
				end if
				if not isGrouped then m_contents.add  indent(1) & "<div class=""" & sDivClass & sRequired & sError & """>" & vbCrLf
				m_contents.add  indent(2) & "<label for=""" & sId & """ class=""" & sLabelClass & """ accesskey=""" & sAccess & """>"
				m_contents.add  sName & "</label>" & vbCrLf
				if ((instr(sClass, "date")) and (m_Dijitize = true)) then sCustomTags = sCustomTags & m_DatePicker ' & " cssClass=""" & sClass & """"
				if ((instr(sCustomTags, "size"))=0) then  sCustomTags = sCustomTags & " size=""10"" "
				'if instr(sClass,"date") then sCustomTags = sCustomTags & " onblur=""fixDate(this)"""
				'if instr(sClass,"int") then sCustomTags = sCustomTags & " onblur=""fixInt(this,',')"""
				'if instr(sClass,"money") then sCustomTags = sCustomTags & " onblur=""fixMoney(this,',')"""
				if instr(sClass,"phone") then sCustomTags = sCustomTags & "  onblur=""fixPhone(this,'" & globals("DEFAULT_AREA_CODE") & "','-')"""
				m_contents.add  indent(2) & "<input  id=""" & sId & """ name=""" & sId & """  type=""" & sFieldType & """ class=""" & sClass & """ " & valueFill(sFieldType,sid,sDefaultVal,"") & sCustomTags & "/>" & vbCrLf
				if sFieldType = "file" and m_isUploadEnabled = FALSE then m_contents.add indent(2) & "<small class=""warn"">" & FILE_UP_DISABLED_WARNING & "</small>"
				if (not isGrouped) then
					if (not isNull(sMessage)) and (sMessage <> "") then	m_contents.add indent(2) & "<small>" & sMessage & "</small>" & vbCrLf
					'if (max>0) then	m_contents.add indent(2) & sExtraContent
					if m_dictErrors.exists("" & sid) then 	m_contents.add  indent(2) & "<small class=""error"">" & replace(m_dictErrors("" & sid)," | ","</small>" & vbCrLf & "<small class=""error"">") & "</small>" & vbCrLf
					m_contents.add  indent(1) & "</div>" & vbCrLf
				end if
			case "hidden"
				m_contents.add  indent(1) & "<div class=""hidden " & sDivClass & sRequired & sError & """>" & vbCrLf
				m_contents.add  indent(2) & "<input  id=""" & sId & """ name=""" & sId & """  type=""" & sFieldType & """ class=""" & sClass & """ " & valueFill(sFieldType,sid,sDefaultVal,"") & " size=""10"" " & sCustomTags & "/>" & vbCrLf
				m_contents.add  indent(1) & "</div>" & vbCrLf
			case "textarea"
				m_hasTextarea = true
				if not (validateFormField(sRequired, sName, sId, sFieldType, sClass)) then
					sError = " error"
					sAccess = nextErrorAccessKey()
				end if
				if not isGrouped then m_contents.add  indent(1) & "<div class=""" & sDivClass & sRequired & sError & """>" & vbCrLf
				if instr(sCustomTags,"rows=""")=0 then sCustomTags = sCustomTags & " rows=""4"""
				m_contents.add  indent(2) & "<label for=""" & sId & """ class=""" & sLabelClass & """ accesskey=""" & sAccess & """>"
				m_contents.add  sName & "</label>" & vbCrLf
				if instr(sClass, "simple")=0 then sCustomTags = sCustomTags & m_EditorConfig
				sCustomTags = token_replace(sCustomTags)
				m_contents.add  indent(2) & "<textarea id=""" & sId & """ name=""" & sId & """ class=""" & sClass & """ cols=""10"" " & sCustomTags & ">" & valueFill(sFieldType,sid,sDefaultVal,"") & "</textarea>" & vbCrLf
				if (not isGrouped) then
					if (not isNull(sMessage)) and (sMessage <> "") then	m_contents.add indent(2) & "<small>" & sMessage & "</small>" & vbCrLf
					if (max>0) then	m_contents.add indent(2) & sExtraContent
					if m_dictErrors.exists("" & sid) then 	m_contents.add  indent(2) & "<small class=""error"">" & replace(m_dictErrors("" & sid)," | ","</small>" & vbCrLf & "<small class=""error"">") & "</small>" & vbCrLf
					m_contents.add  indent(1) & "</div>" & vbCrLf
				end if
			case "checkbox","radio"
				if (not isGrouped) then
					if not (validateFormField(sRequired, sName, sId, sFieldType, sClass)) then
						sError = " error"
						sAccess = nextErrorAccessKey()
					end if
				end if
				m_contents.add  indent(3) & "<label"
				if (not isGrouped) then m_contents.add  " for=""" & sid & """"
				m_contents.add  " class=""" & sLabelClass & """ accesskey=""" & sAccess & """>" & vbCrLf
				trace("is this button grouped? " & isGrouped)
				trace(sFieldType & " is selected by default? " & isChecked)
				if (isChecked) or ("" & sDefaultVal = "" & true) or (lcase("" & sClass) = "yes") then sChecked = "checked"
				m_contents.add  indent(3) & "<input type=""" & sFieldType & """ name=""" & sGroup & """"
				if (not isGrouped) then m_contents.add  " id=""" & sid & """"
				m_contents.add  " class=""" & sClass & """ " & valueFill(sFieldType,sGroup,sDefaultVal,sChecked) & " " & sCustomTags & "/>" & vbCrLf
				m_contents.add  indent(3) & sName & "</label>" & vbCrLf
				if (not isGrouped) then
					if (not isNull(sMessage)) and (sMessage <> "") then	m_contents.add indent(2) & "<small>" & sMessage & "</small>" & vbCrLf
					if m_dictErrors.exists("" & sid) then 	m_contents.add  indent(2) & "<small class=""error"">" & replace(m_dictErrors("" & sid)," | ","</small>" & vbCrLf & "<small class=""error"">") & "</small>" & vbCrLf
				end if
			case "image"
				debugError("class.form.addFormInput: Please do not use form inputs with type='image' because they are not accessible.")
			case else
				debugError("class.form.addFormInput: There is no such form input for type '" & sFieldType & "'")
		end Select
	end function

	function addFormSelect(sRequired, sName, sId, sClass, sCustomTags)
		dim sDivClass : sDivClass = ""
		dim sError : sError = ""
		dim sAccess : sAccess = nextAccessKey()
		dim sLabelClass
		if isNull(sClass) then sClass = ""
		if instr(sClass, "required")>0 then
			sClass = replace(sClass,"required","")
			sRequired = "required"
		end if

		sLabelClass = sClass & " labelSelect"
		sLabelClass = sLabelClass & iif(isNull(sName) or len(sName)=0," empty","")

		dim tmp,max,min,i : tmp = split(sClass," ")
		for i=0 to ubound(tmp)
			if instr(tmp(i),"wide")>0 then sDivClass = sDivClass & "wide "
			if instr(tmp(i),"narrow")>0 then sDivClass = sDivClass & "narrow "
		next

		debug("class.form.addFormSelect: '" & sId & "'")
		dim a : set a = New FastString
		trace("class.form.addFormSelect: '" & sRequired & "' name='" & sName & "' id='" & sId & "' class='" & sClass & "' tags='" & sCustomTags & "'.")
		currentSelectGroup = sId
		isMultiSelect = instr(sClass, "selectMany") > 0
		if isMultiselect then sCustomTags = sCustomTags & " multiple=""multiple"""
		if not isMultiSelect and instr(sClass, "selectOne") = 0 then sClass = sClass + " selectOne"

		if not (validateFormField(sRequired, sName, sId, "select", sClass)) then
			sError = " error"
			sAccess = nextErrorAccessKey()
		end if
		m_contents.add  indent(1) & "<div class=""" & sDivClass & sRequired & sError & """>" & vbCrLf
		m_contents.add  indent(2) & "<label for=""" & sId & """ class=""" & sLabelClass & """ accesskey=""" & sAccess & """>" & sName & "</label>" & vbCrLf
		m_contents.add  indent(2) & "<select id=""" & sId & """ name=""" & sId & """ class=""" & sRequired & " " & sClass & """ " & sCustomTags & ">" & vbCrLf
	end function

	function addFormOption(selectId, sValue, sDisplay, sSelected)
		'dim valChoice : valChoice = selectId & ":" & sValue
		dim sName,sDivider,sClass


		sName = ""
		sClass = iif(instr(sSelected, OPTION_DIVIDER)>0," " & OPTION_DIVIDER,"")
		sClass = sClass & iif(isNull(sName) or len(sName)=0," empty","")
		trace("")
		if currentSelectGroup <> "" then
			if currentSelectGroup <> selectId then
				debugError("class.form.addFormOption: SELECT group specified for this OPTION (" & selectId & ") does not coinside with the actual parent tag that is open right now, using the default that is open (" & currentSelectGroup & ")")
			end if
			'if isMultiSelect = true then sName = "name=""" & currentSelectGroup & """ "

			trace("class.form.addFormOption: OPTION FOR SELECT GROUP(" & currentSelectGroup & "): '" & sSelected & "' value='" & sValue & "' groupId='" & currentSelectGroup & "' display='" & sDisplay & ".")
			'if instr(sSelected,"selected") then valChoice = valChoice & ":selected"
			m_contents.add  indent(3) & "<option " & sName & valueFill("option",selectId,sValue,sSelected) & " class=""" & sDivider & """>" & sDisplay & "</option>" & vbCrLf
		else
			debugError("class.form.addFormOption: there is currently no Select Group for which to add this option!")
			debugError("class.form.addFormOption: use addFormSelect() to initialize a select group first")
		end if
	end function

	function endFormSelect(byval sMessage)
		debug("class.form.endFormSelect: '" & currentSelectGroup & "'")
		if isNull(currentSelectGroup) or (currentSelectGroup = "") then
			debugError("there is no Select Group to close")
			debugError("Please use addFormSelect() to initialize a select group")
		else
			m_contents.add  indent(2) & "</select>" & vbCrLf
			if sMessage <> "" and not isNull(sMessage) then m_contents.add indent(2) & "<small>" & sMessage & "</small>" & vbCrLf
			if m_dictErrors.exists("" & currentSelectGroup) then
				trace("errors were found in this Select Group")
				m_contents.add indent(2) & "<small class=""error"">" & m_dictErrors("" & currentSelectGroup) & "</small>" & vbCrLf
			end if
			m_contents.add  indent(1) & "</div>" & vbCrLf
		end if
		currentSelectGroup = ""
	end function


	'you can specify a null or empty string for sId which puts the
	'input fields inside the group within the same visual fieldset,
	'but this will not tie them to the group. if you specify an id
	'however, all input fields inside the group will be tied to that
	'id, not the field's id you specified
	function addFormGroup(sFieldType,sRequired,sDisplayName,sId)
		dim sError : sError = ""
		dim sAccess : sAccess = nextAccessKey()
		dim fieldsetName : fieldsetName= ""
		dim a : set a = New FastString
		trace("")
		trace( UCASE(sFieldType) & " GROUP: '" & sRequired & "' displayName='" & sDisplayName & "' id='" & sId & "'.")
		isGrouped = true
		if isNull(sid) or sid = "" then
			'do not assign group id
			'do not check validity of group (because the units in the group are not bound to this group id)
			isGrouped = FALSE
		else
			fieldsetName = " name=""" & sid & """"
			currentGroupId = sid
			if not (validateFormField(sRequired,sDisplayName,sId,sFieldType,"")) then
			sError = " error"
			sAccess = nextErrorAccessKey()
			end if
		end if
		m_contents.add  indent(1) & "<div class=""" & sRequired & sError & """>" & vbCrLf & vbtab
		m_contents.add  indent(1) & "<fieldset" & fieldsetName & ">"  & vbCrLf
		if len(sDisplayName) > 0 then m_contents.add  indent(3) & "<legend accesskey=""" & sAccess & """>" & sDisplayName & "</legend>" & vbCrLf
		trace("class.form.addFormGroup: '" & currentGroupId & "'")
	end function


	function endFormGroup()
		m_contents.add  indent(2) & "</fieldset>"  & vbCrLf
		if m_dictErrors.exists("" & currentGroupId) then
			debuginfo("class.form.endFormGroup: '" & currentGroupId & "' had errors")
			m_contents.add  indent(2) & "<small class=""error"">" & m_dictErrors("" & currentGroupId) & "</small>" & vbCrLf
		end if
		m_contents.add  indent(1) & "</div>"  & vbCrLf
		currentGroupId = ""
		isGrouped = FALSE
	end function

	function addFormRadioButton(sid, sValue, sLabel, sClass, sChecked)
		dim sError : sError = ""
		dim sGroup : sGroup = sid
		if currentGroupId <> "" then
			sGroup = currentGroupId
			sid = currentGroupId & "_" & sid
		end if
		dim valChoice : valChoice = sGroup & ":" & sValue
		if len(sLabel)=0 then sLabel = sValue
		trace("class.form.addFormRadioButton: group='" & sGroup & "' id='" & sid & "' value='" & sValue & "'  class='" & sClass & "' checked='" & sChecked & "'.")
		if instr(sChecked,"checked") or instr(sChecked,"selected") then valChoice = valChoice & ":checked"
		dim a : set a = New FastString
		m_contents.add indent(3) & "<label for=""" & sid & """ class=""labelRadio " & sClass & """>" & vbCrLf
		m_contents.add indent(3) &	"<input type=""radio"" name=""" & sGroup & """ class=""inputRadio"" " & valueFill("radio",sGroup,sValue,sChecked) & "/>" & vbCrLf
		m_contents.add indent(3) & sLabel & "</label>" & vbCrLf
	end function

	'============================
	'    PRIVATE FUNCTIONS
	'============================
	private function formatName(strName)
		formatName = replace(strName," ","_")
	end function

	private function nextAccessKey()
		m_accessKeyIndex = m_accessKeyIndex + 1
		nextAccessKey = m_accessKeyIndex
	end function

	private function nextErrorAccessKey()
		if ((m_errorAccessKeyIndex mod 100) = 91) then
			m_errorAccessKeyIndex = m_errorAccessKeyIndex + 74
		end if
		dim i
		for i=1 to round(m_errorAccessKeyIndex / 100)
			nextErrorAccessKey = nextErrorAccessKey & chr(m_errorAccessKeyIndex mod 100)
		next
		m_errorAccessKeyIndex = m_errorAccessKeyIndex +1
	end function

	private function validateFormField(byval sRequired,byval sName,byval sid,byval sFieldType,byval sClass)
		validateFormField = true
		'developer double check uniqueness of field id (depending on input type)
		if (checkDuplicateFormFieldId(sName, sid, sFieldType)) then validateFormField = FALSE

		if wasSubmitted() then
			trace("class.form.validateFormField: '" & sid & "'")
		'only check field values if form was submitted
			select case sFieldType
			'if (sFieldType = "text"  or sFieldType = "password") then
			case "text","password"
				if (isMemberOf(sRequired,"required")) then
					if not ( requireValue(sName, sid)) then validateFormField = FALSE
				end if
				if (isMemberOf(sClass,"date")) then
					if not ( checkDate(sName, sid)) then validateFormField = FALSE
				end if
				if (isMemberOf(sClass,"time")) then
					if not ( checkTime(sName, sid)) then validateFormField = FALSE
				end if
				if (isMemberOf(sClass,"time24")) then
					if not ( checkTime24(sName, sid)) then validateFormField = FALSE
				end if
				if (isMemberOf(sClass,"ssn")) then
					if not ( checkSSN(sName, sid)) then validateFormField = FALSE
				end if
				if (isMemberOf(sClass,"cc")) then
					if not ( checkCreditCard(sName, sid)) then validateFormField = FALSE
				end if
				if (isMemberOf(sClass,"phone")) then
					if not ( checkPhone(sName, sid)) then validateFormField = FALSE
				end if
				if (isMemberOf(sClass,"money")) then
					if not ( checkMoney(sName, sid)) then validateFormField = FALSE
				end if
				if (isMemberOf(sClass,"numeric")) then
					if not ( checkNumeric(sName, sid)) then validateFormField = FALSE
				end if
				if (isMemberOf(sClass,"int")) then
					if not ( checkInt(sName, sid)) then validateFormField = FALSE
				end if
				if (isMemberOf(sClass,"float")) then
					if not ( checkFloat(sName, sid)) then validateFormField = FALSE
				end if
				if (isMemberOf(sClass,"zip")) then
					if not ( checkZip(sName, sid)) then validateFormField = FALSE
				end if
				if (isMemberOf(sClass,"email")) then
					if not ( checkEmail(sName, sid)) then validateFormField = FALSE
				end if
				if (isMemberOf(sClass,"length:")) then
					if not ( requireLength(sName, sid, sClass)) then validateFormField = FALSE
				end if
			case "textarea"
			'elseif (sFieldType = "textarea") then
				if (isMemberOf(sRequired,"required")) then
					if not ( requireValue(sName, sid)) then validateFormField = FALSE
				end if
				if (isMemberOf(sClass,"length:")) then
					if not ( requireLength(sName, sid, sClass)) then validateFormField = FALSE
				end if
			case "file"
			'elseif (sFieldType = "file") then
				if (isMemberOf(sClass,"required")) then
					if not ( requireValue(sName, sid)) then validateFormField = FALSE
				end if
			case "checkbox"
			'elseif (sFieldType = "checkbox") then
				if (isMemberOf(sRequired,"required")) then
					if not requireChecked(sName, sid) then validateFormField = FALSE
				end if
			case "radio"
			'elseif (sFieldType = "radio") then
				if (isMemberOf(sRequired,"required")) then
					if not requireRadio(sName, sid) then validateFormField = FALSE
				end if
			case "select"
			'elseif (sFieldType = "select") then
				if (isMemberOf(sRequired,"required")) then
					if not requireValue(sName, sid) then validateFormField = FALSE
				end if
			'end if
			case else
				debugWarning("class.form.validateFormField: field of type " & sFieldType & " is not currently supported for validation.")
			end select
		else
			trace("class.form.validateFormField: form not submitted nothing to validate")
		end if
		if validateFormField then
			debugInfo("class.form.validateFormField: '" & sid & "' values are valid. ")
		else
			debugInfo("class.form.validateFormField: '" & sid & "' values are invalid. ")
		end if
	end function

	private function checkDuplicateFormFieldId(fldName, id, sFieldType)
		dim bolDuplicate : bolDuplicate = FALSE
		if m_fieldNames.exists("" & id) then
			dim erMsg : erMsg = "The " & sFieldType & " field '" & fldName & "' with id '" & id & "' already exists in this form.  It was previously added to this form with " & m_fieldNames("" & id)
			debug(erMsg)
			select case sFieldType
				case "text","password","select"
					addFormError "" & id, erMsg
				case "checkbox", "radio"
					addFormError "" & id, erMsg
					bolDuplicate = true
				case else
					addFormError "" & id, erMsg
					bolDuplicate = true
			end select
		else
			'add the new field to the dictionary
			m_fieldNames.add "" & id, "name:" & fldName & ";type:" & sFieldType
		end if
		if bolDuplicate then debugError("class.form.checkDuplicateion: '" & id & "' is duplicate! ")
		checkDuplicateFormFieldId = bolDuplicate
	end function

	private function isMemberOf(sAttributes,sName)
		dim bolValid : bolValid = FALSE
		if (instr(sAttributes,sName)) then
			bolValid = true
			debug("it is " & sName)
		end if
		isMemberOf = bolValid
	end function

	private function requireValue(fldName, id)
		requireValue = true
		debug("its value is '" & m_Request.Form("" & id) & "'")
		if m_Request.Form("" & id) = "" then
			addFormError id, "The " & fldName & " field cannot be left blank."
			requireValue = FALSE
		end if
	end function

	private function requireRadio(rdoGroup, id)
		'require a radio button from radio group be checked
		requireRadio = TRUE
		if m_Request.Form("" & id) = "" then
			addFormError id, "You must select one of the options."
			requireRadio = FALSE
		end if
	end function

	private function requireChecked(chkGroup, id)
		'require a checkbox to be checked
		requireChecked = TRUE
		if m_Request.Form("" & id) = "" then
			addFormError id, "The" & chkGroup & " checkbox must be checked."
			requireChecked = FALSE
		end if
	end function

	private function requireLength(fldName, id, classString)
		requireLength = true
		dim tmp, min, max, i : tmp = split(classString," ")
		for i=0 to ubound(tmp)
			if instr(tmp(i),"length:") then
				tmp(i) = replace(tmp(i),"length:","")
				if instr(tmp(i),",") then
					min = cint(split(tmp(i),",")(0))
					max = cint(split(tmp(i),",")(1))
				else
					min = -1
					max = cint(tmp(i))
				end if
			end if
		next
		debug("class.form.requireLength: " & fldName & " requires min length of " & min & " and max length of " & max & ".")
		dim val : val = m_Request.Form("" & id)
		if (min > -1) and (len(val) < min) then
			addFormError id, "The " & fldName & " field must be at least " & min & " characters long. It is currently " & len(val) & " characters long."
			requireLength = FALSE
		end if
		if (max > -1) and (len(val) > max) then
			addFormError id, "The " & fldName & " field must be no more than " & min & " characters long. It is currently " & len(val) & " characters long."
			requireLength = FALSE
		end if
	end function

	private function checkEmail(fldName, id)
		checkEmail = true
		dim val : val = m_Request.Form("" & id)
		if val <> "" then
			dim phony : set phony = new RegExp
			phony.Pattern = "@(\w+\.)*example\.(com|net|org)$"
			phony.IgnoreCase = TRUE
			phony.Global = TRUE
			if phony.Test(val) then
				addFormError id, "Please enter your email address in the " & fldName & " field."
				checkEmail = FALSE
			end if

			dim emlformat : set emlformat = new RegExp
			emlformat.Pattern = "^\w+([+.-]\w+)*@\w+([.-]\w+)*\.\w{2,8}$"
			emlformat.IgnoreCase = True
			emlformat.Global = True
			if not emlformat.test(val) then
				addFormError id, "The " & fldName & " field must contain a valid email address."
				checkEmail = FALSE
			end if
		end if
	end function

	private function checkPassword(fldName, id)
		checkPassword = true
		dim val : val = m_Request.Form("" & id)
		if val <> "" then
			Dim re
			Set re = new RegExp

			re.IgnoreCase = FALSE
			re.global = FALSE
			re.Pattern = "^[a-zA-Z]\w{3,14}$"

			if not re.Test(val) then
				addFormError id, "The " & fldName & " field must be between 3 and 14 characters long."
				checkPassword = FALSE
			end if
		end if
	end function

	private function checkMoney(fldName, id)
		checkMoney = true
		dim val : val = m_Request.Form("" & id)
		if val <> "" then
			val = trim(val)
			val= replace(val,"$","")
			if len(val) > 0 then
				if not isNumeric(val) then
					addFormError id, "The " & fldName & " field must contain a dollar amount."
					checkMoney = FALSE
				end if
			end if
		end if
	end function

	private function checkCreditCard(fldName, id)
		checkCreditCard = true
		debugError("class.form.checkCreditCard: validation is not yet implemented for ASP it does however work in javascript, there is no guarantee that the end user will have javascript on so please refrain from using this unless you want to implement the error checking.")
	'	dim val : val = m_Request.Form("" & id)
	'	dim ctype
	'	if val <> "" then
	'		 'get only numeric part of string
	'		val = replace(val," ","")
	'		val = replace(val,"-","")
	' 	val = replace(val,".","")
	' 	dim prefix2= cint(left(val,0,2))
	'		if( left(val,0,1) = "4" ) then
	'			ctype= "Visa\xae"
	'			if( len(val) = 16 ) then
	'			elseif( len(val) = 13 ) then  ' very old #, should be reassigned
	'			elseif( len(val) < 13) then
	'				addFormError id, "The Visa\xae number you provided is not long enough."
	'				checkCreditCard = FALSE
	'			elseif( len(val) > 16) then
	'				addFormError id, "The Visa\xae number you provided is too long."
	'				checkCreditCard = FALSE
	'			else
	'				addFormError id, "The Visa\xae number you provided is either not long enough, or too long."
	'				checkCreditCard = FALSE
	' 			end if
	'		elseif( prefix2 >= 51 & & prefix2 <= 55) then
	'		' MC
	'			ctype= "MasterCard\xae"
	'			if( len(val) < 16 ) then
	'				addFormError id, "The MasterCard\xae number you provided is not long enough."
	'				checkCreditCard = FALSE
	'				elseif( len(val) > 16 ) then
	'				addFormError id, "The MasterCard\xae number you provided is too long."
	'				checkCreditCard = FALSE
	'			end if
	'		elseif( (prefix2 = 34) || (prefix2 = 37) )then
	'		' AmEx
	'			ctype= "American Express\xae card"
	'			if( len(val) < 15) then
	'				addFormError id, "The American Express\xae card number you provided is not long enough."
	'				checkCreditCard = FALSE
	'			elseif( len(val) > 15) then
	'				addFormError id, "The American Express\xae card number you provided is too long."
	'				checkCreditCard = FALSE
	'			end if
	'		elseif( left(val,0,4) = "6011") then
	'		' Novus/Discover
	'			ctype= "Discover\xae card"
	'			if( len(val) < 16) then
	'				addFormError id, "The Discover\xae card number you provided is not long enough."
	'				checkCreditCard = FALSE
	'			elseif( len(val) > 16) then
	'				addFormError id, "The Discover\xae card number you provided is too long."
	'				checkCreditCard = FALSE
	'			end if
	'		end if
	'		else
	'		' other
	'			if( len(val) < 13) then
	'				addFormError id, "The credit card number you provided is not long enough."
	'				checkCreditCard = FALSE
	'			end if
	'			if( len(val) > 19) then
	'				addFormError id, "The credit card number you provided is too long."
	'				checkCreditCard = FALSE
	'			end if
	'		end if
	'
	'		dim sum: sum = 0
	'		dim dbl: dbl = FALSE
	'		Dim i : len(val)-1
	'		Do
	'			(dbl = not dbl)
	'			dim digit= cint(mid(val,i-1,1))*((dbl=!dbl)?1:2)
	'			sum= sum & ( digit > 9 ? (digit%10)+1 : digit )
	'			counter=counter-1
	'		loop until counter=0

	'		if(sum%10) then
	'			addFormError id, "The "+ctype+" number you provided is not valid." & vbCrLf & "Please double-check it and try again."
	'			checkCreditCard = FALSE
	'		end if
	'		checkCreditCard = true
	'		end if
	end function

	private function checkDate(fldName, id)
		checkDate = true
		dim val : val = m_Request.Form("" & id)
		if m_Request.Form("" & id) <> "" then
			if not isDate(val) then
				addFormError id, "The " & fldName & " field date format is invalid. Try using the default format 'MM/DD/YYYY'"
				checkDate = FALSE
			end if
		end if
	end function

	private function checkTime(fldName, id)
		checkTime = true
		dim amPm
		dim val : val = lcase(m_Request.Form("" & id))
		if len(val) > 0 then
			val = replace(val," ", "") 'remove whitespace
			val = replace(val,".", "") 'remove periods (a.m./p.m.)
			if instrRev(val,"am") > 1 then
				amPm = "am"
				val = left(val,0,instrRev(val,"am")-1)
			elseif instrRev(val,"pm") > 1 then
				amPm = "pm"
				val = left(val,0,instrRev(val,"pm")-1)
			end if
			if (not instr(val,":")) or (not isNumeric(replace(val,":",""))) then
				addFormError id, "The " & fldName & " field time format is invalid. Try using the default format 'HH:MM (am/pm)'"
				checkTime = FALSE
			elseif cint(left(val,0,instr(val,":")-1)) > 23 then
				addFormError id, "The " & fldName & "'s hour must be between 1 and 12 or 24 hour format 00 through 23."
				checkTime = FALSE
			elseif cint(right(val,0,instr(val,":")-1)) > 59 then
				addFormError id, "The " & fldName & "'s minutes must be between 00 and 59."
				checkTime = FALSE
			end if
		end if
	end function

	private function checkTime24(fldName, id)
		checkTime24 = true
		dim val : val = lcase(m_Request.Form("" & id))
		val = replace(val," ", "")
		if len(val) > 0 then
			if instrRev(val,"am") or instrRev(val,"pm") then
				addFormError id, "The " & fldName & "'s time must be in 24 hour format (HH:MM) not AM/PM."
				checkTime24 = FALSE
			elseif (not instr(val,":")) or (not isNumeric(replace(val,":",""))) then
				addFormError id, "The " & fldName & " field time format is invalid. Try using the default format 'HH:MM (am/pm)'"
				checkTime24 = FALSE
			elseif cint(left(val,0,instr(val,":")-1)) > 23 then
				addFormError id, "The " & fldName & "'s hour must be between 00 and 23."
				checkTime24 = FALSE
			elseif cint(right(val,0,instr(val,":")-1)) > 59 then
				addFormError id, "The " & fldName & "'s minutes must be between 00 and 59."
				checkTime24 = FALSE
			end if
		end if
	end function

	private function checkPhone(fldName, id)
		checkPhone = true
		dim val : val = m_Request.Form("" & id)
		if len(val) > 0 then
			val = replace(val," ", "")
			val = replace(val,"-", "")
			val = replace(val,".", "")
			val = replace(val,"ext", "x")
			val = replace(val,"*", "x")
			if instrRev(val,"x") > 1 then
				val = left(val,0,instrRev(val,"x")-1)
			end if
			if (len(val) < 7) then
				addFormError id, "The phone number you supplied for the " & fldName & " field was too short. Dont forget the area code."
				checkPhone = FALSE
			elseif (len(val) > 11) then
				addFormError id, "The phone number you supplied for the " & fldName & " field was too long."
				checkPhone = FALSE
			elseif not isNumeric(val) then
				addFormError id, "The phone number you supplied for the " & fldName & " field was incorrect. Please use only digits (0 through 9) and appropriate punctuation.  Valid formats include 1.234.567.8900, 234-567-8900 x1000, 234-567-8900 ext.1234"
				checkPhone = FALSE
			end if
		end if
	end function

	private function checkSSN(fldName, id)
		checkSSN  = true
		dim val : val = m_Request.Form("" & id)
		if len(val) > 0 then
			val = replace(val," ", "")
			val = replace(val,"-", "")
			val = replace(val,".", "")
			if (len(val) < 9) then
				addFormError id, "The Social Security Number you supplied for the " & fldName & " field was too short. The format must be 9 digits. "
				checkSSN = FALSE
			elseif (len(val) > 9) then
				addFormError id, "The Social Security Number you supplied for the " & fldName & " field was too long. The format must be 9 digits. "
				checkSSN = FALSE
			elseif not isNumeric(val) then
				addFormError id, "The Social Security Number you supplied for the " & fldName & " field was incorrect. Please use only digits (0 through 9) and appropriate punctuation.  Valid formats include 123456789,  123-45-6789, or 123.45.6789"
				checkSSN = FALSE
			end if
		end if
	end function

	private function checkNumeric(fldName, id)
		checkNumeric = true
		dim val : val = m_Request.Form("" & id)
		if len(val) > 0 then
			if not isnumeric(val) then
				addFormError id, "The " & fldName & " field must be numeric."
				checkNumeric = FALSE
			end if
		end if
	end function

	private function checkInt(fldName, id)
		checkInt = true
		dim val : val = m_Request.Form("" & id)
		if len(val) > 0 then
			if not isnumeric(val) then
				addFormError id, "The " & fldName & " field must be numeric."
				checkInt = FALSE
			elseif not anInteger.test(val) then
				addFormError id, "The " & fldName & " field must be a number containing only digits 0 through 9."
				checkInt = FALSE
			end if
		end if
	end function

	private function checkFloat(fldName, id)
		checkFloat = true
		dim val : val = m_Request.Form("" & id)
		if len(val) > 0 then
			if not isnumeric(val) then
				addFormError id, "The " & fldName & " field must be numeric."
				checkFloat = FALSE
			end if
		end if
	end function

	private function checkZip(fldName, id)
		checkZip = true
		dim val : val = m_Request.Form("" & id)
		val = replace(val," ", "")
		val = replace(val,"-", "")

		if len(val) > 0 then
			'check only if form contains a value
			trace("class.form.checkZip: this zip code is of length" & len(val))
			if not isnumeric(val) then
				addFormError id, "The " & fldName & " field must be numeric."
				checkZip = FALSE
			elseif not anInteger.test(val) then
				addFormError id, "The " & fldName & " field must be either a 5 or 9 digit Zip Code containing only digits 0 through 9 (and optionally a hyphen)."
				checkZip = FALSE
			elseif ((len(val) < 5)) or ((len(val) > 9)) then
				addFormError id, "The " & fldName & " field must be either a 5 or 9 digit Zip Code."
				checkZip = FALSE
			elseif ((len(val) > 5)) and ((len(val) < 9)) then
				addFormError id, "The " & fldName & " field must be either a 5 or 9 digit Zip Code."
				checkZip = FALSE
			end if
		else
			trace("class.form.checkZip: Zip Code was empty")
		end if
	end function


	'===============================
	'  ERROR HANDLING FUNCTIONS
	'===============================
	'returns true if there were errors found in validating the form fields
	public function hasErrors()
		trace("class.form.hasErrors(): m_dictErrors.count is " & m_dictErrors.count)
		hasErrors = (m_dictErrors.count > 0)
	end function


	'return this form's error dictionary object
	public function getFormErrors()
		set getFormErrors = m_dictErrors
	end function

	'write HTML formatted errors to the response object
	public function printFormErrors()
		if m_dictErrors.Count <> 0 then
			dim strHTMLerr : set strHTMLerr = new FastString
			strHTMLerr.add "<div class=""form-errors"">"
			strHTMLerr.add "Please correct the following errors."
			strHTMLerr.add "<ol>"
				dim fld
				for each fld in m_Request.Form
					if len(m_dictErrors("" & fld)) > 0 then
						strHTMLerr.add "<li class=""error""><a href=#" & fld & " title=""Go to error."">" & replace(m_dictErrors("" & fld),"|","</a></li>" & vbCrLf & "<li class=""error""><a href=#" & fld & " title=""Go to error."">") & "</a></li>"
					end if
			next
			strHTMLerr.add "</ol></div>"
			writeln(WarningMessage(strHTMLerr.value))
			set strHTMLerr = nothing
		end if
	end function

	'adds an error to the error dictionary
	private sub addFormError(id, sMessage)
		debug("class.form.addFormError: field:" & id & "; error:" & sMessage)
		if m_dictErrors.exists("" & id) then
			sMessage = m_dictErrors("" & id) & " | " & sMessage
			m_dictErrors.remove("" & id)
		end if
		m_dictErrors.add "" & id, sMessage
	end sub

	'===============================
	'   FORM DEFAULT VALUE FILLER
	'===============================
	'identifies what value this input gets (default, user, or session)
	'also used to determine if check,radio,or dropdown option should be
	'selected/checked based on if the user selected it, if the session
	'had stored it, or if is the default selected option
	private function valueFill(sFieldType,id,defaultVal,defaultOption)
		trace("class.form.valueFill(" & sFieldType & "," & id & "," & Server.HtmlEncode("" & defaultVal) & "," & defaultOption & ")")
		'strKeyVal = split(strKeyVal,":")
		'dim id : id = strKeyVal(0)
		'dim defaultVal : defaultVal = strKeyVal(1)
		'dim defaultOption : defaultOption = ""
		if isNull(m_Name) or m_Name = "" then m_Name = m_Request.Form("form_name")
		dim formVal : formVal = m_Request.Form("" & id)
		dim sessVal : sessVal = session(m_Name & ":" & id)
	'===START DECISION TREE ====================================
		select case sFieldType
			case "text","password","file","hidden"
				'textboxes are probably the most straightforward,
				'just drop in content from submitted form or session if any
				if wasSubmitted() then
					trace("class.form.valueFill: form was submitted, " & id & " gets value " & formVal)
					valueFill = "value=""" & formVal & """"
				elseif wasStoredToSession(m_Name) and (sessVal <> "") then
					trace("class.form.valueFill: session has non-null contents for " & m_Name & ":" & id & ": gets value " & sessVal)
					valueFill = "value=""" & sessVal & """"
				else 'just use the default variables passed in
					trace("class.form.valueFill: no valid stored values for '" & id & "' so it gets default value '" & defaultVal & "'")
					valueFill = "value=""" & defaultVal & """"
				end if
			case "textarea"
				'textareas are also straightforward,
				'drop in content from submitted form or session if any
				if wasSubmitted() then
					trace("class.form.valueFill: form was submitted, " & id & " gets value " & Server.HtmlEncode("" & formVal))
					valueFill = formVal
				elseif wasStoredToSession(m_Name) then
					trace("class.form.valueFill: session has non-null contents for " & m_Name & ":" & id & " and thus gets value " & Server.HtmlEncode("" & sessVal))
					valueFill = sessVal
				else
					trace("class.form.valueFill: no valid stored values for '" & id & "' so it gets default value '" & Server.HtmlEncode("" & defaultVal) & "'")
					valueFill = defaultVal
				end if


			case "radio", "checkbox"
				'Because individual radio buttons and checkbox values
				'dont have the ability to be change by the user, we
				'only check to see if the radio/check group to which
				'this button belongs has the value (as selected by the
				'user) that coincides with this button's value.
				'Therefore, we first assign it unmutable default value
				'that was passed in, and then check to see if it should
				'be marked as "checked" or not.
				valueFill = "value=""" & defaultVal & """"
				if wasSubmitted() then
					if (formVal = defaultVal) then
						'if this radio/check value was the one submitted by the user then mark it checked
						trace("class.form.valueFill: submitted value matches default value, so this " & sFieldType & " gets checked")
						valueFill = valueFill & " checked=""checked"""
					end if
				elseif wasStoredToSession(m_Name) and (sessVal <> "") then
						trace("class.form.valueFill: session has non-null contents for '" & id & "' :" & sessVal)
						if  (sessVal = defaultVal) then
						trace("class.form.valueFill: the session value matches this " & sFieldType & "'s default value so it gets checked")
						'if this radio/check value coincides with a non-empty session variable for the radio/button group
						valueFill = valueFill & " checked=""checked"""
					end if
				else 'just use the default variables passed in (and any default checked information)
					if instr(defaultOption,"checked") then
						trace("class.form.valueFill: " & sFieldType & " with id '" & id & "' has default checked options and no session values were found so it is thus  enabled")
						valueFill = valueFill & " checked=""checked"""
					else
						trace("class.form.valueFill: " & sFieldType & " with id '" & id & "' has no default checked option.")
					end if
				end if
			case "option"
				'Just like individual radio buttons and checkboxs,
				'individual select option values cannot be modified
				'by the user. All we have to do here is check to see
				'if the current option was the one selected by the user
				'during form submit or stored in the session during a
				'redirect.
				'Therefore, we first assign it the unmutable default
				'value that was passed in, and then check to see if
				'it should be marked as "selected" or not.
				valueFill = "value=""" & defaultVal & """"
				if wasSubmitted() and (formVal <> "") then
					if (formVal = defaultVal) then
						'if this option coincided with the one submitted then mark selected
						trace("class.form.valueFill: " & "submitted value matches default value, so this " & sFieldType & " gets selected")
						valueFill = valueFill & SELECTED
					end if
				elseif wasStoredToSession(m_Name) and (sessVal <> "") then
						trace("class.form.valueFill: " & "session has non-null contents for '" & id & "' :" & sessVal)
					if (sessVal = defaultVal) then
						'if this option value coincides with the non-empty session variable
						trace("class.form.valueFill: " & "the session value matches this " & sFieldType & "'s default value so it gets checked")
						valueFill = valueFill & SELECTED
					end if
				else 'just use the default variables passed in (and any default selected information)
					if instr(defaultOption,"selected") then
						trace("class.form.valueFill: " & sFieldType & " with id '" & id & "' has default selected option, and no session values were found so it is thus enabled")
						valueFill = valueFill & SELECTED
					else
						trace("class.form.valueFill: " & sFieldType & " with id '" & id & "' has no default checked option.")
					end if
				end if
			case else
				debugError("class.form.valueFill: " & " type '" & sFieldType & "' handling is not yet implemented!")
		end select
	'===END DECISION TREE====================================
		debug("class.form.valueFill:  '" & id & "' => '" & Server.HtmlEncode("" & valueFill) & "'")
	end function



	'========================================
	'       FORM SUBMISSION FUNCTIONS
	'========================================
	'returns true if this form was submitted
	public function wasSubmitted()
		'check to see if form directly posted
		dim submitted

		trace("class.form.wasSubmitted: this.form.name = '" & m_Name & "'")
		trace("class.form.wasSubmitted: m_Request.Form.name ='" & m_Request.Form("form_name") & "'")
		'trace("class.form.wasSubmitted: Request.Form.name ='" & Request.Form("form_name") & "'")
		if m_Name = "" then
			debugWarning("class.form.wasSubmitted:  there was no form name specified, its generally a better idea to use setName() before any other form manipulations!")
			'if no form was specified then just check the server variables
			if not isSubmissionChecked then debugInfo("class.form.wasSubmitted: form was submitted by " & Request.ServerVariables("REQUEST_METHOD") & " method and contains " & m_Request.Form.count & " fields.")
			submitted = m_Request.Form.count > 0 and Request.ServerVariables("REQUEST_METHOD")="POST"
		elseif m_Request.Form("form_name") = m_Name then
			'if a form was specified then check to see if it was submitted on post
			if (not isSubmissionChecked) then
				debugInfo("class.form.wasSubmitted: '" & m_Name & "' was submitted by " & Request.ServerVariables("REQUEST_METHOD") & " method and contains " & m_Request.Form.count & " fields.")
			end if
			submitted = (m_Request.Form("form_name") = m_Name)
		else
			trace("class.form.wasSubmitted:  form " & m_Name & " has not yet been submitted.")
		end if
		isSubmissionChecked = true
		wasSubmitted = submitted
	end function

	public function storeFormToSession()
		debug("class.form.storeFormToSession: storing form submission to session")
		if m_dictErrors.Count <> 0 then
			debugError("class.form.storeFormToSession: errors were found in the user's sumbission.")
		end if
		dim fld
		if isNull(m_Name) or m_Name = "" then
			m_Name = m_Request.Form("form_name")
			debug("class.form.storeForemToSession:  no form name was specified. using name '" & m_Name & "' found on the request object!")
		end if
		for each fld in m_Request.Form
			trace("class.form.storeFormToSession: storing " & fld & " to session with value '" & m_Request.Form(fld) & "'")
			session(m_Name & ":" & fld) = encrypt(m_Request.Form(fld))
		next
	end function

	private function wasStoredToSession(strName)
		strName = formatName(strName)
		'check to see if form was stored in session variables
		dim sessionSaved : sessionSaved = FALSE
		if session("form_name") = strName then
		'see if specified form name was used to send data to this form using Session variables
			if (not isSessionChecked) then
				debugInfo("class.form.wasStoredToSession: form '" & strName & "' was redirected from " & Request.ServerVariables("HTTP_REFERER") & " and form fields are stored as Session variables")
			end if
			sessionSaved = true
		end if
		isSessionChecked = true
		wasStoredToSession = sessionSaved
	end function

	private function clearFormFromSession(strName)
		strName = formatName(strName)
		if isNull(strName) Or strName = "" then
			debugError("form.class.clearFormFromSession: you must specify a form name to remove from the session")
		else
			dim key, id
			dim keys() : redim keys(Session.Contents.Count)
			dim i : i = 0
			for each key in Session.Contents
				keys(i) = key
				i = i+1
			next
			debug("form.class.clearFormFromSession: removing session keys for form '" & strName & "'....")
			for i=0 to ubound(keys)-1
				if instr(keys(i),":") > 0 then
					if split(keys(i),":")(0) = strName then
						trace("form.class.clearFormFromSession: removing " & keys(i) & " from session")
						Session.Contents.Remove(keys(i))
					end if
				else
					trace("form.class.clearFormFromSession: leaving " & keys(i))
				end if

			next
			for each key in Session.Contents
				trace("form.class.clearFormFromSession: " & key & " is still here.")
			next
		end if
		clearFormFromSession = True
	end function

	' Summary:         Upload a file (specified by the form item id) to the server at
	'                  the specified path (see UploadPath property). If no location is
	'                  specified, the default UploadPath property is used. You may
	'                  specify a string of the file format(s) that is/are permitted
	'                  for uploading as comma-separated string of MIME type(s). You may
	'                  also specify a max file size in bytes. If the upload reaches this
	'                  maximum the transfer is canceled.
	' Returns:
	'                  Returns the virtual path to the file if there is a file to upload,
	'                  otherwise returns an empty string if there was nothing to upload.
	public function fileUp(id, path, fileFormats, fileSizeLimit)
		fileUp = ""
		if id = "" or isNull(id) then
			debugError("form.class.fileUp: no form field id was specified!")
			exit function
		end if

		err.clear
		on error resume next
		if m_Request.Form(id).isEmpty then
			debug("form.class.fileUp: no file in form field '" & id & "' to upload.")
			if err.number <> 0 then
				'addFormError "" & id, "Important Note! File Upload is not enabled therefore field with id '" & id & "' and value '" & lcase(trim(m_Request.Form(id))) & "' will not be uploaded."
				debugError("form.class.fileUp: Important Note! File Upload is not enabled therefore field with id '" & id & "' and value '" & lcase(trim(m_Request.Form(id))) & "' will not be uploaded.")
				err.clear
				exit function
			end if
		exit function
		end if


		debug("form.class.fileUp: uploading file in form field '" & id & "' ...")
		'define upload file size limit
		dim maxBytes : maxBytes = 1024 * 20  ' 20 kilobytes upload limit.
		if not isNull(fileSizeLimit) then
			if CLng(fileSizeLimit) > 0 then
				maxBytes = fileSizeLimit
			else
				debugError("form.class.fileUp:  fileSizeLimit must be a valid long integer")
			end if
			if err.number <> 0 then
				debugError("form.class.fileUp:  fileSizeLimit '" & fileSizeLimit & "' is not a valid Long")
				err.clear
			end if
		end if

		'setup valid file formats
		dim x
		dim contentFormatArray : contentFormatArray = split(fileFormats,",")
		dim contentFormat : set contentFormat = CreateObject("Scripting.Dictionary")
		for each x in contentFormatArray
			contentFormat.add lcase(trim(x)), ""
		next

		'validate path
		if path = "" or isNull(path) then
			trace("form.class.fileUp: no path specified; default UploadPath applied: " & m_UploadPath)
		else
			UploadPath = path
		end if

		if not contentFormat.exists(lcase(trim(m_Request.Form(id).ContentType))) then
			addFormError "" & id, "Files of type " & lcase(trim(m_Request.Form(id).ContentType)) & " are not allowed for upload."
			exit function
		end if

		m_Request.MaxBytesToCancel = maxBytes
		if err.number <> 0 then
			debugError("form.class.fileUp:  error produced during attempt to set maxbytes to '" & maxBytes & "'")
			err.clear
		end if
		if m_Request.Form(id).TotalBytes > maxBytes then
			addFormError "" & id, "The file exceeds the maximum upload limit.  Please upload files of no more than " & maxBytes & " bytes in size (" & maxBytes/1024 & " kilobytes)."
		end if

		if not m_Request.Form(id).IsEmpty then
			debugInfo(" saving file... '" & globals("SITE_PATH") & m_UploadPath & m_Request.Form(id).ShortFilename & "'")
			m_Request.Form(id).SaveAs ( globals("SITE_PATH") & m_UploadPath & m_Request.Form(id).ShortFilename)
			if err.number <> 0 then
				addFormError "" & id, "" & err.description
			end if
			trace("form.class.fileUp: saving file '" & m_Request.Form(id).ShortFilename & "' to " & m_Request.Path)
			fileUp = m_UploadPath & m_Request.Form(id).ShortFilename
			if err.number <> 0 then
				debugError("form.class.fileUp:  error produced during attempt to test ShortFilename property")
				err.clear
			end if
		end if
		if err.number <> 0 then
			debugError("form.class.fileUp:  error produced during attempt to test IsEmpty property")
			err.clear
		end if

		if err.number <> 0 then
			debugError("form.class.fileUp:  error produced during attempt to upload a file from form field '" & id & "'")
			err.clear
		end if

		erase contentFormatArray
		set contentFormat = nothing
		debug("form.class.fileUp: file uploaded successfully to '" & m_Request.Form(id).Path & "'")

	end function

end class

	function getFolderListOptions(byref theForm, byval currentFolder,byval selectedFolder,byval optionId)
		debug("")
		debug("")
		debug("")
		debug("")
		debug("form.getFolderListOption('" & currentFolder & "','" & selectedFolder & "')")
		theForm.addFormOption optionId, currentFolder, currentFolder, iif(lcase(currentFolder) = lcase(selectedFolder),SELECTED,"")
		on error resume next
		dim galFolder : set galFolder = fs.getFolder( globals("SITE_PATH") & currentFolder )
		dim subFolders: set subFolders = galFolder.SubFolders
		dim folder
		for each folder in subFolders
			if left(folder.name,1) <> "_" and left(folder.name,1) <> "." then
				debug("getting sub folder list for " & currentFolder & "/" & folder.name)				'myForm.addFormOption "mod_gallery_folder", currentFolder & "/" & folder.name, currentFolder & "/" & folder.name, strSelected
				getFolderListOptions theForm,currentFolder & "/" & folder.name,selectedFolder,optionId
			end if
		next
		trapError
		set galFolder = nothing
		set subFolders = nothing
	end function
%>
