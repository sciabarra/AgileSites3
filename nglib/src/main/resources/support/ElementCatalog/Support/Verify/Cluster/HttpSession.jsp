<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// Support/Verify/Cluster/HTTPSession
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
<center><h3>HttpSession</h3></center>
<%
java.text.DateFormat df = new java.text.SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
%><table class="altClass">
<tr><td nowrap>getCreationTime</td><td><%= df.format(new java.util.Date(session.getCreationTime())) %></td><td>Returns the time when this session was created, measured in milliseconds since midnight January 1, 1970 GMT.</td></tr>
<tr><td nowrap>getId</td><td><%= session.getId() %></td><td>Returns a string containing the unique identifier assigned to this session. </td></tr>
<tr><td nowrap>getLastAccessedTime</td><td><%= df.format(new java.util.Date(session.getLastAccessedTime()))  %></td><td>Returns the last time the client sent a request associated with this session, as the number of milliseconds since midnight January 1, 1970 GMT, and marked by the time the container recieved the request. </td></tr>
<tr><td nowrap>getMaxInactiveInterval</td><td><%= session.getMaxInactiveInterval()  %></td><td>Returns the maximum time interval, in seconds, that the servlet container will keep this session open between client accesses. </td></tr>
<tr><td nowrap>isNew</td><td><%= session.isNew()  %></td><td>Returns true if the client does not yet know about the session or if the client chooses not to join the session.</td></tr>
</table>
</cs:ftcs>
