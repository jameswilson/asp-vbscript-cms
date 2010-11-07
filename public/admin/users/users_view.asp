<%
function contentView()
	dim rs,a,i
	set a = New FastString
	strHeader = ("View "&Pcase(strContentPL))
	dim nCount 
	'nCount = db.BuildList(rs, strTableName, " LEFT JOIN tblUserRoles ON "&strTableName&".Role=tblUserRoles.Level ORDER BY Disabled, FirstName, SecondName")
	set rs = db.getRecordSet("SELECT "&strTableName&".*, tblUserRoles.Name FROM "&strTableName&" LEFT JOIN tblUserRoles ON "&strTableName&".Role=tblUserRoles.Level ORDER BY Role DESC, Disabled, FirstName, SecondName")
	debug("the count returned is "&nCount)
	
	if rs.state = 0 then 
	'if nCount = -1 then
		a.add ErrorMessage("There was a database error retrieving the list of "&strContentPL&". "&objLinks.item("ERROR_FEEDBACK"))&vbcrlf
	elseif rs.recordcount = 0 then 'nCount = 0 then  
		a.add WarningMessage("There are currently no "&strContentPL&" with custom content stored in the database. Would you like to <a href='?create'>create the first "&strContent&"</a>?")
	else
		a.add "<form id='list' action='?edit' method='post'>" & vbcrlf
		a.add "<table id='pages' class='list sortable' width='100%' border='0' cellspacing='0' cellpadding='3'>" & vbcrlf
		a.add "<thead>" & vbcrlf
		a.add "<tr>" & vbcrlf
		a.add "<th width='15px' class='checkbox'>Active</th>" & vbcrlf
		a.add "<th>User Name</th>" & vbcrlf
		a.add "<th>Email</th>" & vbcrlf
		a.add "<th>Role</th>" & vbcrlf
		a.add "<th>Phone</th>" & vbcrlf
		a.add "<th>Last Login</th>" & vbcrlf
		a.add "<th width='5%' class='sorttable_nosort' colspan=2>Actions</th>" & vbcrlf
		a.add "</tr>" & vbcrlf
		a.add "</thead>" & vbcrlf
		a.add "" & vbcrlf
		a.add "" & vbcrlf
		dim strUserName, strEmail,strPhone, strLastLogin, strId, strRole
		while not rs.eof or rs.bof
			strActive = iif(rs("Disabled"),"no","yes")
			'if rs("Disabled") then strActive = "no"
			'strActive = "yes"
			strEven = iif(i MOD 2 = 0, " even", "")
			'strEven = ""
			'if (i MOD 2 = 0) then strEven = " even"		
			
			strUserName = rs("FirstName") &" "&rs("SecondName")
			strEmail = rs("Email")
			strPhone = rs("Phone")
			strLastLogin = rs("LastLogin")
			strRole = rs("Name")
			strId = rs(strKey)		
			
			a.add "" & vbcrlf
			a.add "<tr class='"&strActive&strEven&"'>" & vbcrlf
			a.add "<td class='"&strActive&"'><span>"&strActive&"</span></td>" & vbcrlf
			a.add "<td><a href='?edit="&strId&"' title='Edit "&strContent&" "&strUserName&"'>"& strUserName & "</a></td>" & vbcrlf
			a.add "<td><a href='mailto:"& strEmail &"' title='Send email to "&strUserName&"'>"& strEmail &"</a></td>" & vbcrlf
			a.add "<td>"& strRole &"</td>" & vbcrlf
			a.add "<td>"& strPhone &"</td>" & vbcrlf
			a.add "<td>"& strLastLogin &"</td>" & vbcrlf
			a.add "<td class='action edit'><a class='edit action' href='?edit="&strId&"' title='Edit "&strContent&" "&strUserName&"'>Edit</a></td>" & vbcrlf
			a.add "<td class='action delete'><a class='delete action' href='?delete="&strId&"' title='Delete "&strContent&" "&strUserName&"' onclick=""return confirm('Really delete "&strContent&" "&strUserName&"?')"">Delete</a></td>" & vbcrlf
			a.add "</tr>" & vbcrlf
			trapError
			rs.movenext
		wend
		a.add "</table>" & vbcrlf
		if user.getRole() >= USER_ADMINISTRATOR then
			a.add "<div class='buttonbar'><ul><li><a class='new button' title='New "&Pcase(strContent)&"' href='?create'>Create a new "&strContent&"</a></li></ul></div>" & vbcrlf
		end if
		a.add "</form>" & vbcrlf
		a.add "" & vbcrlf
		a.add "<script type=""text/javascript"" src="""&objLinks("SITEURL")&"/core/assets/scripts/sorttable.js""></script>" & vbcrlf
		
	end if
	contentView = a.value
end function
%>