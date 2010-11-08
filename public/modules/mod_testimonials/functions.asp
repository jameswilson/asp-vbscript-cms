<%
' returns a scripting dictionary of the testimonial
' for the specified id.
function getTestimonialById(id)
	dim rs, sd, key, val, counter, i 
	set sd = Server.CreateObject("Scripting.Dictionary")
	set rs = db.getRecordSet("SELECT * FROM tblTestimonials WHERE (tblTestimonials.ID="&id&");")
	if rs.state > 0 then 
		if rs.EOF and rs.BOF then
			strError = "There is no testimonial for id '"&id&"'.<br/>" & _
			"Would you like to  <a href='?view'>go back to the list</a> "& _
			"or <a href='?create'>create a new one</a>?"
			debugError("no data found for page with id '"&id&"'.")
		else
			rs.movefirst
			counter = rs.fields.count		
			do until rs.EOF
				trace("the following database content found for testimonial with id '"&id&"':")				
				for i=0 to counter-1
					key = ""&rs.fields.item(i).name
					val = ""&rs(i)
					trace("[ "&key&" -&gt; "&Server.HTMLEncode(""&val)&" ]")
					if not sd.exists(key) then
						sd.add key, val
					else
						debugError("expected result set of 1 item but got more!  A value for '"&rs.fields.item(i).name&"' already exists!")
					end if
				next
				trapError
				rs.movenext
			loop
		end if
	end if	
	set getTestimonialById = sd
end function


'returns HTML formatted list of testimonials
function getActiveTestimonialsAsHTML()
	dim rsTestimonilas, a, sql, strEven, i, strAdmin
	strAdmin = globals("ADMINURL")&"/modules/testimonials/testimonials.asp"
	set a = New FastString
	a.add "<div id=""testimonials"">" & vbCrLf
	if user.isAdministrator() then
		a.add indent(1) & "<ul>" & vbCrLf
		a.add indent(2) & "<li><a title=""Administer all testimonials."" href="""&strAdmin&"?view"">Admin Testimonials</a></li>" & vbCrLf
		a.add indent(2) & "<li class=""last""><a title=""Create a new testimonials."" href="""&strAdmin&"?create"">Create New Testimonial</a></li>  " & vbCrLf
		a.add indent(1) & "</ul>" & vbCrLf
	end if
	sql="SELECT * "_
		 &"FROM tblTestimonials "_
		 &"WHERE Active=True ORDER BY SortOrder,TestimonialDate DESC;"
	set rsTestimonials = db.getRecordSet(sql)
	i = 1
	do while not rsTestimonials.EOF and not rsTestimonials.BOF
		strEven = iif( i mod 2 = 0, " even", " odd")
		a.add indent(1) & "<div class=""testimonial"&strEven&""">"& vbCrLf
		
		dim comments : comments = rsTestimonials("Comments")
		if user.isAdministrator() then
			comments = comments & "<span class=""adminedit""><a title=""Edit This Testimonial"" href="""&strAdmin&"?edit="&rsTestimonials("ID")&"""><span>...edit</span></a></span>"
		end if
		if (instr(lcase(comments),"<p>")=0) then comments = p(comments)
		a.add indent(2) & "<div class=""comment"" id=""comment"&rsTestimonials("ID")&""">"& vbCrLf
		a.add indent(3) & comments & vbCrLf
		a.add indent(2) & "</div>" & vbCrLf
		a.add indent(2) & "<div class=""author"">"& vbCrLf
		if lcase(rsTestimonials("ShowEmail")) = lcase("true") then
			a.add indent(3) & "<span class=""name email""><a href="""&EmailObfuscate("mailto:"&rsTestimonials("Email"))&"?subject=Regarding Your Review on "&globals("SITENAME")&" Site"">"&rsTestimonials("Name")&"</a></span>" & vbCrLf
		else 
			a.add indent(3) & "<span class=""name"">"&rsTestimonials("Name")&"</span>" & vbCrLf
 		end if
		a.add indent(3) & "<span class=""location"">"&rsTestimonials("Location")&"</span> "& vbCrLf
		a.add indent(3) & "<span class=""date"">"&rsTestimonials("TestimonialDate")&"</span>" & vbCrLf 
		a.add indent(2) & "</div>"& vbCrLf
		a.add indent(1) & "</div>"& vbCrLf
		trapError
		rsTestimonials.movenext
		i=i+1
	loop
	
	processErrors
	a.add "</div>" & vbCrLf
	getActiveTestimonialsAsHTML = getCSS & a.value
	set a = nothing
end function



function getCSS()
	%>
		<style type="text/css">
		<!--
		<!--#include file="testimonials.css"-->
		-->
		</style>
		<%
end function

%>
