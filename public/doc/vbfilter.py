#!/usr/bin/env python
# -*- coding: utf-8 -*-	
#
# This is a filter to convert Visual Basic v6.0 code
# into something doxygen can understand.
# Copyright (C) 2005  Basti Grembowietz
# 
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
# ------------------------------------------------------------------------- 
#
# This filter depends on following circumstances:
# in VB-code,
#  '! comments get converted to doxygen-class-comments (comments to a class)
#  '* comments get converted to doxygen-comments (function, sub etc)
#
#
# v0.1 - 2004-12-25
#  initial work
# v0.2 - 2004-12-30
#  added states
# v0.3 - 2004-12-31
#  removed states =)
# v0.4 - 2005-01-01
#  added class-comments
# v0.5 - 2005-01-03
#  changed default behaviour from "private" to "public"
#  + fixed re_doxy (whitespace now does not matter anymore)
#  + fixed re_sub and re_func (brackets inside brackets ok now)
# v0.6 - 2005-02-14
#  minor changes
# v0.7 - 2005-02-23
#  refactoring: removed double code.
#  + VB-Types are enabled now
#  + Doxygen-Comments can also start in the line of the feature which should be documented
# v0.8 - 2005-02-25
#  changed command line switches: now the usage is just "vbfilter.py filename".
# v0.9 - 2005-03-09
#  added handling of friends in vb.
# v0.10 - 2005-04-14
#  added handling of Property Let and Set
#  added recognition of default-values for parameters
# v0.11 - 2005-05-05
#  fixed handling of Property Get ( instead of Set ... )


import getopt          # get command-line options
import os.path         # getting extension from file
import string          # string manipulation
import sys             # output and stuff
import re              # for regular expressions

## stream to write output to
outfile = sys.stdout

# regular expression
## re to strip comments from file
re_comments   = re.compile("([^\']*)\'.*")
re_VB_Name    = re.compile(r"\s*class\s+(\w+)", re.I)

## re to search doxygen-class-comments
re_doxy_class = re.compile("[^']*\'!(.*)")
## re to search doxygen-comments
re_doxy       = re.compile("[^']*\'\*(.*)")
## re to search for global variables members (used in bas-files)
re_globals    = re.compile(r"\s*(Const\s+)?([^']+)", re.I)
## re to search for class-members (used in cls-files)
re_members    = re.compile(r"\s*(Public\s+|Friend\s+|Private\s+|Static\s+){0,1}([\w\(\)]+)", re.I)
## re to search Subs 
re_sub        = re.compile(r"\s*(Public\s+|Friend\s+|Private\s+|(S|s)tatic\s+){0,1}(Sub|Property\s+Let)\s+(\w+)\s*(\([\w =,\(\)]*\))", re.I)
## re to search Functions
re_function = re.compile(r"\s*(Public\s+|Friend\s+|Private\s+|(S|s)tatic\s+){0,1}(Function|Property\s+Get)\s+(\w+)\s*(\([\w =,\(\)]*\))\s+", re.I)
## re to search for type-statements
re_type     = re.compile(r"\s*(Public\s+|Friend\s+|Private\s+|Static\s+){0,1}Type\s+(\w+)", re.I)
## re to search for type-statements
re_endType  = re.compile(r"End\s+Type", re.I)

# default "level" (private / public / protected) to take when not specified
def_level = "public:"

# strips vb-style comments from string
def strip_comments(str):
	global re_comments
	my_match = re_comments.match(str)
	if my_match is not None:
		return my_match.group(1)
	else:
		return str

# dumps the given file
def dump(filename):
	f = open(filename)
	r = f.readlines()
	f.close()
	for s in r:
		sys.stdout.write("."), 
		sys.stdout.write(s)

def processGlobalComments(r):
	global re_doxy_class
	# we have to look for global comments first!
	# they start with '!
	for s in r:
		gcom = re_doxy_class.match(s)
		if gcom is not None:
			# found global comment
			if (gcom.group(1) is not None):
				# write this comment to file
				outfile.write("/// " + gcom.group(1) + "\n")

def processClassName(r):
	global re_VB_Name
	sys.stderr.write("Searching for classname... ") 
	className = "dummy"
	for s in r:
		# now search for a class name
		cname = re_VB_Name.match(strip_comments(s))
		if cname is not None:
			# ok, className is found, so save it...
			sys.stderr.write("found! ") 
			className = cname.group(1)
			# ...and leave searching-loop
			break
	# ok, so let's start writing the pseudo-class
	sys.stderr.write(" using " + className + "\n") 
	outfile.write("\nclass " + className + "\n{\n") 

def checkDoxyComment(s):
	global re_doxy
	doxy = re_doxy.match(s)
	if (doxy is not None):
	# a comment was found... so write it
		outfile.write("/// " + doxy.group(1) + "\n")
		# 2005-01-03 : do not continue -> member-comments can now be in the same line as members
		#continue # and go to next line in source

def foundMember(s):
	global re_members
	member = re_members.match(strip_comments(s))
	if (member is not None):
		#	produce resulting string
		res_str = getAccessibility(member.group(1)) + " " + member.group(3) + " " + member.group(2)  + ";"
		# and deliver it
		outfile.write(res_str + "\n")
		return True
	else:
		return False

