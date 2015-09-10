<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// Support/CacheManager/ShowCachedPageJSP
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
<%!
static String lightMarkers(String body){
    StringBuffer nb = new StringBuffer();
    int tStart = 0;
    int tEnd = 0;
    java.util.List list = new java.util.ArrayList();
    while ((tStart= body.indexOf("<page ",tEnd)) != -1){
        nb.append(body.substring(tEnd,tStart));
        if ((tEnd = body.indexOf("/page>",tStart)) > -1){
            nb.append("&lt;page ");
            nb.append(body.substring(tStart+6,tEnd));
            nb.append("/page&gt;");
        }
    }
    if (tEnd == 0)  {
        return body;
    } else {
        nb.append(body.substring(tEnd+6));
        return nb.toString();
    }
}
%><cs:ftcs><%
%><ics:sql sql='<%= ics.ResolveVariables("SELECT urlpage FROM SystemPageCache WHERE id = Variables.pid") %>' listname="page" table="SystemPageCache" /><%
%><%= lightMarkers(ics.ResolveVariables("page.@urlpage")) %><%
%></cs:ftcs>