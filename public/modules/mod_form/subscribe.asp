<%
function sendSubscription()
	dim xmlhttp: set xmlhttp = Server.CreateObject("MSXML2.ServerXMLHTTP")
	xmlhttp.Open "POST", "http://kundenserver.de/cgi-bin/mailinglist.cgi", false
	xmlhttp.setRequestHeader "Content-Type", "application/x-www-form-urlencoded"
	dim fld, post, separator
	separator = ""
	post = ""
	for each fld in myForm.Form
		if not fld = "form_name" then
			post = post & separator & fld & "=" & myForm.getValue(fld)
			separator = "&"
		end if
	next
	xmlhttp.send post
	if len(xmlhttp.responsetext)>0 then
		dim start : start = instrrev(lcase(xmlhttp.responsetext),"<body>")+6
		dim length : length = instr(lcase(xmlhttp.responsetext),"</body>") - start
		sendSubscription =  mid(xmlhttp.responsetext,start,length)
	end if
	set xmlhttp = nothing
end function
%>
