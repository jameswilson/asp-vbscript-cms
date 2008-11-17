<%
function contentView()
	dim rs,a,i
	'set a = New FastString
	page.setName("View "&PCase(strContentPL)&"")
	dim nCount : nCount = db.BuildList(rs, strTableName, "")
	debug("the count returned is "&nCount)
	if nCount = -1 then
		pageContent.add WarningMessage(""&PCase(strContent)&" data is currently not stored in the database.  To be able to use the dynamic content functionality to create, modify, and delete site content, you must <a href="""&objLinks.item("ADMINURL")&"/db/install.asp?name="&strTableName&"&path=/core/src/install/create_"&strTableName&".ddl"">install this module</a>.")&vbcrlf
	elseif nCount = 0 then  
		pageContent.add WarningMessage("There are currently no "&strContentPL&" with custom content stored in the database. Would you like to <a href='?create'>create the first "&strContent&"</a>?")
	else

		pageContent.add  "<form id='list' action='?edit' method='post'>" & vbcrlf _
		& "<table id='pages' class='list sortable' width='100%' border='0' cellspacing='0' cellpadding='3'>" & vbcrlf _
		& "<thead>" & vbcrlf _
		& "<tr>" & vbcrlf _
		& "<th width='15px' class='checkbox'>Active</th>" & vbcrlf _
		& "<th>"&PCase(strContent)&" Name</th>" & vbcrlf _
		& "<th>"&PCase(strContent)&" Title</th>" & vbcrlf _
		& "<th>"&PCase(strContent)&" URL</th>" & vbcrlf _
		& "<th width='15px' class='checkbox'>Menu</th>" & vbcrlf _
		& "<th width='5%' class='sorttable_nosort' colspan=3>Actions</th>" & vbcrlf _
		& "</tr>" & vbcrlf _
		& "</thead>" & vbcrlf _
		& "" & vbcrlf _
		& "" & vbcrlf
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
			strMenuSortKey = iif (rs(i)("ParentPage")="" or rs(i)("ParentPage")="0", rs(i)("PageId")&"-0", rs(i)("ParentPage")) & "-"
			strMenuSortKey = iif (rs(i)("MainMenu"),"","9999")& strMenuSortKey
			strMenuSortKey = strMenuSortKey & rs(i)("MenuIndex") & "-" & strName
					
			pageContent.add "" & vbcrlf _
			& "<tr class='"&strActive&strEven&"'>" & vbcrlf _
			& "<td class='"&strActive&"'><span>"&strActive&"</span></td>" & vbcrlf _
			& "<td><a href='?edit="&strId&"' title='Edit Page: "&strName&"'>"&strName &"</a></td>" & vbcrlf _
			& "<td><a href='?edit="&strId&"' title='Edit Page: "&strName&"'>"&rs(i)("PageTitle") &"</a></td>" & vbcrlf _
			& "<td><a href='"&objLinks.item("SITEURL")&"/"&rs(i)("PageFileName")&"' title='Open Page: "&strName&"'>"&rs(i)("PageFileName") &"</td>" & vbcrlf _
			& "<td width='15px' class='"&strMainMenu&"' sorttable_customkey='"&strMenuSortKey&"'><span>"&strMainMenu&"</span></td>" & vbcrlf _
			& "<td width='15px' class='action edit'><a class='edit action' href='?edit="&strId&"' title='Edit "&strName&"'>Edit</a></td>" & vbcrlf _
			& "<td width='15px' class='action view'><a class='view action' href='"&objLinks.item("SITEURL")&"/"&rs(i)("PageFileName")&"' title='View "&PCase(strContent)&"' target='_blank'>View</a></td>" & vbcrlf _
			& "<td class='action delete'><a class='delete action' href='?delete="&strId&"' title='Delete "&strContent&" "&strName&"' onclick=""return confirm('Really delete "&strContent&" \'"&strName&"\'?')"">Delete</a></td>" & vbcrlf _
			& "</tr>" & vbcrlf
			trapError
		next
		pageContent.add "</table>" & vbcrlf
		if user.getRole() >= USER_ADMINISTRATOR then
			pageContent.add "<div class='buttonbar'><ul><li><a class='new button' title='New "&PCase(strContent)&"' href='?create'>Create a new "&strContent&"</a></li></ul></div>" & vbcrlf
		end if
		pageContent.add "</form>" & vbcrlf _
			& "" & vbcrlf _
			& "<script type=""text/javascript"" src="""&objLinks("SITEURL")&"/core/assets/scripts/sorttable.js""></script>" & vbcrlf
		
	end if
	'contentView = a.value
end function
%>
