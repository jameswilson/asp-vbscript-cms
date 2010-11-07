<!--#include file="../../core/include/global.asp" -->
<%
strDebugHTML.clear
getCategories()
'printDebugHTML()


function getCategories()
	dim rs, result, sql, catid
	set result = new FastString
	dim prodImagePath : prodImagePath = objLinks.item("SITEURL")&"/"
	dim prodImgUrl, prodImgAlt
  pid = request.QueryString("catid")
		trace("mod_prod_categories: selecting active categories...")
		sql="SELECT Key, Active, PID, Category, ShortDescription, LongDescription, Image1 "_
			 &"FROM tblProducts "_
			 &"WHERE Active=True AND((ProductName='') OR (ProductName Is Null)) "_
			 &"ORDER BY PID, Category;"
	
		set rs = db.getRecordSet(sql)
		trace("mod_prod_categories: ...done selecting active categories")
		trace("mod_prod_categories: printing categories list to page...")
		dim numCategories : numCategories = 0
		dim prodLink, prodLinkTitle, varclass

		result.add vbcrlf & indent(2) & "<div class=""categorieslist"">"& vbcrlf
		do while not rs.EOF and not rs.BOF
			numCategories = numCategories + 1
			varclass="category clearfix"
			prodLink = "?catid="&rs("PID")
			prodLinkTitle = "Click for more info about "&rs("Category")
			prodImgUrl = prodImagePath&rs("Image1")
			prodImgAlt = rs("Category")

			if pid=	""&rs("PID") then varclass="current "&varclass

  		result.add indent(3) &"<div class="""&varclass&""">"& vbcrlf
			if not (isempty(rs("Image1")) = true) and (len(trim(rs("Image1"))) > 0) then
				debugInfo("Image1 value is '"&rs("Image1")&"'")
				debugInfo("Checking if image file exists at '"&prodImagePath&rs("Image1")&"'")
				if fileExists(prodImagePath&rs("Image1")) = true then
					result.add indent(4) & anchor(prodLink, img(prodImgUrl, prodImgAlt, prodImgAlt, "product-image"), prodLinkTitle, prodImgAlt&" image") & vbcrlf
				end if
			end if
			result.add indent(4) &"<p>"& vbcrlf
			result.add indent(5) & "<span class=""more-info"">"&anchor(prodLink,""&rs("Category")&"","Click for more info about "&rs("Category"),null)&"</span>"& vbcrlf
			result.add indent(4) & "</p>" & vbcrlf
			result.add indent(3) & "</div>" & vbcrlf
			rs.movenext
		loop
		result.add indent(3) & "<br clear=""all""/>"& vbcrlf
		result.add indent(2) & "</div>"& vbcrlf
		trace("mod_prod_categories: ...end printing categories list, "& numCategories &" categories listed.")
		numCategories = null
	writeln(result.value)
	set result = nothing
end function
%>