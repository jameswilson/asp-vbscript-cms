<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Form submission test.</title>
<script src="../../SpryAssets/SpryValidationTextField.js" type="text/javascript"></script>
<link href="../../SpryAssets/SpryValidationTextField.css" rel="stylesheet" type="text/css" />
<style type="text/css">
<!--
dt,dd {
	padding-top: 0.3em;
	padding-right: 0.9em;
}
-->
</style>
</head>

<body>
<% 

if len(request("name"))>0 then response.write "<p>Name is "&request("name")
if len(request("email"))>0 then response.write "<p>Email is "&request("email")
%>
<p>Form submission test.</p>
<form id="form1" name="form1" method="post" action="">
  <table width="500" border="0" cellspacing="4" cellpadding="0">
  <tr>
    <td width="94"><label for="name">
      <div align="right">Text To Send</div>
    </label></td>
    <td width="348"><input type="name" name="name" id="text" accesskey="t" tabindex="1" /></td>
  </tr>
  <tr>
    <td><label for="email">
    <div align="right">Email</div>
    </label></td>
    <td><span id="emailValidate">
        <input type="text" name="email" id="email" accesskey="e" tabindex="2" />
        <span class="textfieldRequiredMsg">A value is required.</span>
        <span class="textfieldInvalidFormatMsg">Invalid format.</span>  		</span></td>
  </tr>
  <tr>
    <td><div align="right"></div></td>
    <td><label for="submit"></label>
      <input type="submit" name="submit" id="submit" value="Submit" accesskey="s" tabindex="3" /></td>
  </tr>
</table>
</form>

<p>&nbsp;</p>
<h1>Why do I get 'HTTP 405 - Resource Not Allowed' errors?</h1>
<div>
  <table border="0" cellpadding="10" cellspacing="0">
    <tbody>
      <tr>
        <td>HTTP/1.1 Error <br />
          405 Method Not Allowed <br />
          The  method specified in the Request Line is not allowed for the resource  identified by the request. Please ensure that you have the proper MIME  type set up for the resource you are requesting. <br />
          Please contact the server's administrator if this problem persists. </td>
      </tr>
    </tbody>
  </table>
  <dl>
    <dt> Form Name</dt>
      <dd>Ensure your form  has a name, or a method -- particularly in Netscape.</dd>
    <dt> Form Action to static page</dt>
        <dd> if you try to submit a form to an HTM, HTML or other 'static' page type.</dd>
    <dt><strong>Empty Form Action </strong>
        <dd>when your form<strong> doesn't have an action parameter, </strong>or it is<strong> left blank, </strong>if the form is in the<strong> default document </strong><em>and</em> the user  accessed the file as http://yoursite/yourfolder/ instead of http://yoursite/yourfolder/default.asp<strong>.</strong> <br />
    See <a href="http://support.microsoft.com/default.aspx/kb/216493" target="_self" title="http://support.microsoft.com/default.aspx/kb/216493">KB #216493</a> for more information (and not ethat you don't have to be using a DTC for this symptom to appear).</dt>
    </dd>
		<dt>Remote Scripting</dt>
      <dd>If you are using Remote Scripting, see <a href="http://support.microsoft.com/default.aspx/kb/191276" target="_self" title="http://support.microsoft.com/default.aspx/kb/191276">KB #191276</a>.</dd>
    <dt>Visual InterDev's preview/design modes?</dt>
        <dd> If  you are using Visual InterDev's preview/design modes, switch to your  browser. Don't use your editor to preview your code, use the tool your  users will be using!</dd>
    <dt> Posting Acceptor?</dt>
        <dd>If you are using Posting Acceptor to  upload files, make sure IUSR has full permissions on cpshost.dll; or,  better yet, use a real upload solution (<a href="http://www.aspfaq.com/show.asp?id=2189" target="_self" title="http://www.aspfaq.com/show.asp?id=2189">Article #2189</a>).</dd>
    <dt> FrontPage Server Extensions _vti_bin lacks 'execute' permissions
        <dd> You can get this if you have FrontPage Server Extensions installed, and the _vti_bin lacks 'execute' permissions.  See <a href="http://support.microsoft.com/default.aspx/kb/238461" target="_self" title="http://support.microsoft.com/default.aspx/kb/238461">KB #238461</a> for more information.  Also, see <a href="http://support.microsoft.com/default.aspx/kb/206046" target="_self" title="http://support.microsoft.com/default.aspx/kb/206046">KB #206046</a> and <a href="http://support.microsoft.com/default.aspx/kb/229295" target="_self" title="http://support.microsoft.com/default.aspx/kb/229295">KB #229295</a> for other FrontPage-related articles.</dd>
    <dt> Searching Option Pack 4.0 documentation
        <dd>A rare case, see <a href="http://support.microsoft.com/default.aspx/kb/186809" target="_self" title="http://support.microsoft.com/default.aspx/kb/186809">KB #186809</a>.</dd>
    </dt>
  </dl>
  </div>
<p>&nbsp;</p>
<script type="text/javascript">
<!--
var sprytextfield2 = new Spry.Widget.ValidationTextField("emailValidate", "email", {validateOn:["blur"], hint:"email@domain.com"});
//-->
</script>
</body>
</html>
