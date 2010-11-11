<%
const MODULE_FOLDER = "/modules/" 'include leading & trailing slashes
const CUSTOMSETTINGS_RECORD_DELIMITER = "}" 
const CUSTOMSETTINGS_FIELD_DELIMITER = "{" 

class SiteModules

	private myModulesDict
	private rsPageModules
	private rsSiteModules
	private m_modCount
	'============================
	'    INITIALIZATION CODE
	'============================

	'called at creation of instance
	private sub class_Initialize()
		set rsPageModules = nothing
		set rsSiteModules = db.getRecordSet("SELECT * FROM tblModuleTypes")
		set myModulesDict = nothing
		m_modCount = 0
	end sub
	
	'called when object instance is set to nothing
	private sub class_Terminate()
		'set myModulesDict = nothing
		set rsSiteModules = nothing
	end sub

	' returns a dictionary of modules indexed by number, 
	' the content is the path to the module
	private function initModulesDictionary()
		dim rs, sd, key, val, counter, i, sql
		set sd = Server.CreateObject("Scripting.Dictionary")
		on error resume next
		sql="SELECT * "_
			 &"FROM tblModuleTypes "_
			 &"WHERE Disabled=False "_
			 &"ORDER BY ModID;"

		set rs = db.getRecordSet(sql)
		trace("class.modules.init(): initializing module registry...")
		if rs.state > 0 then 
			if rs.EOF and rs.BOF then
				debugWarning("class.modules.init(): There are no modules registered in the system.")
			else
				do while not rs.EOF
					if not sd.exists(cstr(rs("ModID"))) then 
						trace("class.modules.init(): registering module ["& rs("ModID") &"]: '"& rs("ModName") &"' at location "& rs("ModHandler"))
						sd.add ""&rs("ModID"), ""&rs("ModHandler")
					else
						debugError("class.modules.init(): The key "& rs("ModID") &" already exists.")
					end if
					rs.movenext
				loop
			end if
		else
			debugError("class.modules.init(): the database encountered an error retrieving module types")
		end if
		if err.number <> 0 then 
			debugError("class.modules.init: "& err.number &" - "& err.description)
			err.clear
		end if
		trace("class.modules.init(): initialization complete.")
		set initModulesDictionary = sd
	end function
	
	public property get Count
		Count = m_modCount
	end property
	
	
	' return true if the specified module handle is active for this site
	public function isActive(strModule)
		isActive = false
		if rsSiteModules.state > 0 then
			if rsSiteModules.EOF and rsSiteModules.BOF then exit function
			rsSiteModules.movefirst
			do until rsSiteModules.EOF
				if rsSiteModules("ModHandler") = strModule then
					isActive = not rsSiteModules("Disabled")
					exit function
				end if
				rsSiteModules.movenext
			loop
		end if
			
	end function
	
	'return the path to the module code for execution 
	public function getModAddress(itemId)
		dim result : result = ""
		if len(itemId) > 0 then 
			if myModulesDict.exists(cstr(itemId)) then 
				result = myModulesDict.item(cstr(itemId))
			else
				debug("class.modules.getItem: no item exists for the id specified '"& itemId &"'")
			end if
		end if
		getModAddress = result
	end function
	
	'returns a dictionary of modules enabled for this site.
	public function getActiveModules()
		if myModulesDict is nothing then 
			set myModulesDict = initModulesDictionary
		end if
		set getActiveModules = myModulesDict
	end function
	
	'**
	'* returns a dictionary of the specified module type
	'*
	public function getModuleByType(byval modType)
		dim rs, sd, key, val, counter, i, sql
		if isNull(modType) or modType = "" then
			debugError("class.modules.getModuleByType: cannot execute getModuleByType('"& modType &"'). The provided module type must be non-null.")
			exit function
		end if
		set rs = db.getRecordSet("SELECT * FROM tblModuleTypes WHERE ModID = '"& modType &"'")
		set sd = server.CreateObject("Scripting.Dictionary")
		if rs.state > 0 then 
		counter = rs.fields.count	
			rs.movefirst
			do until rs.EOF
				trace("class.module.getModuleByType: the following database content found for module with type id '"& id &"':")				
				for i = 0 to counter - 1
					key = cstr(rs.fields.item(i).name)
					val = cstr(rs(i))
					trace("[ "& key &" -&gt; "& Server.HTMLEncode(val) &" ]")
					if not sd.exists(key) then
						sd.add key, val
						if key = "CustomSettings" then 
							CreateDictionary sd, val, CUSTOMSETTINGS_RECORD_DELIMITER, CUSTOMSETTINGS_FIELD_DELIMITER, adDictOverwrite
						end if
					else
						debugWarning("class.module.getModuleByType: id '"& id &"' is not unique!")
						debugError("class.module.getModuleByType: expected a single record but found that the recordset has multiple when field '"& rs.fields.item(i).name &"' returned a second value.")
					end if
				next
				rs.movenext
			loop
		end if
		set getModuleByType = sd
	end function
	
	'**
	'* set this Modules object to represent the modules enabled for the specified page.
	'* @return true if the specified page has any modules to display
	'*
	public function setPage(strPageId)
		debug("class.modules.setPage: '"& strPageId &"'")
		setPage = false
		dim sql : sql = "SELECT * "_
			&"FROM tblModules "_
			&"LEFT JOIN tblModuleTypes ON tblModules.Type=tblModuleTypes.ModID "_
			&"WHERE (((tblModules.PageIDs Like '%:"& strPageId &":%') OR (tblModules.PageIDs Like '%:0:%')) AND (tblModules.Active=True) AND ((tblModuleTypes.Disabled)=False)) "_
			&"ORDER BY tblModules.Location, tblModules.SortOrder;"
		set rsPageModules = db.getRecordSet(sql)
		if rsPageModules.state > 0 then
			if rsPageModules.EOF or rsPageModules.BOF then
				debugInfo("class.modules.setPage: no active modules found for page with id '"&strPageId&"'")
				m_modCount = 0
			else 
				setPage = true
				do until rsPageModules.EOF
					trace("[ Module:"& rsPageModules("ModName") &", Location:'"& rsPageModules("Location") &"', CustomSettings:'"& Server.HTMLEncode(cstr(rsPageModules("CustomSettings"))) &"']")
					rsPageModules.moveNext
					m_modCount = m_modCount + 1
				loop
				rsPageModules.moveFirst
			end if
		else
			debugError("class.modules.setPage: modules table could not be queried [state: "& rsPageModules.state &"]")
		end if				
	end function
	
	
	'**
	'*
	'*
	public function display(strLocation)
		dim tracker : tracker = 0
		debug("class.modules.display('"& strLocation &"')...")
		if rsPageModules is nothing or isNull(rsPageModules) then 
			debugWarning("class.modules.display: cannot execute display('"& strLocation &"').  Please initialize the module class first by specifying a page name using the setPage() method.'")
		else
			if rsPageModules.state = 0 then
				debug("class.modules.display: no modules to display for '"& strLocation &"'. modules recordset state is 0.")
			else
				if rsPageModules.EOF and rsPageModules.BOF then
					debug("class.modules.display: no modules to display for '"& strLocation &"'. modules recordset is empty.")
				else 
					rsPageModules.moveFirst
					dim attrib : set attrib = new FastString
					dim sClass : set sClass = new FastString
					do until rsPageModules.EOF
						if rsPageModules("Location") = strLocation then
							attrib.clear
							debugInfo("class.modules.display('"& strLocation &"': executing "& rsPageModules("ModHandler"))
							if len(rsPageModules("StyleClass")) > 0 then sClass.add trim(rsPageModules("StyleClass"))
							if isLastRecord(rsPageModules) = true then sClass.add " last"
							if len(rsPageModules("StyleID")) > 0 then attrib.add " id="""& trim(rsPageModules("StyleID")) &""""
							if len(rsPageModules("StyleClass")) > 0 then attrib.add " class="""& trim(sClass.value)&""""
							if len(rsPageModules("StyleInline")) > 0 then attrib.add " style="""& trim(rsPageModules("StyleInline")) &""""
								
							writeln(vbCrLf &"<div"& attrib.value &"><div><div class=""wrapper"">"& vbCrLf)
							debug("class.modules.display('"& strLocation &"'): executing '"& rsPageModules("ModHandler") &"/display.asp' with custom settings '"& Server.HTMLEncode(""& rsPageModules("CustomSettings"))&"'")
							executeMod cstr(rsPageModules("ModHandler")) &"/display.asp", cstr(rsPageModules("CustomSettings"))
							writeln(vbCrLf &"</div></div></div>"& vbCrLf)
							tracker = tracker + 1
						end if
						rsPageModules.moveNext
					loop
				end if
			end if
		end if
		debug("class.modules.display('"& strLocation &"'):  "& tracker &" modules were processed.")
	end function

	'returns a dictionary of the module 
	public function getModuleById(id)
	dim rs, sd, key, val, counter, i, sql
		set sd = Server.CreateObject("Scripting.Dictionary")
		debug("class.module.getModuleById:  getting page data for id '"& id &"'...")
		if isNull(id) or id = "" then 
			debugWarning("class.module.getModuleById: non-null id required")
		else 
			sql = "SELECT * FROM tblModules INNER JOIN tblModuleTypes ON tblModules.Type=tblModuleTypes.ModID WHERE tblModules.ID="& id
			set rs = db.getRecordSet(sql)
			if rs.state > 0 then
				if rs.EOF and rs.BOF then
					debugError("class.module.getModuleById: no database content found for module with id '"& id &"'.")
					addError("There is no module for id '"& id &"'.<br/>" & _
					"Would you like to  <a href='?view'>go back to the list</a> "& _
					"or <a href='?create'>create a new one</a>?")
				else
					rs.movefirst
					counter = rs.fields.count		
					do until rs.EOF
						trace("class.module.getModuleById: the following database content found for module with id '"& id &"':")				
						for i = 0 to counter - 1
							key = cstr(rs.fields.item(i).name)
							val = cstr(rs(i))
							trace("[ "& key &" -&gt; "& Server.HTMLEncode(val) &" ]")
							if not sd.exists(key) then
								sd.add key, val
								if key = "CustomSettings" then 
									CreateDictionary sd, val, CUSTOMSETTINGS_RECORD_DELIMITER, CUSTOMSETTINGS_FIELD_DELIMITER, adDictOverwrite
								end if
							else
								debugWarning("class.module.getModuleById: id '"& id &"' is not unique!")
								debugError("class.module.getModuleById: expected a single record but found that the recordset has multiple when field '"& rs.fields.item(i).name &"' returned a second value.")
							end if
						next
						rs.movenext
					loop
					trapError
				end if
			end if
		end if
		set getModuleById = sd	
	end function
	
	private function isLastRecord(rs)
		rs.movenext
		isLastRecord = Cbool(rs.EOF)
		rs.moveprevious	
	end function

	public sub executeMod(strHandler, strCustomSettings)
		debug("class.modules.executeMod: executing module '"& strHandler &"'")
		Session("ModuleCustomSettings") = ""
		if isNull(strCustomSettings) or strCustomSettings = "" then 
			debug("class.modules.executeMod: no custom settings for this module")
		else
			debug("class.modules.executeMod: adding custom setting string to session '"& Server.HTMLEncode(strCustomSettings) &"'")
			Session("ModuleCustomSettings") = cstr(strCustomSettings)
		end if
		dim modFile : set modFile = new SiteFile
		modFile.Path = MODULE_FOLDER & strHandler
		debug("class.modules.executeMod:  executing '"& modFile.VirtualPath &"' ...")
		modFile.run()
		'session("ModuleCustomSettings") = ""			
	end sub

end class

%>
