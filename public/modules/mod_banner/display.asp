<!--#include file="../../../core/include/bootstrap.asp" -->
<!--#include file="../../../core/src/classes/class.form.asp" -->
<%
'logger.clear
writeln getBanner()
'logger.debug_dump

function getBanner()
	dim a,i,ts,bannerFile,bannerFileName,banners,content,line,settings
	CreateDictionary settings,session("ModuleCustomSettings"),CUSTOMSETTINGS_RECORD_DELIMITER,CUSTOMSETTINGS_FIELD_DELIMITER,adDictOverwrite
	
	debug("mod_banner: starting mod_banner module....")

'on error resume next 
	err.clear
	if not settings.exists("banner_file") then
		debugError("mod_banner: no banner file was specified!")
		exit function
	end if
	
	bannerFileName = settings("banner_file")  '"/banner.txt"
	trace("mod_banner: initializing banner ad from file '"&bannerFileName&"'")
	set bannerFile = new SiteFile
	bannerFile.Path = bannerFileName

	if not bannerFile.fileExists() = true then
		debugError("mod_banner: banner file '"&bannerFile.getPath&"' does not exist")
		exit function
	end if
	
	set a = new FastString
	trace("mod_banner: opening text file...")
	err.clear
	set ts = fs.openTextFile(bannerFile.AbsolutePath,1,0)
	i=0
	do until ts.atEndOfStream
		'trace("mod_banner: reading line...")
		i=i+1
		line = ts.ReadLine
		line = trim(line)
		if line <> "" and instr(line,"#")<>1 then 
			trace("mod_banner: line "&i&" added '"&line&"' ")
			a.add vbCrLf&line
		else
			trace("mod_banner: line "&i&" ignored '"&line&"'") 
		end if
		
	loop
	trace("mod_banner: content for processing is  <br/>"&replace(a.value,""& vbCrLf,"<br/>"))
	if err.number <> 0 then
		debugError("mod_banner: there was an error reading/opening file "&bannerFileName)
		debugError("VBScript ERROR [" &  Err.number & "] (Ox"& Hex(Err.number) & "): " & Err.description & vbCrLf _
						& "URL: "&request.ServerVariables("URL") _
						& "SOURCE: "&Err.source _
						& "LINE: "&Err.line)
		trapError
		exit function
	end if
	banners = split(a.value,""& vbCrLf)
	a.clear
	set a = nothing
	if err.number <> 0 then
		debugError("mod_banner: there was an error processing the file "&bannerFileName)
		trapError
		exit function
	end if
	
	trace("mod_banner: There are "&ubound(banners)&" banner files. The banners to choose from are: ")
	for i=0 to ubound(banners)
		trace("getBanner("&i&"): Banner "&i&": "&banners(i))
	next
	Randomize
	dim rand, text, banner, link, dimensions, width, height
	dim bannerImg : set bannerImg = new SiteFile
	i=0
	do 
		text = globals("SITE_NAME")
		link = ""
		dimensions = null
		width = null
		height = null
		rand = Int(Rnd * ubound(banners)+2)-1
		i = i + 1
		trace("mod_banner: Random number was: "&rand)
		if len(banners(rand))>0 then 
			banner = split(trim(banners(rand)),";")
			if banner(0) <> "" then
				bannerImg.Path = trim(banner(0)) 
				debug("mod_banner: banner image file: "&banner(0))
			end if
			if 1 <= ubound(banner) then 
				text = banner(1)
				debug("mod_banner: banner text is: "&text)
			end if	
			if 2 <= ubound(banner) then 
				link = banner(2)
				debug("mod_banner: banner link is: "&link)
			end if
			if 3 <= ubound(banner) then
				dimensions = split(banner(3),"x")
			  width = trim(dimensions(0))
				height = trim(dimensions(1))
			  debug("mod_banner: banner width is:"&width)
				'debug("mod_banner: banner height is:"&height)
			end if
		end if
	loop until bannerImg.fileExists or i>ubound(banners)
	
	trace("mod_banner: banner url is '"&bannerImg.Url&"'")
	if link <> "" then response.write( "<a href="""&link&""" title="""&text&""">")
	response.write( mediaFile(bannerImg.Url,text,"banner",width,height))
	'response.write( "<img src="""&bannerImg.Url&""" class=""banner-image"" alt="""&text&""" title=""Site Banner""/>" )
	if link <> "" then response.write( "</a>" )
end function
%>

