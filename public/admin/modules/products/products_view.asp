<%
function contentView()
	dim rs, a, i, nCount
	set a = New FastString
	page.setName("View " & Pcase(strContentPL) & "")
	nCount = db.BuildList(rs, strTableName, "(ProductName<>'') AND (ProductName IS NOT null)")
	debug("the count returned is " & nCount)
	if nCount = -1 then
		a.add WarningMessage(PCase(strContentPL) & " are currently not stored in the database.  To be able to use the dynamic content functionality to create, modify, and delete " & strContentPL & ", you must <a href=""" & globals("ADMINURL") & "/db/install.asp?name=" & strTableName & "&path=/core/src/install/create_" & strTableName & ".ddl"">install this module</a>.") & vbCrLf
	elseif nCount = 0 then
		a.add WarningMessage("There are currently no " & strContentPL & " with custom content stored in the database. Would you like to <a href='?create'>create the first " & strContent & "</a>?")
	else
		a.add "<form id='list' action='?edit' method='post'>" & vbCrLf
		a.add "<table id='products' class='list sortable' width='100%' border='0' cellspacing='0' cellpadding='3'>" & vbCrLf
		a.add "<thead>" & vbCrLf
		a.add "<tr>" & vbCrLf
		a.add "<th width='5%' class='checkbox'>Active</th>" & vbCrLf
		a.add "<th width='5%' class='checkbox'>Recommended</th>" & vbCrLf
		a.add "<th>Product</th>" & vbCrLf
		a.add "<th>Category</th>" & vbCrLf
		a.add "<th>Brand</th>" & vbCrLf
		a.add "<th width='5%' class='sorttable_nosort' colspan=3>Actions</th>" & vbCrLf
		a.add "</tr>" & vbCrLf
		a.add "</thead>" & vbCrLf
		a.add "" & vbCrLf
		a.add "" & vbCrLf
		a.add "" & vbCrLf
		for i=0 to nCount-1
			strEven = iif(i MOD 2 = 0, " even", "")
			strActive = iif(rs(i)("Active"), "yes", "no")
			strRecommended = iif(rs(i)("Recommended"), "yes", "no")
			a.add "<tr class='" & strActive & strEven & "'>" & vbCrLf
			a.add "<td class='" & strActive & "'><span>" & strActive & "</span></td>" & vbCrLf
			a.add "<td class='" & strRecommended & "'><span>" & strRecommended & "</span></td>" & vbCrLf
			a.add "<td><a href='?edit=" & rs(i)(strKey) & "' title='Edit " & rs(i)(strIdField) & "'>" & rs(i)(strIdField) & "</a></td>" & vbCrLf
			a.add "<td>" & rs(i)("Category") & "</td>" & vbCrLf
			a.add "<td>" & rs(i)("Brand") & "</td>" & vbCrLf
			a.add "<td class='action edit'><a class='edit action' href='?edit=" & rs(i)(strKey) & "' title='Edit " & rs(i)(strIdField) & "'>Edit</a></td>" & vbCrLf
			a.add "<td class='action view'><a class='view action' href='" & globals("SITEURL") & "/products.asp?pid=" & rs(i)("PID") & "' title='View " & Pcase(strContent) & " Page' target='_blank'>View</a></td>" & vbCrLf
			a.add "<td class='action delete'><a class='delete action' href='?delete=" & rs(i)(strKey) & "' title='Delete " & strContent & " " & rs(i)(strIdField) & "' onclick=""return confirm('Really delete " & strContent & " by " & rs(i)(strIdField) & "?')"">Delete</a></td>" & vbCrLf
			a.add "</tr>" & vbCrLf
			trapError
		next
		a.add "</table>" & vbCrLf
		a.add "<div class='buttonbar'>" & vbCrLf
		a.add "<ul><li><a class='new button' title='New " & Pcase(strContent) & "' href='?create'>Create a new " & strContent & "</a></li>"
		a.add "<li><a class='new button' title='New Category' href='categories/categories.asp?create'>Create a new Category</a></li></ul></div>" & vbCrLf
		a.add "</form>" & vbCrLf
		a.add "" & vbCrLf
		a.add "<script type=""text/javascript"" src=""" & globals("SITEURL") & "/core/assets/scripts/sorttable.js""></script>" & vbCrLf

	end if
	contentView = a.value
end function
%>
