<%
function contentView()
	dim rs, a, i
	set a = New FastString
	strHeader = ("View " & Pcase(strContentPL))
	dim nCount
	'nCount = db.BuildList(rs, strTableName, " LEFT JOIN tblUserRoles ON " & strTableName & ".Role=tblUserRoles.Level ORDER BY Disabled, FirstName, SecondName")
	set rs = db.getRecordSet("SELECT " & strTableName & ".*, tblUserRoles.Name FROM " & strTableName & " LEFT JOIN tblUserRoles ON " & strTableName & ".Role=tblUserRoles.Level ORDER BY Role DESC, Disabled, FirstName, SecondName")
	debug("the count returned is " & nCount)

	if rs.state = 0 then
	'if nCount = -1 then
		a.add ErrorMessage("There was a database error retrieving the list of " & strContentPL & ". " & globals("ERROR_FEEDBACK")) & vbCrLf
	elseif rs.recordcount = 0 then 'nCount = 0 then
		a.add WarningMessage("There are currently no " & strContentPL & " with custom content stored in the database. Would you like to <a href='?create'>create the first " & strContent & "</a>?")
	else
		a.add "<form id='list' action='?edit' method='post'>" & vbCrLf
		a.add "<table id='pages' class='list sortable' width='100%' border='0' cellspacing='0' cellpadding='3'>" & vbCrLf
		a.add "<thead>" & vbCrLf
		a.add "<tr>" & vbCrLf
		a.add "<th width='15px' class='checkbox'>Active</th>" & vbCrLf
		a.add "<th>User Name</th>" & vbCrLf
		a.add "<th>Email</th>" & vbCrLf
		a.add "<th>Role</th>" & vbCrLf
		a.add "<th>Phone</th>" & vbCrLf
		a.add "<th>Last Login</th>" & vbCrLf
		a.add "<th width='5%' class='sorttable_nosort' colspan=2>Actions</th>" & vbCrLf
		a.add "</tr>" & vbCrLf
		a.add "</thead>" & vbCrLf
		a.add "" & vbCrLf
		a.add "" & vbCrLf
		dim strUserName, strEmail,strPhone, strLastLogin, strId, strRole
		while not rs.eof or rs.bof
			strActive = iif(rs("Disabled"), "no", "yes")
			'if rs("Disabled") then strActive = "no"
			'strActive = "yes"
			strEven = iif(i MOD 2 = 0, " even", "")
			'strEven = ""
			'if (i MOD 2 = 0) then strEven = " even"

			strUserName = rs("FirstName") & " "  & rs("SecondName")
			strEmail = rs("Email")
			strPhone = rs("Phone")
			strLastLogin = rs("LastLogin")
			strRole = rs("Name")
			strId = rs(strKey)

			a.add "" & vbCrLf
			a.add "<tr class='" & strActive & strEven & "'>" & vbCrLf
			a.add "<td class='" & strActive & "'><span>" & strActive & "</span></td>" & vbCrLf
			a.add "<td><a href='?edit=" & strId & "' title='Edit " & strContent & " " & strUserName & "'>" & strUserName & "</a></td>" & vbCrLf
			a.add "<td><a href='mailto:" & strEmail & "' title='Send email to " & strUserName & "'>" & strEmail & "</a></td>" & vbCrLf
			a.add "<td>" & strRole & "</td>" & vbCrLf
			a.add "<td>" & strPhone & "</td>" & vbCrLf
			a.add "<td>" & strLastLogin & "</td>" & vbCrLf
			a.add "<td class='action edit'><a class='edit action' href='?edit=" & strId & "' title='Edit " & strContent & " " & strUserName & "'>Edit</a></td>" & vbCrLf
			a.add "<td class='action delete'><a class='delete action' href='?delete=" & strId & "' title='Delete " & strContent & " " & strUserName & "' onclick=""return confirm('Really delete " & strContent & " " & strUserName & "?')"">Delete</a></td>" & vbCrLf
			a.add "</tr>" & vbCrLf
			trapError
			rs.movenext
		wend
		a.add "</table>" & vbCrLf
		if user.getRole() >= USER_ADMINISTRATOR then
			a.add "<div class='buttonbar'><ul><li><a class='new button' title='New " & Pcase(strContent) & "' href='?create'>Create a new " & strContent & "</a></li></ul></div>" & vbCrLf
		end if
		a.add "</form>" & vbCrLf
		a.add "" & vbCrLf
		a.add "<script type=""text/javascript"" src=""" & globals("SITEURL") & "/core/assets/scripts/sorttable.js""></script>" & vbCrLf

	end if
	contentView = a.value
end function
%>
