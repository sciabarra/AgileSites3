<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld"
%><%//
// Support/SS/pagelet
//
// INPUT
//
// OUTPUT
//%>
<%@ page import="COM.FutureTense.Interfaces.FTValList"
%><%@ page import="COM.FutureTense.Interfaces.ICS"
%><%@ page import="COM.FutureTense.Interfaces.IList"
%><%@ page import="COM.FutureTense.Interfaces.Utilities"
%><%@ page import="COM.FutureTense.Util.ftErrors"
%><%@ page import="COM.FutureTense.Util.ftMessage"
%><cs:ftcs><hr/>
created: <b><%= new java.util.Date() %></b>&nbsp;<%= System.currentTimeMillis() %><br>
a:<b><%= ics.GetVar("a") %></b><br>
sessionid: <%= ics.SessionID() %><br>
page: <b><%= ics.pageURL() %></b><br>
cacheable: <b><%= ics.isCacheable(ics.GetVar("pagename")) %></b><br>
<hr/>
<a href="Satellite?pagename=Support/SS/pagelet&a=<%= ics.GetVar("a") %>">self</a><br/>
<a href="Satellite?pagename=Support/SS/pagelet&a=<%= ics.GetVar("a") %>0">a times ten</a>
</cs:ftcs>
