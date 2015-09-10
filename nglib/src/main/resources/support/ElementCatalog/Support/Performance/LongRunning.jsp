<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// Support/Performance/LongRunning
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
<cs:ftcs>
<html>
<head>
<title>Long running performance test</title>
</head>
<body>
<%
String waitTimeStr = ics.GetVar("waitTime");
long waitTime = 500L;
if (waitTimeStr != null){
	try {
		waitTime = Long.parseLong(waitTimeStr);
	} catch (Exception e){
		%>Exception:<%= e.getMessage() %><br><%
	}
}
%>Waiting for <%= waitTime %> milliseconds<br><%
try {
	Thread.sleep(waitTime);
} catch (InterruptedException e){

}
%>
End!
</body>
</html>
</cs:ftcs>