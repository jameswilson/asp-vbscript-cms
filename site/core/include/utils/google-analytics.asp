<%
if request.ServerVariables("SERVER_NAME")<>"localhost" then 
	response.write "<script src=""http://www.google-analytics.com/urchin.js"" type=""text/javascript""></script>" &vbcrlf
	response.write "<script type=""text/javascript"">"&vbcrlf
	response.write "_uacct='"
	if isobject(objLinks) then 
	 response.write objLinks("GOOGLE_ANALYTICS")
	else
	 response.write GA_ACCOUNT_ID
	end if
	response.write "';"&vbcrlf&"urchinTracker();"&vbcrlf&"</script>"
end if
%>