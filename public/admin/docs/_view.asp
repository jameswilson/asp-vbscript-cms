<!--#include file="../../../core/src/functions/functions.source.asp"-->
<%

function contentView()
	myForm.isForNewContent = false
	'strHeader.add PCase(strContent) &" Manager"
	
	dim sf, sRoot, sPath
	
	
	'get any path supplied on the url or from post
	sPath = replace(request("view"), "\", "/")
	
	
	
	if len(sPath) > 0 then 
		'prepend the path with leading slash
		if instr(sPath,"/") <> 1 then sPath = "/" & sPath 
		
		'filter out any hackers
		if instr(sPath,"/~") = 1 or instr(sPath, "/..") > 0 then 
			strError = "The path provided, '" & sPath & "', is invalid."
			exit function
		end if
		
		'remove double slashes 
		sPath = replace(sPath, "//", "/") 
		
		set sf = new SiteFile
		sf.path = "/"& FILE_FOLDER &sPath
		
		'if the path doesnt exist as a file or folder in the site
		if not sf.fileExists() then 
			strError = "The path provided, '" & sPath & "', is invalid."
			exit function
		end if 
		
			'a possible file was specified
		if fs.fileExists(sf.absolutepath) then
			sendResponse(sf) 'feed the file to the user
			exit function
		end if
	end if


	' if the above section didnt find the path to be a file...
	' then continue to process it as if it were a folder
	sRoot = sPath & "/"	
	
	'remove double slashes 
	sRoot = replace(sRoot, "//", "/") 
		
	set sf = new SiteFile
	sf.path = "/" & FILE_FOLDER & sRoot
	
	

	' have the FileSystemObject prove the path is really a folder.
	if not fs.FolderExists(sf.absolutepath) then
		strError = "The folder provided, '" & sRoot & "', does not exist."
		exit function
	end if
	
	dim breadcrumb, paths, j, path, separator : paths = split(sRoot, "/")
	breadcrumb = "/"& a("?view=" & path, FILE_FOLDER, "Explore folder '" & FILE_FOLDER & "'", null) 
	for j=0 to ubound(paths)
		if len(paths(j))>0 then
			separator = "/"
			path = path & "/" & trim(paths(j))
			breadcrumb = breadcrumb & separator & a("?view=" & path, trim(paths(j)), "Explore folder '" & paths(j) & "'", null)
		end if
	next

	''' the following is for debug only
	'pageContent.add p("The Current folder is "& sRoot)
	'pageContent.add p("the absolute path is "& sf.absolutepath)
	'pageContent.add p("instr(path,'.')="& instr(sRoot,"."))

	pageContent.add h3("Folder: "& breadcrumb)
	

	
	dim fo, sfo, fi, stats, divider
	
	set fo=fs.GetFolder(sf.absolutepath)
	set sfo=fo.SubFolders
	set fi=fo.Files
	
	if sfo.count = 0 and fi.count = 0 then
		pageContent.add "" & vbCrLf _
		 &WarningMessage("There are currently no " & strContentPL & ". " _
		 &"Would you like to <a href='?create'>create the first one</a>?") & vbCrLf
	else
	
		stats = "The current folder has "
		if sfo.count > 0 then 
			stats = stats & sfo.count & " sub-folder"
			if sfo.count > 1 then stats = stats & "s"
			divider = " and "
		end if
		if fi.count > 0 then
			stats = stats & divider & fi.count & " file"
			if fi.count > 1 then stats = stats & "s"
		end if
		if len(divider)>0 then stats = stats & ", totaling " & sfo.count + fi.count & " items"
		stats = stats & "."	
		pageContent.add p(stats)
		
		pageContent.add "" & vbCrLf _
		 & "<form id='list' action='?edit' method='post'>" & vbCrLf _
		 & "<table id='pages' class='list sortable' width='100%' border='0' cellspacing='0' cellpadding='3'>" & vbCrLf _
		 & "<thead>" & vbCrLf _
		 & "<tr>" & vbCrLf _
		 & "<th width='2%' class='icon'>Type</th>" & vbCrLf _
		 & "<th>Name</th>" & vbCrLf _
		 & "<th>File Description</th>" & vbCrLf _
		 & "<th>Mime Type</th>" & vbCrLf _
		 & "<th>Size</th>" & vbCrLf _
		 & "<th width='12%'>Created</th>" & vbCrLf _
		 & "<th width='12%'>Modified</th>" & vbCrLf _
			& "<th width='5%' class='sorttable_nosort' colspan=4>Actions</th>" & vbCrLf _
			& "</tr>" & vbCrLf _
			& "</thead>" & vbCrLf _
		 & "" & vbCrLf _
		 & "" & vbCrLf
		 
		 
		
		dim strEven, strPath, strMime, strExt, subfo, x, i
		if sRoot <> "/" then
			set x = fo.ParentFolder
			strPath = left(sRoot, len(sRoot) - len(fo.name & "/"))
			pageContent.add "" & vbCrLf _
			 & "<tr class='file folder"& strEven &"'>"& vbCrLf _
			 & "<td class='parent-folder' sorttable_customkey='__"& x.name &"'><span>folder</span></td>"& vbCrLf _
			 & "<td><a href='?view=" & strPath & "' title='Browse parent folder [" & x.name &"]'>../</a></td>"& vbCrLf _
			 & "<td>Parent "& x.Type &"</td>" & vbCrLf _
			 & "<td></td>" & vbCrLf _
			 & "<td sorttable_customkey='"& x.Size &"'>"& formatSize(x.Size) &"</td>"& vbCrLf _
			 & "<td sorttable_customkey='"& x.DateCreated &"'>"& getRelativeDate(x.DateCreated) &"</td>"&  vbCrLf _
			 & "<td sorttable_customkey='"& x.DateLastModified &"'>"& getRelativeDate(x.DateLastModified) &"</td>"& vbCrLf _
			 & "<td class='action edit'><a class='edit action' href='?edit="& strPath &"' title='Edit this folder'>Edit</a></td>" & vbCrLf _
			 & "<td class='action view'><a class='view action' href='?view="& strPath &"' title='Open this folder'>Link</a></td>" & vbCrLf _
			 & "<td></td>" & vbCrLf _
			 & "<td></td>" & vbCrLf _
			 & "</tr>" & vbCrLf
			trapError
			i = i + 1
		end if
		for each x in sfo
			strPath = sRoot & x.name
			strEven = iif((i MOD 2 = 0), " even", "")
			pageContent.add "" & vbCrLf _
			 & "<tr class='file folder" & strEven & "'>" & vbCrLf _
			 & "<td class='folder'sorttable_customkey='_" & x.name & "'><span>folder</span></td>" & vbCrLf _
			 & "<td><a href='?view="& strPath &"' title='Browse " & x.name & " folder'>" & x.name & "</a></td>" & vbCrLf _
			 & "<td>" & x.Type & "</td>" & vbCrLf _
			 & "<td></td>" & vbCrLf _
			 & "<td sorttable_customkey='" & x.Size & "'>" & formatSize(x.Size) &"</td>" & vbCrLf _
			 & "<td sorttable_customkey='" & x.DateCreated & "'>" & getRelativeDate(x.DateCreated) & "</td>" & vbCrLf _
			 & "<td sorttable_customkey='" & x.DateLastModified & "'>" & getRelativeDate(x.DateLastModified) &"</td>" & vbCrLf _
			 & "<td class='action edit'><a class='edit action' href='?edit=" & strPath & "' title='Edit this folder'>Edit</a></td>" & vbCrLf _
			 & "<td class='action view'><a class='view action' href='?view=" & strPath & "' title='Open this folder'>Link</a></td>" & vbCrLf _
			 & "<td></td>" & vbCrLf _
			 & "<td class='action delete'><a class='delete action' href='?delete=" & strPath & "' title='Delete this folder " & x.name & "' onclick=""return confirm('Really delete folder \'" & strPath & "\'?')"">Delete</a></td>" & vbCrLf _
			 & "</tr>" & vbCrLf
			trapError
			i = i + 1
		next
		for each x in fi
			strPath = sRoot & x.name
			strEven = iif((i MOD 2 = 0), " even", "" )
			strMime = getMimeType(x.name)
			strExt = mid(x.name, instrrev(x.name,".") + 1)
			pageContent.add "" & vbCrLf _
			 & "<tr class='file" & strEven&"'>" & vbCrLf _
			 & "<td class='file " & replace(replace(strMime,"/"," "), ".", " ") & "'sorttable_customkey='" & strExt & "_" & x.name & "'><span>" & strMime & "</span></td>" & vbCrLf _
			 & "<td><a href='?view=" & strPath & "' title='Download " & x.name & "'>" & x.name & "</a></td>" & vbCrLf _
			 & "<td>"& x.Type &"</td>" & vbCrLf _
			 & "<td>"& strMime &"</td>" & vbCrLf _
			 & "<td sorttable_customkey='" & x.Size &"'>"& formatSize(x.Size) &"</td>" & vbCrLf _
			 & "<td sorttable_customkey='" & x.DateCreated &"'>"& getRelativeDate(x.DateCreated) &"</td>" & vbCrLf _
			 & "<td sorttable_customkey='" & x.DateLastModified &"'>"& getRelativeDate(x.DateLastModified) &"</td>" & vbCrLf _
			 & "<td class='action edit'><a class='edit action' href='?edit="& strPath &"' title='Edit this "& strContent &"'>Edit</a></td>" & vbCrLf _
			 & "<td class='action view'><a class='view action' href='"& sf.virtualPath & x.name & "' title='Link to this " & strContent & "'>Link</a></td>" & vbCrLf _
			 & "<td class='action download'><a class='download action' href='?view=" & strPath & "& dl=1' title='Download this " & strContent & "'>Download</a></td>" & vbCrLf _
			 & "<td class='action delete'><a class='delete action' href='?delete=" & strPath & "' title='Delete " & strContent & " " & x.name & "' onclick=""return confirm('Really delete " & strContent & " \'" & strPath & "\'?')"">Delete</a></td>" & vbCrLf _
			 & "</tr>" & vbCrLf
			trapError
			i = i + 1
		next
		
		
		
		pageContent.add "</table>" & vbCrLf _
		 & "<div class='buttonbar'><ul><li><a class='new button' title='New "& Pcase(strContent) &"' href='?create'>Add a "& strContent &"</a></li></ul></div>" & vbCrLf _
		 & "</form>" & vbCrLf _
		 & "" & vbCrLf _
		 & "<script type=""text/javascript"" src="""& globals("SITEURL") &"/core/assets/scripts/sorttable.js""></script>" & vbCrLf
		
	end if
end function

function formatSize(fileSize)
	if Clng(fileSize) < 1024 then
		formatSize = fileSize & " bytes"
	else
		formatSize = Clng(fileSize / 1024) & " KB"
	end if
end function


function getMimeType(path)
	dim sExt, sMIME, objShell
	sExt = mid(path,instrrev(path,"."),len(path))
	
'	on error resume next
'		' Now we have the extension, the file's MIME type is held in the registry at
'		' HKEY_CLASSES_ROOT.<ext>Content Type
'		' Create an instance of Wscript.Shell to let us read the registry
'		set objShell = Server.CreateObject("Wscript.Shell")
'		' Get the MIME type
'		sMIME = objShell.RegRead("HKEY_CLASSES_ROOT\" & sExt & "\Content Type")
'		set objShell = nothing
'	on error goto 0
	
	
	if len(sMIME) = 0 then
		Select Case sExt
			Case ".pdf"
			sMIME = "application/pdf"
			Case ".doc",".dot"
			sMIME = "application/msword"
			Case ".xls",".xla",".xlc",".xlm",".xlt",".xlw"
			sMIME = "application/vnd.ms-excel"
			Case ".ppt",".pot",".pps"
			sMIME = "application/vnd.ms-powerpoint"
			Case ".mpp"
			sMIME = "application/vnd.ms-project"
			Case ".wcm",".wdb",".wks",".wps"
			sMIME = "application/vnd.ms-works"
			Case ".mdb"
			sMIME = "application/vnd.msaccess"
			Case ".zip",".7zip",".7z",".rar"
			sMIME = "application/zip"
			Case ".z"
			sMIME = "application/x-compress"
			Case ".tar"
			sMIME = "application/x-tar"			
			Case ".gz"
			sMIME = "application/x-gzip"
			Case ".rtf"
			sMIME = "application/rtf"
			
			Case ".gif"
			sMIME = "image/gif"
			Case ".ico"
			sMIME = "image/x-icon"
			Case ".jpg", ".jpeg", ".jpe"
			sMIME = "image/jpeg"
			Case ".png"
			sMIME = "image/png"
			Case ".bmp"
			sMIME = "image/bmp"
			Case ".svg"
			sMIME = "image/svg+xml"
			Case ".tif",".tiff"
			sMIME = "image/tiff"
			
			Case ".wav"
			sMIME = "audio/wav"
			Case ".mp3"
			sMIME = "audio/mpeg3"
			Case ".aac"
			sMIME = "audio/aac"
			Case ".flac"
			sMIME = "audio/flac"
			Case ".ogg"
			sMIME = "application/ogg"
			Case ".wma"
			sMIME = "audio/x-ms-wma"
			
			Case ".mpg", ".mpeg",".mp2",".mpa",".mpe",".mpv2"
			sMIME = "video/mpeg"
			Case ".mp4", ".mpeg4"
			sMIME = "video/mpeg4"
			case ".mov",".qt"
			sMIME = "video/quicktime"
			Case ".asf",".asx",".asr"
			sMIME = "video/x-ms-asf"
			Case ".avi"
			sMIME = "video/avi"
			Case ".fla"
			sMIME = "application/x-shockwave-flash"
			Case ".flv"
			sMIME = "video/flv"
			Case ".swf"
			sMIME = "application/x-shockwave-flash"		
			
			case ".txt",".inc",".c",".h"
			sMIME = "text/plain"
			Case ".htm", ".html",".stm"
			sMIME = "text/html"
			Case ".xml", ".xsl", ".xslt"
			sMIME = "text/xml"
			Case ".xhtml"
			sMIME = "text/xhtml+xml"
			Case ".asp"
			sMIME = "text/asp"
			Case ".aspx"
			sMIME = "text/aspx"
			Case ".js"
			sMIME = "application/javascript"	
			Case ".es"
			sMIME = "application/ecmascript"	
			Case ".css"
			sMIME = "text/css"
			Case ".vb"
			sMIME = "application/vbscript"
			case ".py"
			sMIME = "application/python"
			case ".pl"
			sMIME = "application/perl"
			
			Case Else
			'Handle All Other Files. This will prompt
			' the user with the "Open or Save to disk" dialogue.
			sMIME = "application/octetstream"
		End Select	
	end if
	getMimeType = sMIME
end function

function sendResponse(objSiteFile)
	dim act, strFileName, strMimeType
	dim textDisplay : set textDisplay = new RegExp
	textDisplay.pattern = "text|html|xhtml|xml|python|perl|java|vb|script"
	
	strFileName = objSiteFile.name
	strMimeType = getMimeType(strFileName)
	
	response.clear
	' if a download has been requested, set the type to 
	' application/octetstream (regardless of the real mimetype)
	' in order to enforce the browser's "Save As" file download pop-up dialog.
	if request("dl")="1" then strMimeType = "application/octetstream"
	
	
	if not textDisplay.test(strMimeType) then 
		response.contentType = strMimeType
		response.addHeader "Content-Disposition", "filename=" & strFileName & ";"
		Set act = server.createObject("ADODB.Stream")
		act.open
		'set the type to binary
		act.type = 1
	 'Load our file
		act.LoadFromFile objSiteFile.AbsolutePath
	 'And send it to the browser
	 	on error resume next
		response.binaryWrite act.Read
		on error goto 0 
		if err.number<>0 then
			set act = fs.opentextfile(objSiteFile.AbsolutePath)
			if not act.AtEndOfStream then response.write getHTMLHeader(objSiteFile) & getFormatAspJsHtmlAdoSource(act.readall) & getHTMLFooter()
		end if
	else
		set act = fs.opentextfile(objSiteFile.AbsolutePath)
		if not act.AtEndOfStream then response.write getHTMLHeader(objSiteFile) & getFormatAspJsHtmlAdoSource(act.readall) & getHTMLFooter()
	end if
	
	response.flush
	response.end
	act.Close
	Set objStream = Nothing
end function


function getHTMLHeader(objSiteFile)
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><%=objSiteFile.Name%></title>
<link rel="stylesheet" type="text/css" href="<%=globals("SITEURL")%>/core/assets/style/sourcecode.css">
</head>
<body>
<h3>File: <%=objSiteFile.Name%> (<a href="<%=request.ServerVariables("URL") &"?"& request.QueryString()%>&dl=1" title="Download this file">download file</a>)</h3>
<dl>
<dt></dt><dd></dd>
</dl>

<%
end function

function getHTMLFooter()
%>
</body>
</html>
<%
end function
%>