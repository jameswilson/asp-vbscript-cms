<%
'+---------------------------------------------+
'| RSS Content Feed VBScript Class 1.0         |
'| © 2004 www.tele-pro.co.uk                   |
'| http://www.tele-pro.co.uk/scripts/rss/      |
'| The RSSContentFeed Class makes it easy to   |
'| download and display RSS XML feeds.         |
'+---------------------------------------------+
  
Class RSSContentFeed

'+---------------------------------------------+

'declare class variables

'strings
Private classname
Private xml_URL  
Private xml_data   
Private StrResultsXML 
Private StrCachePath
Private Strchannel
Private Strtitle
Private Strlink
Private Strdescription
Private StrRSSVersion  
Private imgTitle 
Private imgUrl 
Private imgLink 

'ebay 
Private eBayAPIURL
Private eBayAPISandboxURL
Private imgBuyItNow  
 
Public eBayTime 'date  

'int
Private iTotalResults
Private icacheDays
Private iMaxResults
Private imgWidth
Private imgHeight 
  
'bool
Private bFromcache
  
'dict
Private Headers

'arrays
Public Results()
Public Links()
Public Titles()
Public Descriptions()  
Public PubDates()
Public Images()
Public Ids()
  
'+---------------------------------------------+
'Class Functions

'Class_Initialize
Private Sub Class_Initialize
  Initialize
End Sub
           
'Class_Terminate
Private Sub Class_Terminate  
  'empty the cache
  DeleteCache()

  'empty the dict
  If IsObject(Headers) Then
    Headers.RemoveAll
    Set Headers = Nothing
  End If
  
End Sub

Public Sub Initialize 
  'set constant values 
  classname = "RSSContentFeed"

  eBayAPIURL = "https://api.ebay.com/ws/api.dll" 
  eBayAPISandboxURL = "https://api.sandbox.ebay.com/ws/api.dll"   
  imgBuyItNow = "http://pics.ebaystatic.com/aw/pics/promo/holiday/buyItNow_15x54.gif"
      
  'set object vars
  xml_URL = ""
  xml_data = ""
  StrCachePath = "" 
  icacheDays = 1
  iMaxResults = 10
  
  'clear result vars
  Set Headers = Createobject("Scripting.Dictionary")
  Clear()
End Sub

'+---------------------------------------------+

Public Sub Clear 

  'Clear search variables
  iTotalResults =0  
  bFromcache = false  
  Strlink = ""
  Strtitle = ""
  Strdescription = ""

  'channel image
  imgTitle = ""   
  imgUrl = ""     
  imgLink = ""   
  imgWidth = 0 
  imgHeight = 0 
    
  eBayTime = ""
  
  ReDim Results(1)
  ReDim Links(1)
  ReDim Titles(1)
  ReDim Descriptions(1)  
  ReDim PubDates(1)
  ReDim Images(1)
  ReDim Ids(1)
End Sub

'+---------------------------------------------+
'Public Properties - Readonly

'show the copyright info
Public Property Get Version
  Version = "XML RSS Content Feed VBScript Class Version 1.0 " & VbCrLf & _
            "© 2004 www.tele-pro.co.uk"
End Property

Public Property Get TotalResults
  TotalResults = iTotalResults
End Property
Public Property Get CacheCount
  CacheCount = CacheContentCount(StrCachePath)
End Property
Public Property Get Fromcache
  Fromcache= (bFromcache = true)
End Property
Public Property Get ChannelLink
  ChannelLink= Trim(Strlink)
End Property
Public Property Get ChannelTitle
  ChannelTitle= Trim(Strtitle)
End Property
Public Property Get ChannelDescription
  ChannelDescription = Trim(Strdescription)
End Property  
Public Property Get ChannelImgURL
  ChannelImgURL = Trim(imgURL)
End Property  
Public Property Get ChannelImgTitle
  ChannelImgTitle = Trim(imgTitle)
End Property  
Public Property Get ChannelImgLink
  ChannelImgLink = Trim(imgLink)
End Property  
Public Property Get ChannelImgWidth
  ChannelImgWidth = CLNG(imgWidth)
