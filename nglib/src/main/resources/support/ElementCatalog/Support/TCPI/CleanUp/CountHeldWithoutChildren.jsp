<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld"
%><%//
// Support/TCPI/CleanUp/CountHeldWithoutChildren
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
<h3><center>Count Held Assets with/without Children</center></h3>
<b>Number of held assets per target and assettype</b>
<ics:sql sql="SELECT COUNT(DISTINCT assetid) AS num, pt.name as name, assettype FROM ApprovedAssets aa, PubTarget pt WHERE pt.id= aa.targetid AND  tstate IN ('C') GROUP BY pt.name, assettype ORDER BY pt.name, assettype" table="ApprovedAssetDeps" listname="aa" />
<table class="altClass">
    <tr>
        <th>Destinations</th>
        <th>AssetType</th>
        <th>Total</th>
    </tr>
    <ics:listloop listname="aa">
    <tr>
        <td><ics:listget listname="aa" fieldname="name" /></td>
        <td><ics:listget listname="aa" fieldname="assettype" /></td>
        <td><ics:listget listname="aa" fieldname="num" /></td>
    </tr>
    </ics:listloop>
</table>

<br/><b>Number of held assets per target and assettype without children in same target</b>
<ics:sql sql="SELECT COUNT(DISTINCT assetid) AS num, pt.name as name, assettype FROM ApprovedAssets aa, PubTarget pt WHERE pt.id= aa.targetid AND  tstate IN ('C') AND NOT EXISTS (SELECT 'x' FROM ApprovedAssetDeps aad WHERE aa.id = aad.ownerid) GROUP BY pt.name, aa.assettype ORDER BY pt.name, aa.assettype" table="ApprovedAssetDeps" listname="aa" />
<table class="altClass">
        <tr>
        <th>Destinations</th>
        <th>AssetType</th>
        <th>Total</th>
    </tr>
    <ics:listloop listname="aa">
    <tr>
        <td><ics:listget listname="aa" fieldname="name" /></td>
        <td><ics:listget listname="aa" fieldname="assettype" /></td>
        <td><ics:listget listname="aa" fieldname="num" /></td>
    </tr>
    </ics:listloop>
</table>

<br/><b>Number of held assets per target and assettype with children in same target</b>
<ics:sql sql="SELECT COUNT(DISTINCT assetid) AS num, pt.name as name, assettype FROM ApprovedAssets aa, PubTarget pt WHERE pt.id= aa.targetid AND tstate IN ('H','C') AND EXISTS (SELECT 'x' FROM ApprovedAssetDeps aad WHERE aa.id = aad.ownerid) GROUP BY pt.name, aa.assettype ORDER BY pt.name, aa.assettype" table="ApprovedAssetDeps" listname="aa" />
<table class="altClass">
        <tr>
        <th>Destinations</th>
        <th>AssetType</th>
        <th>Total</th>
    </tr>
    <ics:listloop listname="aa">
    <tr>
        <td><ics:listget listname="aa" fieldname="name" /></td>
        <td><ics:listget listname="aa" fieldname="assettype" /></td>
        <td><ics:listget listname="aa" fieldname="num" /></td>
    </tr>
    </ics:listloop>
</table>

<br/><b>Number of dependancies for held assets per target and assettype where children are for the same target</b>
<ics:sql sql="SELECT COUNT(DISTINCT aad.id) AS num, pt.name as name, aa.assettype FROM ApprovedAssets aa, PubTarget pt, ApprovedAssetDeps aad WHERE aa.tstate IN ('H','C') AND pt.id = aa.targetid AND  aa.id = aad.ownerid GROUP BY pt.name, aa.assettype ORDER BY pt.name, aa.assettype" table="ApprovedAssetDeps" listname="aa" />
<table class="altClass">
        <tr>
        <th>Destinations</th>
        <th>AssetType</th>
        <th>Total</th>
    </tr>
    <ics:listloop listname="aa">
    <tr>
        <td><ics:listget listname="aa" fieldname="name" /></td>
        <td><ics:listget listname="aa" fieldname="assettype" /></td>
        <td><ics:listget listname="aa" fieldname="num" /></td>
    </tr>
    </ics:listloop>
</table>
</cs:ftcs>

