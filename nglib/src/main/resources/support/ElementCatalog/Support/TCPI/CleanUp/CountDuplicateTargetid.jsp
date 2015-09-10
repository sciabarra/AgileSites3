<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" 
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" 
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" 
%><%//
// Support/TCPI/CleanUp/CountDuplicateTargetid
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

<ics:sql sql="select count(distinct ownerid) as num FROM ApprovedAssetDeps aad WHERE NOT EXISTS (SELECT 1 FROM ApprovedAssets aa WHERE aad.ownerid = aa.id)" table="ApprovedAssetDeps" listname="aad1"/>
Number of ApprovedAssetDeps without an owner: <b><ics:listget listname="aad1" fieldname="num"/></b><br/>

<ics:sql sql="select count(distinct ownerid) as num FROM ApprovedAssetDeps aad WHERE EXISTS (SELECT 1 FROM ApprovedAssets aa WHERE aad.ownerid = aa.id AND aad.targetid =aa.targetid)" table="ApprovedAssetDeps" listname="aad2"/>
Number of ApprovedAssetDeps with same targetid then owner: <b><ics:listget listname="aad2" fieldname="num"/></b><br/>

<ics:sql sql="select count(distinct ownerid) as num FROM ApprovedAssetDeps aad WHERE NOT EXISTS (SELECT 1 FROM ApprovedAssets aa WHERE aad.ownerid = aa.id AND aad.targetid =aa.targetid)" table="ApprovedAssetDeps" listname="aad3"/>
Number of ApprovedAssetDeps with different targetid then owner: <b><ics:listget listname="aad3" fieldname="num"/></b>

<% if (Integer.parseInt(ics.ResolveVariables("aad3.num")) > 0){ %>
    <ics:sql sql="SELECT COUNT(DISTINCT targetid) AS num, ownerid FROM ApprovedAssetDeps GROUP BY ownerid HAVING COUNT(DISTINCT targetid) > 1" table="ApprovedAssetDeps" listname="aad" limit="100" />
    <h3>Count distinct targetid in ApprovedAssetDeps for owners with mulitple targets <ics:listget listname="aad" fieldname="#numRow"/></h3>
	<table class="altClass">
	    <ics:listloop listname="aad">
		<tr>
			<td><ics:listget listname="aad" fieldname="ownerid"/><td>
			<td><ics:listget listname="aad" fieldname="num"/><td>
		</tr>
	    </ics:listloop>
	</table>

	<ics:sql sql="select count(aad.id) as num, aad.targetid, aad.ownerid, aa1.assetid as assetid, aa1.assettype as assettype FROM ApprovedAssetDeps aad, ApprovedAssets aa1 WHERE aad.ownerid = aa1.id AND NOT EXISTS (SELECT 1 FROM ApprovedAssets aa WHERE aad.ownerid = aa.id AND aad.targetid =aa.targetid) GROUP BY aad.targetid, aad.ownerid, aa1.assetid, aa1.assettype ORDER BY num desc, ownerid" table="ApprovedAssetDeps" listname="aad" limit="100"/>
   	<h3>List ApprovedAssetDeps with mulitple targets (max 100 rows)</h3>
	<table class="altClass">
    	<tr>
        	<th>Nr</th>
        	<th>id</th>
        	<th>Targetid</th>
        	<th>Ownerid</th>
        	<th>Assetype</th>
        	<th>Asssetid</th>
    	</tr>
	    <ics:listloop listname="aad">
    	<tr>
            <td><ics:listget listname="aad" fieldname="#curRow"/></td>
            <td><ics:listget listname="aad" fieldname="num"/></td>
            <td><ics:listget listname="aad" fieldname="targetid"/></td>
            <td><ics:listget listname="aad" fieldname="ownerid"/></td>
            <td><ics:listget listname="aad" fieldname="assettype"/></td>
            <td><a href='ContentServer?pagename=Support/TCPI/AP/ShowHeld&assetid=<ics:listget listname="aad" fieldname="assetid"/>'><ics:listget listname="aad" fieldname="assetid"/></a></td>			
		</tr>
    	</ics:listloop>
	</table>
<% } %>
</cs:ftcs>
