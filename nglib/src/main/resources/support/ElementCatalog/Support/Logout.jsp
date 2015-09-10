<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld"
%><%@ taglib prefix="user" uri="futuretense_cs/user.tld"
%><%//
// Support/Logout
//
// INPUT
//
// OUTPUT
//%>
<%@ page import="COM.FutureTense.Interfaces.ICS"
%><cs:ftcs><%
String redir = "Support/Home";
if (ics.GetVar("redir") !=null){
    redir=ics.GetVar("redir");
}
%><ics:catalogmanager><ics:argument name="ftcmd" value="logout"/><ics:argument name="killsession" value="true"/></ics:catalogmanager><%
%><html><head><meta http-equiv="refresh" content='0;URL=ContentServer?pagename=<%= redir %>'></head></html><%
%></cs:ftcs>