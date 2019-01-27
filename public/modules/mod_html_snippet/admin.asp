<%
dim mycontent : mycontent = Server.HtmlEncode(eval("m_content"))
debug("mod_html_snippet: the content is: "&mycontent)
myForm.addFormInput "optional", "Text/HTML Snippet", "mod_content","textarea","simple wide", mycontent, DBTEXT,"Enter a short bit of HTML to have included in the rendering of your page."
%>
