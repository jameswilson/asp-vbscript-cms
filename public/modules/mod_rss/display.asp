<!--#include file="../../../core/include/bootstrap.asp" -->
<!--#include file="../../../core/src/classes/class.rss-content-feed.asp" -->
<%
dim myForm
logger.clear
getContent()
'logger.debug_dump
function getContent()
	dim settings, feed_url
	CreateDictionary settings, session("ModuleCustomSettings"),CUSTOMSETTINGS_RECORD_DELIMITER, CUSTOMSETTINGS_FIELD_DELIMITER, adDictOverwrite
	debug("mod_rss.display: starting mod_rss module....")
	if settings.exists("feed_url") then
		feed_url = settings("feed_url")
		debug("mod_rss.display: feed_url to display: " & codeblock(Server.HtmlEncode(feed_url)) )
		dim rss
		set rss= new RSSContentFeed
		'get content
		on error resume next
		rss.ContentURL = feed_url
		rss.GetRSS()
		if err.Number <> 0 then
			writeln Errormessage("Error: <br> " & err.Description)
			trapError
			exit function
		end if
		'display content
		if settings("show_title") = "1" then
			writeln h3(rss.ChannelTitle)
		end if
		if settings("show_description") = "1" then
			writeln "<p>" & rss.ChannelDescription & "</p>"
		end if
		dim i, desc, max, min, j, js, transition
		max = cint(iif(len(settings("feed_article")) > 0, settings("feed_article"), ubound(rss.Results)))
		min = 0
		select case max
			case -1
				randomize
				max = int(rnd * ubound(rss.Results) + 1)
				min = max - 1
			case 0
				max = ubound(rss.Results) + 1
			case else
				max = iif(ubound(rss.results) < max, ubound(rss.results) + 1, max)
		end select
		j = 0
		transition = 5000
		if isnumeric(settings("transition")) then
			transition=cint(settings("transition") * 1000)
		end if
		js = "<scr" & "ipt type=""text/javascript"">" & vbCrLf _
			& "<!--// <![CDATA["  & vbCrLf _
			& "var delay=" & transition & " //pausa (en milisegundos)" & vbCrLf _
			& "var fcontent=new Array()" & vbCrLf _
			& "begintag=''" & vbCrLf _
			& "closetag=''" & vbCrLf _
			& "var ie4=document.all&&!document.getElementById" & vbCrLf _
			& "var ns4=document.layers" & vbCrLf _
			& "var DOM2=document.getElementById" & vbCrLf _
			& "var faderdelay=0" & vbCrLf _
			& "var index=0" & vbCrLf _
			& "if (DOM2) faderdelay=2000" & vbCrLf _
			& "frame=20;" & vbCrLf _
			& "hex=255  // Initial color value." & vbCrLf _
			& "window.onload=changecontent" & vbCrLf
		writeln "<scr" & "ipt type=""text/javascript"">document.write('<style type=""text/css""> div#fscroller{display:block;}</style>')</scr" & "ipt>"
		if settings("show_anime")="1" then
			writeln "<div id=""fscroller"" style=""display:none;"">" & vbCrLf
		else
			writeln "<div id=""fscroller"">" & vbCrLf
		end if
		for i = min to max - 1
			txt = "<div class=""item"">" & vbCrLf
			if settings("show_article") = "1" then
				txt = txt & h4(a(rss.Links(i), rss.Titles(i), "item" & i + 1, "title"))
			else
				txt = txt & h4(rss.Titles(i))
			end if
			if settings("show_pubdate") = "1" then
				txt = txt & "<small>" & rss.PubDates(i) & "</small><br>" & vbCrLf
			end if
			if settings("show_description_article") = "1" then
				desc = HtmlDecode(replace((replace((rss.Descriptions(i)), "<![CDATA[", "")), "]]>", ""))
				if settings("show_number_words") <> "" and isnumeric(settings("show_number_words")) then
					dim length, ending, htmlCode
					length = cint(settings("show_number_words"))
					ending = "&hellip; <br>" & a(rss.Links(i), " more&hellip; ","item" & i + 1, "more")
					set htmlCode = new RegExp
					htmlCode.pattern = "<[^>]+>"
					htmlCode.global = true

					'strip any html tags
					desc = htmlCode.replace(desc, "")

					'shorten the description to max length
					desc = p(rss.Shorten(desc, length, ending))
				end if
				txt = txt & div(desc, null, null, "description")
			end if
			if settings("show_images") = "1" then
				txt = txt & "<span class=""image""><img src=""" & rss.Images(i) & """ /></span><br>" & vbCrLf
			else
				txt = txt & "<style type=""text/css""><!--.image, #fscroller img, #fscroller embed {display:none;}--></style>" & vbCrLf
			end if
			txt = txt & "</div>" & vbCrLf
			js = js & vbCrLf & "fcontent[" & i & "] = """ & replace(replace(replace(txt,vbCrLf,""), """", "'"), "/", "\/") & """"
			writeln txt
			j = j + 1
		next
		if settings("show_total_results") = "1" then
			writeln "<h4>" & j & " Article" & iif(j <> 1, "s", "") & "</h4>" & vbCrLf
		end if
		writeln "</div>" & vbCrLf
		js = "<scr" & "ipt type=""text/javascript"" src=""" _
			& globals("SITEURL") & "/modules/mod_rss/fscroller.js"">" _
			& "</scr" & "ipt>" & vbCrLf _
			& js & vbCrLf _
			& "// ]]>-->" & vbCrLf _
			& "</scr" & "ipt>" & vbCrLf
		if settings("show_anime") = "1" and j > 1 then
			writeln js
		end if

		set rss = nothing
	else
		debug("mod_rss.display: no feed_url found in this snippet.")
	end if
end function

%>
