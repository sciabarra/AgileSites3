<%@ page contentType="text/html; charset=utf-8"
%><%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld"
%><%//
// Support/Audit/Default/DB/Menu
//
// INPUT
//
// OUTPUT
//
%><%@ page import="COM.FutureTense.Interfaces.FTValList"
%><%@ page import="COM.FutureTense.Interfaces.ICS"
%><%@ page import="COM.FutureTense.Interfaces.IList"
%><%@ page import="COM.FutureTense.Interfaces.Utilities"
%><%@ page import="COM.FutureTense.Util.ftErrors"
%><%@ page import="COM.FutureTense.Util.ftMessage"
%><cs:ftcs>
<center><h3>DB Consistency Check</h3></center>
<table class="altClass">
<tr>
<td><b><satellite:link pagename="Support/Audit/DispatcherFront" ><satellite:argument name="cmd" value="DB/cleartemptables"/></satellite:link><a href='<ics:getvar name="referURL"/>'>TT-Tables</a></b></td>
<td>&nbsp;</td>
<td>&nbsp;</td>
</tr>

<tr>
<td><b><satellite:link pagename="Support/Audit/DispatcherFront" ><satellite:argument name="cmd" value="DB/Queries"/></satellite:link><a href='<ics:getvar name="referURL"/>'>ContentServer Queries</a></b></td>
<td>&nbsp;</td>
<td>&nbsp;</td>
</tr>

<tr>
<td><b><satellite:link pagename="Support/Audit/DispatcherFront" ><satellite:argument name="cmd" value="DB/CSDirectQueries"/></satellite:link><a href='<ics:getvar name="referURL"/>'>CS-Direct Queries</a></b></td>
<td>CSDirect releated</td>
<td>&nbsp;</td>
</tr>

<tr>
<td><b><satellite:link pagename="Support/Audit/DispatcherFront" ><satellite:argument name="cmd" value="DB/AssetTypeQueries"/></satellite:link><a href='<ics:getvar name="referURL"/>'>AssetType Queries</a></b></td>
<td>AssetType</td>
<td>&nbsp;</td>
</tr>
</table>
</cs:ftcs>
