<!--#include file="../../../../core/src/classes/class.form.asp"-->
<!--#include file="../../../modules/mod_testimonials/functions.asp"-->
<%
function buildFormContents(id)
	dim sdContent
	strActive = ""
	strShowEmail = ""
	dim rs, checked, active
	dim selected : selected = ""
	dim idSortOrder, rscount
  set rscount = db.getrecordset("SELECT COUNT(SortOrder) FROM tblTestimonials ")
	idSortorder = rscount(0)
	rscount.close
	debugInfo("we got id='" & id & "'")
	set sdContent = nothing
	if id <> "" then
		set sdContent = getTestimonialById(id)
	else
		set sdContent = Server.CreateObject("Scripting.Dictionary")
		sdContent.Add "Active","true"
		sdContent.Add "ShowEmail","true"
		sdContent.Add "SortOrder",idSortOrder
	end if
	dim i
	for i = 0 to sdContent.count - 1
			debug(pcase(strContent) & " Field " & i + 1 & ": '" & sdContent.keys()(i) & "' '" & sdContent.items()(i) & "'")
	next

	if sdContent("Active") then strActive = "checked"
	if sdContent("ShowEmail") then strShowEmail = "checked"
	with myForm
	'.CreateNew(formName, action)
	.addFieldset pcase(strContent) & " Content","<strong>Bold</strong> fields are required."
	.startNoteSection()
	.addNote "Customer Information","Fill in the Name, Email, and Extra Info with "_
					& "valid information to achieve best presentation on your site."
	.addNote "Public Email?","A public email means that on the live site's " & pcase(strContentPL) & "" _
					& "page, the <strong>Customer's Name</strong> will appear as an  <acronym " _
					& "title=""the hyperlink will appear as 'mailto:customername@domain.com'"">email " _
					& "hyperlink</acronym> that when clicked, will allow you to compose " _
					& "an email addressed to said customer in the website- viewer's mail client."
	.addNote "Advanced Message Editing","If you know what you are doing, the content "_
					& "may be formatted with <acronym title=""HyperText Markup Language"">HTML</acronym>. "_
					& "Advanced administrators only, please!"
	.endNoteSection()
	if not (.isForNewContent = true) then .addFormInput "", "", strKey, "hidden", "", sdContent(strKey), "", ""
	.addFormInput "required", "Customer's Name", strIdField, "text", "", sdContent(strIdField), DBTEXT, ""
	.addFormInput "optional", "Customer's Email", "Email", "text", "email", sdContent("Email"), DBTEXT, ""
	.addFormInput "optional", "Display Order", "SortOrder", "text", "", sdContent("SortOrder"), DBTEXT, ""
	.addFormInput "optional", "Extra Info", "Location", "text", "", sdContent("Location"), DBTEXT, "eg, Location, Title, or Profession."
	.addFormInput "required", "Testimonial Date", "TestimonialDate",  "text", "date", sdContent("TestimonialDate"), DBTEXT, ""
	.addFormGroup "checkbox", "optional", "Display Options", ""
	.addFormInput "optional", "Make email address public?", "ShowEmail", "checkbox", "compact", "Yes", strShowEmail, ""
	.addFormInput "optional", "Make this " & strContent & " visible on live website?", "Active", "checkbox", "compact", "Yes",  strActive, ""
	.endFormGroup()
	.addFormInput "required wide", "Customer's Comments", "Comments",  "textarea", "simple expanding", sdContent("Comments"), " rows=""15""" & DBMEMO, "Please enter the customer's " & strContent & ". See the side note on <strong>Advanced Content Editing</strong> for more details."
	.addFormSubmission "left", "Submit &raquo;", "", "", ""
	.endFieldset()

	buildFormContents = .getContents()
	end with
end function
%>
