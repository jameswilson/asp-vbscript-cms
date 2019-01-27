<%
'**
'* Intialize the global filesystem object.
dim fs : set fs = Server.CreateObject("Scripting.FileSystemObject")

'**
'* A regular expression to match domain names.
dim domainRx : set domainRx = new RegExp
domainRx.pattern      = "(^(http[s]?://)?[\w.-]*?)(/)"

'**
'* Regular Expression constants.
const adFileIgnore    = 0 '*< ignore file
const adFileOverwrite = 1 '*< overwrite file
const adFileAppend    = 2 '*< overwrite file
const ForReading      = 1 '*< open file for reading
const TristateFalse   = 0 '*< tristate false

'**
'* Use this one-liner function call to do a quick check to see if a file exists.
'* This global function may be used instead of writing code to initialize a
'* SiteFile object just to check to see if it exists.
'* @fn fileExists
'* @return true if file exists
'* @param path_to_file
function fileExists(path_to_file)
	dim fl : set fl = new SiteFile
	fl.Path = path_to_file
	fileExists = fl.fileExists()
	set fl = nothing
end function


'! @class SiteFile
'! @file class.file.asp
'! Wrapper class for FileSystemObject in the CMS application environment.
'! The SiteFile class can construct a file relative to your project root
'! directory (where-ever it may be) and determine if the file exists for
'! the following three types:
'!
'! - An absolute URL:
'! \code
'!        dim file : file = new SiteFile
'!        file.path = "http://mydomain.com/xyz/images/photo1.jpg"
'! \endcode
'! - A path relative to the project:
'! \code
'!        dim file : file = new SiteFile
'!        file.path = "/images/photo1.jpg"
'! \endcode
'! - A path relative to the current (calling) asp file:
'! \code
'!        dim file : file = new SiteFile
'!        file.path = "images/photo1.jpg"Basically, since
'! \endcode
'! The benefit of using this wrapper class is that when the site sits in a
'! virtual folder that appears as a sub-folder on the domain, for example
'! a testing folder on the localhost,  (ie, http://localhost/xyz/) then all
'! files that are referenced from the site root eg, "/images/photo1.jpg"
'! must somehow know how to be referenced with the xyz/ in the test environment
'! but without this folder in the production environment.
'! Using regular Server.MapPath("/images/photo1.jpg") without prepending the virtual sub folder would produce:
'!        c:\inetpub\wwwroot\images\photo1.jpg
'! When in reality the path to the file we are looking for, because the project
'! exists in a sub-directory and possibly a virtual directory, might be somewhere
'! else completely:
'!        c:\path\to\my_web_projects\xyz\images\photo1.jpg
'! This can automatically be acheived by using the SiteFile.AbsolutePath function
'! After creating the file object and specifying a path as above, the AbsolutePath
'! property will know the real absolute location of the file.
'! @example:
'! Find the absolute path to the file "/images/photo1.jpg"  in the XYZ project. The
'! XYZ project is a virtual folder "xyz" that references files in "c:\my_projects\xyz\".
'! The live site is at mydomain.com/ references the folder xyz/ which sits inside
'! a virtual webspace: e:\users\s2342498939\webroot.  The xyz/ folder is not visible
'! on the URL.
'! \code
'! dim file : file = new SiteFile
'! file.Path = globals("SITE_URL") & "/images/photo1.jpg"
'! Response.Write(file.Url)
'! Response.Write(vbCrLf)
'! Response.Write(file.AbsolutePath)
'! \endcode
'! on localhost this would produce output:
'!    http://localhost/xyz/images/photo1.jpg
'!    c:\my_projects\xyz\images\photo1.jpg
'! on myDomain.com this would produce output:
'!    http://mydomain.com/images/photo1.jpg
'!    e:\users\s2342498939\webroot\xyz\images\photo1.jpg
class SiteFile

	private fUrl
	private fPath
	private fVirtualPath
	private fAbsolutePath
	private fExists
	private fIsFolder
	private fIsFile
	private fName
	private fExtention
	private fErrors
	private m_defaultFileType
	private m_fileObject

	public sub Class_Initialize()
		if globals("SITE_PATH") = "" then
			debugError("class.file.init: global variable 'SITE_PATH' is required but was not found")
		else
			trace("class.file.init: global variable 'SITE_PATH' is '" & globals("SITE_PATH") & "'")
		end if
		fUrl = ""
		fPath = ""
		fVirtualPath = ""
		fAbsolutePath = ""
		fExists = false
		set m_fileObject = nothing
		set m_defaultFileType = new RegExp
		m_defaultFileType.pattern = "/(default.asp[x]?|default.htm[l]?|index.htm[l]?)$"
		m_defaultFileType.ignorecase = "true"
		m_defaultFileType.global = false
	end sub

	private sub Class_Terminate()
		fUrl = null
		fPath = null
		fVirtualPath = null
		fAbsolutePath = null
		fExists = false
		set m_fileObject = nothing
		set m_defaultFileType = nothing
	end sub

	'**
	'* Create a SiteFile for the specified path_to_file
	'* @usage
	'*  \code
	'*
	'*
	'*
	'*  \endcode
	'* @param string path_to_file
	public property let Path(strPath)
		'on error resume next
		fExists = false
		fIsFolder = false
		fIsFile = false
		set m_fileObject = nothing
		if isEmpty(strPath) or isNull(strPath) or (strPath = "") then
			debugError("class.file.path: must provide a non-empty, non-null string to set the path.")
		else
			fPath = strPath
			trace("class.file.path: file name string is '" & strPath & "'")
			if instr(fPath, globals("SITEURL")) > 0 then
				'the file is on this domain
				fPath = replace(fPath, globals("SITEURL"), "") 'domainRx.replace(fPath, "$3")
				trace("class.file.path: the file is on this domain... converted Path to '" & fPath & "'")
			end if
			if instr(fPath, "http") = 1 then
				' Assume that a file exists if its not on this domain.
				fExists = true
				trace("class.file.path: the file '" & fPath & "'is not on this domain, and we assume it exists")
			else
				' If the path is not a canonical URI, then check the filesystem
				' to ensure the file exists.

				' Strip multiple and mixed slashs that can cause runtime errors
				' in MapPath. (eg 'path/\to\file.txt'
				fPath = replace(fPath, "/", "\")
				fPath = replace(fPath, "\\", "\")
				trace("class.file.path: getting absoulte path for '" & fPath & "'...")
				if left(fPath, 1) = "\" then
					trace("class.file.path: path specified was a virtual path based off of the site root")
					'if virtual file reference is based off the root, add the site_path
					fAbsolutePath = globals("SITE_PATH") & fPath
					'trace("class.file.path: path before processing: " & fAbsolutePath)
					'fAbsolutePath = Server.MapPath(globals("SITE_PATH") & fPath)
					'trace("class.file.path: path after processing: " & fAbsolutePath)
				else
					if instr(fPath, globals("SITE_PATH")) = 1 then
						trace("class.file.path: path specified was absolute path inside this site.")
						fAbsolutePath = fPath
						fPath = right(fPath, len(globals("SITE_PATH")))
					else
						trace("class.file.path: path specified was a virtual path based off of the current folder")
						fAbsolutePath = Server.MapPath(fPath)
					end if
				end if
				trace("class.file.path: file absolute path is '" & fAbsolutePath & "'")

				' If the file is in the public website, determine the virtual
				' path (relative url from the site root).
				if inStr(fAbsolutePath, globals("SITE_PATH")) > 0 then
					fUrl = globals("SITEURL") & replace(fAbsolutePath, globals("SITE_PATH"), "")
					fUrl = replace(fUrl, "\" , "/")
					fVirtualPath = replace(fUrl, "https://" & Request.ServerVariables("HTTP_HOST"), "")
					fVirtualPath = replace(fUrl, "http://" & Request.ServerVariables("HTTP_HOST"), "")
					trace("class.file.path: file virtual path is '" & fVirtualPath & "'")
					trace("class.file.path: file complete url is '" & fUrl & "'")
				end if
				fIsFile = fs.fileExists(fAbsolutePath)
				fIsFolder = fs.folderExists(fAbsolutePath)
				fExists = fIsFile or fIsFolder
				trapError
			end if
			if inStrRev(fPath, "\") > 0 and inStrRev(fPath, "\") < len(fPath) then
				fName = mid(fPath, inStrRev(fPath, "\") + 1)
			else
				fName = fPath
			end if
			if inStrRev(fName, ".") > 0 and inStrRev(fName, ".") < len(fName) then
				fExtention = mid(fName, inStrRev(fName, ".") + 1)
			end if
			if m_defaultFileType.test(fUrl) = true then
				fUrl = m_defaultFileType.replace(fUrl,"")
			end if

			' Ensure RFC-3986 compliance for URIs.
			fUrl = EncodeURI(fUrl)
			if fExists then
				if fIsFile then
					set m_fileObject = fs.getFile(fAbsolutePath)
				elseif fIsFolder then
					set m_fileObject = fs.getFolder(fAbsolutePath)
				end if
			end if
		end if
		if fExists then
			debugInfo("class.file.path: file at path '" & fPath & "' exists")
		else
			debugWarning("class.file.path: file at path '" & fPath & "' does not exist")
		end if
	end property

	public function modifiedDate()
		if not m_fileObject is nothing then
			modifiedDate = m_fileObject.DateLastModified
		end if
	end function

	public function parentFolder()
		if not m_fileObject is nothing then
			modifiedDate = m_fileObject.ParentFolder
		end if
	end function

	'* Return true if there is a real file that exists.
	public function fileExists()
		fileExists = fExists
	end function

	'* Return the virtual path (url) off of the site root.
	public function VirtualPath()
		VirtualPath = fVirtualPath
	end function

	public function Url()
		Url = fUrl
	end function

	public function RelativeURL()
		VirtualURL = VirtualPath
	end function

	public function AbsolutePath()
		AbsolutePath = fAbsolutePath
	end function

	public function Name()
		Name = fName
	end function

	public function FileExtension()
		FileExtension = fExtention
	end function

	public function run()
		if not fileExists() = true then
			debugError("class.file.run: module handler '" & fVirtualPath & "' does not exist!")
		else
			trace("class.file.run: executing module: '" & fVirtualPath & "'")
			on error resume next
			Server.Execute(fVirtualPath)
			if err.number <> 0 then
				debugError("class.file.run: error executing '" & fVirtualPath & "'")
				debugError("class.file.run: " & err.number & " - " & err.description)
				err.clear
			end if
		end if
	end function

	private function AddError(byval strError)
		debugError(strError)
		fErrors = fErrors & " <br> " & strError
	end function

	public function GetErrors()
		getErrors = fErrors
	end function

	public function copy_file(byval strfilesource, byval strfiledestination, byval stroverwrite)
		copy_file = false
		'--------------------------------[error checking]--------------------------------
		' error checking!!!!...
		if strfilesource = "" or isNull(strfilesource) then
			AddError("File source path is required when calling this function")
			exit function
		end if
		' error checking!!!!...
		if strfiledestination = "" or isNull(strfiledestination) then
			AddError("File destination path is required when calling this function")
			exit function
		end if
		if strfiledestination = strfilesource then
			AddError("The destination file is the same as the source ")
			exit function
		end if
		' error checking!!!!...[true - false]
		if stroverwrite = "" or isNull(stroverwrite) then
			AddError("Parameter overwrite must be true or false")
			exit function
		end if
		if fs.fileexists(globals("SITE_PATH") & "/" & strfilesource) = FALSE then
			AddError("The source file '" & strfilesource & "' does not exist")
			exit function
		end if
		'--------------------------------[/error checking]--------------------------------
		dim f, path, max, i, path_write
		path = split(replace(strfiledestination, "/", "\"), "\")
		max = ubound(path)
		path_write = ""
		for i = 0 to max - 1
			if len(path(i)) > 0 then
				path_write = path_write & "\" & path(i)
				if fs.FolderExists(globals("SITE_PATH") & path_write) = FALSE then
					debugInfo("Folder '" & globals("SITE_PATH") & path_write & "' created!")
						set f = fs.CreateFolder(globals("SITE_PATH") & path_write)
						set f = nothing
				else
					Trace("Folder exist!")
				end if
				debugInfo(globals("SITE_PATH") & path_write & "<br>")
			end if
		next
		on error resume next
		fs.CopyFile globals("SITE_PATH") & "/" & strfilesource, globals("SITE_PATH") & path_write & "\" & path(max), stroverwrite
		if err.number <> 0 then
			trapError
			exit function
		end if
		copy_file = TRUE
		debugInfo("Copied '" & strfilesource & "' to '" & globals("SITE_PATH") & path_write & "\" & path(max) & "'")
	end function
	public function delete_file(byval strfilesource)
		delete_file = FALSE
		if strfilesource = "" or isNull(strfilesource) then
			AddError("File source path is required when calling this function")
			exit function
		end if
		on error resume next
		fs.deletefile globals("SITE_PATH") & "/" & strfilesource, TRUE
		if err.number <> 0 then
			trapError
			exit function
		end if
		delete_file = TRUE
	end function

	public function move_file(byval strfilesource, byval strfilename, byval strcontent, byval collisionResolution)
		if write_file(strfilename, strcontent, collisionResolution) = TRUE then
			move_file = delete_file(strfilesource)
		else
			move_file = FALSE
		end if
	end function

	public function write_file(byval strfilename, byval strcontent, byval collisionResolution)
		write_file = FALSE
		'--------------------------------[error checking]--------------------------------
		' error checking!!!!...
		if strfilename = "" or isNull(strfilename) then
			AddError("File source path is required when calling this function")
			exit function
		end if
		' error checking!!!!...
		if strcontent = "" or isNull(strcontent) then
			AddError("File destination path is required when calling this function")
			exit function
		end if
		if collisionResolution = "" or isNull(collisionResolution) then
			AddError("Parameter overwrite must be true or false")
			exit function
		end if
		'--------------------------------[/error checking]--------------------------------
		dim tfile, exist
		on error resume next
		exist = fs.FileExists(strfilename)
		if exist = TRUE and collisionResolution = adFileIgnore then
			AddError("The file'" & strfilename & "' already exists")
			exit function
		elseif exist = TRUE and collisionresolution = adFileAppend then
			set tfile = fs.OpenTextFile(strfilename, 8, TRUE)
			tfile.WriteLine(strcontent)
			tfile.Close
			if err.number<>0 then
				trapError
				exit function
			end if
			else
				set tfile = fs.CreateTextFile(strfilename)
				tfile.WriteLine(strcontent)
				tfile.close
				if err.number<>0 then
					trapError
					exit function
				end if
			end if
		write_file = TRUE
		debugInfo("Created '" & strfilename & "'")
	end function


	'**
	'* if this object is an existing folder, then return a dictionary of file.
	'* optionally provide a specific list of file extension(s) to limit the result set
	'* @param fileExtensions a comma separated list of file extensions (including the period)
	'*
	function getFiles(byval fileExtensions)
		dim folder, item, url, resultDict, fileTypes, bIncludeExtensions
		fileTypes = split(fileExtensions, ",")
		bIncludeExtensions = (ubound(fileTypes) <> 0)
		debug("class.file.getFilesInFolder: absolute folder path is " & AbsolutePath )
		on error resume next
		set folder = fs.GetFolder(AbsolutePath)
		if err.number > 0 then
			set getFiles = nothing
			exit function
		end if
		''''on error goto 0
		set resultDict = Server.CreateObject("Scripting.Dictionary")
		dim i, ext
		for each item in folder.Files
			for i = 0 to ubound(fileTypes)
				ext = trim(fileTypes(i))
				if (len(ext) > 0) and (len(item.Name) > len(ext)) then
					if (instr(item.Name, ext) = len(item.name) - len(ext) + 1) then
						if not bIncludeExtensions then
							trace(" [ " & replace(item.Name, ext, "") & " => " & item.path & " ]")
							resultDict.add replace(item.Name, ext, ""), item.path
						else
							trace(" [ " & item.Name & " => " & item.path & " ]")
							resultDict.add item.Name, item.path
						end if
					end if
				else
					trace(" [ " & item.Name & " => " & item.path & " ]" )
					resultDict.add item.Name, item.path
				end if
				traperror
			next
		next
		set getFiles = resultDict
	end function

	'return the contents of the current sitefile, processing each line as
	public function readAll()
		readAll = ""
		if not fExists then exit function
		on error resume next
		dim result : set result = new FastString
		dim myFile : set myFile = fs.GetFile(fAbsolutePath)
		dim stream : set stream = myFile.OpenAsTextStream(ForReading, TristateFalse)
		do while not stream.atEndOfStream
			result.add stream.readLine
		loop
		readAll = result.value
		set result = nothing
	end function
end class

'* Retrieve a listing of files of the specified type at the specified path.
'*
'* @param strPath
'*   The path to the folder.
'* @param fileExtensions
'*   The three or four letter file extensions to look for. Separate multiple
'*   extensions by a comma.
'* @return Dictionary
'*   A Scripting.Dictionary object of each file's path, stored as a string.
function getFilesInFolder(strPath, fileExtensions)
	dim folder, file, item, url, resultDict, fileTypes, bIncludeExtensions
	set file = new SiteFile
	file.path = strPath
	fileTypes = split(fileExtensions, ",")
	bIncludeExtensions = (ubound(fileTypes) <> 0)
	debug("class.file.getFilesInFolder: absolute folder path is " & file.absolutePath)
	on error resume next
	set folder = fs.GetFolder(file.absolutePath)
	if err.number > 0 then
		set getFilesInFolder = nothing
		exit function
	end if
	'on error goto 0
	set resultDict = Server.CreateObject("Scripting.Dictionary")
	dim i, ext
	for each item in folder.Files
		for i = 0 to ubound(fileTypes)

			ext = trim(fileTypes(i))
			if (len(ext) > 0) and (len(item.Name) > len(ext)) then
				if (instr(item.Name, ext) = len(item.name) - len(ext) + 1) then
					if not bIncludeExtensions then
						trace(" [ " & replace(item.Name, ext, "") & " => " & item.path & " ]")
						resultDict.add replace(item.Name, ext, ""), item.path
					else
						trace(" [ " & item.Name & " => " & item.path & " ]")
						resultDict.add item.Name, item.path
					end if
				end if
			else
				trace(" [ " & item.Name & " => " & item.path & " ]")
				resultDict.add item.Name, item.path
			end if
			traperror
		next
	next
	set getFilesInFolder = resultDict
end function
%>
