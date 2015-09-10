<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%//
// Support/Verify/Cluster/ClusterTest
//
// INPUT
//
// OUTPUT
//%>
<%@ page import="COM.FutureTense.Interfaces.ICS" %>
<%@ page import="COM.FutureTense.Interfaces.Utilities" %>
<%@ page import="java.util.*"%>
<cs:ftcs>
<center><h3>Basic Cluster test</h3></center>
<table class="altClass">
<tr><th>runtime hashCode</th><th>Current thread</th><th>Session id</th></tr>
<tr><td><%= Runtime.getRuntime().hashCode()  %></td><td><%= Thread.currentThread().getName() %></td><td><%= ics.SessionID() %></td><tr>
</table>
<hr/>
<table class="altClass">
<tr><th>Unique ID</th><th>Session counter</th></tr>
<%
String tmp="";
for (int i=0; i<60; i++) {
    String current = ics.GetSSVar("sessionCounter");
    if (current == null) {
        ics.SetSSVar("sessionCounter","0");
        current = ics.GetSSVar("sessionCounter");
    }
    int curVal = new Integer(current).intValue();
    ics.SetSSVar("sessionCounter", new String("" + (++curVal)));
    %><tr><td><%= Utilities.genID(ics) %></td><td><%= ics.GetSSVar("sessionCounter") %></td></tr><%
}
%>
</table>
</cs:ftcs>
