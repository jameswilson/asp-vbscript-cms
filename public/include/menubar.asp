<%
	dim rsPages, strLink, objChildren, sql
	sql="SELECT * "_
		 &"FROM tblPages "_
		 &"WHERE (((tblPages.Active)=True) AND ((tblPages.MainMenu)=True)) "_
		 &"ORDER BY tblPages.ParentPage DESC , tblPages.MenuIndex;"
	set rsPages = db.getRecordSet(sql)
	writeln( vbcrlf )
	writeln( indent(2) & "<div><div>")
	writeln( indent(2) & "<div class=""wrapper clearfix"">")
	'writeln( indent(3) &	h2("Main Menu"))
	writeln( indent(3) &	"<ul id=""menu""")

	if rsPages is nothing then
		'means no database was found.
		writeln(indent(3)& ">"&CreateNavlink(objLinks.item("SITEURL"),"Sample Link",null,null)& "<ul class=""sub-menu""")
		writeln(indent(4)& ">"&CreateNavlink(objLinks.item("SITEURL"),"Subnav Link 1",null,null)& "</li")
		writeln(indent(4)& ">"&CreateNavlink(objLinks.item("SITEURL"),"Subnav Link 2",null,null)& "</li")
		writeln(indent(4)& ">"&CreateNavlink(objLinks.item("SITEURL"),"Subnav Link 3",null,null)& "</li")
		writeln(indent(4)& "><li><hr/></li")
		writeln(indent(4)& ">"&CreateNavlink(objLinks.item("SITEURL"),"Subnav Link 4",null,null)& "</li")
		writeln(indent(4)& ">"&CreateNavlink(objLinks.item("SITEURL"),"Subnav Link 5",null,null)& "</li></ul")
		writeln(indent(3)& "><li class=""current""><strong><a href="""&objLinks.item("SITEURL")&""">Selected Link</a></strong><ul class=""sub-menu""")
		writeln(indent(4)& ">"&CreateNavlink(objLinks.item("SITEURL"),"Subnav Link 1",null,null)& "</li")
		writeln(indent(4)& "><li class=""current""><strong><a href="""&objLinks.item("SITEURL")&""">Selected Subnav</a></strong></li")
		writeln(indent(4)& ">"&CreateNavlink(objLinks.item("SITEURL"),"Subnav Link 3",null,null)& "</li")
		writeln(indent(4)& "><li><hr/></li")
		writeln(indent(4)& ">"&CreateNavlink(objLinks.item("SITEURL"),"Subnav Link 4",null,null)& "</li")
		writeln(indent(4)& ">"&CreateNavlink(objLinks.item("SITEURL"),"Subnav Link 5",null,null)& "</li></ul")
		writeln(indent(3)& ">"&CreateNavlink(objLinks.item("SITEURL"),"Sample Link",null,null)& "</li")
		writeln(indent(3)& ">"&CreateNavlink(objLinks.item("SITEURL"),"Another Link",null,null)& "</li")
		writeln(indent(3)& ">"&CreateNavlink(objLinks.item("SITEURL"),"Last Link",null,"last")& "</li")
	elseif rsPages.state > 0 then
		if rsPages.EOF or rsPages.BOF then 
			writeln (">"& createNavLink(objLinks.item("ADMINURL"), "Add Content", "There appears to be no active webpages for this site. Add content in the Admin area.","last") & "</li")
		else
			set objChildren = Server.CreateObject("Scripting.Dictionary")
			rsPages.MoveFirst
			do until rsPages.EOF
			'pass through the child pages first
				strLink =  CreateNavLink(rsPages("PageFileName"), rsPages("PageName"), rsPages("PageLinkHoverText"), null) 
				if rsPages("ParentPage") > 0 then
					if not objChildren.exists(""&rsPages("ParentPage")) then 
						'add first child link for specified parentpage
						objChildren.add ""&rsPages("ParentPage"),  indent(4)& ">" & strLink & "<" 
					else
						'because of dictionary rules, you cannot append directly to an existing key
						'therefore to add secondary children links, must use a temp string...
						' 1. add existing children to temp string
						' 2. add new child to temp string
						strLink = objChildren.item(""&rsPages("ParentPage")) & "/li" & vbcrlf & indent(4) & ">" & strLink & "<" 
						' 3. remove the old (existing) children key/value pair
						objChildren.remove(""&rsPages("ParentPage")) 
						' 4. add temp string containing new child
						objChildren.add ""&rsPages("ParentPage"),  strLink  
					end if
				else
					'pass through the parents
					response.write(indent(3) & ">" & strLink & "<")
					if objChildren.exists(""&rsPages("PageID")) then 
						response.write("ul class=""sub-menu""" & vbcrlf)
						writeln(objChildren.item(""&rsPages("PageID")) & "/li></ul></li")
					else 
						response.write( "/li" & vbcrlf)
					end if
				end if
				trapError
				rsPages.MoveNext
			loop
		end if
	end if 
	writeln(indent(3) &	"></ul>" & vbcrlf)
	writeln(indent(2) & "</div>" & vbcrlf )
	writeln(indent(2) & "</div></div>" & vbcrlf )
%>