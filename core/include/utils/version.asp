<!--#include file="../bootstrap.asp"-->
<%
page.setFile("default.asp")
function customContent(byval area)
	select case area
		case "main"
			page.ignoreDBContent = true

	customContent = div( _
		h1("{PRODUCT_BRANDING}, Version " & PRODUCT_VERSION) _
		& img("{PRODUCT_LOGO}","{PRODUCT_BRANDING} Logo", "{PRODUCT_BRANDING}","floatleft branding") _
		& p(PRODUCT_DESCRIPTION) _
		& p(brclearall & "For questions, comments and support, please contact {DEVELOPER_SUPPORT_LINK}") _
		, null, "product-version", null)

	'TODO: add list of installed modules, accentuating the ones that are active.
		case else
	end select
end function
%>
<!--#include file = "../template.asp"-->
