<%


function contentCreate()
	const heading = "Add A Module"
	const instructions = "Please select the type of module you wish to add..."

	myForm.isForNewContent = true
	myForm.Name = "SelectAModuleType"
	myForm.Action = "?add"
	myForm.Method = "POST"

	dim rs : set rs = db.getRecordSet("SELECT * FROM tblModuleTypes WHERE tblModuleTypes.Disabled=false ORDER BY tblModuleTypes.ModName;")
	if rs.state = 0 then
		strError = "No modules appear to be installed on your system." & globals("ERROR_FEEDBACK")
		set result = nothing
		exit function
	end if
	if (rs.EOF and rs.BOF) then
		strError = "No modules appear to be installed on your system." & globals("ERROR_FEEDBACK")
		set result = nothing
		exit function
	end if
	dim modName, modID, modExists
	if len(myForm.getValue("create")) > 0 then
		debug( "got a form value of :" & myForm.getValue("create"))
		modName = myForm.getValue("type")
	elseif len(Request.QueryString("create")) > 0 then
		debug( "got a querystring value of :" & Request.QueryString("create"))
		modName = Request.QueryString("create")
	end if
	if len(modName) > 0 then
		strHeader.add anchor("?create", heading, "", "")
		strHeader.add connector
		strHeader.add modName & " Module"

		rs.movefirst
		do until rs.EOF
			if rs("ModName") = modName then
				modExists = true
				modID = rs("ModID")
			end if
			rs.movenext
		loop
		if not modExists = true then
			pageContent.clear
			strWarn = "That is not a valid module type!" & p(instructions)
			selectAModule(rs)
			exit function
		end if
		myForm.name = "ModuleCreator"
		pageContent.add buildFormContents("", modID)
		exit function
	else
		strHeader.add heading
		pageContent.add p(instructions)
		selectAModule(rs)
		exit function
	end if
end function


function selectAModule(byref rs)
	pageContent.add "<style type=""text/css"">" & vbCrLf
	pageContent.add "<!--" & vbCrLf
	pageContent.add "div.mdl {position:relative;padding-top:5em;}" & vbCrLf
	pageContent.add ".mdl dt { width:6em;margin:0;padding:0;text-align:center;}" & vbCrLf
	pageContent.add ".mdl dl { float:left;}" & vbCrLf
	pageContent.add ".mdl dt { border:1px solid white;background:transparent;margin:0;padding:1em 0.2em;}" & vbCrLf
	pageContent.add "dt:hover, dt.sfhover { border:1px solid gray;background:#EFF4F8;}" & vbCrLf
	pageContent.add ".mdl a{ display:block;text-align:center;margin:0 auto; }" & vbCrLf
	pageContent.add ".mdl img{ display:block;margin:0 auto; }" & vbCrLf
	pageContent.add ".mdl dd { display:none;position:absolute;top:0;left:0;margin:0 1em;height:3.2em;width:35em;text-align:left;background-position:0.9em 0.9em;}" & vbCrLf
	pageContent.add ".mdl dl:hover dd, .mdl dl.sfhover dd {display:block;}" & vbCrLf
	pageContent.add "-->" & vbCrLf
	pageContent.add "</style>" & vbCrLf
	pageContent.add "<div class=""mdl clearfix"">" & vbCrLf

	dim modName, id, val, desc, link, icon, hover
	rs.movefirst
	do until rs.EOF
		modName = rs("ModName")
		id = rs("ModID")
		val = Server.UrlEncode(modName)
		hover = "Add a " & modName & " module"
		icon = img(globals("SITEURL") & "/modules/" & rs("ModHandler") & "/icon.png", modName & " icon", hover, "mod-icon")
		desc = rs("ModDescription")
		link = a("?create&type=" & val,modName,desc,"")
		pageContent.add createTag("dl", " class=""clearfix""", (dt(a("?create=" & val, icon & modName, hover, "")) & createTag("dd", " class=""info""", desc))) & vbCrLf
		rs.movenext
	loop

	pageContent.add "</div>"
end function
%>
