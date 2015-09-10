<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// Support/Audit/V7/Publishing/ClearPubApprovalTarget
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
<%@ page import="java.util.StringTokenizer" %>
<cs:ftcs>
<h3>Delete Publish/Approval Status per Target</h3>
<%
String cmd = ics.GetVar("cmd");
String[] tables = {"PubKeyTable", "ApprovedAssets","ApprovedAssetDeps","PubContext","PublishedAssets","PubSession", "PubMessage"}; 
String checkString ="I know what I am doing";
if ("true".equals(ics.GetVar("deletepub")) && ics.GetVar("targetid") != null){
	if (checkString.equals(ics.GetVar("check"))){
		%><h4>Start purging</h4><%
		String mytargetid = Utilities.replaceAll(ics.GetVar("targetid"),";",",");
		String[] sql = new String[7];
		for(int i=0; i< 3; i++){
			sql[i] = "DELETE FROM " + tables[i] + " WHERE targetid IN (" + mytargetid +")";
		}
		sql[3] = "DELETE FROM " + tables[3] + " WHERE cs_target IN (" + mytargetid +")";
		sql[4] = "DELETE FROM " + tables[4] + " WHERE NOT EXISTS(SELECT 1 FROM PubKeyTable WHERE id = PublishedAssets.pubkeyid)";
		sql[5] = "DELETE FROM " + tables[5] + " WHERE NOT EXISTS(SELECT 1 FROM PubContext WHERE cs_sessionid = PubSession.id)";
		sql[6] = "DELETE FROM " + tables[6] + " WHERE NOT EXISTS(SELECT 1 FROM PubSession WHERE id = PubMessage.cs_sessionid)";

		for(int i=0; i< sql.length; i++){
			String listname = null;
			StringBuffer errstr = new StringBuffer();

			ics.ClearErrno();
			int count=0;
			IList resultList = ics.SQL(tables[i], sql[i], listname, -1, true, errstr); 
			if (ics.GetErrno()==0 || ics.GetErrno()==-502){
				out.write("<br/>Rows from <b>" + tables[i] + "</b> purged.<br>");
			} else {
				out.write("<br/>Errno: " + ics.GetErrno() +" on " + tables[i] + ".<br>");
			}
			ics.FlushCatalog(tables[i]);
			
		}	
	 } else {
		%>the check string was not <i>&quot;<%= checkString %>&quot;</i><br><br>but: <i>&quot;<%= ics.GetVar("check") %>&quot;</i><br>Purging did not take place<br><%
	}
	
} else {
%>
<satellite:form satellite="false" name="form1" method="post" >
    To purge all <b>publish/approval history for a specific target</b>, you have to type <b><i>&quot;<%= checkString %>&quot;</i></b> in the checkbox below, select a specific target and press 
    Purge tables. 
  <p><input type="text" name="check"></p>
    <table class="altClass">
    	<ics:sql sql="SELECT id,name FROM PubTarget ORDER BY NAME" table="PubTarget" listname="targets"/>
    	<ics:listloop listname="targets">
    		<tr>
    			<td>
    				<input name="targetid" type="checkbox" value='<%=ics.ResolveVariables("targets.id") %>'/> 
    			</td>
    			<td>
    				<ics:resolvevariables name="targets.name"/>
    			</td>
    		</tr>
    	</ics:listloop>
    </table>
  <p><input name="Purge" type="submit" value="Purge tables"></p>
     <input type="hidden" name="pagename" value="Support/Audit/DispatcherFront">
     <input type="hidden" name="cmd" value='<%=cmd %>'>
     <input type="hidden" name="deletepub" value="true">
  <p>&nbsp; </p>
</satellite:form>

<%
}
String query="SELECT tblname,num FROM ( ";
for(int i=0; i< tables.length; i++){
	if (i>0) query +=" UNION ";
	query += "SELECT '"+tables[i] +"' as tblname , count(*) as num FROM " + tables[i];
	ics.FlushCatalog(tables[i]);
}
query += ") foo ORDER BY tblname";
%>
	<ics:callelement element="Support/Audit/Default/DB/DisplayQuery">
		<ics:argument name="query" value='<%= query %>' />
		<ics:argument name="table" value="ApprovedAssets" />
	</ics:callelement>
</cs:ftcs>
