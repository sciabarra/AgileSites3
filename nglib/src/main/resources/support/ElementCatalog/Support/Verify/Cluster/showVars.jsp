<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// Support/Verify/Cluster/showVars
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
<cs:ftcs><br>
Host: <%=  java.net.InetAddress.getLocalHost().toString() %><br>
<%
for(Enumeration e=ics.GetVars(); e.hasMoreElements();) {
	String key = (String)e.nextElement();
	String value = ics.GetVar(key);
	%><%= key %>:<%= value %><br><%
}
for(Enumeration e=ics.GetSSVars(); e.hasMoreElements();) {
	String key = (String)e.nextElement();
	String value = ics.GetSSVar(key);
	%><%= key %>:<%= value %><br><%
}
%></cs:ftcs>
