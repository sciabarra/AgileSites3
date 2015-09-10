<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" 
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" 
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" 
%><%//
// Support/TCPI/CleanUp/CountDiffNumberDepsPerTarget
//
// INPUT
//
// OUTPUT
//
%><%@ page import="COM.FutureTense.Interfaces.FTValList" 
%><%@ page import="COM.FutureTense.Interfaces.ICS" 
%><%@ page import="COM.FutureTense.Interfaces.IList" 
%><%@ page import="COM.FutureTense.Interfaces.Utilities" 
%><%@ page import="COM.FutureTense.Util.ftErrors" 
%><%@ page import="COM.FutureTense.Util.ftMessage"%>
<cs:ftcs>
<%!
static String sql ="SELECT foa.assetid, assettype, numaa, numaad FROM ("
+"SELECT SUM(numaa) as numaa, SUM(numaad) as numaad, assetid FROM ( "
+"SELECT 0 as numaa , count(DISTINCT aad.targetid) AS numaad, aa.assetid FROM ApprovedAssets aa, ApprovedAssetDeps aad WHERE aa.id = aad.ownerid GROUP BY aa.assetid  "
+"UNION "
+"SELECT count(DISTINCT aa.targetid) AS numaa, 0 as numaad, aa.assetid FROM ApprovedAssets aa GROUP BY aa.assetid  "
+") foo "
+"GROUP BY assetid "
+") foa , AssetPublication "
+"WHERE numaa <> numaad "
+" AND foa.assetid = AssetPublication.assetid";



%>

<h2>Find assets with different number of targets for ApprovedAssets and ApprovedAssetDeps</h2>
<ics:sql sql='<%=sql%>' table="ApprovedAssetDeps" limit="100" listname="diffs"/>
<table>
	<ics:listloop listname="diffs">

		<tr>
		<td><ics:listget listname="diffs" fieldname="assettype"/></td>
		<td><a href='ContentServer?pagename=Support/TCPI/AP/ShowHeldSummary&assetid=<ics:listget listname="diffs" fieldname="assetid"/>'><ics:listget listname="diffs" fieldname="assetid"/></a></td>
		<td><ics:listget listname="diffs" fieldname="numaa"/></td>
		<td><ics:listget listname="diffs" fieldname="numaad"/></td>

		</tr>
	</ics:listloop>
</table>
</cs:ftcs>
