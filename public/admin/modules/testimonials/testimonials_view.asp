<%
function contentView()
	dim rs,a,i
	set a = New FastString
	page.setName("View "& pcase(strContentPL) &"")
	dim nCount : nCount = db.BuildList(rs, strTableName, "ORDER BY Active ASC, "& strIdField)
	dim rs2 : set rs2 =db.getRecordSet("SELECT * FROM tblModules INNER JOIN tblModuleTypes ON tblModuleTypes.ModID=tblModules.Type WHERE tblModuleTypes.ModHandler='mod_testimonials' ORDER BY Active ASC, "& strIdField)
	
	if not (rs2.state > 0) then 
		a.add WarningMessage("The "& strContentPL &" module has not been setup correctly for this domain. "& globals("ERROR_FEEDBACK")) & vbCrLf
	end if
	
	debug("the count returned is "& nCount)
	if nCount = -1 then
		a.add "<div class=""warning"">The "& strContentPL &" module is not installed."& vbCrLf
		a.add "<a class=""install button"" href="""& globals("ADMINURL") &"/db/install.asp?name="& strTableName &"& path=/core/src/install/create_"& strTableName &".ddl"">Install this module</a>?</div>"& vbCrLf
	elseif nCount = 0 then  
		a.add "<div class=""warning"">There are currently no "& strContentPL &" stored for your site. "& vbCrLf
		a.add "<a class=""install button"" href=""?create"">Create the first "& strContent &"</a></div>"
	else
		a.add "<form id='list' action='?edit' method='post'>" & vbCrLf
		a.add "<table id='pages' class='list sortable' width='100%' border='0' cellspacing='0' cellpadding='3'>" & vbCrLf
		a.add "<thead>" & vbCrLf
		a.add "<tr>" & vbCrLf
		a.add "<th width='15px' class='checkbox'>Active</th>" & vbCrLf
		a.add "<th>Cust. Name</th>" & vbCrLf
		a.add "<th>Cust. Email</th>" & vbCrLf
		a.add "<th width='15px' class='checkbox'><abbr title=""Is email public?"">Email</abbr></th>" & vbCrLf
		a.add "<th>"& Pcase(strContent) &"</th>" & vbCrLf
		a.add "<th width='5%' class='sorttable_nosort' colspan=3>Actions</th>" & vbCrLf
		a.add "</tr>" & vbCrLf
		a.add "</thead>" & vbCrLf
		a.add "" & vbCrLf
		a.add "" & vbCrLf
		a.add "" & vbCrLf
		for i=0 to nCount-1
			strEven = ""
			strActive = "no"
			strShowEmail = strActive
			if (i MOD 2 = 0) then strEven = " even"
			if rs(i)("Active") then strActive = "yes"
			if rs(i)("ShowEmail") then strShowEmail = "yes"
			a.add "<tr class='"& strActive &strEven&"'>" & vbCrLf
			a.add "<td class='checkbox "& strActive &"'><span>"& strActive &"</span></td>" & vbCrLf
			a.add "<td><a href='?edit="& rs(i)(strKey) &"' title='Edit "& strContent &" by "& rs(i)(strIdField) &"'>"& rs(i)(strIdField) &"</a></td>" & vbCrLf
			a.add "<td>"& rs(i)("Email") &"</td>" & vbCrLf
			a.add "<td class='checkbox "& strShowEmail &"'><span>"& strShowEmail &"</span></td>" & vbCrLf
			a.add "<td>"& Left(rs(i)("Comments"),80) &"...</td>" & vbCrLf
			a.add "<td width='15px' class='action edit'><a class='edit action' href='?edit="& rs(i)(strKey) &"' title='Edit "& strContent &" by "& rs(i)(strIdField) &"'>Edit</a></td>" & vbCrLf
			a.add "<td width='15px' class='action view'><a class='view action' href='"& globals("SITEURL") &"/testimonials.asp#comment"& rs(i)(strKey) &"' title='View "& strContentPL &" page on public site (opens in a new window)' target='_blank'>View</a></td>" & vbCrLf
			a.add "<td width='15px' class='action delete'><a class='delete action' href=""?delete="& rs(i)(strKey) &""" title=""Delete "& strContent &" by "& rs(i)(strIdField) &""" onclick=""return confirm('Really delete "& strContent &" by "& rs(i)(strIdField) &"?')"">Delete</a></td>" & vbCrLf
			a.add "</tr>" & vbCrLf
			trapError
		next
		a.add "</table>" & vbCrLf
		a.add "<div class='buttonbar clearfix'><ul><li><a class='new button' title='New Page' href='?create'>Create a new "& strContent &"</a></li></ul></div>" & vbCrLf
		a.add "</form>" & vbCrLf
		a.add "" & vbCrLf
		a.add "<script type=""text/javascript"" src="""& globals("SITEURL") &"/core/assets/scripts/sorttable.js""></script>" & vbCrLf
	end if
	contentView = a.value
end function
%>