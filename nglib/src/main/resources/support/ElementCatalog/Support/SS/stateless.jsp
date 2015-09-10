<%@ page session="false"
%><%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld"
%><%//
// Support/SS/stateless
//
// INPUT
//
// OUTPUT
//
%><%@ page import="COM.FutureTense.Util.ftMessage"
%><cs:ftcs>
<%
COM.FutureTense.ContentServer.PageData mypage = ics.getPageData(ics.GetVar(ftMessage.PageName));
String ccsession = (String)mypage.getDefaultArguments().get(ftMessage.ccsession);
%>ccsession: <%= ccsession %><br/>
Hello World
</cs:ftcs>