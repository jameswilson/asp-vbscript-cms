<%
dim feed_url : feed_url = eval("m_feed_url")
dim feed_article : feed_article =eval("m_feed_article")
dim show_title : show_title = eval("m_show_title")
dim show_description : show_description = eval("m_show_description")
dim show_number_words : show_number_words = eval("m_show_number_words")
dim show_description_article : show_description_article = eval("m_show_description_article")
dim show_article : show_article = eval("m_show_article")
dim show_total_results : show_total_results = eval("m_show_total_results")
dim show_pubdate : show_pubdate = eval("m_show_pubdate")
dim show_image : show_image = eval("m_show_image")
dim show_anime : show_anime = eval("m_show_anime")
dim transition : transition = eval("m_transition")
dim strSelected, strActive, i

debug("mod_rss.fields: URL is: "&feed_url)
myForm.addFormGroup "checkbox","optional","RSS Feed Options",""
myForm.addFormInput  "required", "Feed URL", "mod_feed_url",  "text", "url", feed_url, DBTEXT,"A link to the location of the RSS Feed (eg, http://www.xyz.com/rss.xml)"
myForm.addFormSelect "required", "Show", "mod_feed_article", "", ""
myForm.addFormOption "mod_feed_article", "0", "All articles", iif(feed_article="0", SELECTED,"") 
myForm.addFormOption "mod_feed_article", "-1", "A random article", iif(feed_article="-1", SELECTED,"") & OPTION_DIVIDER
myForm.addFormOption "mod_feed_article", "1", "The latest article", iif(feed_article="1", SELECTED,"") & OPTION_DIVIDER
for i=2 to 20
myForm.addFormOption "mod_feed_article", ""& i, i &" latest articles" , iif(feed_article=""& i, SELECTED,"")
next
myForm.EndFormSelect("Select the number of articles to be displayed.")
myForm.addFormInput  "optional", "Show feed title", "mod_show_title",  "checkbox", "", "1", iif(show_title="1",CHECKED, "") ,""
myForm.addFormInput  "optional", "Show feed description", "mod_show_description",  "checkbox", "", "1", iif(show_description="1",CHECKED, "") ,""
myForm.addFormInput  "optional", "Show feed image", "mod_show_image",  "checkbox", "", "1", iif(show_image="1",CHECKED, "") ,""
myForm.addFormInput  "optional", "Show article count", "mod_show_total_results",  "checkbox", "", "1", iif(show_total_results="1",CHECKED, "") ,""
myForm.endFormGroup
myForm.addFormGroup "checkbox","optional","Animation Options",""
myForm.addFormInput  "optional", "Show article transition effects (for JavaScript-enabled browsers)", "mod_show_anime",  "checkbox", "", "1", iif(show_anime="1",CHECKED, "") ,""
myForm.addFormInput  "optional", "Transition Delay", "mod_transition",  "text", "", transition,"","Number of seconds to show each article."
myForm.endFormGroup
myForm.addFormGroup "checkbox","optional","Article Display Options",""
myForm.addFormInput  "optional", "Hyperlink article title", "mod_show_article",  "checkbox", "", "1", iif(show_article="1",CHECKED, "") ,""
myForm.addFormInput  "optional", "Show article publication date", "mod_show_pubdate",  "checkbox", "", "1", iif(show_pubdate="1",CHECKED, ""),""
myForm.addFormInput  "optional", "Show article body", "mod_show_description_article",  "checkbox", "", "1", iif(show_description_article="1",CHECKED, "") ,""
myForm.addFormInput  "optional", "Word Count", "mod_show_number_words",  "text", "",show_number_words, DBTEXT,"Trim the length of the article body to the specified number of words. Leave blank to use entire article body. Note: this also removes all HTML formatting in the body of the article. "
myForm.endFormGroup
%>