End Property
Public Property Get ChannelImgHeight
  ChannelImgHeight = CLNG(imgHeight)
End Property
Public Property Get ResultsXML
  ResultsXML = Trim(strResultsXML)
End Property
Public Property Get RSSVersion
  RSSVersion = Trim(strRSSVersion)
End Property

'+---------------------------------------------+
'Public Properties - settable

'show the xml_URL 
Public Property Get ContentURL
  ContentURL = Trim(xml_URL)
End Property
'set the xml_URL 
Public Property Let ContentURL(ByVal vContentURL)
  vContentURL = Trim(vContentURL)
  'add protocol if necessary
  If inStr(LCASE(vContentURL), "http://")=0 Then
    vContentURL = "http://" & vContentURL
  End if
  xml_URL = Trim(vContentURL)
End Property

Public Property Get PostData
  PostData = Trim(xml_data)
End Property
Public Property Let PostData(sxml_data)
  xml_data = Trim(sxml_data)
End Property 

Public Property Get Cache
  Cache = Trim(StrCachePath)
End Property
Public Property Let Cache(ByVal sCache)
  StrCachePath = ""
  If Trim(sCache)<>"" Then
  
    If Not DExists(sCache) Then 
      ErrRaise "SetCache" , "Cache folder does not exist " 
    Else
      'rem last slash
      If (Mid(sCache, LEN(sCache), 1) = "\") Then
        sCache = Mid(sCache, 1, LEN(sCache)-1)
      End If 
      'add slash 
      StrCachePath = Trim(sCache) & "\"      
    End If    
  End If
End Property

Public Property Get CacheDays
  CacheDays = CLNG(iCacheDays)
End Property
Public Property Let CacheDays(iDays)
  iCacheDays = CLNG(iDays)
End Property

Public Property Get MaxResults
  MaxResults = CLNG(iMaxResults)
End Property
Public Property Let MaxResults(vMaxResults)
  iMaxResults = CLNG(vMaxResults)
End Property

'+---------------------------------------------+
'Public Functions

'Delete items in Cache
Public FUNCTION DeleteCache()
  If (Trim(StrCachePath)<>"") Then
    DeleteCache = DeleteCacheContent(StrCachePath, icacheDays)
  End If
End FUNCTION

'add header for http request
Public FUNCTION AddHeader(str_hdr, str_val)
  'add header to dict for http request
  If Not (Headers.Exists(Trim(str_hdr))) Then 
    Headers.Add Trim(str_hdr), Trim(str_val)
  Else
    Headers(str_hdr) = Trim(str_val)
  End If
End FUNCTION

'transform xml with xsl
Public FUNCTION Transform(str_xslt)
  If Trim(StrResultsXML)="" Then Exit Function
  If Trim(str_xslt)="" Then Exit Function
  
  'Load XML
  Dim x
  set x = CreateObject("MSXML2.DOMDocument")  
  x.async = false  
  x.setProperty "ServerHTTPRequest", True  

  'path or url?
  If (inStr(str_xslt, "http")=1) Then 'url
      Dim tmpStr
      tmpStr = getResults(str_xslt)
      x.LoadXML(tmpStr)        
  Else
    If (inStr(str_xslt, "\")=0) Then 'needs mapping
      str_xslt = Server.MapPath(str_xslt) 
      x.Load(str_xslt) 
    End if  
  End if  
  x.resolveExternals = False
  
  If (x.parseError.errorCode <> 0) Then
    ErrRaise "Transform", "XML error: " & x.parseError.reason 
    EXIT FUNCTION        
  End If 
  str_xslt = x.xml

  Transform = TransformXML(StrResultsXML, str_xslt)  
End FUNCTION

'retrieve the value of a node
Public FUNCTION XMLValue(str_node)
  If Trim(StrResultsXML)="" Then Exit Function
  XMLValue = GetNodeText(str_node, StrResultsXML)
End FUNCTION

'construct amazon rss url and call getrss function
Public Function GetAmazonRSS(t, devt, kwd, mode, bcm)
'check 
If Trim(t) = "" Then
  ErrRaise "GetAmazonRSS", "Associate tag must be set"
  Exit Function
End if
If Trim(devt) = "" Then
  ErrRaise "GetAmazonRSS", "Developer token must be set"
  Exit Function
End if
If Trim(kwd) = "" Then
  ErrRaise "GetAmazonRSS", "KeywordSearch token must be set"
  Exit Function
End if
If Trim(mode) = "" Then
  mode = "books"
End if
  
'set amazon vals
xml_url = "http://xml-na.amznxslt.com/onca/xml3" & _
    "?t=" & Trim(t) & _
    "&dev-t=" &Trim(devt) &  _
    "&KeywordSearch=" & Trim(kwd) & _
    "&mode=" & Trim(mode) & _
    "&bcm=" & Trim(bcm) &  _
    "&type=lite" & _
    "&page=1" & _
    "&ct=text/xml" & _
    "&sort=%2Bsalesrank" & _
    "&f=http://www.tele-pro.co.uk/scripts/rss/amazon.xsl"
    '"&f=http://xml.amazon.com/xsl/xml-rss091.xsl"
         
  GetAmazonRSS = GetRSS()
End Function

'+---------------------------------------------+
'main function

Public Function GetRSS()

  'clear search
  Clear()
  
  'check xml_URL
  If Trim(xml_URL) = "" Then
    ErrRaise "GetRSS", "ContentURL must be set"
  End if
    
  'get results from web or cache 
  Dim soapResults, soapResultsStd  
  soapResults = getResults(xml_URL)  
  
  'Dump the results into an XML document.
  Dim Res
  Set Res = CreateObject("MSXML2.DOMDocument")  
  Res.async = false 
   
  'set the global xml string
  StrResultsXML = Trim(soapResults) 
  soapResultsStd = DeSensitize(soapResults)
    
  Res.setProperty "ServerHTTPRequest", True
  Res.loadXML soapResultsStd
  Res.resolveExternals = False    
  
  If (Res.parseError.errorCode <> 0) Then
    ErrRaise "GetRSS", "XML error: " & Res.parseError.reason 
    EXIT FUNCTION        
  End If    
  
  'set the global xml string to the xml formatted string
  If Trim(soapResultsStd) = Trim(soapResults) Then 
    StrResultsXML = Trim(Res.XML)  
  End If
  
  Dim Node, Nodes   

  '---------------------------------------------------------
  'get RSS  Version
  
  StrRSSVersion = ""
  Set Nodes = Res.selectNodes("//rss")
  For Each Node In Nodes          
    on error resume next 
    strRSSVersion = Node.getAttribute("version")
    on error Goto 0              
  Next  
  
  if (Trim(strRSSVersion)="") Then 
    Set Nodes = Res.selectNodes("//eBay")
    For Each Node In Nodes  
      strRSSVersion = "eBay"       
    Next     
  end if
      
  if (Trim(strRSSVersion)="") Then
    Set Nodes = Res.selectNodes("//rdf:RDF")
    For Each Node In Nodes          
      on error resume next 
      strRSSVersion = Node.getAttribute("xmlns") 
      If Trim(strRSSVersion) = "http://purl.org/rss/1.0/" Then 
        strRSSVersion = "1.0"
      End If
      on error Goto 0              
    Next            
  end if
  
  if (Trim(strRSSVersion)="eBay") Then 
    Set Nodes = Res.selectNodes("//eBayTime")
    For Each Node In Nodes  
      eBayTime = Node.Text      
    Next     
  end if
  
  '---------------------------------------------------------
  
  'set the size of arrays to the max results
  Dim c
  c=0  
  
  'get the size
  Set Nodes = Res.selectNodes("//item")  
  For Each Node In Nodes
    If (c<iMaxResults) Then
      c = c + 1
    End If
  Next
  
  'set the size
  ReDim Results(c-1)
  ReDim Links(c-1)
  ReDim Titles(c-1)
  ReDim Descriptions(c-1)
  ReDim PubDates(c-1)
  ReDim Images(c-1)
  ReDim Ids(c-1)
    
  'get item content   
  'declare results strings
  Dim res_URL
  Dim res_title
  Dim res_desc
  Dim res_date
  Dim res_img
  Dim res_id

  'ebay
  Dim CurrencyId, CurrentPrice, BidCount
      
  'Parse the XML document.
  c=0 
  For Each Node In Nodes
  If (c<iMaxResults) Then
  
    'clear the strings
    res_URL = ""
    res_title = ""
    res_desc = ""
    res_date = ""
    res_img = ""
    res_id = ""
    CurrencyId = ""
    CurrentPrice = ""
    BidCount = ""
        
    'retrieve the values
    on error resume next    
    res_URL = Trim(Node.selectSingleNode("link").Text)
    res_title = Trim(Node.selectSingleNode("title").Text)
    res_desc = Trim(Node.selectSingleNode("description").XML) 
    'amazon from custom xsl   
    res_img = Trim(Node.selectSingleNode("imgS").Text) 
    res_id = Trim(Node.selectSingleNode("Asin").Text)
    on error goto 0
        
    'or it might be a dc:description tag
    If (Trim(res_desc)="") Then    
      on error resume next
      res_desc = Trim(Node.selectSingleNode("dc:description").XML)
      on error goto 0
    End If 
    
    res_desc = Replace(res_desc, "<description>", "")
    res_desc = Replace(res_desc, "</description>", "")
    
    'or it might be ebay
    If (strRSSVersion = "eBay") Then
    If (Trim(res_desc)="") Then
      
      'get ebay data
      on error resume next        
      CurrencyId = Trim(Node.selectSingleNode("CurrencyId").Text)
      CurrentPrice = Trim(Node.selectSingleNode("CurrentPrice").Text)
      BidCount = Trim( Node.selectSingleNode("BidCount").Text)    
      res_img = Trim(Node.selectSingleNode("ItemProperties//GalleryURL").Text)
      res_id = Trim( Node.selectSingleNode("Id").Text) 
      on error goto 0 
              
      res_desc = res_desc & "<b>"
      res_desc = res_desc & eBayCurrencySymbolFromID(CurrencyId)
      res_desc = res_desc & Trim(CurrentPrice) & "</b> ("
      res_desc = res_desc & Trim(BidCount) & " bids) " & VbCrLf
      
      'construct description
      on error resume next	  
      If Trim(Node.selectSingleNode("ItemProperties//BuyItNow").Text)="1" Then        
        res_desc = res_desc & " &nbsp;<a href="""
        res_desc = res_desc & res_URL
        res_desc = res_desc & """><img align=""absmiddle"" border=""0"" src="""  
        res_desc = res_desc & imgBuyItNow
        res_desc = res_desc & """ alt=""Buy It Now""></a>" & VbCrLf        
      End If   
      on error goto 0    
      
      'ItemProperties//Featured
      'ItemProperties//New
      'ItemProperties//IsFixedPrice
      'ItemProperties//Gift
      'ItemProperties//CharityItem      
        
    End If 
    End If '(strRSSVersion = "eBay") 

    'optional tags
    on error resume next
    res_date = Node.selectSingleNode("pubDate").Text  
    'ebay
    If (Trim(res_date)="") Then
      res_date = Node.selectSingleNode("EndTime").Text 
    End If           
    on error goto 0
    
    if Trim(res_URL)<>"" Or _ 
       Trim(res_title)<>"" Or _ 
       Trim(res_desc)<>"" then 
        
        'its a result, add to array
        Results(c) = c
        Links(c) = res_URL
        Titles(c) = res_title 
        Descriptions(c) = res_desc
        PubDates(c) = res_date        
        Images(c) = res_img         
        Ids(c) = res_id 
        
        c=c+1 'inc counter            
    End If                     
  End If                     
  Next    
  
  '---------------------------------------------------------
 
  'get channel content 
  Set Nodes = Res.selectNodes("//channel")
  For Each Node In Nodes      
    on error resume next
    Strlink = Node.selectSingleNode("link").Text
    Strtitle = Node.selectSingleNode("title").Text
    Strdescription = Node.selectSingleNode("description").Text
    on error Goto 0              
  Next
 
  'get image
  Set Nodes = Res.selectNodes("//image")
  For Each Node In Nodes   
    on error resume next
    imgTitle = Node.selectSingleNode("title").Text
    imgUrl = Node.selectSingleNode("url").Text
    imgLink = Node.selectSingleNode("link").Text
    imgWidth = Node.selectSingleNode("width").Text
    imgHeight = Node.selectSingleNode("height").Text
    on error Goto 0              
  Next
    
  'release objects
  Set Nodes  = Nothing  
  Set Res = Nothing
  
  'return count
  iTotalResults = c
  GetRSS = c    
End Function

Private Function DeSensitize(Istr)
  Dim str
  str = Istr
  str = Replace(str, "<Item>", "<item>", 1, -1, 1)
  str = Replace(str, "<Link>", "<link>", 1, -1, 1)
  str = Replace(str, "<Title>", "<title>", 1, -1, 1)
  str = Replace(str, "</Item>", "</item>", 1, -1, 1)
  str = Replace(str, "</Link>", "</link>", 1, -1, 1)
  str = Replace(str, "</Title>", "</title>", 1, -1, 1) 
  DeSensitize = str
End Function

Public Function ItemHTML(iNumber)
  Dim r_URL, r_title, r_description, r_pubdate
  
  If (iTotalResults=0) Then
    ErrRaise "ItemHTML", "There are no items"
    Exit Function
  End If
  If (iNumber>=iTotalResults) Then
    ErrRaise "ItemHTML", "Item index out of bounds"
    Exit Function
  End If
  
  r_URL = Links(iNumber)
  r_title= Titles(iNumber)
  r_description = Descriptions(iNumber)
  r_pubdate = PubDates(iNumber)
  
  ItemHTML = Trim(FormatResult(r_URL, r_title, r_description, r_pubdate))
End Function
  
Private Function FormatResult(h, t, d, p)
  Dim str
  str = ""
  str = str & "<b><a href=""" & h & """>" & t & "</a></b> <br/> " & VbCrLF
  If (Trim(d) <> "") Then str = str & Shorten(d, 25, "...") & "<br/>" & VbCrLF
  str = str & "<a href=""" & h & """>" & h & "</a>" & VbCrLF
  If (Trim(p) <> "") Then str = str & "<br/>" & p & VbCrLF  
  FormatResult= Trim(str)
End Function

'+---------------------------------------------+
'Private Functions

Private Function ErrRaise(f, e)
  Err.Raise vbObjectError+1001, classname, f & ": " & e
  Response.End  
End Function 

Private Function GetXMLResults(q)
  GetXMLResults = XmlHttp( (q), xml_data, Headers)  
  'Server.URLEncode
End Function

'get results from cache or from web    
Private FUNCTION qCheckSum(d)
    'quick checksum
    Dim chks
    chks = 0
    Dim x
    For x = 1 To LEN(d)
      chks = chks + ( (ASC(Mid(d, x, 1))) * (x Mod 255) )
    Next
    qCheckSum = CLNG(chks)
End Function

'get results from cache or from web    
Private FUNCTION getResults(q)
  Dim res, a
  a = CacheFileName(q & xml_data)
  res = ""
  
  If (Trim(StrCachePath)<>"") Then res = ReadFile(a)   
  If (Trim(res) = "") Then
    res = getXMLResults(q) 
       
    'after many problems passing string straight back
    'writing and reading back solved the problem     
    Dim b
    b = objLinks("SITE_PATH")&"\core\cache\_class_rss-content-feed.cache" 
		debug("class.rss-content-feed.getResults: cache='"&b&"'") 
    Call DelFile(b)    
    Call Write2File(b, res)
    res = ReadFile(b)  
    Call DelFile(b)    
        
    If (Trim(StrCachePath)<>"") Then Call Write2File(a, res)     
    bFromcache = False  
  Else
    bFromcache = True  
  End if
  
  getResults = res
END FUNCTION

Private FUNCTION CacheFileName(n)

  Dim cn
  Dim cd
  cn = qCheckSum(n) 
  cd = DomainFromUrl(n)
  cn = StrCachePath & cd & "~" & cn & ".xml"
  CacheFileName = cn
End FUNCTION

Private Function DomainFromUrl(sText)
  Dim nIndex
  If (LCase(Left(sText, 7))) = "http://" Then sText = Mid(sText, 8)
  If LCase(Left(sText, 8 )) = "https://" Then sText = Mid(sText, 9)
  nIndex = InStr(sText, "/")
  If (nIndex > 0) Then sText = Left(sText, nIndex - 1)
  DomainFromUrl = sText
End Function

Private FUNCTION CacheContentCount(cache)
  CacheContentCount = 0
  If Trim(cache)="" Then Exit FUNCTION 
  If Not DExists(cache) Then Exit FUNCTION   
  CacheContentCount = CLNG(FolderCount(cache))
End FUNCTION

Private FUNCTION DeleteCacheContent(cache, age)
  If Trim(cache)="" Then Exit FUNCTION
  If Not DExists(cache) Then Exit FUNCTION
  
  'count cache
  Dim a
  a = CacheContentCount(cache)
  
  Dim fs
  Set fs = Createobject("Scripting.FileSystemobject") 
  Dim oFolder
  Set oFolder = fs.GetFolder(cache)
  Dim oFile
  For Each oFile in oFolder.Files  
    If (age <= (Int(Now() - oFile.DateLastModified))) Then
      oFile.Delete True 
    End If
  Next  
  Set fs = Nothing
  Set oFolder = Nothing  

  'count cache
  a = (CLNG(a) - CLNG(CacheContentCount(cache)))
  
  DeleteCacheContent = CLNG(a)
END FUNCTION

'+---------------------------------------------+
'Generic

'Retrieve response and return HTML response body
Public Function XmlHttp(xAction, data, hdrs)
  Dim HTTP, Raw
  Set Http = CreateObject("MSXML2.ServerXMLHTTP")
  'MSXML2.XMLHTTP
  
  if (Trim(data) <> "") then
    Http.open "POST", xAction, FALSE
    
    'add post hdr
    if (inStr(data, "<?xml")=1) then
      Http.setRequestHeader "Content-Type","text/xml"
    else
      Http.setRequestHeader "Content-Type","application/x-www-form-urlencoded"     
    end if
    Http.setRequestHeader "Content-Length",Len(data)
  else
  
    Http.open "GET", xAction, FALSE
  end if

  'get headers from the dict
  If IsObject(hdrs) Then
    Dim hdr
    For Each hdr in hdrs
      Http.setRequestHeader Trim(hdr), Trim(hdrs(hdr))
    Next
  End If

  Http.send (data)
  Raw = http.responseText
  Set Http = Nothing
  XmlHttp = Raw
End Function

Private Function DExists(d) 'true if file exists
  Dim fso
  Set fso = CreateObject("Scripting.FileSystemObject")
  DExists = fso.FolderExists(d)
  Set fso = Nothing
End Function
  
Private Function FExists(d) 'true if file exists
  Dim fso
  Set fso = CreateObject("Scripting.FileSystemObject")
  FExists = fso.FileExists(d)
  Set fso = Nothing
End Function
  
Private Function DelFile(f)
  If Trim(f)="" Then Exit FUNCTION  
  Dim fso
  Set fso = CreateObject("Scripting.FileSystemObject")
  if FExists(f) then fso.DeleteFile(f)
  Set fso = Nothing
End Function

Private FUNCTION FolderCount(dir)
  If Trim(dir)="" Then Exit FUNCTION  
  Dim fs
  Set fs = Createobject("Scripting.FileSystemobject") 
  Dim oFolder
  Set oFolder = fs.GetFolder(dir)
  FolderCount = oFolder.Files.Count  
  Set fs = Nothing
  Set oFolder = Nothing  
END FUNCTION

Private Function Write2File(afile,bstr)
  Dim wObj, wText
  if afile="" Then EXIT FUNCTION
  Set wObj = CreateObject("Scripting.FileSystemObject")
  Set wtext = wObj.OpenTextFile(afile, 8, True)

  Dim nCharPos, sChar
  For nCharPos = 1 To Len(bstr)
    sChar = Mid(bstr, nCharPos, 1)
    On Error resume next  '<-- **** Error handing starts ****
    wtext.Write sChar
    On Error Goto 0       '<-- ***** Error handing ends *****
  Next

  wtext.Close()
  Set wtext = Nothing
  Set wObj = Nothing
End Function

Private Function ReadFile(fpath)
  Dim fObj, ftext, fileStr  
  Set fObj = CreateObject("Scripting.FileSystemObject")
  If fObj.FileExists(fpath) Then
    Set ftext = fObj.OpenTextFile(fpath, 1, FALSE)
    fileStr =""
    WHILE NOT ftext.AtEndOfStream
      fileStr  = fileStr  & ftext.ReadLine & chr(13)
    WEND
    ftext.Close
  else
    fileStr = ""
  End if
  ReadFile= fileStr
End Function

Public Function Shorten(sentence, wds, addifShortened)
  Dim ret
  ret = Trim(sentence)
  Dim ar
  ReDim ar(1)
  ar = Split(ret)

  ret = ""
  Dim c 
  For c = 0 To UBOUND(ar)
  If c < wds Then
    ret = ret & " " & ar(c)
  End If 
  Next
  ret = Trim(ret)
  If Trim(ret) <> Trim(sentence) Then
    ret = ret & addifShortened
  End If 

  Shorten = ret
End Function 
  
Private FUNCTION GetNodeText(str_node, str_xml)
  Dim tmpString
  tmpString = Trim(str_xml)

  'declare an xml object to work with
  dim xmldoc
  set xmldoc = CreateObject("MSXML2.DOMDocument")
  xmldoc.async = False
  xmldoc.setProperty "ServerHTTPRequest", True
  
  'attempt to load from str
  xmldoc.LoadXML(tmpString)
  xmldoc.resolveExternals = False
  
  If (xmldoc is Nothing) Or (Len(xmldoc.text) = 0) then
    'error        
    EXIT FUNCTION
  End If
  'attempt to get Node Text
  Dim currNode
  tmpString = ""  
  Set currNode = xmlDoc.documentElement.selectSingleNode(str_node) 
  On Error Resume next
  tmpString = Trim(currNode.Text)
  On Error Goto 0  
  Set currNode = Nothing
  
  GetNodeText = Trim(tmpString)
END FUNCTION

'Transform XML with XSL string
Private FUNCTION TransformXML(xml, xslt)
  'Load XML
  Dim x
  set x = CreateObject("MSXML2.DOMDocument")  
  x.async = false
  x.setProperty "ServerHTTPRequest", True
    
  x.LoadXML(xml)
  x.resolveExternals = False

  If (x.parseError.errorCode <> 0) Then
      ErrRaise "TransformXML", "XML Parse error: " & x.parseError.reason 
      EXIT FUNCTION        
  End If 
  'Load XSL
  Dim xsl
  set xsl = CreateObject("MSXML2.DOMDocument")  
  xsl.async = false
  xsl.LoadXML(xslt)
  If (xsl.parseError.errorCode <> 0) Then
      ErrRaise "TransformXML", "XSL Parse error: " & xsl.parseError.reason 
      EXIT FUNCTION        
  End If 
  'Transform file
  TransformXML = (x.transformNode(xsl))
END FUNCTION

'get the ebay xml api response
Public FUNCTION GeteBayRSS(eBayVerb, eBayToken, eBayParam1, ebaySiteId, bProduction)
' eBayVerb: GetSearchResults | GetSellerList | GetCategoryListings
' eBayToken: http://developer.ebay.com/tokentool/Credentials.aspx
' eBayParam1: Search query, Seller Id or Category Id
' ebaySiteId: ebay SiteId
' bProduction: Production or Sandbox

  If Trim(eBayVerb) = "" Then
    ErrRaise "GeteBayRSS", "eBayVerb must be set"
    Exit Function
  End if
  If Trim(eBayToken) = "" Then
    ErrRaise "GeteBayRSS", "eBayToken must be set"
    Exit Function
  End if
  If Trim(ebaySiteId) = "" Then
    ebaySiteId = "0"
  End if
  bProduction = (bProduction=True)
              
  Headers.RemoveAll()  
  Headers.Add "X-EBAY-API-COMPATIBILITY-LEVEL", "305"
  Headers.Add "X-EBAY-API-DETAIL-LEVEL", "0" 
  Headers.Add "X-EBAY-API-CALL-NAME", eBayVerb
  Headers.Add "X-EBAY-API-SITEID", ebaySiteId 
  
  If (bProduction) then    
    xml_URL = eBayAPIURL    
  Else
    xml_URL = eBayAPISandboxURL
  End If      
  xml_data = eBayCreateRequestXML(eBayVerb, eBayToken, eBayParam1, ebaySiteId, iMaxResults)
  
  GeteBayRSS = GetRSS()
END FUNCTION 

'construct the ebay soap request xml
Private FUNCTION eBayCreateRequestXML(UserVerb, UserToken, qry, SiteId, UserMaxResults)
  Dim xml
  xml = ""
  xml = xml & "<?xml version=""1.0"" encoding=""iso-8859-1""?>" & VbCrLf
  xml = xml & "<request xmlns=""urn:eBayAPIschema"">" 
  xml = xml & "<RequestToken>" & UserToken & "</RequestToken>" & VbCrLf
  xml = xml & "<SiteId>" & SiteId & "</SiteId>" & VbCrLf
  xml = xml & "<DetailLevel>0</DetailLevel>" & VbCrLf
  xml = xml & "<ErrorLevel>1</ErrorLevel>" & VbCrLf
  xml = xml & "<MaxResults>" & UserMaxResults & "</MaxResults>" & VbCrLf

  xml = xml & "<Verb>" & UserVerb & "</Verb>" & VbCrLf
  SELECT Case LCASE(UserVerb)
    Case "getsearchresults":
      xml = xml & "<Query>" & qry & "</Query>" & VbCrLf
    Case "getsellerlist":
      xml = xml & "<UserId>" & qry & "</UserId>" & VbCrLf
      xml = xml & "<ItemsPerPage>" & UserMaxResults & "</ItemsPerPage>" & VbCrLf
      xml = xml & "<PageNumber>1</PageNumber>" & VbCrLf
      xml = xml & "<EndTimeFrom>2002-01-01 00:00:01</EndTimeFrom>" & VbCrLf
      xml = xml & "<EndTimeTo>2020-01-01 00:00:01</EndTimeTo>" & VbCrLf
    Case "getcategorylistings":
      xml = xml & "<CategoryId>" & qry & "</CategoryId>" & VbCrLf      
  END SELECT 
  xml = xml & "</request>" & VbCrLf
  eBayCreateRequestXML = Trim(xml)
END FUNCTION

Public FUNCTION eBayTimeLeft(eBayEndTime)
  Dim eBayOfficialTime  
  eBayOfficialTime = eBayTime
  If eBayOfficialTime="" Then Exit Function  
  eBayOfficialTime = Replace(eBayOfficialTime, "GMT", "")  
  eBayEndTime = Replace(eBayEndTime, "GMT", "") 
  Dim TimeLeft, TimeLeftD, TimeLeftH, TimeLeftM
  TimeLeft = DateDiff("n", eBayOfficialTime, eBayEndTime)  
  If TimeLeft<0 Then 
    eBayTimeLeft = "Ended " 
  Else
    TimeLeftD = Int(TimeLeft/( 60 * 24))
    TimeLeftH = Int((TimeLeft - (TimeLeftD * 60 * 24)) / 60)
    TimeLeftM = Int(TimeLeft - (TimeLeftD * 60 * 24) - (TimeLeftH * 60) )     
    eBayTimeLeft = TimeLeftD & "d " & TimeLeftH & "h " & TimeLeftM & "m " 
  End If 
END FUNCTION

Private FUNCTION eBayCurrencySymbolFromID(sym)
  Dim res, s
  res= ""
  s = trim(Sym)
  If (s= "") Then Exit FUNCTION
  If Not IsNumeric(s) Then Exit FUNCTION
  s = CLNG(s)
    
  SELECT CASE (S)
    case 1: res="$"
    case 2: res="C $"
    case 3: res="GBP"
    case 5: res="AU $"
    case 7: res="EUR"
    case 8: res="FRF"
    case 31: res="NLG"
    case 13: res="CHF"
    case 41: res="NT $"
  END SELECT
  eBayCurrencySymbolFromID = Trim(res)
END FUNCTION 

End Class

%>
