<%
function isIE60()
  isIE60 = isUserAgent("MSIE 6.0")
end function

function isIE()
	isIE = isUserAgent("MSIE")
end function

function isUserAgent(strAgent) 
  isUserAgent = false
  if instr(request.ServerVariables("HTTP_USER_AGENT"),strAgent) > 0 then 
		isUserAgent = true
	end if
end function
%>
