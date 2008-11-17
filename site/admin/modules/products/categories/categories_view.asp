<%
function contentView()
	dim rs, a, sql
	set a = New FastString
	page.setName("View "&Pcase(strContentPL))
	sql="SELECT Key, Active, PID, Category, ShortDescription, LongDescription, Image1 "_
		 &"FROM "&strTableName&" "_
		 &"WHERE ((ProductName='') OR (ProductName Is Null)) "_
		 &"ORDER BY Active, PID, Category;"
	set rs = db.getRecordSet(sql)
	if rs.State > 0 then 
		if rs.EOF and rs.BOF then
			strWarn = "There are currently no "&strContentPL&" stored in the database. "& _
				"Would you like to <a href='?create'>create one</a>?"
		else
			checkPageForErrors()
			a.add "<form id='list' action='?edit' method='post'>" & vbcrlf
			a.add "<table id='products' class='list sortable' width='100%' border='0' cellspacing='0' cellpadding='3'>" & vbcrlf
			a.add "<thead>" & vbcrlf			
			a.add "<tr>" & vbcrlf
			a.add "<th width='15px' class='checkbox'>Active</th>" & vbcrlf
			a.add "<th width='18%'>ID</th>" & vbcrlf
			a.add "<th width='18%'>"&Pcase(strContent)&" Name</th>" & vbcrlf
			a.add "<th width='48%'>Description</th>" & vbcrlf
			a.add "<th width='5%' class='sorttable_nosort' colspan=3>Actions</th>" & vbcrlf
			a.add "</tr>" & vbcrlf
			a.add "</thead>" & vbcrlf
			a.add "" & vbcrlf
			a.add "" & vbcrlf
			a.add "" & vbcrlf
			rs.MoveFirst
			dim i : i = 0
			dim strId, strName
			do until rs.EOF
				i=i+1
				strEven = iif(i MOD 2 = 0, " even", "")
				strActive = iif(rs("Active"),"yes","no")
				strId = rs(strKey)
				strName = rs("Category")
				a.add "<tr class='"&strActive&strEven&"'>" & vbcrlf
				a.add "<td class='"&strActive&"'><span>"&strActive&"</span></td>" & vbcrlf
				a.add "<td>"&rs("PID") &"</td>" & vbcrlf
				a.add "<td>"&rs("Category") &"</td>" & vbcrlf
				a.add "<td>"&rs("ShortDescription") &"</td>" & vbcrlf
				a.add "<td class='action edit'><a class='edit action' href='?edit="&strId&"' title='Edit "&strName&"'>Edit</a></td>" & vbcrlf
				a.add "<td class='action view'><a class='view action' href='"&objLinks.item("SITEURL")&"/products.asp?pid="&rs("PID")&"' title='View "&Pcase(strContent)&" Page' target='_blank'>View</a></td>" & vbcrlf
				a.add "<td class='action delete'><a class='delete action' href='?delete="&strId&"' title='Delete "&strContent&" "&strName&"' onclick=""return confirm('Really delete "&strContent&" "&rs(strIdField)&"?')"">Delete</a></td>" & vbcrlf
				a.add "</tr>" & vbcrlf
				trapError
				rs.MoveNext
			Loop
			a.add "</table>" & vbcrlf
			a.add "<div class='buttonbar'>"& vbcrlf
			a.add "<ul><li><a class='new button' title='New "&Pcase(strContent)&"' href='?create'>Create a new "&strContent&"</a></li>"
			a.add "<li><a class='new button' title='New Category' href='../products.asp?create'>Create a new Product</a></li></ul></div>" & vbcrlf
			a.add "</form>" & vbcrlf
			a.add "" & vbcrlf
			a.add "<script type=""text/javascript"" src="""&objLinks("SITEURL")&"/core/assets/scripts/sorttable.js""></script>" & vbcrlf

			
		end if
	end if
	contentView = a.value
end function
%>