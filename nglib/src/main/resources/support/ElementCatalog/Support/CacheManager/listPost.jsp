<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%
//
// Support/CacheManager/listPost
//
// INPUT
//
// OUTPUT
//
%><%@ page import="COM.FutureTense.Cache.CacheManager"
%><%@ page import="COM.FutureTense.Cache.CacheHelper"
%><cs:ftcs>
<%
// create the cache manager
CacheManager cm = new CacheManager(ics);                 

if ("on".equals(ics.GetVar("ss"))) {
	%><h3>Satellite Cache</h3><br/><%
    for (String inventory : cm.getSSInventory(ics,CacheHelper.sNames)) {
		// dump the contents of each server!
		%><h5><%=inventory %></h5><br/><%
	}
}
if ("on".equals(ics.GetVar("cs"))) {
	%><h3>ContentServer Cache</h3><br/>
	<h5><%=cm.getCSInventory(ics,CacheHelper.sBasic)%></h5><%
} 
%></cs:ftcs>
