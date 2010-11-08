<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%><%option explicit%>
<!--#include file="../../core/include/bootstrap.asp"-->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Directory Browser</title>
</head>

<body>

<%
'Author: Adrian Forbes
dim sRoot, sDir, sParent, objFSO, objFolder, objFile, objSubFolder, sSize
' This is the root directory that the explorer will browse.  Make sure there is no backslash ()
' at the end.  Also make sure that show.asp has an identical sRoot variable.
sRoot = token_replace("{SITEPATH}\assets\")

' Get the directory relative to the root directory
sDir = Request("Dir")

' Add a backslash
sDir = sDir & "\"

Response.Write "<h1>" & sDir & "</h1>" & vbCrLf

' Create a copy of FileSystemObject
Set objFSO = CreateObject("Scripting.FileSystemObject")
on error resume next
' Get a handle on the folder
Set objFolder = objFSO.GetFolder(sRoot & sDir)
if err.number <> 0 then
    Response.Write "Could not open folder"
    Response.End
end if
on error goto 0

' We want a link to the parent folder also
' Get the full path of the parent folder
sParent = objFSO.GetParentFolderName(objFolder.Path)

' Remove the contents of sRoot from the front.  This gives us the parent
' path relative to the root folder
' eg. if parent folder is "c:webfilessubfolder1subfolder2" then we just want "subfolder1subfolder2"
sParent = mid(sParent, len(sRoot) + 1)

Response.Write "<table border=""1"">"

' Give a link to the parent folder.  This is just a link to this page only pssing in
' the new folder as a parameter
Response.Write "<tr><td colspan=3><a href=""browse.asp?dir=" & Server.URLEncode(sParent) & """>Parent folder</a></td></tr>" & vbCrLf

' Now we want to loop through the subfolders in this folder
For Each objSubFolder In objFolder.SubFolders
    ' And provide a link to them
    Response.Write "<tr><td colspan=3><a href=""browse.asp?dir=" & Server.URLEncode(sDir & objSubFolder.Name) & """>" & objSubFolder.Name & "</a></td></tr>" & vbCrLf
Next

' Now we want to loop through the files in this folder
For Each objFile In objFolder.Files
    if Clng(objFile.Size) < 1024 then
        sSize = objFile.Size & " bytes"
    else
        sSize = Clng(objFile.Size / 1024) & " KB"
    end if
    ' And provide a link to view them.  This is a link to show.asp passing in the directory and the file
    ' as parameters
    Response.Write "<tr><td><a href=""show.asp?file=" & server.URLEncode(objFile.Name) & "&dir=" & server.URLEncode (sDir) & """>" & objFile.Name & "</a></td><td>" & sSize & "</td><td>" & objFile.Type & "</td></tr>" & vbCrLf
Next

Response.Write "</table>"
%>

</body>
</html>

