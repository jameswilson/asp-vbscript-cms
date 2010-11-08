<!--#include file="../../../core/src/classes/class.form.asp"-->
<%
function buildFormContents(byval theKey)
	dim rs, sdPage, checked, active, selected, sAdminOnly, sDisabled, isContentEditable
	if theKey <> "" then 
		set sdPage = db.init(strTableName)
		sdPage(strKey) = theKey 
		if db.Read(sdPage) = FALSE then 
			strError = "there is no such "& strConten &" in the database." 'page.getPageDataById(theKey)
			exit function
		end if
	else
		set sdPage = Server.CreateObject("Scripting.Dictionary")
		sdPage.Add "Disabled", "" & FALSE
		sdPage.Add "Role", cstr(USER_REGISTERED)
	end if
	strActive = iif(Cstr(sdPage("Disabled")) = cstr(TRUE), CHECKED, "")
	sAdminOnly =  iif(user.getRole < USER_ADMINISTRATOR, READONLY, "") 
	sDisabled = iif(user.getRole < USER_ADMINISTRATOR, DISABLED, "")
	isContentEditable =  iif(user.getRole >= cint(sdPage("Role")), TRUE, FALSE) 
	dim item
	
	with myForm
		if not (myForm.isForNewContent = TRUE) then .addFormInput  "", "", strKey,  "hidden", "", sdPage(strKey), "", ""
		.addFieldset "User Information","<strong>Bold</strong> fields are required."
		.addFormInput  "required", "User Id", "UserID",  "text", "", sdPage("UserID"), sAdminOnly & DBTEXT, ""
		.addFormInput  "required", "First Name", "FirstName",  "text", "", sdPage("FirstName"), DBTEXT, ""
		.addFormInput  "required", "Last Name", "SecondName",  "text", "", sdPage("SecondName"), DBTEXT, ""
		if (user.getRole >= USER_ADMINISTRATOR) then 
			.addFormInput  "required", "Password", "Password",  "text", "", sdPage("Password"), DBTEXT, ""
		else
			.addFormInput  "required", "Password", "Password",  "password", "", sdPage("Password"), DBTEXT,""
		end if
		.addFormInput  "required", "Email", "Email",  "text", "email", sdPage("Email"), DBTEXT, ""
		
		if isContentEditable then 
			.addFormSelect  "required", "Role", "Role", "", sAdminOnly
			set rs = db.getRecordSet("SELECT * FROM tblUserRoles")
			if rs.state > 0 then 
				if not (rs.EOF and rs.BOF) then
					rs.movefirst
					do until rs.EOF
						selected = ""
						if (cint(rs("Level")) = cint(sdPage("Role"))) then selected = "selected"
						.addFormOption "Role",  rs("Level"), rs("Name"), selected
						rs.movenext
					loop
				end if
			end if
			.endFormSelect("")
		else
			set rs = db.getRecordSet("SELECT * FROM tblUserRoles WHERE Level="& sdPage("Role"))
			if rs.state > 0 then
				if not (rs.eof and rs.bof) then 
					.addFormInput  "required", "Role", "Role",  "text", "", rs("Name"), sAdminOnly & DBTEXT, ""
				else
					.addFormInput  "required", "Role", "Role",  "text", "", USER_GUEST, sAdminOnly & DBTEXT, ""
				end if
			end if
		end if
		
		.addFormInput "optional", "Disable this user?", "Disabled", "checkbox", "", "Yes",  sDisabled & strActive, ""
		.addFormSubmission "left","Submit &raquo;","","",""
		.endFieldset()
	
		.addFieldset "User Details","<strong>Bold</strong> fields are required."
		.addFormInput  "optional", "Description", "Description",  "textarea", "simple", sdPage("Description"), DBMEMO, ""
		.addFormInput  "optional", "Phone", "Phone",  "text", "", sdPage("Phone"), DBTEXT, ""
		.addFormInput  "optional", "Address 1", "Address1",  "text", "", sdPage("Address1"), DBTEXT, ""
		.addFormInput  "optional", "Address 2", "Address2",  "text", "", sdPage("Address2"), DBTEXT, ""
		.addFormInput  "optional", "City", "City",  "text", "", sdPage("City"), DBTEXT, ""
		.addFormInput  "optional", "State", "State",  "text", "", sdPage("State"), DBTEXT, ""
		.addFormInput  "optional", "Zip", "PostalCode",  "text", "", sdPage("PostalCode"), DBTEXT, ""
		.addFormInput  "optional", "Country Code", "Country",  "text", "", sdPage("Country"), " maxlength=""2""", "The country code consists of two lowercase letters."
		.addFormSubmission "left","Submit &raquo;", "", "", ""
		.endFieldset()
		
		buildFormContents = .getContents()
	end with
end function
%>
