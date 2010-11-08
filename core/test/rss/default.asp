<%
' +---------------------------------------------+
' | RSS Content Feed VBScript Class 1.0         |
' | © 2004 www.tele-pro.co.uk                   |
' | http://www.tele-pro.co.uk/scripts/rss/      |
' +---------------------------------------------+
'   
' Sample VBScript Code for the RSSContentFeed Class 
'

%>
<!-- #INCLUDE file="../../core/src/classes/class.rss-content-feed.asp" -->
<!-- #INCLUDE file="../../core/include/bootstrap.asp" -->
<%


'create object
Dim rss
Set rss= New RSSContentFeed

'get content
rss.ContentURL = "http://www.vnunet.com/feeds/rss/latest/all/news"
rss.GetRSS()

'display content
response.write "<h3>" & rss.ChannelTitle & "</h3>"& vbCrLf
response.write "<p>" &rss.ChannelDescription& "</p>"& vbCrLf
response.write "<h4>Total Results: " & rss.TotalResults & "</h4>"& vbCrLf
Dim i
Dim desc

For Each i in rss.Results
  response.write "<a href=""" & rss.Links(i) & """>"   & rss.Titles(i) & "</a><br>"& vbCrLf
	desc=HtmlDecode(replace ((replace(rss.Descriptions(i),"<![CDATA[","")),"]]>",""))
	response.Write desc &"<br>" & vbCrLf
	response.Write rss.PubDates(i) &"<br>" & vbCrLf
	response.Write "<span class=""image"">"& rss.Images(i) &"</span><br>" & vbCrLf
	response.Write rss.Ids(i) &"<br>" & vbCrLf
Next

response.write "<small>"&rss.Version&"</small>"
response.write "<h3>XML Content (for debugging)</h3>"& vbCrLf
response.write "<blockquote><code><pre>" & Server.HTMLEncode(rss.ResultsXML) & "</pre></code></blockquote>"& vbCrLf

'release object
Set rss= Nothing

%>

