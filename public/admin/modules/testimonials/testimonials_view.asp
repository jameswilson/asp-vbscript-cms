<%
function contentView()
	dim rs,a,i
	set a = New FastString
	page.setName("View "&pcase(strContentPL)&"")
	dim nCount : nCount = db.BuildList(rs, strTableName, "ORDER BY Active ASC, "&strIdField)
	dim rs2 : set rs2 =db.getRecordSet("SELECT * FROM tblModules INNER JOIN tblModuleTypes ON tblModuleTypes.ModID=tblModules.Type WHERE tblModuleTypes.ModHandler='mod_testimonials' ORDER BY Active ASC, "&strIdField)
	
	if not (rs2.state > 0) then 
		a.add WarningMessage("The "&strContentPL&" module has not been setup correctly for this domain. "&objLinks("ERROR_FEEDBACK"))& vbcrlf
	end if
	
	debug("the count returned is "&nCount)
	if nCount = -1 then
		a.add "<div class=""warning"">The "&strContentPL&" module is not installed."&vbcrlf
		a.add "<a class=""install button"" href="""&objLinks.item("ADMINURL")&"/db/install.asp?name="&strTableName&"&path=/core/src/install/create_"&strTableName&".ddl"">Install this module</a>?</div>"&vbcrlf
	elseif nCount = 0 then  
		a.add "<div class=""warning"">There are currently no "&strContentPL&" stored for your site. "& vbcrlf
		a.add "<a class=""install button"" href=""?create"">Create the first "&strContent&"</a></div>"
	else
		a.add "<form id='list' action='?edit' method='post'>" & vbcrlf
		a.add "<table id='pages' class='list sortable' width='100%' border='0' cellspacing='0' cellpadding='3'>" & vbcrlf
		a.add "<thead>" & vbcrlf
		a.add "<tr>" & vbcrlf
		a.add "<th width='15px' class='checkbox'>Active</th>" & vbcrlf
		a.add "<th>Cust. Name</th>" & vbcrlf
		a.add "<th>Cust. Email</th>" & vbcrlf
		a.add "<th width='15px' class='checkbox'><abbr title=""Is email public?"">Email</abbr></th>" & vbcrlf
		a.add "<th>"&Pcase(strContent)&"</th>" & vbcrlf
		a.add "<th width='5%' class='sorttable_nosort' colspan=3>Actions</th>" & vbcrlf
		a.add "</tr>" & vbcrlf
		a.add "</thead>" & vbcrlf
		a.add "" & vbcrlf
		a.add "" & vbcrlf
		a.add "" & vbcrlf
		for i=0 to nCount-1
			strEven = ""
			strActive = "no"
			strShowEmail = strActive
			if (i MOD 2 = 0) then strEven = " even"
			if rs(i)("Active") then strActive = "yes"
			if rs(i)("ShowEmail") then strShowEmail = "yes"
			a.add "<tr class='"&strActive&strEven&"'>" & vbcrlf
			a.add "<td class='checkbox "&strActive&"'><span>"&strActive&"</span></td>" & vbcrlf
			a.add "<td><a href='?edit="&rs(i)(strKey)&"' title='Edit "&strContent&" by "&rs(i)(strIdField)&"'>"&rs(i)(strIdField) &"</a></td>" & vbcrlf
			a.add "<td>"&rs(i)("Email") &"</td>" & vbcrlf
			a.add "<td class='checkbox "&strShowEmail&"'><span>"&strShowEmail&"</span></td>" & vbcrlf
			a.add "<td>"&Left(rs(i)("Comments"),80)&"...</td>" & vbcrlf
			a.add "<td width='15px' class='action edit'><a class='edit action' href='?edit="&rs(i)(strKey)&"' title='Edit "&strContent&" by "&rs(i)(strIdField)&"'>Edit</a></td>" & vbcrlf
			a.add "<td width='15px' class='action view'><a class='view action' href='"&objLinks.item("SITEURL")&"/testimonials.asp#comment"&rs(i)(strKey)&"' title='View "&strContentPL&" page on public site (opens in a new window)' target='_blank'>View</a></td>" & vbcrlf
			a.add "<td width='15px' class='action delete'><a class='delete action' href=""?delete="&rs(i)(strKey)&""" title=""Delete "&strContent&" by "&rs(i)(strIdField)&""" onclick=""return confirm('Really delete "&strContent&" by "&rs(i)(strIdField)&"?')"">Delete</a></td>" & vbcrlf
			a.add "</tr>" & vbcrlf
			trapError
		next
		a.add "</table>" & vbcrlf
		a.add "<div class='buttonbar clearfix'><ul><li><a class='new button' title='New Page' href='?create'>Create a new "&strContent&"</a></li></ul></div>" & vbcrlf
		a.add "</form>" & vbcrlf
		a.add "" & vbcrlf
		a.add "<script type=""text/javascript"" src="""&objLinks("SITEURL")&"/core/assets/scripts/sorttable.js""></script>" & vbcrlf
	end if
	contentView = a.value
end function
%>