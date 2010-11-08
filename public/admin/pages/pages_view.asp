<%
function contentView()
	dim rs,a,i
	'set a = New FastString
	page.setName("View "& PCase(strContentPL) &"")
	dim nCount : nCount = db.BuildList(rs, strTableName, "")
	debug("the count returned is "& nCount)
	if nCount = -1 then
		pageContent.add WarningMessage(""& PCase(strContent) &" data is currently not stored in the database.  To be able to use the dynamic content functionality to create, modify, and delete site content, you must <a href="""& globals("ADMINURL") &"/db/install.asp?name="& strTableName &"& path=/core/src/install/create_"& strTableName &".ddl"">install this module</a>.") & vbCrLf
	elseif nCount = 0 then  
		pageContent.add WarningMessage("There are currently no "& strContentPL &" with custom content stored in the database. Would you like to <a href='?create'>create the first "& strContent &"</a>?")
	else

		pageContent.add  "<form id='list' action='?edit' method='post'>" & vbCrLf _
		& "<table id='pages' class='list sortable' width='100%' border='0' cellspacing='0' cellpadding='3'>" & vbCrLf _
		& "<thead>" & vbCrLf _
		& "<tr>" & vbCrLf _
		& "<th width='15px' class='checkbox'>Active</th>" & vbCrLf _
		& "<th>"& PCase(strContent) &" Name</th>" & vbCrLf _
		& "<th>"& PCase(strContent) &" Title</th>" & vbCrLf _
		& "<th>"& PCase(strContent) &" URL</th>" & vbCrLf _
		& "<th width='15px' class='checkbox'>Menu</th>" & vbCrLf _
		& "<th width='5%' class='sorttable_nosort' colspan=3>Actions</th>" & vbCrLf _
		& "</tr>" & vbCrLf _
		& "</thead>" & vbCrLf _
		& "" & vbCrLf _
		& "" & vbCrLf
		dim strMenuSortKey, strId, strName
		for i=0 to nCount-1
			strEven = ""
			strActive = "no"
			strMainMenu = strActive
			strId = rs(i)(strKey)
			strName = rs(i)(strIdField)
			if (i MOD 2 = 0) then strEven = " even"
			if rs(i)("Active") then strActive = "yes"
			if rs(i)("MainMenu") then strMainMenu = "yes"
			strMenuSortKey = iif (rs(i)("ParentPage")="" or rs(i)("ParentPage")="0", rs(i)("PageId") &"-0", rs(i)("ParentPage")) & "-"
			strMenuSortKey = iif (rs(i)("MainMenu"),"","9999") & strMenuSortKey
			strMenuSortKey = strMenuSortKey & rs(i)("MenuIndex") & "-" & strName
					
			pageContent.add "" & vbCrLf _
			& "<tr class='"& strActive &strEven&"'>" & vbCrLf _
			& "<td class='"& strActive &"'><span>"& strActive &"</span></td>" & vbCrLf _
			& "<td><a href='?edit="& strId &"' title='Edit Page: "& strName &"'>"& strName &"</a></td>" & vbCrLf _
			& "<td><a href='?edit="& strId &"' title='Edit Page: "& strName &"'>"& rs(i)("PageTitle") &"</a></td>" & vbCrLf _
			& "<td><a href='"& globals("SITEURL") &"/"& rs(i)("PageFileName") &"' title='Open Page: "& strName &"'>"& rs(i)("PageFileName") &"</td>" & vbCrLf _
			& "<td width='15px' class='"& strMainMenu &"' sorttable_customkey='"& strMenuSortKey &"'><span>"& strMainMenu &"</span></td>" & vbCrLf _
			& "<td width='15px' class='action edit'><a class='edit action' href='?edit="& strId &"' title='Edit "& strName &"'>Edit</a></td>" & vbCrLf _
			& "<td width='15px' class='action view'><a class='view action' href='"& globals("SITEURL") &"/"& rs(i)("PageFileName") &"' title='View "& PCase(strContent) &"' target='_blank'>View</a></td>" & vbCrLf _
			& "<td class='action delete'><a class='delete action' href='?delete="& strId &"' title='Delete "& strContent &" "& strName &"' onclick=""return confirm('Really delete "& strContent &" \'"& strName &"\'?')"">Delete</a></td>" & vbCrLf _
			& "</tr>" & vbCrLf
			trapError
		next
		pageContent.add "</table>" & vbCrLf
		if user.getRole() >= USER_ADMINISTRATOR then
			pageContent.add "<div class='buttonbar'><ul><li><a class='new button' title='New "& PCase(strContent) &"' href='?create'>Create a new "& strContent &"</a></li></ul></div>" & vbCrLf
		end if
		pageContent.add "</form>" & vbCrLf _
			& "" & vbCrLf _
			& "<script type=""text/javascript"" src="""& globals("SITEURL") &"/core/assets/scripts/sorttable.js""></script>" & vbCrLf
		
	end if
	'contentView = a.value
end function
%>
