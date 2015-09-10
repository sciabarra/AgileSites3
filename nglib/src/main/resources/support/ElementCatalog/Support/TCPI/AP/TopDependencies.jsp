<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld"
%><%//
// Support/TCPI/AP/TopDependencies
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
<center><h3>Top Dependencies</h3></center><br/>
<ics:sql sql="SELECT count(aad.id) AS num, aa.assetid as assetid, aa.assettype as assettype FROM ApprovedAssetDeps aad, ApprovedAssets aa WHERE aad.ownerid = aa.id GROUP BY aa.assetid, aa.assettype ORDER BY num DESC, assettype, assetid" table="ApprovedAssetDeps" limit='<%= ics.GetVar("showmax") %>' listname="aad" />
<table class="altClass">
    <tr>
        <th>assettype</th>
        <th>assetid</th>
        <th>num of dependancies</th>
        <th>Force Approve</th>
    </tr>
    <ics:listloop listname="aad">
    <tr>
        <td><ics:listget listname="aad" fieldname="assettype"/></td>
        <td><a href='ContentServer?pagename=Support/TCPI/AP/ShowHeldSummary&assetid=<ics:listget listname="aad" fieldname="assetid"/>'><ics:listget listname="aad" fieldname="assetid"/></a></td>
        <td><ics:listget listname="aad" fieldname="num"/></td>
        <td><a href='ContentServer?pagename=Support/TCPI/AP/ForceApproveAsset&assetid=<ics:listget listname="aad" fieldname="assetid"/>&assettype=<ics:listget listname="aad" fieldname="assettype"/>'>Force Approve for all previous targets</a></td>
    </tr>
    </ics:listloop>
</table>
</cs:ftcs>
