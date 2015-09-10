<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// Support/DB/Queries
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

<center><h3>CSApps Queries</h3></center>

<%
String queryid = ics.GetVar("queryid");

String query[][] = {

//{"SELECT * FROM Template WHERE rootelement NOT IN (SELECT name FROM ElementCatalog)","ElementCatalog","Templates without an existing Rootelement"},
//{"SELECT * FROM Template WHERE rootelement  NOT IN (SELECT rootelement FROM SiteCatalog)","Template","Templates without an existing SiteCatalog entry"},
{"SELECT DISTINCT username FROM UserPublication WHERE username NOT IN (SELECT 'userid=' || id || ',ou=People'  from SystemUsers)","UserPublication","Are there users defined in UserPublication that are not in SystemUsers"},
{"SELECT oid FROM SitePlanTree WHERE otype='Publication' AND oid NOT IN (SELECT id FROM Publication)","SitePlanTree","SitePlanTree"},
{"SELECT DISTINCT ncode FROM SitePlanTree","SitePlanTree","SitePlanTree"},
{"SELECT * FROM SitePlanTree WHERE ncode = 'UnPlaced'","SitePlanTree","SitePlanTree"},
{"SELECT * FROM SitePlanTree WHERE ncode = 'Void'","SitePlanTree","SitePlanTree"},
{"SELECT * FROM SitePlanTree WHERE nparentid in (SELECT t1.nid FROM SitePlanTree t1 WHERE otype='Publication')","SitePlanTree","SitePlanTree"},
{"SELECT assettype, count(id) as num FROM PublishedAssets GROUP BY assettype ORDER BY assettype","PublishedAssets","PublishedAssets"},
{"SELECT count(*), pubkeyid FROM PublishedAssets GROUP BY pubkeyid HAVING count(*) >1","PublishedAssets","PublishedAssets"},
{"SELECT assetid, assettype FROM AssetPublication WHERE assetid IN (SELECT t1.assetid  FROM PubKeyTable t1, publishedassets t2 WHERE t2.assetid=1044630334634 AND t2.pubkeyid = t1.id)","AssetPublication","AssetPublication"},
{"SELECT ownerid, count(assetid) as NUM FROM ApprovedAssetDeps GROUP BY ownerid ORDER BY NUM","ApprovedAssetDeps","ApprovedAssetDeps"},
{"SELECT assettype, tstate, count(id) as num FROM ApprovedAssets GROUP BY assettype, tstate ORDER BY tstate,assettype","ApprovedAssets","ApprovedAssets"},
{"SELECT t2.name, t1.assettype, count(t1.assetid) as num FROM AssetPublication t1, Publication t2 WHERE t1.assetid NOT IN (SELECT assetid FROM ApprovedAssets) AND t1.pubid = t2.id GROUP BY t2.name, t1.assettype ORDER BY t2.name, t1.assettype","ApprovedAssets","Assets outside the approval process"},
{"SELECT t2.name FROM CSElement t2 WHERE NOT EXISTS (SELECT 1 FROM ElementCatalog WHERE name = t2.rootelement)","CSElement","CSElements without a root element"}
};

if (queryid!=null){ 
	int qid = Integer.parseInt(queryid);
	if (qid >=0 && qid < query.length) {
		%>
		<h4><%= query[qid][2] %></h4>
		<%= query[qid][0] %><br/>
		<ics:callelement element="Support/Audit/Default/DB/DisplayQuery">
			<ics:argument name="query" value='<%= query[qid][0] %>' />
			<ics:argument name="table" value='<%= query[qid][1] %>' />
		</ics:callelement>
		<br>
		<% 
		if (qid > 0) {
			%><a href='ContentServer?pagename=<%= ics.GetVar("pagename") %>&#38;cmd=<%= ics.GetVar("cmd") %>&#38;queryid=<%= (qid - 1) %>'>Previous</a>&nbsp;<%
		} 
		 if (qid < query.length -1) {
			%><a href='ContentServer?pagename=<%= ics.GetVar("pagename") %>&#38;cmd=<%= ics.GetVar("cmd") %>&#38;queryid=<%= (qid + 1) %>'>Next</a><%
		} 
		%><br><%
	}
}


%><table class="altClass"><%

for (int i=0; i< query.length; i++){
	%><tr>
	<td><a href='ContentServer?pagename=Support/Audit/DispatcherFront&#38;cmd=<%= ics.GetVar("cmd") %>&#38;queryid=<%=i %>'>Query <%= i %></a></td>
	<td><%= query[i][2] %></td>
	</tr>
<%
}
%></table><%		
///	} catch (Exception e){
//		out.write(e.getMessage());
//		e.printStackTrace();
//		throw e;
//	}

%>
<!-- 
Assets from a specific site are mentioned in:
AssetPublication
AssetRelationTree
Publication tables
Aproval tables
SitePlanTree

-->
</cs:ftcs>
