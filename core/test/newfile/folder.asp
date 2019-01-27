<!--#include file="../../core/include/bootstrap.asp"-->
<%
set fs = Server.CreateObject("Scripting.FileSystemObject")
dim f, path, max, i, tfile, cfolder
path = split(replace("/asp/f1/f2/nuevo.asp", "/", "\"), "\")
max = ubound(path)
path_write = ""
cfolder = ""
for i = 0 to max - 1
  if len(path(i)) > 0 then
  	path_write = path_write & "\" & path(i)
  	if fs.FolderExists(globals("SITE_PATH")& path_write)=false then
  	  Response.Write("Folder created!")
  			set f=fs.CreateFolder(globals("SITE_PATH")& path_write)
  	else
    	Response.Write("Folder exist!")
  	end if
  	cfolder=cfolder & "../"
  	Response.Write(globals("SITE_PATH") & path_write & "<br>")
  end if
next
Response.Write(globals("SITE_PATH") & path_write & "\" & path(max))
'Set fs = CreateObject("Scripting.FileSystemObject")
'fs.CopyFile globals("SITE_PATH") & "/cambio.asp", globals("SITE_PATH")& path_write & "\" & path(max),false
'set fs = createobject("scripting.filesystemobject")
'fs.deletefile globals("SITE_PATH") & "/cambio.asp", true
set tfile = fs.CreateTextFile(globals("SITE_PATH") & path_write & "\" & path(max))
tfile.WriteLine("<" & "%Server.Execute(""" & cfolder & "404.asp"")%" & ">")
tfile.close
%>
