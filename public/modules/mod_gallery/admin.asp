<%
dim gallery_folder : gallery_folder = eval("m_gallery_folder")
dim include_subfolders : include_subfolders = eval("m_include_subfolders")
dim max_images_per_page : max_images_per_page = eval("m_max_images_per_page")
dim thumbnail_width : thumbnail_width = eval("m_thumbnail_width")
dim thumbnail_height : thumbnail_height = eval("m_thumbnail_height")
dim slideshow : slideshow = eval("m_slideshow")

dim image_root : image_root = "/images"
debug("mod_gallery: the gallery folder is: "&gallery_folder)


dim gallery_root : set gallery_root = new SiteFile
if len(gallery_folder)= 0 then gallery_folder = image_root
gallery_root.path = gallery_folder
if not gallery_root.fileExists then
	dim note : note = "No Images directory could be found! Please specify the folder you want to use for gallery images."
	myForm.addFormInput "required", "Gallery Folder", "mod_gallery_folder","text","", gallery_folder, DBTEXT,note
else
	myForm.addFormSelect "required", "Gallery Folder", "mod_gallery_folder","selectOne",""
	getFolderListOptions myForm,image_root,gallery_folder,"mod_gallery_folder"
	myForm.endFormSelect("")
end if

myForm.addFormInput "optional", "Slideshow auto-advance?", "mod_slideshow", "checkbox", "", "1",  iif( slideshow="1",CHECKED,""), ""

myForm.addFormInput "optional", "Thumbnail Width", "mod_thumbnail_width","text","int", thumbnail_width, " maxlength=""3""","Please specify the maximum pixel width of the thumbnail images. A number between 80 and 150 is optimal. Specify 0 or leave blank to use max height instead."
myForm.addFormInput "optional", "Thumbnail Height", "mod_thumbnail_height","text","int", thumbnail_height, " maxlength=""3""","Please specify the maximum pixel height of the thumbnail images. A number between 80 and 150 is optimal. Specify 0 or leave blank to use max width instead."
myForm.addFormInput "optional", "Images Per Page", "mod_max_images_per_page","text","int", max_images_per_page, " maxlength=""4""","Please specify the maximum number of thumbnails to appear on a gallery page. If the gallery has many images then additional pages will be created automatically."

set gallery_root = nothing
%>