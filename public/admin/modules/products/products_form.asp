<!--#include file="../../../../core/src/classes/class.form.asp"-->
<%
function buildFormContents(pk)
	strActive = ""
	strRecommended = ""
	dim rs, checked, active, sql
	dim selected : selected = ""
	dim sdContent
	debugInfo("editing " & strContent & " with primary key='" & pk & "'")
	if pk <> "" then
		set sdContent = getProductByKey(pk)
	else
		set sdContent = Server.CreateObject("Scripting.Dictionary")
		sdContent.Add "Active", "true"
		sdContent.Add "Recommended", "true"
	end if
	if sdContent("Active") <> "" then strActive = "checked"
	if sdContent("Recommended") <> "" then strRecommended = "checked"

	with myForm
	'.CreateNew formName, action
	if not (.isForNewContent = true) then .addFormInput "", "", strKey, "hidden", "", sdContent(strKey), "", ""
	.addFieldset Pcase(strContent) & " Content", ""
	.startNoteSection()
	.addNote "Advanced Content Editing", "If you know what you are doing, the Page "_
					& "Content may be formatted with <acronym title=""HyperText "_
					& "Markup Language"">HTML</acronym>. Advanced administrators "_
					& "only, please!"
	.endNoteSection()
	.addFormInput "required", Pcase(strContent) & " Name", "ProductName", "text", "", sdContent("ProductName"), DBTEXT, ""
		sql="SELECT Key, Active, PID, Category "_
		& "FROM " & strTableName & " "_
		& "WHERE ((ProductName='') OR (ProductName Is , null)) "_
		& "ORDER BY PID, Category;"

	set rs = db.getRecordSet(sql)
	if rs.state > 0 then
		if not (rs.EOF and rs.BOF) then
			.addFormSelect "required", "Product Category", "Category", "", ""
			do until rs.EOF
				selected = ""
				active = " [Inactive]"
				if (rs("Active")) then active = " [Active]"
				if (rs("Category") = sdContent("Category")) then selected = "selected"
				.addFormOption "Category", rs("Category"), rs("Category") & active, selected
				rs.movenext
			loop
			.endFormSelect("")
		else
			.addFormInput "required", "Cateogry", "Cateogry", "", "There are no categories stored in the database. Please create a generic category name that classifies this product type."
		end if
	else
		debugError("there was an error opening the following sql: " & sql)
	end if
	trapError

	.addFormInput "optional wide", "Short Description", "ShortDescription", "textarea", "", sdContent("ShortDescription"), " rows=""3""" & DBMEMO, "The product description is a quick product summary."
	.addFormInput "optional full", "Long Description", "LongDescription", "textarea", "", sdContent("LongDescription"), " rows=""10""" & DBMEMO, "The long description may include more details, specifications, benefits, added value, and links to similar products. May be formatted with text/html. See the side note on <strong>Advanced Content Editing</strong> for more details."
	.addFormSubmission "left", "Submit &raquo;", "", "", ""
	.endFieldset()

	.addFieldset "" & Pcase(strContent) & " Details", "<strong>Bold</strong> fields are required."
	'content table's db fields
	.addFormInput "optional", "" & Pcase(strContent) & " ID", "PID", "text", "", sdContent("PID"), DBTEXT, "A unique identifier (alpha-numeric) for this " & strContent & ". (eg, sku or upc code)"
	.addFormInput "optional", "Brand/Company/Make", "Brand", "text", "", sdContent("Brand"), DBTEXT, "Improve your product organization by providing the " & Pcase(strContent) & " Name."
	.addFormInput "optional", "Line/Model", "ProductLine", "text", "", sdContent("ProductLine"), DBTEXT, "Use this to further classify your product into various product lines within a brand."

	'category logic
	'sql="SELECT Key, PID, Active, Category, Brand, ProductLine, ShortDescription, LongDescription, Image1 "_
	'	 & "FROM " & strTableName & " "_
	'	 & "WHERE ((ProductName="") OR (ProductName Is , null)) "_
	'	 & "ORDER BY Category, Brand, ProductLine;"

	'display options
	.addFormGroup "checkbox", "optional", "Display Options", ""
	.addFormInput "optional", "List this product as a recommended product?", "Recommended", "checkbox", "", "Yes", strRecommended, ""
	.addFormInput "optional", "Enable product display on live website?", "Active", "checkbox", "", "Yes", strActive, ""
	.endFormGroup()
	.addFormInput "optional", "Options", "Options", "text", "", sdContent("Options"), DBMEMO, "Specify a comma separated list of options or customizations from which the client can choose: (eg, color combinations, texture, sizing)"
	.addFormInput "optional", "Retail Price", "RetailPrice", "text", "money", FormatCurrency(sdContent("RetailPrice")), DBTEXT, ""
	.addFormInput "optional", "Wholesale Price", "WholesalePrice", "text", "money", FormatCurrency(sdContent("WholesalePrice")), DBTEXT, ""
	dim imgPreview1, imgPreview2, imgText
	imgText = "Only specify a new file if you wish to change the current file."
	imgPreview1 = "Please browse your computer for a primary (larger) image to represent this product."
	imgPreview2 = "Please browse your computer for a secondary (smaller) thumbnail image to represent this product."
	if sdContent("Image1") <> "" then imgPreview1 = img(globals("SITEURL") & "/" & sdContent("Image1"), "Image1", "image-preview", "") & imgText
	if sdContent("Image2") <> "" then imgPreview2 = img(globals("SITEURL") & "/" & sdContent("Image2"), "Image2", "image-preview", "") & imgText
	.addFormInput "optional", "Primary Image", "Image1", "file", "", "", DBTEXT, imgPreview1
	.addFormInput "optional", "Secondary Image", "Image2", "file", "", "", DBTEXT, imgPreview2
	.addFormSubmission "left", "Submit &raquo;", "", "", ""
	.endFieldset()

	buildFormContents = .getContents()
	end with
end function

function getProductByKey(pk)
		dim rs, sd, key, val, counter, i, sql
		set sd = Server.CreateObject("Scripting.Dictionary")
		if isNull(pk) or pk = "" then
			debugWarning("getProductByKey(): non-null id required")
		else
			sql="SELECT * "_
				 & "FROM " & strTableName & " "_
				 & "WHERE (Key=" & pk & ");"
			set rs = db.getRecordSet(sql)
			if rs.EOF and rs.BOF then
				debugError("getProductByKey(): no database content found for " & strContent & " with primary key '" & pk & "'.")
				addError("There is no " & strContent & " with the specified key '" & pk & "' in the database.<br/>" & _
				"Would you like to <a href='?view'>go back to the list</a> " & _
				"or <a href='?create'>create a new one</a>?")
			else
				rs.movefirst
				counter = rs.fields.count
				do until rs.EOF
					trace("getProductByKey(): the following database content found for page with pk '" & pk & "':")
					for i = 0 to counter - 1
						key = cstr(rs.fields.item(i).name)
						val = cstr(rs(i))
						trace("[ " & key & " -&gt; " & Server.HtmlEncode(val) & " ]")
						if not sd.exists(key) then
							sd.add key, val
						else
							debugWarning("getProductByKey(): primary key '" & pk & "' is not unique!")
							debugError("getProductByKey(): expected a single record but found that the recordset has multiple when field '" & rs.fields.item(i).name & "' returned a second value.")
						end if
					next
					rs.movenext
				loop
				trapError
			end if

		end if
		set getProductByKey = sd
end function
%>
