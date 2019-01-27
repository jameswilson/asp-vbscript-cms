<%
function contentView()
	dim rs, a, sql
	set a = New FastString
	page.setName("View " & Pcase(strContentPL))
	sql="SELECT Key, Active, PID, Category, ShortDescription, LongDescription, Image1 "_
		 & "FROM " & strTableName & " "_
		 & "WHERE ((ProductName='') OR (ProductName Is , null)) "_
		 & "ORDER BY Active, PID, Category;"
	set rs = db.getRecordSet(sql)
	if rs.State > 0 then
		if rs.EOF and rs.BOF then
			strWarn = "There are currently no " & strContentPL & " stored in the database. " & _
				"Would you like to <a href='?create'>create one</a>?"
		else
			checkPageForErrors()
			a.add "<form id='list' action='?edit' method='post'>" & vbCrLf
			a.add "<table id='products' class='list sortable' width='100%' border='0' cellspacing='0' cellpadding='3'>" & vbCrLf
			a.add "<thead>" & vbCrLf
			a.add "<tr>" & vbCrLf
			a.add "<th width='15px' class='checkbox'>Active</th>" & vbCrLf
			a.add "<th width='18%'>ID</th>" & vbCrLf
			a.add "<th width='18%'>" & Pcase(strContent) & " Name</th>" & vbCrLf
			a.add "<th width='48%'>Description</th>" & vbCrLf
			a.add "<th width='5%' class='sorttable_nosort' colspan=3>Actions</th>" & vbCrLf
			a.add "</tr>" & vbCrLf
			a.add "</thead>" & vbCrLf
			a.add "" & vbCrLf
			a.add "" & vbCrLf
			a.add "" & vbCrLf
			rs.MoveFirst
			dim i : i = 0
			dim strId, strName
			do until rs.EOF
				i=i+1
				strEven = iif(i MOD 2 = 0, " even", "")
				strActive = iif(rs("Active"), "yes", "no")
				strId = rs(strKey)
				strName = rs("Category")
				a.add "<tr class='" & strActive & strEven & "'>" & vbCrLf
				a.add "<td class='" & strActive & "'><span>" & strActive & "</span></td>" & vbCrLf
				a.add "<td>" & rs("PID") & "</td>" & vbCrLf
				a.add "<td>" & rs("Category") & "</td>" & vbCrLf
				a.add "<td>" & rs("ShortDescription") & "</td>" & vbCrLf
				a.add "<td class='action edit'><a class='edit action' href='?edit=" & strId & "' title='Edit " & strName & "'>Edit</a></td>" & vbCrLf
				a.add "<td class='action view'><a class='view action' href='" & globals("SITEURL") & "/products.asp?pid=" & rs("PID") & "' title='View " & Pcase(strContent) & " Page' target='_blank'>View</a></td>" & vbCrLf
				a.add "<td class='action delete'><a class='delete action' href='?delete=" & strId & "' title='Delete " & strContent & " " & strName & "' onclick=""return confirm('Really delete " & strContent & " " & rs(strIdField) & "?')"">Delete</a></td>" & vbCrLf
				a.add "</tr>" & vbCrLf
				trapError
				rs.MoveNext
			Loop
			a.add "</table>" & vbCrLf
			a.add "<div class='buttonbar'>" & vbCrLf
			a.add "<ul><li><a class='new button' title='New " & Pcase(strContent) & "' href='?create'>Create a new " & strContent & "</a></li>"
			a.add "<li><a class='new button' title='New Category' href='../products.asp?create'>Create a new Product</a></li></ul></div>" & vbCrLf
			a.add "</form>" & vbCrLf
			a.add "" & vbCrLf
			a.add "<script type=""text/javascript"" src=""" & globals("SITEURL") & "/core/assets/scripts/sorttable.js""></script>" & vbCrLf


		end if
	end if
	contentView = a.value
end function
%>
