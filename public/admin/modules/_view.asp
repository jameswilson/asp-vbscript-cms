<%

function contentView()
dim rs,i,result
myForm.isForNewContent = false

strHeader.add "View Current Modules"
set rs = db.getRecordSet("SELECT * FROM tblModules INNER JOIN tblModuleTypes ON tblModules.Type=tblModuleTypes.ModID ORDER BY Location, SortOrder;")
dim rs2 : set rs2 =db.getRecordSet("SELECT * FROM tblPages ORDER BY Active, MainMenu, MenuIndex, ParentPage;")

'dim nCount : nCount = db.BuildList(rs, "SELECT * FROM tblModules INNER JOIN tblModuleTypes ON tblModules.Type=tblModuleTypes.ModID", "ORDER BY Location, SortOrder;")
'debug("admin.modules.view: the count returned is "&nCount)
if rs.state = 0 then 
	pageContent.add "" & vbcrlf _
	 &WarningMessage("Modules have not been setup in the database. "_
	 &"To be able to use the dynamic modules on your site, you must <a "_
	 &"href="""&objLinks.item("ADMINURL")&"/db/install.asp?name=tblModules&path=/core/src/install/create_tblModules.ddl"">install this module</a>.")&vbcrlf
elseif rs.RecordCount = 0 then
	pageContent.add "" & vbcrlf _
	 &WarningMessage("There are currently no pages with custom  " _
	 &"content stored in the database. Would you like to "_
	 &"<a href='?create'>add a module</a>?")& vbcrlf
else
	'writeln("There are currently "&rs.RecordCount& " modules installed on your site.")
	pageContent.add "" & vbcrlf _
	 &"<form id='list' action='?edit' method='post'>" & vbcrlf _
	 &"<table id='pages' class='list sortable' width='100%' border='0' cellspacing='0' cellpadding='3'>" & vbcrlf _
	 &"<thead>" & vbcrlf _
	 &"<tr>" & vbcrlf _
	 &"<th width='15px' class='checkbox'>Active</th>" & vbcrlf _
	 &"<th>Type</th>" & vbcrlf _
	 &"<th>Module</th>" & vbcrlf _
	 &"<th>Description</th>" & vbcrlf _
	 &"<th>Location</th>" & vbcrlf _
		&"<th width='5%' class='sorttable_nosort' colspan=3>Actions</th>" & vbcrlf _
		&"</tr>" & vbcrlf _
		&"</thead>" & vbcrlf _
	 &"" & vbcrlf _
	 &"" & vbcrlf
	dim strActive, strEven 
	for i=0 to rs.RecordCount-1
		strEven = ""
		strActive = "no"
		if (i MOD 2 = 0) then strEven = " even"
		if rs("Active") then strActive = "yes"
		pageContent.add "" & vbcrlf _
		 &"<tr class='"&strActive&strEven&"'>" & vbcrlf _
		 &"<td class='"&strActive&"'><span>"&strActive&"</span></td>" & vbcrlf _
		 &"<td>"&rs("ModName") &"</td>" & vbcrlf _
		 &"<td><a href='?edit="&rs("ID")&"' title='Edit "&rs(strIdField)&"'>"&rs(strIdField) &"</a></td>" & vbcrlf _
		 &"<td>"&rs("Description") &"</td>" & vbcrlf _
		 &"<td>"&rs("Location") &"</td>" & vbcrlf _
		 &"<td class='action edit'>"&anchor("?edit="&rs(strKey),"Edit","Edit this "&rs("ModName"),"edit action")&"</td>" & vbcrlf '<a class='edit action' href='?edit="&rs(strKey)&"' title='Edit this "&rs("ModName")&"'>Edit</a></td>" & vbcrlf _
		dim viewLink : viewLink = ""
		dim veiwPage : veiwPage = ""
		dim viewClass : viewClass = ""
		if rs2.state > 0 then 
			if not (rs2.EOF and rs2.BOF) then
				rs2.movefirst
				dim firstFound : firstFound = false
				if instr(rs("PageIDs"),":0:")> 0 then
					viewLink = objLinks("SITEURL")
					veiwPage = "Homepage"
					firstFound = true
				end if
				do until rs2.EOF or firstFound = true
					if instr(rs("PageIDs"),":"&rs2("PageId")&":")> 0 then
						viewLink = objLinks("SITEURL")&"/"&rs2("PageFileName")
						veiwPage = rs2("PageName")&" Page"
						firstFound = true
					end if
					rs2.movenext
				loop
				if firstFound = true then 
					viewClass = "action view"
					viewLink = anchor(viewLink,"View","View Module on "&veiwPage,"view action")
				end if
			end if
		end if
		pageContent.add "<td class='"&viewClass&"'>"&viewLink&"</td>" & vbcrlf
		pageContent.add "<td class='action delete'><a class='delete action' href='?delete="&rs(strKey)&"' title='Delete "&strContent&" "&rs(strIdField)&"' onclick=""return confirm('Really delete "&rs("ModName") &" "&strContent&" \'"&rs(strIdField)&"\'?')"">Delete</a></td>" & vbcrlf _
		 &"</tr>" & vbcrlf
		
		trapError
		rs.movenext
	next
	pageContent.add "</table>" & vbcrlf _
	 &"<div class='buttonbar'><ul><li><a class='new button' title='New Module' href='?create'>Add a module</a></li></ul></div>" & vbcrlf _
	 &"</form>" & vbcrlf _
	 &"" & vbcrlf _
	 &"<script type=""text/javascript"" src="""&objLinks("SITEURL")&"/core/assets/scripts/sorttable.js""></script>" & vbcrlf
	
end if
set result = nothing
end function
%>
