<%

dim contentFormat : set contentFormat = CreateObject("Scripting.Dictionary")

contentFormat.add "image/gif", ""
contentFormat.add "image/pjpeg", ""
contentFormat.add "image/jpeg", ""
dim maxBytes : maxBytes = 1024 * 20  ' 20 kilobytes upload limit.


' function to upload a file to the server
' returns the filename if there is a file to upload, and returns an empty string if there was nothing to upload.
'function fileUp(id, location)
'	fileUp = ""
'	dim upl
'	on error resume next
'	set upl = Server.CreateObject("SoftArtisans.FileUp")
'	if contentFormat.exists(lcase(upl.Form(id).ContentType)) then 
'		upl.MaxBytesToCancel = maxBytes
'		upl.Path = objLinks.item("SITE_PATH")&location
'		if not upl.Form(id).IsEmpty then upl.Form(id).Save
'		fileUp = upl.Form(id).ShortFilename
'	end if
'	TrapError
'	set upl = Nothing
'end function

%>