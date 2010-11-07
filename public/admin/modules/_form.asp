<!--#include file="../../core/src/classes/class.form.asp"-->
<%
const MODULE_LOCATIONS = "header,nav,main,local,sub,footer,extra1,extra2,extra3"
const MODULE_CUSTOM_FIELDS = "admin.asp"  'name of file (in module folder) where custom form fields are imported

function buildFormContents(id,modType)
dim rs, sd, modules, checked, selected, active, intSortOrder, location
intSortOrder = 0
active = ""
checked = ""
selected = ""

if len(id)> 0 then 
	debug("admin.mod.buildFormContents: id supplied was "&id)
	set modules = new SiteModules
	set sd = modules.getModuleById(id)
else
	debug("admin.mod.buildFormContents:  no id was supplied ")
	set sd = Server.CreateObject("Scripting.Dictionary")
	sd.add "Active",""&true
	sd.add "Location","main"
end if

if len(modType) > 0 then 
	set modules = new SiteModules
	set sd = modules.getModuleByType(modType)
	sd.add "Type", ""&modType
	dim mods : set mods = modules.getActiveModules()
	debug("Modhandler is " &mods.item(""&modType))
	
	sd.add "ModHandler", mods(""&modType)
	sd.add "Active",""&true
	sd.add "Location","main"
end if
if len(sd("ModName"))>0 then strHeader.add sd("ModName")&" Module"


with myForm
'.CreateNew formName, action
if not (myForm.isForNewContent = true) then .addFormInput  "", "", "ID",  "hidden", "", sd("ID"), "",""

.addFormInput  "", "", "Type",  "hidden", "", sd("Type"), "",""
.addFieldset "Module Info",""
.startNoteSection()
.addNote sd("ModName")&" Module",sd("ModDescription")
.endNoteSection()
.addFormInput  "required", "Module Name", "Name",  "text", "", sd("Name"), " maxsize=""50""",""
.addFormInput  "optional", "Description", "Description",  "textarea", "simple", sd("Description"), DBTEXT,""
if ""&sd("Active") = ""&true then checked = "checked"
.addFormInput  "optional", "This module is active?", "Active", "checkbox", "", "1",  checked, ""

'process and insert modules custom settings
dim moduleHandler : moduleHandler = MODULE_FOLDER& sd("ModHandler")&"/"&MODULE_CUSTOM_FIELDS
dim custModuleResults : custModuleResults = executeFile(moduleHandler, getVariableDefinitionScript(sd))
debug("admin.mod.buildFormContents: file execution returned: "&custModuleResults)
.addFormSubmission "left","Submit &raquo;","","",""
.endFieldset 

.addFieldset "Module Location",""
.addFormSelect "required", "Location", "Location","selectOne",""
for each location in split(MODULE_LOCATIONS,",")
	selected = ""
	debug("module location is '"&sd("Location")&"'")
	if lcase(trim(location)) = lcase(trim(sd("Location"))) then selected = "selected"
	.addFormOption "Location", lcase(trim(location)), lcase(trim(location)), selected
next
.endFormSelect("Select the location on the page to display the content. These names refer to the available layout divs for your site.")

if .isForNewContent then 
	set rs = db.getRecordSet("SELECT Max(SortOrder) AS SortOrder FROM tblModules WHERE Location='main'")
	intSortOrder = rs("SortOrder") + 1
else
	intSortOrder = sd("SortOrder")
end if
.addFormInput "optional", "Sort Order", "SortOrder",  "text", "", intSortOrder, DBTEXT,"If the page has multiple modules in the same layout div, then this order will determin which is to be displayed first."


.addFormSelect "required", "Page(s)", "PageIDs","selectMany"," size=""10"""
if instr(sd("PageIDs"),":0:")> 0 then selected = "selected"
.addFormOption "PageIDs", ":0:", "All",selected
set rs = db.getRecordSet("SELECT * FROM tblPages ORDER BY Active, MainMenu, MenuIndex, ParentPage;")
if not (rs.EOF and rs.BOF) then
	rs.movefirst
	do until rs.EOF
		selected = ""
		active = " [Inactive]"
		if (rs("Active")) then active = " [Active]"
		if instr(sd("PageIDs"),":"&rs("PageId")&":")> 0 then selected = "selected"
		.addFormOption "PageIDs", ":"&rs("PageId")&":", rs("PageName")&active, selected
		rs.movenext
	loop
end if
.endFormSelect("Select the pages on the which to display this module.")

.addFormSubmission "left","Submit &raquo;","","",""
.endFieldset 

.addFieldset "Presentation",""
.addFormInput  "optional", "Module ID", "StyleID",  "text", "", sd("StyleID"), " maxsize=""50""","A unique identifier for this module, that may be user for custom css styling on the wrapper div."
.addFormInput  "optional", "Custom Class", "StyleClass",  "text", "", sd("StyleClass"), " maxsize=""50""","You may provide a space-separated list of classes to be applied to the class attribute of the module's wrapper div for custom css styling."
.addFormInput  "optional", "Inline CSS", "StyleInline",  "textarea", "simple", sd("StyleInline"), DBMEMO&" rows=""10""","You may provide custom valid css to be applied inline to the style attribute of the module's containing div."
.addFormSubmission "left","Submit &raquo;","","",""
.endFieldset 



	buildFormContents = .getContents()
end with
end function


function executeFile(byval virtualPathToModule,byval pretext)
	const forReading = 1 
	executeFile = false
	dim f : set f = new SiteFile
	f.Path = virtualPathToModule
	if f.fileExists() then
		debug("admin.mod.executeFile: file absolute path is "&f.absolutePath)
		dim ts : set ts = fs.openTextFile(f.absolutePath, forReading)
		dim content : content = pretext & vbcrlf & replace(replace(ts.readAll,"<"&"%",""),"%"&">","")
		debug("admin.mod.executeFile: file contents are: "&codeblock(content))
		err.clear
		on error resume next
		Execute(content)

		if err.number <> 0 then 
			debugError("there was an error executing "&codeblock(content))
			trapError
		else 
			executeFile = true		
		end if 
		
	end if
end function

function getVariableDefinitionScript(sd)
	dim key, result
	
	for each key in sd.keys
	'had to add the prefix m_ to all the variable generated here due to the fact that 
	'this will break at runtime if the field name in the db happens to be a reserved keyword!
		result = result & "dim m_"&key&" : m_"&key&" = """&replace(replace(replace(replace(sd(key),"""",""""""),vbcrlf,"""& vbcrlf &"""),vbcr,"""& vbcr &"""),vblf,"""& vblf &""")&""" : debug(""m_"&key&" is '""&server.HTMLEncode(m_"&key&")&""'"")" & vbcrlf
	next
	getVariableDefinitionScript = result
end function 
%>