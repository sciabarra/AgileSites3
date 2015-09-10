<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// Support/DB/AssetTypeQueries
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
<%@ page import="java.util.StringTokenizer"%>

<cs:ftcs>

<center><h3>AssetType Queries</h3></center>

<%
String queryids = ics.GetVar("queryid");
String assettypes = ics.GetVar("assettype");

String query[][] = {
{"SELECT * FROM Variables.atype WHERE template NOT IN (SELECT name FROM Template)","Variables.atype","Does Variables.atype have a non existant Template?"},
{"SELECT template, COUNT(id) as num FROM Variables.atype GROUP BY template ORDER BY template","Variables.atype","How often is a default template defined for an Variables.atype?"},
{"SELECT status, COUNT(id) as num FROM Variables.atype GROUP BY status ORDER BY status","Variables.atype","How is status distributed for an Variables.atype?"}
};

if (queryids!=null && assettypes != null) { 
	StringTokenizer atz = new StringTokenizer(assettypes,";");
	while(atz.hasMoreTokens()){
		String assettype=atz.nextToken();
		ics.SetVar("atype",assettype);
		StringTokenizer qtz = new StringTokenizer(queryids,";");
		while(qtz.hasMoreTokens()){
			String queryid= qtz.nextToken();
			int qid = Integer.parseInt(queryid);
			if (qid >=0 && qid < query.length) {
				%>
				<h4><%= ics.ResolveVariables(query[qid][2]) %></h4>
				<%= ics.ResolveVariables(query[qid][0]) %><br>
				<ics:callelement element="Support/Audit/Default/DB/DisplayQuery">
					<ics:argument name="query" value='<%= ics.ResolveVariables(query[qid][0]) %>' />
					<ics:argument name="table" value='<%= ics.ResolveVariables(query[qid][1]) %>' />
				</ics:callelement>
				<br><%
			}
		}
	}
}
%>
<satellite:form satellite="false" name="form1" method="post">
  <table>
  <tr>
      <td width="10%"><b>AssetType:</b></td>
      <td width="35%"><select name="assettype" size="15" multiple>
<%
String sql ="SELECT assettype, description FROM AssetType ORDER BY AssetType.description ASC";

StringBuffer sql_errors = new StringBuffer();
ics.ClearErrno();
IList rset = ics.SQL ("AssetType", sql, null,  -1, true, sql_errors);
if (ics.GetErrno() == 0) {
	int counter = rset.numRows();
	for (int i=1; i<=counter; i++) {
		rset.moveTo(i);
		String desc = rset.getValue("description");
		String assetType = rset.getValue("assettype");
		%><option value="<%= assetType %>"><%=desc %></option><%
	}
}
%>
      </select></td>
      <td width="55%">
<%
ics.SetVar("atype","assettype");
for (int i=0; i< query.length; i++){
%>
         <label><input type="checkbox" name="queryid" value='<%= i %>'>
         &nbsp;<%= ics.ResolveVariables(query[i][2]) %></label><br/><br/><br/><br/>
<% } %>
      </td>
    </tr>
  <tr>      
      <td>
      <input name="pagename" type="hidden" value="Support/Audit/DispatcherFront">
      <input name="cmd" type="hidden" value='<%= ics.GetVar("cmd") %>'>
      <input type="submit" name="Submit" value="Submit">
      </td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
  </tr>
  </table>
</satellite:form>
</br>

</cs:ftcs>
