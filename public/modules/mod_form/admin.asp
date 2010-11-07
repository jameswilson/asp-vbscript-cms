<%
dim form_id : form_id = eval("m_form_id")
dim external_css : external_css = eval("m_external_css")

dim strSelected, strActive

debug("mod_form.fields: the form id is: "&form_id)
debug("mod_form.fields: the external css is: "&external_css)

myForm.addFormSelect "required", "Form", "mod_form_id","selectOne",""
if cint(form_id) = 0 then strSelected = "selected"
set rs = db.getRecordSet("SELECT DISTINCT FormID, * FROM tblForms WHERE FieldName = 'form_name';")
if not (rs.EOF and rs.BOF) then
rs.movefirst
do until rs.EOF
	strLabel = rs("FieldLabel")
	if cint(form_id) = cint(rs("FieldId")) then strSelected = "selected"
	myForm.addFormOption "mod_form_id", rs("FieldId"), strLabel, strSelected
	rs.movenext
loop
end if
myForm.endFormSelect "Please select the form to display."

myForm.addFormInput  "optional", "External CSS File", "mod_external_css",  "text", "", external_css, DBTEXT,"The path to the external css file (references from the project root /). If none is included will use the default css styles in modules/mod_form/form.css"

%>