<!--#include file="../../../core/src/classes/class.form.asp"-->
<%
dim SEO_NOTE : SEO_NOTE = h5("Search Engine Optimization") & p("Obtaining and maintaining a high Search Engine Ranking is not only a goal but a pre-requisite for websites these days. Creating solid, unique page content is the most important factor to achieve good Rankings. Additionally, optimizing your page with a keyword rich <strong>Page Title</strong> is the second most important factor.")
function buildFormContents(id)
	dim sdContent
	strActive = ""
	strMainMenu = ""
	dim rs, checked, active, sReadWrite, intMenuIndex
	intMenuIndex = 0
	dim strSelected : strSelected = ""
	sReadWrite = ""
	if not (user.getRole >= USER_ADMINISTRATOR) then sReadWrite = READONLY

	if id <> "" then
		set sdContent = page.getPageDataById(id)
	else
		set sdContent = Server.CreateObject("Scripting.Dictionary")
		sdContent.Add "Active", cstr(TRUE)
		sdContent.Add "MainMenu", cstr(TRUE)
	end if
	if cstr(sdContent("Active")) = cstr(TRUE) then strActive = "checked"
	if cstr(sdContent("MainMenu")) = cstr(TRUE) then strMainMenu = "checked"

	with myForm
	.Clear
	if not (myForm.isForNewContent = TRUE) then .addFormInput "", "", strKey, "hidden", "", sdContent(strKey), "", ""
	.addFieldset "Content", "Please fill out this form with quality content and detailed supporting data. Note: <strong>Bold</strong> fields are required."
	.startNoteSection()
	'.addNote "Advanced Content Editing", "If you know what you are doing, the " & PCase(strContent) & "  "_
	'				& "Content may be formatted with <acronym title=""HyperText "_
	'				& "Markup Language"">HTML</acronym>. Advanced administrators "_
	'				& "only, please!"
	.addNote "Page Name", "This is a short name of the page as it appears in menus and links throughout your site."
	.addNote "Page Title", "In adition to serving as <acronym title=""Search Engine Results Page"">SERP</acronym>s page hyperlink text, the page title is also used in the browser window of "_
					& "your site visitor's, as well as when visitors bookmark it. The absolute max length is 120 " _
					& "characters -- Internet Explorer browser cuts off after 95 characters.  Optimally, keep "_
					& "your title within <strong>66 characters</strong> for Google ranking."

	.endNoteSection()
	.addFormInput "required", "Page Name", strIdField, "text", "", sdContent(strIdField), DBTEXT, "Limit to one or two words."
	.addFormInput "required", "Page Title**", "PageTitle", "textarea", "simple length:0,120", sdContent("PageTitle"), " rows=""3""","This single text containing important page keywords helps sumarize the page. See the side note on Page Title."
	.addFormInput "required full", "Page Content", "PageContent", "textarea", "expanding", token_decode(sdContent("PageContent"), variableList), " rows=""15""" & DBMEMO ,"Please enter the text/html that will appear on the " & sdContent(strIdField) & ". <br /><strong>Advanced Editing:</strong><br />If you know what you are doing, the " & PCase(strContent) & "  "_
					& "Content may be formatted with <acronym title=""HyperText "_
					& "Markup Language"">HTML</acronym>."
	.addFormSubmission "left", "Submit &raquo;", "", "", ""
	.endFieldset()

	.addFieldset "Display", "<strong>Bold</strong> fields are required."
	.startNoteSection()
	.addNote "File Name", "The file name cannot be modified without taking further "_
					& "actions on your webserver. Please contact " & globals("DEVELOPER_SUPPORT_LINK") & " " _
					& "if you need to modify the file name."
	.addNote "Display Options", "An enabled (checkbox checked) page will be visible "_
					& "in menus and linkable on the site. Unchecked box here means a "_
					& "page is removed from menus and attempts to open the page directly"_
					& "will result in a redirect	to the homepage."
	.endNoteSection()

	.addFormInput "required", "<acronym title='Uniform Resource Locator'>URL</acronym>", "PageFileName", "text", "", sdContent("PageFileName"), sReadWrite & DBTEXT, ""

	dim css_root : set css_root = new SiteFile
	css_root.path = CSS_FOLDER

	if not css_root.fileExists then
		dim note : note = "The default Style Layout directory could not be found! Please specify the path to the css file to use for css page style."
		myForm.addFormInput "optional", "Style Layout", "Style", "text", "", CSS_FOLDER, DBTEXT, note
	else
		myForm.addFormSelect "optional", "Style Layout", "Style", "selectOne", ""
		dim style_layout
		for each style_layout in css_root.getFiles(".css")
			if left(style_layout, 1) <> "_" and left(style_layout, 1) <> "." then
				debug("getting style folder list for " & css_root.VirtualPath & "/" & style_layout)				'myForm.addFormOption "mod_gallery_folder", currentFolder & "/" & folder.name, currentFolder & "/" & folder.name, strSelected
				myForm.addFormOption "Style", style_layout, style_layout, iif(lcase(style_layout) = lcase(sdContent("Style")), SELECTED, "")
			end if
		next
		myForm.endFormSelect("")
	end if

	.addFormSelect "optional", "Parent Page", "ParentPage", "", sReadWrite
	if cint(sdContent("ParentPage")) = 0 then strSelected = SELECTED
	.addFormOption "ParentPage", "0", "None", strSelected
	set rs = db.getRecordSet("SELECT * FROM " & strTableName & " ORDER BY Active, MainMenu, MenuIndex, ParentPage;")
	if not (rs.EOF and rs.BOF) then
		rs.movefirst
		do until rs.EOF
			strSelected = ""
			active = " [Inactive]"
			if (rs("Active")) then active = " [Active]"
			if (cint(rs(strKey)) = cint(sdContent("ParentPage"))) then strSelected = SELECTED
			.addFormOption "ParentPage",  rs(strKey), rs(strIdField) & active, strSelected
			rs.movenext
		loop
	end if
	.endFormSelect("")
	if .isForNewContent then
		set rs = db.getRecordSet("SELECT Max(MenuIndex) AS MenuIndex FROM " & strTableName & " WHERE (((" & strTableName & ".ParentPage)=0));")
		intMenuIndex = rs("MenuIndex") + 1
	else
		intMenuIndex = sdContent("MenuIndex")
	end if
	.addFormInput "optional", "Menu Order", "MenuIndex", "text", "", intMenuIndex, DBTEXT, "The order in which this page will appear if shown in the main menu."
	.addFormGroup "checkbox", "optional", "Display Options", ""
	.addFormInput "optional", "List this page in your public site's Main Menu?", "MainMenu", "checkbox", "", "Yes", strMainMenu, ""
	.addFormInput "optional", "Enable page access on live website?", "Active", "checkbox", "", "Yes",  strActive, ""
	.endFormGroup()
	.addFormSubmission "left", "Submit &raquo;", "", "", ""
	.endFieldset()


	.addFieldset "Meta Information", "<strong>Bold</strong> fields are required."
	.startNoteSection()
	.addNote "What is Metadata?", "Metadata is data about data, put plainly, its the important information explaining the regular " _
					& "content page you want to view. This information, while not directly visible to the web surfer is " _
					& "recognized by most search engines. Having quality metadata embeded in the html of each page of your site" _
					& "can greatly improve your Search Engine Rankings.<br /><br />For more questions about optimizing your website <a "_
					& "href=""mailto:" & globals("DEVELOPER_EMAIL") & "?Request info about Search Engine Optimization"" " _
					& "title=""Request info about Search Engine Optimization"">contact " & globals("DEVELOPER_SHORTNAME") & "</a> "
	.addNote "Keywords","Keywords and phrases are specially chosen terms that pertain to and summarize the content on the page. "_
					& "Keep your most important keywords and phrases within the first 100 characters. Individual words &amp; phrases "_
					& "separated by commas with no spaces between words, up to 500 characters in length."
	.addNote "Hover Text","Hover text is a short description, that appears when you hold " _
					& "the cursor over a menu item, or a page link in any other place " _
					& "for a few seconds."
	.endNoteSection()
	.addFormInput "optional", "Description", "PageDescription", "textarea", "simple length:0,250", sdContent("PageDescription"), " rows=""3""" & DBTEXT, "Sentence/s of up to 250 characters in total length that describes this page."
	.addFormInput "optional", "Keywords", "PageKeywords", "textarea", "simple length:0,500", sdContent("PageKeywords"), " rows=""3""" & DBTEXT, "<em>Space-separated</em> list of keywords, or <em>comma-separated</em> list of key phrases."
	.addFormInput "optional", "Link Hover Text", "PageLinkHoverText", "text", "", sdContent("PageLinkHoverText"), DBTEXT, "A very short descriptive phrase that appears when you hold the cursor over a link to this page."
	.addFormSubmission "left", "Submit &raquo;", "", "", ""
	.endFieldset()



	buildFormContents = WarningMessage(SEO_NOTE) & .getContents()
	end with
end function
%>
