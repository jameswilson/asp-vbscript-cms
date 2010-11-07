<!--#include file="../../core/include/global.asp"-->
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
	if fs.FolderExists(objLinks("SITE_PATH")& path_write)=false then
	  response.write("Folder created!")
			set f=fs.CreateFolder(objLinks("SITE_PATH")& path_write)
	else
  	response.write("Folder exist!")
	end if
	cfolder=cfolder&"../"
	response.write(objLinks("SITE_PATH")& path_write& "<br>")
end if
next
response.write(objLinks("SITE_PATH")& path_write&"\"&path(max))
'Set fs = CreateObject("Scripting.FileSystemObject")
'fs.CopyFile objLinks("SITE_PATH")&"/cambio.asp", objLinks("SITE_PATH")& path_write&"\"&path(max),false
'set fs = createobject("scripting.filesystemobject")
'fs.deletefile objLinks("SITE_PATH")&"/cambio.asp", true
set tfile=fs.CreateTextFile(objLinks("SITE_PATH")& path_write&"\"&path(max))
tfile.WriteLine("<"&"%server.Execute("""&cfolder&"404.asp"")%"&">")
tfile.close
%>