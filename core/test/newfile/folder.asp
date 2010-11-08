<!--#include file="../../core/include/bootstrap.asp"-->
<%
set fs=Server.CreateObject("Scripting.FileSystemObject")
dim f,path,max,i,tfile,cfolder
path=split(replace("/asp/f1/f2/nuevo.asp","/","\"),"\")
max=ubound(path)
path_write=""
cfolder=""
for i=0 to max-1
if len(path(i))>0 then
	path_write = path_write &"\"& path(i)
	if fs.FolderExists(globals("SITE_PATH")& path_write)=false then
	  response.write("Folder created!")
			set f=fs.CreateFolder(globals("SITE_PATH")& path_write)
	else
  	response.write("Folder exist!")
	end if
	cfolder=cfolder&"../"
	response.write(globals("SITE_PATH")& path_write& "<br>")
end if
next
response.write(globals("SITE_PATH")& path_write&"\"&path(max))
'Set fs = CreateObject("Scripting.FileSystemObject")
'fs.CopyFile globals("SITE_PATH")&"/cambio.asp", globals("SITE_PATH")& path_write&"\"&path(max),false
'set fs = createobject("scripting.filesystemobject")
'fs.deletefile globals("SITE_PATH")&"/cambio.asp", true
set tfile=fs.CreateTextFile(globals("SITE_PATH")& path_write&"\"&path(max))
tfile.WriteLine("<"&"%server.Execute("""&cfolder&"404.asp"")%"&">")
tfile.close
%>