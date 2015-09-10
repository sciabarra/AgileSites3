<%@ page contentType="text/html; charset=utf-8"
%><%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld"
%><%@ taglib prefix="time" uri="futuretense_cs/time.tld"
%>
<%//
// Support/Performance/PageIntensive
//
// INPUT
//
// OUTPUT
//%>
<cs:ftcs><time:set name="mystamp" /><%
boolean cached = "true".equals(ics.GetVar("cached"));
String pagename="Support/Performance/SimplePageToCall";
if (cached) pagename="Support/Performance/SimpleCachedPageToCall";

for (int i=0;i<Integer.parseInt(ics.GetVar("number"));i++){
%><satellite:page pagename="<%= pagename %>"/><%
}
%>
<time:get name="mystamp" /> ms<br>
</cs:ftcs>