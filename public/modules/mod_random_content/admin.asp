<%
dim parent_page_id : parent_page_id = eval("m_parent_page_id")
dim content_pre : content_pre = eval("m_content_pre")
dim content_post : content_post = eval("m_content_post")
dim strSelected, strActive

debug("mod_random_content.fields: the parent page id is: " & parent_page_id)
debug("mod_random_content.fields: the pre content is: " & content_pre)
debug("mod_random_content.fields: the post content is: " & content_post)

myForm.addFormSelect "required", "Parent Page", "mod_parent_page_id","selectOne", ""
if cint(parent_page_id) = 0 then strSelected = "selected"
myForm.addFormOption "mod_parent_page_id", "0", "All", strSelected
set rs = db.getRecordSet("SELECT * FROM tblPages ORDER BY Active, MainMenu, MenuIndex, ParentPage;")
if not (rs.EOF and rs.BOF) then
rs.movefirst
do until rs.EOF
	strSelected = ""
	strActive = " [Inactive]"
	if (rs("Active")) then strActive = " [Active]"
	strLabel = rs("PageName") & strActive
	if cint(parent_page_id) = cint(rs("PageId")) then strSelected = "selected"
	if rs("ParentPage") > 0 then strLabel = ".." & strLabel
	myForm.addFormOption "mod_parent_page_id", rs("PageId"), strLabel, strSelected
	rs.movenext
loop
end if
myForm.endFormSelect("Content will be selected randomly from one of the sub-pages of the page selected here.")

myForm.addFormInput "required", "Content Before", "mod_content_pre",  "textarea", "simple", content_pre, DBTEXT,"Static Text/HTML to appear above the random content."
myForm.addFormInput "required", "Content After", "mod_content_post",  "textarea", "simple", content_post, DBTEXT, "Static Text/HTML to appear below the random content."
%>
