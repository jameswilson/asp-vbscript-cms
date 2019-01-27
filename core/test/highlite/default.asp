<%@ LANGUAGE="VBSCRIPT" CODEPAGE="65001" %>
<!--#include file="../../core/src/functions/functions.source.asp"-->
<%
dim files : files = split("test1.asp,test2.asp,test3.asp,test4.asp,test5.js",",")
dim fs : set fs = createobject("scripting.filesystemobject")

Response.Write "<h1>Syntaxt highliting tests.....</h1>"
for each fi in files
	Response.Write "<h3>" & fi & "</h3>"
	doHilite(fi)
next


function doHilite(filename)

	dim path : path = Server.MapPath(filename)

	dim act, strFileName, strMimeType
	strFileName = filename
	strMimeType = getMimeType(strFileName)


	'Response.Clear
	if inStr(strMimeType, "text") = 0 and inStr(strMimeType, "javascript") = 0 then
		Response.contentType = strMimeType
		Response.AddHeader "Content-Disposition", "filename=" & strFileName & ";"
		Set act = Server.CreateObject("ADODB.Stream")
		act.open
		'set the type to binary
		act.type = 1
	 'Load our file
		act.LoadFromFile path
	 'And send it to the browser
	 	on error resume next
		Response.BinaryWrite act.Read
		on error goto 0
		if err.number<>0 then
			set act = fs.opentextfile(path)
			if not act.AtEndOfStream then Response.Write getHTMLHeader() & getFormatAspJsHtmlAdoSource(act.readall)
		end if
	else
		set act = fs.opentextfile(path)
		if not act.AtEndOfStream then Response.Write getHTMLHeader() & getFormatAspJsHtmlAdoSource(act.readall)
	end if

	Response.Flush
	'Response.End
	act.Close
	Set objStream = Nothing

end function

function getHTMLHeader()
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Code Highliting Test</title>
<link rel="stylesheet" type="text/css" href="../../core/assets/style/sourcecode.css">
</head>
<body>
<%
end function

function getHTMLFooter()
%>
</body>
</html>
<%
end function

function getMimeType(path)
	dim sExt, sMIME, objShell
	sExt = mid(path, instrrev(path, "."), len(path))

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
			Case ".doc", ".dot"
			sMIME = "application/msword"
			Case ".xls", ".xla", ".xlc", ".xlm", ".xlt", ".xlw"
			sMIME = "application/vnd.ms-excel"
			Case ".ppt", ".pot", ".pps"
			sMIME = "application/vnd.ms-powerpoint"
			Case ".mpp"
			sMIME = "application/vnd.ms-project"
			Case ".wcm", ".wdb", ".wks", ".wps"
			sMIME = "application/vnd.ms-works"
			Case ".mdb"
			sMIME = "application/vnd.msaccess"
			Case ".zip", ".7zip", ".7z", ".rar"
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
			Case ".tif", ".tiff"
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

			Case ".mpg", ".mpeg", ".mp2", ".mpa", ".mpe", ".mpv2"
			sMIME = "video/mpeg"
			Case ".mp4", ".mpeg4"
			sMIME = "video/mpeg4"
			case ".mov", ".qt"
			sMIME = "video/quicktime"
			Case ".asf", ".asx", ".asr"
			sMIME = "video/x-ms-asf"
			Case ".avi"
			sMIME = "video/avi"
			Case ".fla"
			sMIME = "application/x-shockwave-flash"
			Case ".flv"
			sMIME = "video/flv"
			Case ".swf"
			sMIME = "application/x-shockwave-flash"

			case ".txt", ".inc", ".c", ".h"
			sMIME = "text/plain"
			Case ".htm", ".html",".stm"
			sMIME = "text/html"
			Case ".xml", ".xsl", ".xslt"
			sMIME = "text/xml"
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
%>
