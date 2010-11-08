<!--#include file="../../core/include/bootstrap.asp"-->
<%
'Set fs = CreateObject("Scripting.FileSystemObject")
fs.CopyFile globals("SITE_PATH")&"/original.asp", globals("SITE_PATH")&"/nuevo.asp",false
set fs = createobject("scripting.filesystemobject")
fs.deletefile globals("SITE_PATH")&"/original.asp", true

%> 
