<%
if Request.ServerVariables("SERVER_NAME") <> "localhost" then
	Response.Write "<script src=""http://www.google-analytics.com/urchin.js"" type=""text/javascript""></script>" & vbCrLf
	Response.Write "<script type=""text/javascript"">" & vbCrLf
	Response.Write "_uacct='"
	if isObject(globals) then
		Response.Write globals("GOOGLE_ANALYTICS")
	else
		Response.Write GA_ACCOUNT_ID
	end if
	Response.Write "';" & vbCrLf & "urchinTracker();" & vbCrLf & "</script>"
end if
%>