def foundFunction(s):
	global re_function
	s_func = re_function.match(strip_comments(s))	 # s_func == start_of_a_function
	if (s_func is not None):
		# now make the resulting string
		res_str = getAccessibility(s_func.group(1)) + " " + s_func.group(5) + " " + s_func.group(3) + s_func.group(4) + ";"
		# and deliver this string
		outfile.write(res_str + "\n")
		return True
	else:
		return False

def foundSub(s):
	global def_level # for private/public/protected-issue
	global re_sub
	s_sub = re_sub.match(strip_comments(s))
	if (s_sub is not None):
		#	produce resulting string
		res_str = getAccessibility(s_sub.group(1)) + " void " + s_sub.group(3) + s_sub.group(4)  + ";"
		# and deliver it
		outfile.write(res_str + "\n")
		return True
	else:
		return False

def getAccessibility(s):
	accessibility = def_level
	if (s is not None):
		if (s.strip().lower() == "private"): accessibility = "private:"
		elif (s.strip().lower() == "public"): accessibility = "public:"
		elif (s.strip().lower() == "friend"): accessibility = "friend "
		elif (s.strip().lower() == "static"): accessibility = "static"
	return accessibility

def foundMemberOfType(s):
	global re_members
	member = re_members.match(strip_comments(s))
	if (member is not None):
		#	produce resulting string
		res_str = member.group(3) + " " + member.group(2)  + ";"
		# and deliver it
		outfile.write(res_str + "\n")

def foundType(s):
	global re_type
	vbType = re_type.match(strip_comments(s))
	if (vbType is not None):
		#	produce resulting string
		res_str = getAccessibility(vbType.group(1)) + " struct " + vbType.group(2)  + " {"
		# and deliver it
		outfile.write(res_str + "\n")
		return True
	else:
		return False

def processType(s):
	global re_endType
	vbEndType = re_endType.match(strip_comments(s))
	if (vbEndType is not None): # found End Type
		outfile.write("}; \n") #write end of struct
		return False
	else:
		# match <var AS type>
		# write <type var;>
		foundMemberOfType(s)
		return True

# filters .cls-files - VB-CLASS-FILES
def filterCLS(filename):
	global outfile ## get global variable
	f = open(filename)
	r = f.readlines()
	f.close()
	outfile.write("\n// -- processed by [filterCLS] --\n") 

	processGlobalComments(r)

	processClassName(r)

	# now scan every line and look either for doxy-comments, members or functions/subs
	# searching for multiline-type-statements, we need a flag here:
	inTypeSearch = False

	for s in r:
		checkDoxyComment(s)

		if inTypeSearch:
			inTypeSearch = processType(s)
			continue
		
		if foundType(s):
			inTypeSearch = True
			continue

		#	see if line contains a member
		if foundMember(s):
			continue # line could not contain anything more than a member

		# see if there is a function-statement
		if foundFunction(s):
			continue

		# there was no match to a function - let's try a sub
		if foundSub(s):
			continue

	outfile.write("}")  # for ending class
	outfile.write("\n// -- [/filterCLS] --\n") 


# filters .bas-files
def filterBAS(filename):
	global outfile ## get global variable
	f = open(filename)
	r = f.readlines()
	outfile.write("\n// -- processed by [filterBAS] --\n") 

	processGlobalComments(r)

	processClassName(r)

	# now scan every line and look either for doxy-comments or functions/subs
	# or both
	
	# searching for multiline-type-statements, we need a flag here:
	inTypeSearch = False

	for s in r:
		checkDoxyComment(s)

		if inTypeSearch:
			inTypeSearch = processType(s)
			continue
		
		if foundType(s):
			inTypeSearch = True
			continue

		# line is not a comment. 
		# see if there is a function-statement
		if foundFunction(s):
			continue

		# there was no match to a function - let's try a sub
		if foundSub(s):
			continue

	outfile.write("}")  # for ending class
	outfile.write("\n// -- [/filterBAS] --\n") 

## main filter-function ##
##
## this function decides whether the file is
## (*) a bas file  - module
## (*) a cls file  - class
## (*) a frm file  - frame
##
## and calls the appropriate function

def filter(filename, out=sys.stdout):
	global outfile
	outfile = out

	try:
		root, ext = os.path.splitext(filename)
		if (root.lower() == "class") or (ext.lower() ==".cls") or (ext.lower() == ".frm"):
			## if it is a class or frame call filterCLS
			filterCLS(filename)
		elif (ext.lower() ==".bas") or (root.lower() == "function") or (ext.lower() == ".asp"):
			## if it is a module call filterBAS
			filterBAS(filename)
		else:
			## if it is an unknown extension, just dump it
			dump(filename)

		sys.stderr.write("OK\n") 
	except IOError,e:
		sys.stderr.write(e[1]+"\n")

## main-entry ##
################

if len(sys.argv) != 2:
	print "usage: ", sys.argv[0], " filename"
	sys.exit(1)

# Filter the specified file and print the result to stdout
filename = sys.argv[1] 
filter(filename)
sys.exit(0)
