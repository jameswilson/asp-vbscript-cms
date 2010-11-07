<%
function contentView()
	dim rs,a,i,nCount
	set a = New FastString
	page.setName("View "&Pcase(strContentPL)&"")
	nCount = db.BuildList(rs, strTableName, "(ProductName<>'') AND (ProductName IS NOT NULL)")
	debug("the count returned is "&nCount)
	if nCount = -1 then
		a.add WarningMessage(""&PCase(strContentPL)&" are currently not stored in the database.  To be able to use the dynamic content functionality to create, modify, and delete "&strContentPL&", you must <a href="""&objLinks.item("ADMINURL")&"/db/install.asp?name="&strTableName&"&path=/core/src/install/create_"&strTableName&".ddl"">install this module</a>.")&vbcrlf
	elseif nCount = 0 then  
		a.add WarningMessage("There are currently no "&strContentPL&" with custom content stored in the database. Would you like to <a href='?create'>create the first "&strContent&"</a>?")
	else
		a.add "<form id='list' action='?edit' method='post'>" & vbcrlf
		a.add "<table id='products' class='list sortable' width='100%' border='0' cellspacing='0' cellpadding='3'>" & vbcrlf
		a.add "<thead>" & vbcrlf
		a.add "<tr>" & vbcrlf
		a.add "<th width='5%' class='checkbox'>Active</th>" & vbcrlf
		a.add "<th width='5%' class='checkbox'>Recommended</th>" & vbcrlf
		a.add "<th>Product</th>" & vbcrlf
		a.add "<th>Category</th>" & vbcrlf
		a.add "<th>Brand</th>" & vbcrlf
		a.add "<th width='5%' class='sorttable_nosort' colspan=3>Actions</th>" & vbcrlf
		a.add "</tr>" & vbcrlf
		a.add "</thead>" & vbcrlf
		a.add "" & vbcrlf
		a.add "" & vbcrlf
		a.add "" & vbcrlf
		for i=0 to nCount-1
			strEven = iif(i MOD 2 = 0, " even", "")
			strActive = iif(rs(i)("Active"),"yes","no")
			strRecommended = iif(rs(i)("Recommended"),"yes","no")
			a.add "<tr class='"&strActive&strEven&"'>" & vbcrlf
			a.add "<td class='"&strActive&"'><span>"&strActive&"</span></td>" & vbcrlf
			a.add "<td class='"&strRecommended&"'><span>"&strRecommended&"</span></td>" & vbcrlf
			a.add "<td><a href='?edit="&rs(i)(strKey)&"' title='Edit "&rs(i)(strIdField)&"'>"&rs(i)(strIdField) &"</a></td>" & vbcrlf
			a.add "<td>"&rs(i)("Category") &"</td>" & vbcrlf
			a.add "<td>"&rs(i)("Brand") &"</td>" & vbcrlf
			a.add "<td class='action edit'><a class='edit action' href='?edit="&rs(i)(strKey)&"' title='Edit "&rs(i)(strIdField)&"'>Edit</a></td>" & vbcrlf
			a.add "<td class='action view'><a class='view action' href='"&objLinks.item("SITEURL")&"/products.asp?pid="&rs(i)("PID")&"' title='View "&Pcase(strContent)&" Page' target='_blank'>View</a></td>" & vbcrlf
			a.add "<td class='action delete'><a class='delete action' href='?delete="&rs(i)(strKey)&"' title='Delete "&strContent&" "&rs(i)(strIdField)&"' onclick=""return confirm('Really delete "&strContent&" by "&rs(i)(strIdField)&"?')"">Delete</a></td>" & vbcrlf
			a.add "</tr>" & vbcrlf
			trapError
		next
		a.add "</table>" & vbcrlf
		a.add "<div class='buttonbar'>"& vbcrlf
		a.add "<ul><li><a class='new button' title='New "&Pcase(strContent)&"' href='?create'>Create a new "&strContent&"</a></li>"
		a.add "<li><a class='new button' title='New Category' href='categories/categories.asp?create'>Create a new Category</a></li></ul></div>" & vbcrlf
		a.add "</form>" & vbcrlf
		a.add "" & vbcrlf
		a.add "<script type=""text/javascript"" src="""&objLinks("SITEURL")&"/core/assets/scripts/sorttable.js""></script>" & vbcrlf
		
	end if
	contentView = a.value
end function
%>