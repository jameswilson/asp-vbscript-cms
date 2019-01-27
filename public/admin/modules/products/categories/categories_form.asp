<!--#include file="../../../../../core/src/classes/class.form.asp"-->
<%
function buildFormContents(pk)
	strActive = ""
	strRecommended = ""
	dim rs, checked, active
	dim selected : selected = ""
	dim sdContent
	debugInfo("editing product with primary key='" & pk & "'")
	if pk <> "" then
		set sdContent = getCategoryByKey(pk)
	else
		set sdContent = Server.CreateObject("Scripting.Dictionary")
		sdContent.Add "Active", "true"
	end if
	if sdContent("Active") <> "" then strActive = "checked"

		with myForm
		'.CreateNew(formName, action)
		if not (.isForNewContent = true) then
			.addFormInput "", "", strKey, "hidden", "", sdContent(strKey), "", ""
		end if
		.addFieldset Pcase(strContent) & " Details", "<strong>Bold</strong> fields are required."

		'editable database fields for this content
		.addFormInput "required", Pcase(strContent) & " Name", "Category", "text", "", sdContent("Category"), DBTEXT, ""
		.addFormInput "required", Pcase(strContent) & " ID", "PID", "text", "", sdContent("PID"), DBTEXT, "A unique identifier (alpha-numeric) for this category of products. (eg, sku or upc code)"
		.addFormGroup "checkbox", "optional", "Display Options", ""
		.addFormInput "optional", "This category and all its products should be displayed on live website?", "Active", "checkbox", "", "Yes", strActive, ""
		.endFormGroup()
		dim imgPreview1
		if sdContent("Image1") <> "" then
			imgPreview1 = img(globals("SITEURL") & "/" & sdContent("Image1"), "Image1", "image-preview", "") & "Only specify a new file if you wish to change the current file."
		else
			imgPreview1 = "There is currently no image stored for this category. Please select a file to upload."
		end if
		.addFormInput "optional", Pcase(strContent) & " Image", "Image1", "file", "", "", DBTEXT, imgPreview1
		.addFormSubmission "left", "Submit &raquo;", "", "", ""
		.endFieldset()

		.addFieldset Pcase(strContent) & " Content", ""
		.startNoteSection()
		.addNote "Advanced Content Editing", "If you know what you are doing, the Page "_
						& "Content may be formatted with <acronym title=""HyperText "_
						& "Markup Language"">HTML</acronym>. Advanced administrators "_
						& "only, please!"
		.endNoteSection()
		.addFormInput "optional wide", "Short Description", "ShortDescription", "textarea", "", sdContent("ShortDescription"), " rows=""3""" & DBMEMO, "The product description is a quick product summary."
		.addFormInput "optional full", "Long Description", "LongDescription", "textarea", "", sdContent("LongDescription"), " rows=""10""" & DBMEMO, "The long description may include more details, specifications, benefits, added value, and links to similar products. May be formatted with text/html. See the side note on <strong>Advanced Content Editing</strong> for more details."
		.addFormSubmission "left", "Submit &raquo;", "", "", ""
		.EndFieldset()

		buildFormContents = .getContents()
	end with
end function

function getCategoryByKey(pk)
		dim rs, sd, key, val, counter, i
		set sd = Server.CreateObject("Scripting.Dictionary")
		if isNull(pk) or pk = "" then
			debugWarning("getCategoryByKey(): non-null id required")
		else
			set rs = db.getRecordSet("SELECT * FROM " & strTableName & " WHERE (" & strKey & "=" & pk & ");")
			if rs.State > 0 then
				if rs.EOF and rs.BOF then
					debugError("getCategoryByKey(): no database content found for " & strContent & " with " & strKey & " '" & pk & "'.")
					addError("There is no " & strContent & " with the specified " & strKey & " '" & pk & "' in the database.<br/>" & _
					"Would you like to <a href='?view'>go back to the list</a> " & _
					"or <a href='?create'>create a new one</a>?")
				else
					rs.movefirst
					counter = rs.fields.count
					do until rs.EOF
						trace("getCategoryByKey(): the following database content found for " & strContent & " with " & strKey & " '" & pk & "':")
						for i = 0 to counter - 1
							key = cstr(rs.fields.item(i).name)
							val = cstr(rs(i))
							trace("[ " & key & " -&gt; " & Server.HtmlEncode(cstr(val)) & " ]")
							if not sd.exists(key) then
								sd.add key, val
							else
								debugWarning("getCategoryByKey(): " & strContent & " " & strKey & " '" & pk & "' is not unique!")
								debugError("getCategoryByKey(): expected a single record but found that the recordset has multiple when field '" & rs.fields.item(i).name & "' returned a second value.")
							end if
						next
						rs.movenext
					loop
					trapError
				end if
			end if

		end if
		set getCategoryByKey = sd
end function
%>
