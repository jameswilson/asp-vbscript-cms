<%
'+---------------------------------------------+
'| RSS Content Feed VBScript Class 1.0         |
'| © 2004 www.tele-pro.co.uk                   |
'| http://www.tele-pro.co.uk/scripts/rss/      |
'| The RSSContentFeed Class makes it easy to   |
'| download and display RSS XML feeds.         |
'+---------------------------------------------+
  
class RSSContentFeed

'+---------------------------------------------+

'declare class variables

'strings
private classname
private xml_URL  
private xml_data   
private StrResultsXML 
private StrCachePath
private Strchannel
private Strtitle
private Strlink
private Strdescription
private StrRSSVersion  
private imgTitle 
private imgUrl 
private imgLink 

'ebay 
private eBayAPIURL
private eBayAPISandboxURL
private imgBuyItNow  
 
public eBayTime 'date  

'int
private iTotalResults
private icacheDays
private iMaxResults
private imgWidth
private imgHeight 
  
'bool
private bFromcache
  
'dict
private Headers

'arrays
public Results()
public Links()
public Titles()
public Descriptions()  
public PubDates()
public Images()
public Ids()
  
'+---------------------------------------------+
'Class functions

'Class_Initialize
private sub Class_Initialize
  Initialize
end sub
           
'Class_Terminate
private sub Class_Terminate  
  'empty the cache
  DeleteCache()

  'empty the dict
  if IsObject(Headers) then
    Headers.RemoveAll
    set Headers = nothing
  end if
  
end sub

public sub Initialize 
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
  set Headers = Createobject("Scripting.Dictionary")
  Clear()
end sub

'+---------------------------------------------+

public sub Clear 

  'Clear search variables
  iTotalResults =0  
  bFromcache = FALSE  
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
  
  redim Results(1)
  redim Links(1)
  redim Titles(1)
  redim Descriptions(1)  
  redim PubDates(1)
  redim Images(1)
  redim Ids(1)
end sub

'+---------------------------------------------+
'public Properties - Readonly

'show the copyright info
public property get Version
  Version = "XML RSS Content Feed VBScript Class Version 1.0 " & vbCrLf & _
            "© 2004 www.tele-pro.co.uk"
end property

public property get TotalResults
  TotalResults = iTotalResults
end property
public property get CacheCount
  CacheCount = CacheContentCount(StrCachePath)
end property
public property get Fromcache
  Fromcache= (bFromcache = TRUE)
end property
public property get ChannelLink
  ChannelLink= Trim(Strlink)
end property
public property get ChannelTitle
  ChannelTitle= Trim(Strtitle)
end property
public property get ChannelDescription
  ChannelDescription = Trim(Strdescription)
end property  
public property get ChannelImgURL
  ChannelImgURL = Trim(imgURL)
end property  
public property get ChannelImgTitle
  ChannelImgTitle = Trim(imgTitle)
end property  
public property get ChannelImgLink
  ChannelImgLink = Trim(imgLink)
end property  
public property get ChannelImgWidth
  ChannelImgWidth = clng(imgWidth)
end property
public property get ChannelImgHeight
  ChannelImgHeight = clng(imgHeight)
end property
public property get ResultsXML
  ResultsXML = Trim(strResultsXML)
end property
public property get RSSVersion
  RSSVersion = Trim(strRSSVersion)
end property

'+---------------------------------------------+
'public Properties - settable

'show the xml_URL 
public property get ContentURL
  ContentURL = Trim(xml_URL)
end property
'set the xml_URL 
public property let ContentURL(ByVal vContentURL)
  vContentURL = Trim(vContentURL)
  'add protocol if necessary
  if inStr(LCASE(vContentURL), "http://")=0 then
    vContentURL = "http://" & vContentURL
  end if
  xml_URL = Trim(vContentURL)
end property

public property get PostData
  PostData = Trim(xml_data)
end property
public property let PostData(sxml_data)
  xml_data = Trim(sxml_data)
