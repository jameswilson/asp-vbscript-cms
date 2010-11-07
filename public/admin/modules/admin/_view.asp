<!--#include file="../../../core/src/functions/functions.source.asp"-->
<%

function contentView()
	myForm.isForNewContent = false
	dim sql, rs, cn, strPath
	sql = "SELECT mt.Disabled, mt.ModID, mt.ModName, mt.ModHandler, mt.ModDescription, Count(m.ID) AS NumInstances, Abs(Sum(m.Active)) AS NumActive "_
		&"FROM tblModules AS m RIGHT JOIN tblModuleTypes as mt ON m.Type = mt.ModID "_
		&"GROUP BY mt.Disabled, mt.ModID, mt.ModName, mt.ModHandler, mt.ModDescription "_
		&"ORDER BY mt.Disabled DESC, mt.ModName;"

	set rs = db.openRecordSet(sql)
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
		pageContent.add "" & vbcrlf _
		 &"<form id='list' action='?edit' method='post'>" & vbcrlf _
		 &"<table id='pages' class='list sortable' width='100%' border='0' cellspacing='0' cellpadding='3'>" & vbcrlf _
		 &"<thead>" & vbcrlf _
		 &"<tr>" & vbcrlf _
		 &"<th width='2%' class='icon'>Active</th>" & vbcrlf _
		 &"<th>"&Pcase(strContent)&"</th>" & vbcrlf _
		 &"<th>Description</th>" & vbcrlf _
		 &"<th>Instances</th>" & vbcrlf _
			&"<th width='5%' class='sorttable_nosort' colspan=2>Actions</th>" & vbcrlf _
			&"</tr>" & vbcrlf _
			&"</thead>" & vbcrlf _
		 &"" & vbcrlf _
		 &"" & vbcrlf
		
		dim strEven, strActive, strActivation, strId, strName, i
		do while not rs.EOF				
			strEven = iif( (i MOD 2 = 0), " even", "" )
			if updateField(rs) = 0 then strEven=strEven&" fail"
			strActive = iif(rs("Disabled"),"no","yes")
			strActivation = iif(rs("Disabled"),"0","1")
			strId = rs(strKey)
			strName = rs(strIdField)
			pageContent.add "" & vbcrlf _
			 &"<tr class='"&strActive&strEven&"'>" & vbcrlf _
			 &"<td class='action "&strActive&"'><a class='check-"&strActive&" action' href='?id="&strId&"&amp;disabled="&strActivation&"' title='change activation status?'><span>"&strActive&"</span></a></td>" & vbcrlf _
			 &"<td><a href='?edit="&strId&"' title='Edit the "&strName&" "&strContent&".'>"&strName&"</a></td>" & vbcrlf _
			 &"<td>"&rs("ModDescription")&"</td>" & vbcrlf _
			 &"<td>"&rs("NumInstances")&iif(rs("NumInstances")>rs("NumActive")," ("&rs("NumInstances")-rs("NumActive")&" disabled) ","")&"</td>" & vbcrlf _
			 &"<td class='action edit'><a class='edit action' href='?edit="&strId&"' title='Edit the "&strName&" "&strContent&".'>Edit</a></td>" & vbcrlf _
			 &"<td class='action delete'><a class='delete action' href='?delete="&strId&"' title='Delete the "&strName&" "&strContent&".' onclick=""return confirm('Really delete "&strContent&" \'"&strName&"\'?')"">Delete</a></td>" & vbcrlf _
			 &"</tr>" & vbcrlf
			trapError
			i = i+1
			rs.movenext
		loop
		rs.close
		
		
		pageContent.add "</table>" & vbcrlf _
		 &"<div class='buttonbar'><ul><li><a class='new button' title='New "&Pcase(strContent)&"' href='?create'>Add a "&strContent&"</a></li></ul></div>" & vbcrlf _
		 &"</form>" & vbcrlf _
		 &"" & vbcrlf _
	 	 & "<script type=""text/javascript"" src="""&objLinks("SITEURL")&"/core/assets/scripts/sorttable.js""></script>" & vbcrlf
		
	end if
end function

function updateField(byref rs)
	on error goto 0
	updateField = -1
	if len(request.QueryString("id"))=0 then exit function
	if not isNumeric(request.QueryString("id")) then exit function
	if int(request.QueryString("id"))<>rs(strKey) then exit function
	dim key
		on error resume next
	for each key in request.QueryString()
		rs.Fields(key).Value = request.QueryString(key)
		if err.number<>0 then
			if err.number=3265 then
				err.clear 'this error means specified key is not a real column name in the database... show no error and proceed as normal
			else
				'otherwise, any other error report as a failure
				updateField = 0
				strError=strError&"<ul><li>Could not update field '"&key&"' with value '"&request.QueryString(key)&"'</li><ul>"&vbcrlf
				exit function
			end if
		else
			'debugging only
			'strStatus=strStatus&"<ul><li>updating field '"&key&"' with value '"&request.QueryString(key)&"'</li><ul>"&vbcrlf
		end if
	next
		on error goto 0
	rs.update
	strSuccess=Pcase(rs(strIdField)&" "&strContent)&" successfully updated.<br>"&strSuccess
	updateField = 1
end function
%>