<!--#include file="../../core/include/global.asp" -->
<!--#include file="../../core/src/classes/class.rss-content-feed.asp" -->
<%
dim myForm
strDebugHTML.clear
getContent()
'printDebugHTML()
function getContent()
	dim settings, feed_url
	CreateDictionary settings,session("ModuleCustomSettings"),CUSTOMSETTINGS_RECORD_DELIMITER,CUSTOMSETTINGS_FIELD_DELIMITER,adDictOverwrite
	debug("mod_rss.display: starting mod_rss module....")
	if settings.exists("feed_url") then 
		feed_url = settings("feed_url")
		debug("mod_rss.display: feed_url to display: "&codeblock(server.htmlencode(feed_url)) )
				Dim rss
				Set rss= New RSSContentFeed
				'get content
				on error resume next
				rss.ContentURL = feed_url
				rss.GetRSS()
				if err.Number <> 0 then
					writeln Errormessage("Error: <br> "&err.Description)
					trapError
				exit function
				end if
				'display content
				if settings("show_title")="1" then writeln h3(rss.ChannelTitle)
				if settings("show_description")="1" then writeln "<p>"&rss.ChannelDescription&"</p>"
				Dim i, desc, max, min, j, js, transition
				max=cint(iif(len(settings("feed_article"))>0, settings("feed_article"), ubound(rss.Results)))
				min=0
				select case max
					 case -1 
					 		randomize
								max=int(rnd * ubound(rss.Results)+1)
								min=max-1
								
						case 0	
				 				max= ubound(rss.Results)+1
						case else
								max=iif(ubound(rss.results)<max,ubound(rss.results)+1,max)
				end select
				j=0
				transition=5000
				if isnumeric(settings("transition")) then
					transition=cint(settings("transition")*1000)
				end if
				js= "<script type=""text/javascript"">"&vbcrlf _
						&"<!--// <![CDATA["  & vbcrlf _
						&"var delay="&transition&" //pausa (en milisegundos)"&vbcrlf _
						&"var fcontent=new Array()"&vbcrlf _
						&"begintag=''"&vbcrlf _
						&"closetag=''"&vbcrlf _
						&"var ie4=document.all&&!document.getElementById"&vbcrlf _
						&"var ns4=document.layers"&vbcrlf _
						&"var DOM2=document.getElementById"&vbcrlf _
						&"var faderdelay=0"&vbcrlf _
						&"var index=0"&vbcrlf _
						&"if (DOM2) faderdelay=2000"&vbcrlf _
						&"frame=20;"&vbcrlf _
						&"hex=255  // Initial color value."&vbcrlf _
						&"window.onload=changecontent"&vbcrlf 
				writeln "<script type=""text/javascript"">document.write('<style type=""text/css""> div#fscroller{display:block;}</style>')</script>"
			 if settings("show_anime")="1" then
			  writeln "<div id=""fscroller"" style=""display:none;"">"&vbcrlf
			 else 
			 	writeln "<div id=""fscroller"">"&vbcrlf
			end if
				For i=min to max-1
					txt="<div class=""item"">" &vbcrlf
					if settings("show_article")="1" then
					txt= txt & h4(a(rss.Links(i), rss.Titles(i),"item"&i+1,"title"))
					else
						txt=txt & h4(rss.Titles(i))
					end if
					if settings("show_pubdate")="1" then txt=txt & "<small>"& rss.PubDates(i) &"</small><br>" &vbcrlf
					if settings("show_description_article")="1" then
						desc=HtmlDecode(replace((replace((rss.Descriptions(i)),"<![CDATA[","")),"]]>",""))
						if settings("show_number_words")<>"" and isnumeric(settings("show_number_words")) then
							dim length,ending,htmlCode
							length = cint(settings("show_number_words"))
							ending = "&hellip; <br>"& a(rss.Links(i), " more&hellip; ","item"&i+1,"more")
							set htmlCode = new RegExp
							htmlCode.pattern = "<[^>]+>"
							htmlCode.global = true
							desc=htmlCode.replace(desc,"") 'removes HTML tags
							desc=p(rss.Shorten(desc,length,ending)) 'shorten code
						end if
						txt=txt & div(desc,null,null,"description")
					end if
					if settings("show_images")="1" then 
						txt=txt & "<span class=""image""><img src="""& rss.Images(i) &""" /></span><br>" &vbcrlf
					else
						txt=txt & "<style type=""text/css""><!--.image, #fscroller img, #fscroller embed {display:none;}--></style>" &vbcrlf
					end if
					txt=txt &"</div>"&vbcrlf
					js=js&vbcrlf &"fcontent["&i&"]=""" & replace(replace(replace(txt,vbcrlf,""),"""","'"), "/", "\/") & """"
					writeln txt
					j=j+1
				Next
				if settings("show_total_results")="1" then writeln "<h4>"& j &" Article" & iif(j<>1,"s","") & "</h4>"&vbcrlf				
				writeln "</div>"&vbcrlf
				
				js="<script type=""text/javascript"" src="""&objLinks("SITEURL")&"/modules/mod_rss/fscroller.js""></script>"&vbcrlf&js&vbcrlf&"// ]]>-->"& vbcrlf&"</script>"&vbcrlf 
				
			  
			 if settings("show_anime")="1" and j>1 then writeln js
			
				Set rss= Nothing
	else
		debug("mod_rss.display: no feed_url found in this snippet.") 
	end if
end function


%>
