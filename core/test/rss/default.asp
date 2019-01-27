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
Set rss = New RSSContentFeed

'get content
rss.ContentURL = "http://www.vnunet.com/feeds/rss/latest/all/news"
rss.GetRSS()

'display content
Response.Write "<h3>" & rss.ChannelTitle & "</h3>" & vbCrLf
Response.Write "<p>" & rss.ChannelDescription & "</p>" & vbCrLf
Response.Write "<h4>Total Results: " & rss.TotalResults & "</h4>" & vbCrLf
Dim i
Dim desc

For Each i in rss.Results
  Response.Write "<a href=""" & rss.Links(i) & """>"   & rss.Titles(i) & "</a><br>" & vbCrLf
	desc=HtmlDecode(replace ((replace(rss.Descriptions(i),"<![CDATA[","")),"]]>",""))
	Response.Write desc & "<br>" & vbCrLf
	Response.Write rss.PubDates(i) & "<br>" & vbCrLf
	Response.Write "<span class=""image"">" & rss.Images(i) & "</span><br>" & vbCrLf
	Response.Write rss.Ids(i) & "<br>" & vbCrLf
Next

Response.Write "<small>" & rss.Version & "</small>"
Response.Write "<h3>XML Content (for debugging)</h3>" & vbCrLf
Response.Write "<blockquote><code><pre>" & Server.HtmlEncode(rss.ResultsXML) & "</pre></code></blockquote>" & vbCrLf

'release object
Set rss = Nothing

%>

