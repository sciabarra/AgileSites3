<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// Support/Audit/Default/CSVariables
//
// INPUT
//
// OUTPUT
//%>
<%@ page import="COM.FutureTense.Interfaces.FTValList" %>
<%@ page import="COM.FutureTense.Interfaces.ICS" %>
<%@ page import="COM.FutureTense.Interfaces.IList" %>
<%@ page import="COM.FutureTense.Interfaces.Utilities" %>
<%@ page import="COM.FutureTense.Util.ftErrors" %>
<%@ page import="COM.FutureTense.Util.ftMessage"%>
<%@ page import="java.util.*"%>
<cs:ftcs>

<h3>WebCenter Sites Variables</h3>
<table class="altClass">
<%
Enumeration e = ics.GetVars();
while ( e.hasMoreElements()) {
  String sVarName = (String)e.nextElement();
  String sVarValue = ics.GetVar( sVarName );
%><tr><td><%= sVarName %></td><td><%= sVarValue %></tr>
<% } %>
</table>

<br/><h3>WebCenter Sites SessionVariables</h3>
<table class="altClass">
<%
e = ics.GetSSVars();
while ( e.hasMoreElements()) {
  String sVarName = (String)e.nextElement();
  String sVarValue = ics.GetSSVar( sVarName );
%><tr><td><%= sVarName %></td><td><%= sVarValue %></tr>
<% } %>
</table>

</cs:ftcs>
