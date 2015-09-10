<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// Support/Audit/V7/Publishing/ClearAssetPubList
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
<h3>Delete Leftover Entries in AssetPublishList table</h3>

<br/><b>Number of Pubsessions</b><br/>
<ics:callelement element="Support/Audit/Default/DB/DisplayQuery">
    <ics:argument name="query" value='SELECT cs_status as status, count(id) as num FROM PubSession GROUP BY cs_status' />
	<ics:argument name="table" value="PubSession" />
</ics:callelement>
<br/>
<b>Records in AssetPublishList</b><br/>
<%
String cmd = ics.GetVar("cmd");
	String query="";
	//query += "SELECT count(apl.id), ps.publishdate, ps.apl.*, PubSession '"+tables[i] +"' as tblname , count(*) as num FROM " + tables[i];
	query = "SELECT count(apl.id) as num, ps.cs_status as status, ps.cs_sessiondate, ps.cs_sessionuser FROM AssetPublishList apl, PubSession ps WHERE ps.id = apl.pubsession GROUP BY ps.cs_sessiondate, ps.cs_status, ps.cs_sessionuser ORDER BY ps.cs_sessiondate";
%>
	<ics:callelement element="Support/Audit/Default/DB/DisplayQuery">
		<ics:argument name="query" value='<%= query %>' />
		<ics:argument name="table" value="AssetPublishList" />
	</ics:callelement>
<%
String checkString ="I know what I am doing";
if ("true".equals(ics.GetVar("deletepub"))){
	if (checkString.equals(ics.GetVar("check"))){
		%><h4>Start purging</h4><hr/><%
		query = "DELETE FROM AssetPublishList WHERE pubsession IN (SELECT id FROM PubSession WHERE cs_status != 'R')";
		%><%= query %><%

		String listname = null;
		StringBuffer errstr = new StringBuffer();

		ics.ClearErrno();
		int count=0;
		IList resultList = ics.SQL("AssetPublishList", query, listname, -1, true, errstr); 
		if (ics.GetErrno()==0 || ics.GetErrno()==-502){
			out.write("<br/>Rows from AssetPublishList purged.<br>");
		} else {
			out.write("<br/>Errno: " + ics.GetErrno() +" on AssetPublishList.<br>");
		}

		ics.FlushCatalog("AssetPublishList");

	 } else {
		%>the check string was not <i>&quot;<%= checkString %>&quot;</i><br><br>but: <i>&quot;<%= ics.GetVar("check") %>&quot;</i><br>Purging did not take place<br><%
	}
	
} else {
%>
<satellite:form satellite="false" name="form1" method="post">
  To purge the enties from the <b>AssetPublishList</b> for all non-running pubsessions, you have to type <b><i>&quot;<%= checkString %>&quot;</i></b> in the checkbox below and press Purge
  <p><input type="text" name="check"></p>
  <p><input name="Purge" type="submit" value="Purge"></p>
     <input type="hidden" name="pagename" value="Support/Audit/DispatcherFront">
     <input type="hidden" name="cmd" value='<%=cmd %>'>
     <input type="hidden" name="deletepub" value="true">
  <p>&nbsp; </p>
</satellite:form>
<% } %>

</cs:ftcs>
