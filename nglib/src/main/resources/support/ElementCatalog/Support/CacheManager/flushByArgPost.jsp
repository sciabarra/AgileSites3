<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"%>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"%>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld"%>
<%//
// Support/CacheManager/flushByArgPost
//
// INPUT
//
// OUTPUT
//
%>
<%@ page import="java.util.StringTokenizer"%>
<%@ page import="COM.FutureTense.Interfaces.FTValList"%>
<%@ page import="COM.FutureTense.Interfaces.ICS"%>
<%@ page import="COM.FutureTense.Interfaces.IList"%>
<%@ page import="COM.FutureTense.Interfaces.Utilities"%>
<%@ page import="COM.FutureTense.Util.ftErrors"%>
<%@ page import="COM.FutureTense.Util.ftMessage"%>
<%@ page import="COM.FutureTense.Util.ftStatusCode"%>
<%@ page import="COM.FutureTense.Cache.CacheManager"%>
<%@ page import="COM.FutureTense.Cache.CacheHelper"%>
<cs:ftcs>
<h3>Flush Pages by Name-Value pair</h3>

<%
String name = ics.GetVar("cmName");
String value = ics.GetVar("cmValue");
String [] idlist = null;
String errorMsg = null;

if (!Utilities.goodString(name))
{
	ics.SetErrno(ftErrors.badparams);
	errorMsg="You must specify at least a name";
}
else
{
	CacheManager cm = new CacheManager(ics);
	cm.setPagesByArg(ics,name,value);
	ftStatusCode sc = null;
	if ("on".equals(ics.GetVar("cs-cs")))
	{
%>
    <h4>Flushing pages from ContentServer cached for a browser</h4>
<%
		sc = cm.flushCSEngine(ics,CacheHelper._cs);
		ics.SetObj("cmStatusCode",sc);
		ics.CallElement("Support/CacheManager/dumpStatusCodes",null);
		ics.SetObj("cmStatusCode",null);
	}
	if ("on".equals(ics.GetVar("cs-ss")))
	{
%>
    <h4>Flushing pages from ContentServer cached for CS Satellite</h4>
<%
		sc = cm.flushCSEngine(ics,CacheHelper._ss);
		ics.SetObj("cmStatusCode",sc);
		ics.CallElement("Support/CacheManager/dumpStatusCodes",null);
		ics.SetObj("cmStatusCode",null);
	}
	if ("on".equals(ics.GetVar("ss")))
	{
%>
    <h4>Flushing pages from CS Satellite</h4>
<%
		sc = cm.flushSSEngines(ics);
		ics.SetObj("cmStatusCode",sc);
		ics.CallElement("Support/CacheManager/dumpStatusCodes",null);
		ics.SetObj("cmStatusCode",null);
	}
}
%>			
<% if (ics.GetErrno() < 0) { %>
    Error: <%= errorMsg%>
<% } %>
</cs:ftcs>
