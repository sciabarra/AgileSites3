<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// Support/Verify/Cluster/remoteDispatch
//
// INPUT
//
// OUTPUT
//%><%@ page import="COM.FutureTense.Interfaces.FTValList, COM.FutureTense.Util.*"%><cs:ftcs><%
String url= ics.GetVar("fp.url");
String pn= ics.GetVar("fp.pagename");
String u= ics.GetVar("fp.username");
String pw= ics.GetVar("fp.password");
String resp = "";
//out.write(url);
//out.write(u);
//out.write(pw);

FormPoster fp = new FormPoster();
FTValList cookies = null;
if(u != null){
	fp.setURL(url + "CatalogManager");
	fp.login(true,null,u,pw);
	cookies = fp.getCookies();
	fp.reset();
}
if (true){
	fp.setAction(FormPoster.Post);
	fp.setURL(url + "ContentServer");
	fp.addTextValue("pagename",pn);
	//if(cookies != null) fp.setCookies(cookies);
	fp.post();
	resp = fp.cleanResponse();
	ics.SetVar("fp.response",resp);
}
%></cs:ftcs>
