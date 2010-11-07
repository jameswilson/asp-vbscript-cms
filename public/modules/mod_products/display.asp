<!--#include file="../../core/include/global.asp" -->
<%
strDebugHTML.clear
getProducts()
'printDebugHTML()


function getProducts()
	dim rs, result, sql, catid, var
	dim prodLink, prodLinkTitle, prodImgUrl, prodImgAlt, catLink, varclass, iscategory, adminedit
	dim prodImagePath : prodImagePath = objLinks.item("SITEURL")&"/"
	set result = new FastString
	catid = request.QueryString("catid")
	'if a pid was selected then show the page for that product
	if len(request.QueryString("pid")) > 0 then 
		
		trace("mod_products: selecting product information by PID="&request.QueryString("pid"))
		'sql="SELECT tblProducts.*, tblProducts.PID "_
		'	 &"FROM tblProducts "_
		'	 &"WHERE (((tblProducts.PID)='"&request.QueryString("pid")&"'));"
		sql="SELECT * FROM TblProducts INNER JOIN (SELECT Category AS CAT2, PID AS CATID FROM tblProducts WHERE ProductName='' OR ProductName IS NULL) AS tbl2 ON tblProducts.Category=tbl2.CAT2 WHERE tblProducts.PID='"&request.QueryString("pid")&"';"
		set rs = db.getRecordSet(sql)
		trace("mod_products: ...done selecting product by PID")
		if rs.State > 0 then 
			if not rs.EOF and not rs.BOF then 
				trace("mod_products: found product '"&rs("ProductName")&"'")
				trace("mod_products: printing product info to page...")
				catLink = "?catid="&rs("CATID")
				result.add h2("Products &rsaquo; "&anchor(catLink,""&rs("Category")&"","Click for more info about "&rs("Category"),null))
				result.add h3(rs("ProductName"))
				if not FormatCurrency(rs("RetailPrice")) = "$0.00" and not FormatCurrency(rs("RetailPrice")) = "0,00 €" then
					result.add indent(5) & "<span class=""product-price"">"&FormatCurrency(rs("RetailPrice"))&"</span>"& vbcrlf
				else
					result.add indent(5) & "<span class=""product-price""><a href=""?"" onclick=""window.open('"
					result.add objLinks.item("SITEURL")&"/modules/mod_products/feedback.asp?s=inquiry&"
					result.add "subject="&server.URLEncode("Price inquiry for "&rs("Brand")&" "&rs("ProductName")& " (PID#"&rs("PID")&")")
					result.add "&message="&server.URLEncode("Please send me a price quote for the "&rs("Brand")&" "&rs("ProductName")&".")
					result.add "&image="&server.URLEncode(""&rs("Image1"))

					result.add "','Price_Inquiry','width=400,height=500');"" "
					result.add "title=""Click Here for a Price Quote"">Get Price Quote</a>" & vbcrlf
				end if
				result.add p(rs("ProductLine")&" from "&rs("Brand"))
				result.add p(img(prodImagePath&rs("Image1"), rs("Brand") &" "&rs("ProductName"), rs("Brand") &" "&rs("ProductName"), "product-image floatleft")&rs("ShortDescription"))
				result.add p(rs("LongDescription"))
				if not FormatCurrency(rs("RetailPrice")) = "$0.00" and not FormatCurrency(rs("RetailPrice")) = "0,00 €" then
					result.add indent(5) & "<span class=""product-price clearfix"">"&FormatCurrency(rs("RetailPrice"))&"</span>"& vbcrlf
				else
					result.add indent(5) & "<span class=""product-price""><a href=""?"" onclick=""window.open('"
					result.add objLinks.item("SITEURL")&"/modules/mod_products/feedback.asp?s=inquiry&"
					result.add "subject="&server.URLEncode("Price inquiry for "&rs("Brand")&" "&rs("ProductName")& " (PID#"&rs("PID")&")")
					result.add "&message="&server.URLEncode("Please send me a price quote for the "&rs("Brand")&" "&rs("ProductName")&".")
					result.add "&image="&server.URLEncode(""&rs("Image1"))
					result.add "','Price_Inquiry','width=400,height=500');"" "
					result.add "title=""Click Here for a Price Quote"">Get Price Quote</a>" & vbcrlf
				end if
				trace("mod_products: ...end printing product")
			else
				debugError("mod_products: NO PRODUCT FOUND WITH PID="&request.QueryString("pid"))
				result.add WarningMessage("Error:  No product exists for the specified product id.<br />Please <a href=""?"">go back</a> to the product list page.")
			end if
		end if
		
	'else show the product index page
	else
		if len(catid)	> 0 then
				sql="SELECT * from tblProducts INNER JOIN (SELECT Category as CAT2, PID as CATID from tblProducts WHERE ProductName='' OR ProductName is null)AS Tbl2 on tblProducts.Category=tbl2.CAT2 where Category=(Select Category from tblProducts where PID='"&catid&"') order by ProductName;"
		else	
			'sql="SELECT Key, PID, Recommended, Category, Brand, ProductLine, ProductName, ShortDescription, RetailPrice, Image1 "&_
			'	 "FROM tblProducts "&_
			'	  "WHERE ProductName Is Not Null AND ProductName <> '' "&_
			'	 "ORDER BY Brand, ProductLine, ProductName;"
			sql="SELECT * from TblProducts INNER JOIN (SELECT Category as CAT2, PID as CATID from tblProducts WHERE ProductName='' OR ProductName is null)AS Tbl2 on tblProducts.Category=tbl2.CAT2 where ProductName Is Not Null AND ProductName <> '' ORDER BY Brand, ProductLine, ProductName;"
		
		end if
		trace("mod_products: selecting active products...")
	
		set rs = db.getRecordSet(sql)
		trace("mod_products: ...done selecting active products")
		trace("mod_products: printing product list to page...")
		dim numProducts : numProducts = 0

		
		result.add vbcrlf & indent(2) & "<div class=""productlist"">"& vbcrlf
		do while not rs.EOF and not rs.BOF
			numProducts = numProducts + 1
			iscategory=len(""&rs("ProductName"))= 0 
			prodLink = "?pid="&rs("PID")
			catLink = "?catid="&rs("CATID")
			prodLinkTitle = "Click for more info about "&rs("Brand") &" "&rs("ProductName")
			prodImgUrl = prodImagePath&rs("Image1")
			prodImgAlt = rs("Brand") &" "&rs("ProductName")

			varclass="product clearfix"
			adminedit="products"
			debug("product_display: processing product '"&prodImgAlt&"'")
			if iscategory then 
			  varclass="category " &varclass
				adminedit="categories"
			end if
			result.add indent(3) &"<div class="""&varclass&""">"& vbcrlf
			result.add indent(5) & adminEditLink("/products/"&adminedit&".asp?edit="&rs("Key"),"Edit","Edit this product")& vbcrlf
			result.add indent(4) &"<p class=""clearfix"">"& vbcrlf
			if not (isempty(rs("Image1")) = true) and (len(trim(rs("Image1"))) > 0) then
				debugInfo("Image1 value is '"&rs("Image1")&"'")
				debugInfo("Checking if image file exists at '"&prodImagePath&rs("Image1")&"'")
				if fileExists(prodImagePath&rs("Image1")) = true then
					result.add indent(5) & anchor(prodLink, img(prodImgUrl, prodImgAlt, prodImgAlt, "product-image"), prodLinkTitle, prodImgAlt&" image") & vbcrlf
				end if
			end if
			result.add indent(5) & "<span class=""product-category"">"&anchor(catLink,""&rs("Category")&"","Click for more info about "&rs("Category"),null)&"</span>"& vbcrlf
			if not isempty(rs("ProductName")) = true then
				result.add indent(5) & "<span class=""product-name"">"&anchor(prodLink, rs("ProductName"), prodImgAlt, "product-link")&"</span>"& vbcrlf
			end if
			if trim(len(""&rs("Brand")))<>0 then
				result.add indent(5) & "<span class=""product-brand"">from "&rs("Brand")&"</span>"& vbcrlf
			end if
			if not isempty(rs("ShortDescription")) = true then 
				result.add indent(5) & "<span class=""short-description"">"&rs("ShortDescription")&"</span>"& vbcrlf
			end if
			if not iscategory then
				if not FormatCurrency(rs("RetailPrice")) = "$0.00" and not FormatCurrency(rs("RetailPrice")) = "0,00 €" then
					result.add indent(5) & "<span class=""product-price"">"&FormatCurrency(rs("RetailPrice"))&"</span>"& vbcrlf
				else
					result.add indent(5) & "<span class=""product-price""><a href=""?"" onclick=""window.open('"
					result.add objLinks.item("SITEURL")&"/modules/mod_products/feedback.asp?s=inquiry&"
					result.add "subject="&server.URLEncode("Price inquiry for "&rs("Brand")&" "&rs("ProductName")& " (PID#"&rs("PID")&")")
					result.add "&message="&server.URLEncode("Please send me a price quote for the "&rs("Brand")&" "&rs("ProductName")&".")
					result.add "&image="&server.URLEncode(""&rs("Image1"))
					result.add "','Price_Inquiry','width=400,height=500');"" "
					result.add "title=""Click Here for a Price Quote"">Get Price Quote</a>" & vbcrlf
				end if
				result.add indent(5) & "<span class=""more-info"">"&anchor("?pid="&rs("PID"), "more info...","Click for more info about "&rs("Brand") &" "&rs("ProductName"), "more-info")&"</span>"& vbcrlf
			end if
			
			result.add indent(4) & "</p>" & vbcrlf
			result.add indent(3) & "</div>" & vbcrlf
			rs.movenext
		loop
		result.add indent(3) & "<br clear=""all""/>"& vbcrlf
		result.add indent(2) & "</div>"& vbcrlf
		trace("mod_products: ...end printing product list, "& numProducts &" products listed.")
		numProducts = null
	end if
	writeln(result.value)
	set result = nothing
end function
%>
