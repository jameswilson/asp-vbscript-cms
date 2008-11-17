<!--#include file="../../core/include/global.asp"-->
<%
'Set fs = CreateObject("Scripting.FileSystemObject")
fs.CopyFile objLinks("SITE_PATH")&"/original.asp", objLinks("SITE_PATH")&"/nuevo.asp",false
set fs = createobject("scripting.filesystemobject")
fs.deletefile objLinks("SITE_PATH")&"/original.asp", true

%> 
