<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// Support/Audit/V7/Publishing/ClearPubApproval
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
<h3>Delete Entire Publish/Approval Status</h3>
<br/>
<%
String cmd = ics.GetVar("cmd");
String[] tables = {"PubKeyTable", "PublishedAssets", "ApprovedAssets","ApprovedAssetDeps","PubSession","PubContext","AssetPublishList"}; 
	String query="";
for(int i=0; i< tables.length; i++){
//	String query = "delete from " + tables[i];
	if (i>0) query +=" UNION ";
	query += "SELECT '"+tables[i] +"' as tblname , count(*) as num FROM " + tables[i];
	ics.FlushCatalog(tables[i]);
}
%>
	<ics:callelement element="Support/Audit/Default/DB/DisplayQuery">
		<ics:argument name="query" value='<%= query %>' />
		<ics:argument name="table" value="ApprovedAssets" />
	</ics:callelement>
<%
/*
	String listname = null;
	StringBuffer errstr = new StringBuffer();


	ics.ClearErrno();
	int count=0;
	IList resultList = ics.SQL(tables[i], query, listname, -1, true, errstr); 
	if (ics.GetErrno()==0 || ics.GetErrno()==-502){
		out.write("Rows from " + tables[i] + " deleted.<br>");
	} else {
		out.write("Errno: " + ics.GetErrno() +" on " + tables[i] + ".<br>");
	}
*/
String checkString ="I know what I am doing";
if ("true".equals(ics.GetVar("deletepub"))){
	if (checkString.equals(ics.GetVar("check"))){
		%><h4>Start purging</h4><hr/><%
		for(int i=0; i< tables.length; i++){
			query = "DELETE FROM " + tables[i];
			String listname = null;
			StringBuffer errstr = new StringBuffer();

			ics.ClearErrno();
			int count=0;
			IList resultList = ics.SQL(tables[i], query, listname, -1, true, errstr); 
			if (ics.GetErrno()==0 || ics.GetErrno()==-502){
				out.write("Rows from <b>" + tables[i] + "</b> purged.<br>");
			} else {
				out.write("Errno: " + ics.GetErrno() +" on " + tables[i] + ".<br>");
			}
			ics.FlushCatalog(tables[i]);
		}
	 } else {
		%>the check string was not <i>&quot;<%= checkString %>&quot;</i><br><br>but: <i>&quot;<%= ics.GetVar("check") %>&quot;</i><br>Purging did not take place<br><%
	}
} else {
%>
<satellite:form satellite="false" name="form1" method="post">
    To purge <b>entire publish/approval history accumulated</b>, you have to type <b><i>&quot;<%= checkString %>&quot;</i></b> in the checkbox below and press 
    Purge tables
  <p><input type="text" name="check"></p>
  <p><input name="Purge" type="submit" value="Purge tables"></p>
     <input type="hidden" name="pagename" value="Support/Audit/DispatcherFront">
     <input type="hidden" name="cmd" value='<%=cmd %>'>
     <input type="hidden" name="deletepub" value="true">
  <p>&nbsp; </p>
</satellite:form>

<% } %>

</cs:ftcs>