end property 

public property get Cache
  Cache = Trim(StrCachePath)
end property
public property let Cache(ByVal sCache)
  StrCachePath = ""
  if Trim(sCache)<>"" then
  
    if Not DExists(sCache) then 
      ErrRaise "SetCache" , "Cache folder does not exist " 
    Else
      'rem last slash
      if (Mid(sCache, LEN(sCache), 1) = "\") then
        sCache = Mid(sCache, 1, LEN(sCache)-1)
      end if 
      'add slash 
      StrCachePath = Trim(sCache) & "\"      
    end if    
  end if
end property

public property get CacheDays
  CacheDays = clng(iCacheDays)
end property
public property let CacheDays(iDays)
  iCacheDays = clng(iDays)
end property

public property get MaxResults
  MaxResults = clng(iMaxResults)
end property
public property let MaxResults(vMaxResults)
  iMaxResults = clng(vMaxResults)
end property

'+---------------------------------------------+
'public functions

'Delete items in Cache
public function DeleteCache()
  if (Trim(StrCachePath)<>"") then
    DeleteCache = DeleteCacheContent(StrCachePath, icacheDays)
  end if
end function

'add header for http request
public function AddHeader(str_hdr, str_val)
  'add header to dict for http request
  if Not (Headers.Exists(Trim(str_hdr))) then 
    Headers.Add Trim(str_hdr), Trim(str_val)
  Else
    Headers(str_hdr) = Trim(str_val)
  end if
end function

'transform xml with xsl
public function Transform(str_xslt)
  if Trim(StrResultsXML)="" then exit function
  if Trim(str_xslt)="" then exit function
  
  'Load XML
  dim x
  set x = CreateObject("MSXML2.DOMDocument")  
  x.async = FALSE  
  x.setProperty "ServerHTTPRequest", TRUE  

  'path or url?
  if (inStr(str_xslt, "http")=1) then 'url
      dim tmpStr
      tmpStr = getResults(str_xslt)
      x.LoadXML(tmpStr)        
  Else
    if (inStr(str_xslt, "\")=0) then 'needs mapping
      str_xslt = Server.MapPath(str_xslt) 
      x.Load(str_xslt) 
    end if  
  end if  
  x.resolveExternals = FALSE
  
  if (x.parseError.errorCode <> 0) then
    ErrRaise "Transform", "XML error: " & x.parseError.reason 
    exit function        
  end if 
  str_xslt = x.xml

  Transform = TransformXML(StrResultsXML, str_xslt)  
end function

'retrieve the value of a node
public function XMLValue(str_node)
  if Trim(StrResultsXML)="" then exit function
  XMLValue = GetNodeText(str_node, StrResultsXML)
end function

'construct amazon rss url and call getrss function
public function GetAmazonRSS(t, devt, kwd, mode, bcm)
'check 
If Trim(t) = "" then
  ErrRaise "GetAmazonRSS", "Associate tag must be set"
  exit function
end if
If Trim(devt) = "" then
  ErrRaise "GetAmazonRSS", "Developer token must be set"
  exit function
end if
If Trim(kwd) = "" then
  ErrRaise "GetAmazonRSS", "KeywordSearch token must be set"
  exit function
end if
If Trim(mode) = "" then
  mode = "books"
end if
  
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
end function

'+---------------------------------------------+
'main function

public function GetRSS()

  'clear search
  Clear()
  
  'check xml_URL
  if Trim(xml_URL) = "" then
    ErrRaise "GetRSS", "ContentURL must be set"
  end if
    
  'get results from web or cache 
  dim soapResults, soapResultsStd  
  soapResults = getResults(xml_URL)  
  
  'Dump the results into an XML document.
  dim Res
  set Res = CreateObject("MSXML2.DOMDocument")  
  Res.async = FALSE 
   
  'set the global xml string
  StrResultsXML = Trim(soapResults) 
  soapResultsStd = DeSensitize(soapResults)
    
  Res.setProperty "ServerHTTPRequest", TRUE
  Res.loadXML soapResultsStd
  Res.resolveExternals = FALSE    
  
  if (Res.parseError.errorCode <> 0) then
    ErrRaise "GetRSS", "XML error: " & Res.parseError.reason 
    exit function        
  end if    
  
  'set the global xml string to the xml formatted string
  if Trim(soapResultsStd) = Trim(soapResults) then 
    StrResultsXML = Trim(Res.XML)  
  end if
  
  dim Node, Nodes   

  '---------------------------------------------------------
  'get RSS  Version
  
  StrRSSVersion = ""
  set Nodes = Res.selectNodes("//rss")
  for each Node in Nodes          
    on error resume next 
    strRSSVersion = Node.getAttribute("version")
    on error goto 0              
  next  
  
  if (Trim(strRSSVersion)="") then 
    set Nodes = Res.selectNodes("//eBay")
    for each Node in Nodes  
      strRSSVersion = "eBay"       
    next     
  end if
      
  if (Trim(strRSSVersion)="") then
    set Nodes = Res.selectNodes("//rdf:RDF")
    for each Node in Nodes          
      on error resume next 
      strRSSVersion = Node.getAttribute("xmlns") 
      if Trim(strRSSVersion) = "http://purl.org/rss/1.0/" then 
        strRSSVersion = "1.0"
      end if
      on error Goto 0              
    next            
  end if
  
  if (Trim(strRSSVersion)="eBay") then 
    set Nodes = Res.selectNodes("//eBayTime")
    for each Node in Nodes  
      eBayTime = Node.Text      
    next     
  end if
  
  '---------------------------------------------------------
  
  'set the size of arrays to the max results
  dim c
  c=0  
  
  'get the size
  set Nodes = Res.selectNodes("//item")  
  for each Node in Nodes
    if (c<iMaxResults) then
      c = c + 1
    end if
  next
  
  'set the size
  redim Results(c-1)
  redim Links(c-1)
  redim Titles(c-1)
  redim Descriptions(c-1)
  redim PubDates(c-1)
  redim Images(c-1)
  redim Ids(c-1)
    
  'get item content   
  'declare results strings
  dim res_URL
  dim res_title
  dim res_desc
  dim res_date
  dim res_img
  dim res_id

  'ebay
  dim CurrencyId, CurrentPrice, BidCount
      
  'Parse the XML document.
  c=0 
  for each Node in Nodes
  if (c<iMaxResults) then
  
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
    if (Trim(res_desc)="") then    
      on error resume next
      res_desc = Trim(Node.selectSingleNode("dc:description").XML)
      on error goto 0
    end if 
    
    res_desc = Replace(res_desc, "<description>", "")
    res_desc = Replace(res_desc, "</description>", "")
    
    'or it might be ebay
    if (strRSSVersion = "eBay") then
    if (Trim(res_desc)="") then
      
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
      res_desc = res_desc & Trim(BidCount) & " bids) " & vbCrLf
      
      'construct description
      on error resume next	  
      if Trim(Node.selectSingleNode("ItemProperties//BuyItNow").Text)="1" then        
        res_desc = res_desc & " &nbsp;<a href="""
        res_desc = res_desc & res_URL
        res_desc = res_desc & """><img align=""absmiddle"" border=""0"" src="""  
        res_desc = res_desc & imgBuyItNow
        res_desc = res_desc & """ alt=""Buy It Now""></a>" & vbCrLf        
      end if   
      on error goto 0    
      
      'ItemProperties//Featured
      'ItemProperties//New
      'ItemProperties//IsFixedPrice
      'ItemProperties//Gift
      'ItemProperties//CharityItem      
        
    end if 
    end if '(strRSSVersion = "eBay") 

    'optional tags
    on error resume next
    res_date = Node.selectSingleNode("pubDate").Text  
    'ebay
    if (Trim(res_date)="") then
      res_date = Node.selectSingleNode("EndTime").Text 
    end if           
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
    end if                     
  end if                     
  next    
  
  '---------------------------------------------------------
 
  'get channel content 
  set Nodes = Res.selectNodes("//channel")
  for each Node in Nodes      
    on error resume next
    Strlink = Node.selectSingleNode("link").Text
    Strtitle = Node.selectSingleNode("title").Text
    Strdescription = Node.selectSingleNode("description").Text
    on error Goto 0              
  next
 
  'get image
  set Nodes = Res.selectNodes("//image")
  for each Node in Nodes   
    on error resume next
    imgTitle = Node.selectSingleNode("title").Text
    imgUrl = Node.selectSingleNode("url").Text
    imgLink = Node.selectSingleNode("link").Text
    imgWidth = Node.selectSingleNode("width").Text
    imgHeight = Node.selectSingleNode("height").Text
    on error Goto 0              
  next
    
  'release objects
  set Nodes  = nothing  
  set Res = nothing
  
  'return count
  iTotalResults = c
  GetRSS = c    
end function

private function DeSensitize(Istr)
  dim str
  str = Istr
  str = Replace(str, "<Item>", "<item>", 1, -1, 1)
  str = Replace(str, "<Link>", "<link>", 1, -1, 1)
  str = Replace(str, "<Title>", "<title>", 1, -1, 1)
  str = Replace(str, "</Item>", "</item>", 1, -1, 1)
  str = Replace(str, "</Link>", "</link>", 1, -1, 1)
  str = Replace(str, "</Title>", "</title>", 1, -1, 1) 
  DeSensitize = str
end function

public function ItemHTML(iNumber)
  dim r_URL, r_title, r_description, r_pubdate
  
  if (iTotalResults=0) then
    ErrRaise "ItemHTML", "There are no items"
    exit function
  end if
  if (iNumber>=iTotalResults) then
    ErrRaise "ItemHTML", "Item index out of bounds"
    exit function
  end if
  
  r_URL = Links(iNumber)
  r_title= Titles(iNumber)
  r_description = Descriptions(iNumber)
  r_pubdate = PubDates(iNumber)
  
  ItemHTML = Trim(FormatResult(r_URL, r_title, r_description, r_pubdate))
end function
  
private function FormatResult(h, t, d, p)
  dim str
  str = ""
  str = str & "<b><a href=""" & h & """>" & t & "</a></b> <br/> " & vbCrLf
  if (Trim(d) <> "") then str = str & Shorten(d, 25, "...") & "<br/>" & vbCrLf
  str = str & "<a href=""" & h & """>" & h & "</a>" & vbCrLf
  if (Trim(p) <> "") then str = str & "<br/>" & p & vbCrLf  
  FormatResult= Trim(str)
end function

'+---------------------------------------------+
'private functions

private function ErrRaise(f, e)
  Err.Raise vbObjectError+1001, classname, f & ": " & e
  Response.End  
end function

private function GetXMLResults(q)
  GetXMLResults = XmlHttp( (q), xml_data, Headers)  
  'Server.URLEncode
end function

'get results from cache or from web    
private function qCheckSum(d)
    'quick checksum
    dim chks
    chks = 0
    dim x
    for x = 1 to LEN(d)
      chks = chks + ( (ASC(mid(d, x, 1))) * (x mod 255) )
    next
    qCheckSum = clng(chks)
end function

'get results from cache or from web    
private function getResults(q)
  dim res, a
  a = CacheFileName(q & xml_data)
  res = ""
  
  if (Trim(StrCachePath)<>"") then res = ReadFile(a)   
  if (Trim(res) = "") then
    res = getXMLResults(q) 
       
    'after many problems passing string straight back
    'writing and reading back solved the problem     
    dim b
    b = globals("SITE_PATH")&"\core\cache\_class_rss-content-feed.cache" 
		debug("class.rss-content-feed.getResults: cache='"&b&"'") 
    Call DelFile(b)    
    Call Write2File(b, res)
    res = ReadFile(b)  
    Call DelFile(b)    
        
    if (Trim(StrCachePath)<>"") then Call Write2File(a, res)     
    bFromcache = FALSE  
  else
    bFromcache = TRUE  
  end if
  
  getResults = res
end function

private function CacheFileName(n)

  dim cn
  dim cd
  cn = qCheckSum(n) 
  cd = DomainFromUrl(n)
  cn = StrCachePath & cd & "~" & cn & ".xml"
  CacheFileName = cn
end function

private function DomainFromUrl(sText)
  dim nIndex
  if (LCase(Left(sText, 7))) = "http://" then sText = Mid(sText, 8)
  if LCase(Left(sText, 8 )) = "https://" then sText = Mid(sText, 9)
  nIndex = InStr(sText, "/")
  if (nIndex > 0) then sText = Left(sText, nIndex - 1)
  DomainFromUrl = sText
end function

private function CacheContentCount(cache)
  CacheContentCount = 0
  if Trim(cache)="" then exit function 
  if Not DExists(cache) then exit function   
  CacheContentCount = clng(FolderCount(cache))
end function

private function DeleteCacheContent(cache, age)
  if Trim(cache)="" then exit function
  if Not DExists(cache) then exit function
  
  'count cache
  dim a
  a = CacheContentCount(cache)
  
  dim fs
  set fs = Createobject("Scripting.FileSystemobject") 
  dim oFolder
  set oFolder = fs.GetFolder(cache)
  dim oFile
  for each oFile in oFolder.Files  
    if (age <= (Int(Now() - oFile.DateLastModified))) then
      oFile.Delete TRUE 
    end if
  next  
  set fs = nothing
  set oFolder = nothing  

  'count cache
  a = (clng(a) - clng(CacheContentCount(cache)))
  
  DeleteCacheContent = clng(a)
end function

'+---------------------------------------------+
'Generic

'Retrieve response and return HTML response body
public function XmlHttp(xAction, data, hdrs)
  dim HTTP, Raw
  set Http = CreateObject("MSXML2.ServerXMLHTTP")
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
  if IsObject(hdrs) then
    dim hdr
    for each hdr in hdrs
      Http.setRequestHeader Trim(hdr), Trim(hdrs(hdr))
    next
  end if

  Http.send (data)
  Raw = http.responseText
  set Http = nothing
  XmlHttp = Raw
end function

private function DExists(d) 'TRUE if file exists
  dim fso
  set fso = CreateObject("Scripting.FileSystemObject")
  DExists = fso.FolderExists(d)
  set fso = nothing
end function
  
private function FExists(d) 'TRUE if file exists
  dim fso
  set fso = CreateObject("Scripting.FileSystemObject")
  FExists = fso.FileExists(d)
  set fso = nothing
end function
  
private function DelFile(f)
  if Trim(f)="" then exit function  
  dim fso
  set fso = CreateObject("Scripting.FileSystemObject")
  if FExists(f) then fso.DeleteFile(f)
  set fso = nothing
end function

private function FolderCount(dir)
  if Trim(dir)="" then exit function  
  dim fs
  set fs = Createobject("Scripting.FileSystemobject") 
  dim oFolder
  set oFolder = fs.GetFolder(dir)
  FolderCount = oFolder.Files.Count  
  set fs = nothing
  set oFolder = nothing  
end function

private function Write2File(afile,bstr)
  dim wObj, wText
  if afile="" then exit function
  set wObj = CreateObject("Scripting.FileSystemObject")
  set wtext = wObj.OpenTextFile(afile, 8, TRUE)

  dim nCharPos, sChar
  for nCharPos = 1 to Len(bstr)
    sChar = mid(bstr, nCharPos, 1)
    on error resume next  '<-- **** Error handing starts ****
    wtext.Write sChar
    on error goto 0       '<-- ***** Error handing ends *****
  next

  wtext.Close()
  set wtext = nothing
  set wObj = nothing
end function

private function ReadFile(fpath)
  dim fObj, ftext, fileStr  
  set fObj = CreateObject("Scripting.FileSystemObject")
  if fObj.FileExists(fpath) then
    set ftext = fObj.OpenTextFile(fpath, 1, FALSE)
    fileStr =""
    while not ftext.AtEndOfStream
      fileStr  = fileStr  & ftext.ReadLine & chr(13)
    wend
    ftext.Close
  else
    fileStr = ""
  end if
  ReadFile= fileStr
end function

public function Shorten(sentence, wds, addifShortened)
  dim ret
  ret = Trim(sentence)
  dim ar
  redim ar(1)
  ar = Split(ret)

  ret = ""
  dim c 
  for c = 0 to UBOUND(ar)
  if c < wds then
    ret = ret & " " & ar(c)
  end if 
  next
  ret = Trim(ret)
  if Trim(ret) <> Trim(sentence) then
    ret = ret & addifShortened
  end if 

  Shorten = ret
end function
  
private function GetNodeText(str_node, str_xml)
  dim tmpString
  tmpString = Trim(str_xml)

  'declare an xml object to work with
  dim xmldoc
  set xmldoc = CreateObject("MSXML2.DOMDocument")
  xmldoc.async = FALSE
  xmldoc.setProperty "ServerHTTPRequest", TRUE
  
  'attempt to load from str
  xmldoc.LoadXML(tmpString)
  xmldoc.resolveExternals = FALSE
  
  if (xmldoc is nothing) Or (Len(xmldoc.text) = 0) then
    'error        
    exit function
  end if
  'attempt to get Node Text
  dim currNode
  tmpString = ""  
  set currNode = xmlDoc.documentElement.selectSingleNode(str_node) 
  on error resume next
  tmpString = Trim(currNode.Text)
  on error goto 0  
  set currNode = nothing
  
  GetNodeText = Trim(tmpString)
end function

'Transform XML with XSL string
private function TransformXML(xml, xslt)
  'Load XML
  dim x
  set x = CreateObject("MSXML2.DOMDocument")  
  x.async = FALSE
  x.setProperty "ServerHTTPRequest", TRUE
    
  x.LoadXML(xml)
  x.resolveExternals = FALSE

  if (x.parseError.errorCode <> 0) then
      ErrRaise "TransformXML", "XML Parse error: " & x.parseError.reason 
      exit function        
  end if 
  'Load XSL
  dim xsl
  set xsl = CreateObject("MSXML2.DOMDocument")  
  xsl.async = FALSE
  xsl.LoadXML(xslt)
  if (xsl.parseError.errorCode <> 0) then
      ErrRaise "TransformXML", "XSL Parse error: " & xsl.parseError.reason 
      exit function        
  end if 
  'Transform file
  TransformXML = (x.transformNode(xsl))
end function

'get the ebay xml api response
public function GeteBayRSS(eBayVerb, eBayToken, eBayParam1, ebaySiteId, bProduction)
' eBayVerb: GetSearchResults | GetSellerList | GetCategoryListings
' eBayToken: http://developer.ebay.com/tokentool/Credentials.aspx
' eBayParam1: Search query, Seller Id or Category Id
' ebaySiteId: ebay SiteId
' bProduction: Production or Sandbox

  if Trim(eBayVerb) = "" then
    ErrRaise "GeteBayRSS", "eBayVerb must be set"
    exit function
  end if
  if Trim(eBayToken) = "" then
    ErrRaise "GeteBayRSS", "eBayToken must be set"
    exit function
  end if
  if Trim(ebaySiteId) = "" then
    ebaySiteId = "0"
  end if
  bProduction = (bProduction=TRUE)
              
  Headers.RemoveAll()  
  Headers.Add "X-EBAY-API-COMPATIBILITY-LEVEL", "305"
  Headers.Add "X-EBAY-API-DETAIL-LEVEL", "0" 
  Headers.Add "X-EBAY-API-CALL-NAME", eBayVerb
  Headers.Add "X-EBAY-API-SITEID", ebaySiteId 
  
  if (bProduction) then    
    xml_URL = eBayAPIURL    
  Else
    xml_URL = eBayAPISandboxURL
  end if      
  xml_data = eBayCreateRequestXML(eBayVerb, eBayToken, eBayParam1, ebaySiteId, iMaxResults)
  
  GeteBayRSS = GetRSS()
end function

'construct the ebay soap request xml
private function eBayCreateRequestXML(UserVerb, UserToken, qry, SiteId, UserMaxResults)
  dim xml
  xml = ""
  xml = xml & "<?xml version=""1.0"" encoding=""iso-8859-1""?>" & vbCrLf
  xml = xml & "<request xmlns=""urn:eBayAPIschema"">" 
  xml = xml & "<RequestToken>" & UserToken & "</RequestToken>" & vbCrLf
  xml = xml & "<SiteId>" & SiteId & "</SiteId>" & vbCrLf
  xml = xml & "<DetailLevel>0</DetailLevel>" & vbCrLf
  xml = xml & "<ErrorLevel>1</ErrorLevel>" & vbCrLf
  xml = xml & "<MaxResults>" & UserMaxResults & "</MaxResults>" & vbCrLf

  xml = xml & "<Verb>" & UserVerb & "</Verb>" & vbCrLf
  SELECT Case LCASE(UserVerb)
    Case "getsearchresults":
      xml = xml & "<Query>" & qry & "</Query>" & vbCrLf
    Case "getsellerlist":
      xml = xml & "<UserId>" & qry & "</UserId>" & vbCrLf
      xml = xml & "<ItemsPerPage>" & UserMaxResults & "</ItemsPerPage>" & vbCrLf
      xml = xml & "<PageNumber>1</PageNumber>" & vbCrLf
      xml = xml & "<EndTimeFrom>2002-01-01 00:00:01</EndTimeFrom>" & vbCrLf
      xml = xml & "<EndTimeTo>2020-01-01 00:00:01</EndTimeTo>" & vbCrLf
    Case "getcategorylistings":
      xml = xml & "<CategoryId>" & qry & "</CategoryId>" & vbCrLf      
  END SELECT 
  xml = xml & "</request>" & vbCrLf
  eBayCreateRequestXML = Trim(xml)
end function

public function eBayTimeLeft(eBayEndTime)
  dim eBayOfficialTime  
  eBayOfficialTime = eBayTime
  if eBayOfficialTime="" then exit function  
  eBayOfficialTime = Replace(eBayOfficialTime, "GMT", "")  
  eBayEndTime = Replace(eBayEndTime, "GMT", "") 
  dim TimeLeft, TimeLeftD, TimeLeftH, TimeLeftM
  TimeLeft = DateDiff("n", eBayOfficialTime, eBayEndTime)  
  if TimeLeft<0 then 
    eBayTimeLeft = "Ended " 
  Else
    TimeLeftD = Int(TimeLeft / (60 * 24))
    TimeLeftH = Int((TimeLeft - (TimeLeftD * 60 * 24)) / 60)
    TimeLeftM = Int(TimeLeft - (TimeLeftD * 60 * 24) - (TimeLeftH * 60) )     
    eBayTimeLeft = TimeLeftD & "d " & TimeLeftH & "h " & TimeLeftM & "m " 
  end if 
end function

private function eBayCurrencySymbolFromID(sym)
  dim res, s
  res= ""
  s = trim(Sym)
  if (s= "") then exit function
  if Not IsNumeric(s) then exit function
  s = clng(s)
    
  select case (S)
    case 1: res="$"
    case 2: res="C $"
    case 3: res="GBP"
    case 5: res="AU $"
    case 7: res="EUR"
    case 8: res="FRF"
    case 31: res="NLG"
    case 13: res="CHF"
    case 41: res="NT $"
  end select
  eBayCurrencySymbolFromID = Trim(res)
end function

end class

%>
