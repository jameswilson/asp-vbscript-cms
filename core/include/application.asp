<%@ Language=VBScript %>
<%Option Explicit%>
<%
'**
'* @file 
'*   Application bootstrap file.
'*
'* This file is responsible for running the full appliation,  processing the 
'* client request, and styling the page output.
'* 

'**
'* Bootstrap the application.
'* 
%><!--#include file="bootstrap.asp"--><%

'**
'* Include router file to handle the client request.
'* 
%><!--#include file="router.asp"--><%

'**
'* Include template file.
'* 
%><!--#include file="template.asp"--><%


%>