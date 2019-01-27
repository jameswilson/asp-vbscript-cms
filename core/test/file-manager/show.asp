<%@ LANGUAGE="VBSCRIPT" CODEPAGE="65001" %><%
option explicit
dim sFile, sRoot, sDir, sExt, objShell, objFSO, sMIME, objStream

' Author: Adrian Forbes -->

' Make sure this is the same sRoot variable that is defined in browse.asp
sRoot = token_replace("{SITEPATH}\assets\")

' Get the directory relative to the root folder
sDir = Request("dir")

' Get the file we're going to show
sFile = Request("file")

' We need to know the MIME type for the file we are about to view.  In
' order to get this we need to know the file's extension.
' We could use string functions to get the file extension but we've going
' to be lazy and use FileSystemObject
set objFSO = Server.CreateObject("Scripting.FileSystemObject")
sExt = objFSO.GetExtensionName (sFile)
set objFSO = nothing

' Now we have the extension, the file's MIME type is held in the registry at
' HKEY_CLASSES_ROOT.<ext>Content Type
' Create an instance of Wscript.Shell to let us read the registry
Set objShell = Server.CreateObject("Wscript.Shell")
on error resume next
' Get the MIME type
sMIME = objShell.RegRead("HKEY_CLASSES_ROOT." & sExt & "Content Type")
On Error GoTo 0
if len(sMIME) = 0 then
    ' If there is no registered type then return octetstream.  This will prompt
    ' the user with the "Open or Save to disk" dialogue.
    sMIME = "application/octetstream"
end if
set objShell = nothing

' Tell the browse the content type
Response.ContentType = sMIME

' And the name of the file
Response.AddHeader "Content-Disposition", "filename=" & sFile & ";"

' Now we need to pipe the file to the browser, to do this we
' will use the ADODB.Stream
Set objStream = Server.CreateObject("ADODB.Stream")
objStream.Open
' Set the type as Binary
objStream.Type = 1
' Load our file
objStream.LoadFromFile sRoot & sDir & sFile

' And send it to the browser
Response.BinaryWrite objStream.Read

objStream.Close
Set objStream = Nothing
%>
