<!--#include file="../../core/include/bootstrap.asp"-->
<%
function copy_file(byval strfilesource,byval strfiledestination,byval stroverwrite)
	copy_file=false
	'--------------------------------[error checking]--------------------------------
	' error checking!!!!...
	if strfilesource = "" or isNull(strfilesource) then
		debugError("sorry but a file source path is required when calling this function")
		exit function
	end if
	' error checking!!!!...
	if strfiledestination = "" or isNull(strfiledestination) then
		debugError("sorry but a file destination path is required when calling this function")
		exit function
	end if
	' error checking!!!!...[true - false]
	if stroverwrite = "" or isNull(stroverwrite) then
		debugError("parameter overwrite must be true or false")
		exit function
	end if
	if fs.fileexists(strfilesource) = false then
		debugError("the file does not exist...")
		exit function
	end if
	'--------------------------------[/error checking]--------------------------------
	dim f, path, max, i
	path = split(replace(strfiledestination,"/","\"),"\")
	max = ubound(path)
	path_write = ""
	for i = 0 to max - 1
		if len(path(i)) > 0 then
			path_write = path_write & "\" & path(i)
			if fs.FolderExists(globals("SITE_PATH") & path_write) = false then
				debugError("Folder created!")
					set f = fs.CreateFolder(globals("SITE_PATH") & path_write)
					set f = nothing
					set fs = nothing
			else
				debugError("Folder exist!")
			end if
			debugError(globals("SITE_PATH") & path_write & "<br>")
		end if
	next
	debugError(globals("SITE_PATH") & path_write & "\" & path(max))
	on error resume next
	fs.CopyFile globals("SITE_PATH") & "/" & strfilesource, globals("SITE_PATH") & path_write & "\" & path(max), stroverwrite
	if err.number <> 0 then
		trapError
		exit function
	end if
	copy_file = true
end function

function delete_file(byval strfilesource)
	delete_file = false
	if strfilesource = "" or isNull(strfilesource) then
		debugerror("sorry but a file source path is required when calling this function")
		exit function
	end if
	on error resume next
	fs.deletefile globals("SITE_PATH") & "/" & strfilesource, true
	if err.number<>0 then
		trapError
		exit function
	end if
	delete_file=true
end function

function move_file(byval strfilesource, byval strfiledestination, byval stroverwrite)
	if copy_file(strfilesource, strfiledestination, stroverwrite) = true then
		move_file = delete_file(strfilesource)
	else
		move_file = false
	end if
end function
%>
