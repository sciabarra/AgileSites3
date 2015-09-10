<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// Support/Audit/Default/SysVariables
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

<center><h3>Java System Properties</h3></center>
<table class="altClass">
<%
Enumeration e = System.getProperties().propertyNames();
while ( e.hasMoreElements() ) {
  String sVarName = (String)e.nextElement();
  String sVarValue = System.getProperty(sVarName );
%><tr><td><%= sVarName %></td><td><%= sVarValue %></tr>
<% } %>
</table>

<p/>

<center><h3>Environment Variables</h3></center>
<table class="altClass">
<%
for (java.util.Map.Entry<String, String> entry : System.getenv().entrySet()) {
	%><tr><td><%=entry.getKey()%></td><td><%=entry.getValue()%></td></tr><%
}
%>
</table>

</cs:ftcs>
