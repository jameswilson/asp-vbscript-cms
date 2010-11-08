<%
if request.ServerVariables("SERVER_NAME")<>"localhost" then 
	response.write "<script src=""http://www.google-analytics.com/urchin.js"" type=""text/javascript""></script>" & vbCrLf
	response.write "<script type=""text/javascript"">"& vbCrLf
	response.write "_uacct='"
	if isobject(globals) then 
	 response.write globals("GOOGLE_ANALYTICS")
	else
	 response.write GA_ACCOUNT_ID
	end if
	response.write "';"& vbCrLf &"urchinTracker();"& vbCrLf &"</script>"
end if
%>