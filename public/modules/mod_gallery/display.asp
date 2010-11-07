<!--#include file="../../core/include/global.asp" -->
<!--#include file="../../core/src/classes/class.form.asp" -->
<%
dim myForm
strDebugHTML.clear
getContent()
'printDebugHTML()

function getContent()
	dim settings, content
	CreateDictionary settings,session("ModuleCustomSettings"),CUSTOMSETTINGS_RECORD_DELIMITER,CUSTOMSETTINGS_FIELD_DELIMITER,adDictOverwrite
	debug("mod_gallery.display: starting mod_gallery module....")
	set content = new FastString
	if not settings.exists("gallery_folder") then 
		content.add ErrorMessage(h1("Gallery Error")&p("Please specify a valid folder in the module settings."))
	else 
		dim gallery_folder : gallery_folder = settings("gallery_folder")
		dim thumb_width : thumb_width = cint(iif(len(settings("thumbnail_width"))>0,settings("thumbnail_width"),0))
		dim thumb_height : thumb_height = cint(iif(len(settings("thumbnail_height"))>0,settings("thumbnail_height"),0))
		dim max_images_per_page : max_images_per_page = cint(iif(len(settings("max_images_per_page"))>0,settings("max_images_per_page"),15))
		dim current_page :  current_page = iif(len(request.QueryString("page"))>0,request.QueryString("page"),1)
		dim slideshow : slideshow = iif(settings("slideshow")="1","lyteshow","lytebox")
		
		debug("mod_gallery.display: content to display: "&server.htmlencode(gallery_folder) )
		dim fileDict : set fileDict = getFilesInFolder(gallery_folder,".jpg,.gif,.jpeg,.png")
		
		dim thumb_size
		if thumb_width>0 or thumb_height>0 then 
			thumb_size = iif(thumb_width>thumb_height," width="""&thumb_width&""""," height="""&thumb_height&"""")
		else
			thumbs_size = ""
		end if
		if not isObject(fileDict) or fileDict is nothing then	
			content.add ErrorMessage(h1("Gallery Error")&p("No files could be found in folder "&gallery_folder))
		else
			debugInfo("mod_gallery.display: number of images "&fileDict.count)
			if fileDict.count > 0 then  
				dim filename, path, name, ext, url, thmb, lnk, page, num_pages
				content.add "<div class=""photo-gallery"">" & vbcrlf
				dim i : i = 0
				num_pages = 0
				debugInfo("mod_gallery.display: the current page is '"&current_page&"'.")
				for each fileName in fileDict
					i = i+1
					page = (i \ max_images_per_page) + 1
					path = fileDict(fileName)
					ext = mid(path,instrrev(path,"."),len(path))
					name = PCase(PrettyText(replace(replace(replace(fileName,ext,""),"."," "),"-"," ")))
					url = objLinks("SITEURL")&gallery_folder&"/"&fileName
					thmb = gallery_folder&"/_thumbs/"&fileName
					thmb_url = objLinks("SITEURL")&thmb
					if int(current_page) = int(page) then 
						thmb = iif( fileExists(thmb), thmb_url, url)
						thmb = "<img src="""&thmb&""" alt="""&name&""" class=""lightbox"""&thumb_size&"/>"
					else
						thmb = ""
					end if
					lnk = "<a href="""&url&""" rel="""&slideshow&"[gallery]"" title="""&name&""""
					lnk = lnk & iif( (thmb<>"") , ">"&thmb&"</a>" , " style=""display:none""></a>")
					
					debugInfo("mod_gallery.display: found file '"&name&"' url string '"&url&"' thumb is '"&thmb&"' and page is '"&page&"'")

					content.add lnk&vbcrlf
					'finally increment the number of pages if this file is a multiple of the max_images_per_page
					if i mod max_images_per_page = 1 then num_pages = num_pages + 1
					
				next
				if num_pages > 1 then
					content.add "<div id=""gallery-page-links"" style=""text-align:right;margin:1em;"">" &vbcrlf
					content.add "<script type=""text/javascript"">" &vbcrlf&"<!--"&vbcrlf
					content.add "document.write('<p style=""text-align:center;margin:1em;"">Click any image to start the slideshow.</p>');"&vbcrlf
					content.add "// -->"&vbcrlf&"</script>"
					content.add "<p>Pages "&vbcrlf
					for i = 1 to num_pages
						content.add iif((int(i)=int(current_page)),i,a("?page="&i,i,"Open page"&i&" of this gallery","")) & vbcrlf
					next
					content.add "</p></div>" & vbcrlf
				end if
				content.add link(objLinks("SITEURL")&"/scripts/lytebox/lytebox.css","stylesheet","text/css") &vbcrlf
				content.add "<script type=""text/javascript"" src="""&objLinks("SITEURL")&"/scripts/lytebox/lytebox.shrinksafe.packered.base64.shrunk-var.js""></script>"&vbcrlf
				'content.add link(objLinks("SITEURL")&"/test/lightbox/css/lightbox.css","stylesheet","text/css") &vbcrlf
				'content.add "<script type=""text/javascript"" src="""&objLinks("SITEURL")&"/test/lightbox/js/prototype.js""></script >"&vbcrlf
				'content.add "<script type=""text/javascript"" src="""&objLinks("SITEURL")&"/test/lightbox/js/scriptaculous.js?load=effects""/></script >"&vbcrlf
				'content.add "<script type=""text/javascript"" src="""&objLinks("SITEURL")&"/test/lightbox/js/lightbox.js""/>"&vbcrlf
				content.add "</div>"& vbcrlf
			end if
		end if
	end if
	writeln(globalVarFill(content.value))
end function
%>