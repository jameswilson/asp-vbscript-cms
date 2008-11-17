<%

class SiteMap
	private m_forbiddenFolders
	private m_validExtensions
	private m_list
	
	sub Class_Initialize()
		set m_forbiddenFolders = new RegExp
		m_forbiddenFolders.pattern = "^(admin|core|include|modules|scripts|styles|tango|test|\.svn|_thumbs)$"
		m_forbiddenFolders.ignorecase = true
		m_forbiddenFolders.global = false	
		
		set m_validExtensions = new RegExp
		m_validExtensions.pattern = "(doc|gif|html|htm|jpg|pdf|png)$"
		m_validExtensions.ignorecase = true
		m_validExtensions.global = false	
		
		m_list = UNORDERED
	end sub 
	
	sub Class_Terminate()
		set m_validExtensions = nothing
		set m_forbiddenFolders = nothing
	end sub

	public property get UNORDERED()
		UNORDERED	= "ul"
	end property
	public property get ORDERED()
	  ORDERED = "ol"
	end property
	public property let ListType(byval strHTMLListTag)
		m_list = strHTMLListTag
	end property

	public function HTML()
		HTML = List(0,0,"list")
	end function
	
	' SiteMap.XML clears the current response object and 
	' sends an XML formatted sitemap document to the browser/robot.
	public function XML()
		response.clear()
		response.ContentType = "text/xml"
		writeln("<?xml version=""1.0""?>")
		writeln("<urlset "_
		&"xmlns:xsi=""http://www.w3.org/2001/XMLSchema-instance"" "_
		&"xmlns:xsd=""http://www.w3.org/2001/XMLSchema"" "_
		&"xmlns=""http://www.sitemaps.org/schemas/sitemap/0.9"">")
		writeln(CrawlPages(0))
		writeln(CrawlSite(objLinks("SITE_PATH")))
		writeln("</urlset>")
		response.end()
	end function
	
	private function CrawlPages(byval sId)
		dim rs, sql, result, i, sFile, modDate
		sql = "SELECT tblPages.PageId, tblPages.Active, tblPages.PageFileName, tblPages.MainMenu, tblPages.MenuIndex, tblPages.ParentPage, tblPages.CreateDate, Max(tblPageContent.ModifiedDate) AS ModifiedDate, Count(tblPageContent.ContentID) AS NumberPageEdits"_
			&" FROM tblPages LEFT JOIN tblPageContent ON tblPages.PageId = tblPageContent.PageId"_
			&" where Active=true and ParentPage= " & sId &" "_
			&" GROUP BY tblPages.PageId, tblPages.Active, tblPages.PageFileName, tblPages.MainMenu, tblPages.MenuIndex, tblPages.ParentPage, tblPages.CreateDate"_
			&" order by MenuIndex;"

		on error resume next
		set rs = db.getRecordset(sql)
		i = 0
		set sFile = new SiteFile
		
		do while not rs.EOF
			sFile.path = rs("PageFileName")
			modDate = iif(isNull(rs("ModifiedDate")),rs("CreateDate"),rs("ModifiedDate") )
			writeln "<url>"
			writeln "<loc>" & sFile.URL & "</loc>"
			writeln "<priority>" & prioritizePage(rs) & "</priority>"
			writeln "<lastmod>" & formatDate("%Y-%m-%dT%h:%i:%s+00:00",modDate) & "</lastmod>"
			writeln "</url>"
			response.Flush()
			CrawlPages(rs("PageId"))
			rs.moveNext
		loop
		set rs = nothing
	end function
	
	private function CrawlSite(byval sFolder)
		CrawlSite = ""
		if isNull(sFolder) or sFolder = "" then
			debugError("must provide a valid folder from which to start... try objLinks(""SITEPATH"")")
			exit function
		end if
		if not fs.folderExists(sFolder) then 
			debugError("folder '"&sFolder&"' does not exist" )
			exit function
		end if
		dim folder, file, sFile
		set folder = fs.getFolder(sFolder)
		for each file in folder.Files
			if m_validExtensions.test(file.name) then
				set sFile = new SiteFile
				sFile.path = file.path
				writeln "<url>"
				writeln "<loc>" & trim(sFile.URL) & "</loc>"
				writeln "<priority>" & prioritize(sFile) & "</priority>"
				writeln "<lastmod>" & formatDate("%Y-%m-%dT%h:%i:%s+00:00",sFile.modifiedDate) & "</lastmod>"
				writeln "</url>"
				response.flush
			end if
		next
		for each folder in folder.SubFolders
			if not m_forbiddenFolders.test(folder.name) then 
				CrawlSite(folder.path)
			end if
		next
	end function
	
	private function prioritize(byref objFile)
		if not objFile is nothing and not isNull(objFile) then
			prioritize = prioritizeDate(objFile.modifiedDate)
		else
			prioritize = 0.5
		end if
	end function
	
	private function prioritizePage(byref rs)
		dim x
		dim d : d = iif(isNull(rs("ModifiedDate")),rs("CreateDate"),rs("ModifiedDate"))
		if not isNull(rs) and not rs is nothing then 
			x = prioritizeDate(d)
			y = cdbl(iif(rs("ParentPage")=0,0.1,0.0))
			'x = y+x 
		else
			x = 0.5
		end if
		prioritizePage = x
	end function
	
	
	' returns a decimal number between 0 and 1 the date specified. 
	private function prioritizeDate(byval sDate)
		dim decay : decay = -1/(24*90)  '(in 45 days data is officially "old" on the web)
		dim h : h = DateDiff("h",sDate,Now) 'how many hours ago is the date
		dim e : e = 2.7182818284590452353  'Euler's Number e for exponential decay
		
		h = Round(e*Exp(decay*h),1)
		h = replace(Cstr(h),"0,","0.")
		h = iif(cstr(h)="1","1.0",h)
		prioritizeDate = h
	end function
	
	
	
	' Returns an unordered, hierarchical list of pages and their subpages (aka, child pages).
	' The listing starts with the specified sId that represents the page id root of the search. 
	' sId = 0 .- lists all pages, starting at the site root.
	' sId = n .- lists all children of page with id n.
	' iLevel .- should always be zero, this value is incremented internally for each recursive step.
	' listId .- the id that should be applied to the generated unordered list's main ul element.
	private function List(byval sId,byval iLevel,byval listId)
		dim rs, result, sql, i, sNewId, sFile, sName, sHover, sClass
		'Check for the bottom of the tree
		if isNull(sId) then
			exit function
		end if
		set result = new FastString
		sql = "select * from tblPages where Active=true and ParentPage=" & sId & " order by MenuIndex;"
		set rs = db.getRecordset(sql)
		i = 0
		do while not rs.EOF
			sFile = rs("PageFileName")
			sName = rs("PageName")
			sHover = rs("PageLinkHoverText")
			sNewId = rs("PageId")
			sClass = ""
			rs.MoveNext
			if i=0 then
				sClass = sClass & " first"
				if iLevel = 0 then 
					result.add "<"&m_list&" id="""&listId&"""" & vbcrlf
				else
					result.add m_list&" class=""l"&iLevel&"""" & vbcrlf
				end if
			end if
			if rs.EOF then
				sClass = sClass & " last"
			end if
			strLink =  CreateNavLink(sFile, sName, sHover, sClass)
			result.add indent(iLevel+1) & ">" & strLink & "<"
			'Recursive call to check for children
			result.add List(sNewId,iLevel+1,null)
			if rs.EOF and iLevel > 0 then
				result.add "/li></"&m_list&"></li"
			else
				result.add "/li" & vbcrlf
			end if
			i = i+1
		loop
		if not rs is nothing then
			rs.Close
		end if
		List = result.value
		set rs = nothing
		set result = nothing
	end function

end class

%>

