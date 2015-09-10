<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld"
%><%//
// Support/TCPI/AP/ShowHeldSummary
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
<h3><center>Held Summary</center></h3>
<b>Assetid: <ics:getvar name="assetid" /></b><br/>

<ics:sql sql='<%= ics.ResolveVariables("SELECT * FROM ApprovedAssets WHERE assetid =Variables.assetid ORDER BY targetid") %>' table="ApprovedAssets" listname="apps"/>
<table class="altClass">
    <tr>
        <th>Nr</th>
        <th>Id</th>
        <th>Assettype</th>
        <th>Assetid</th>
        <th>TState</th>
        <th>TReason</th>
        <th>State</th>
        <th>Reason</th>
        <th>Targetid</th>
        <th>Locked</th>
        <th>Voided</th>
        <th>Lastasset Voided</th>
        <th>Assetdate</th>
        <th>Last assetdate</th>
        <th>Asset version</th>
        <th>Last assetVersion</th>
    </tr>
    <ics:listloop listname="apps">
    <tr>
        <td align="right"><ics:listget listname="apps" fieldname="#curRow"/></td>
        <td><ics:listget listname="apps" fieldname="id"/></td>
        <td><ics:listget listname="apps" fieldname="assettype"/></td>
        <td><ics:listget listname="apps" fieldname="assetid"/></td>
        <td><ics:listget listname="apps" fieldname="tstate"/></td>
        <td><ics:listget listname="apps" fieldname="treason"/></td>
        <td><ics:listget listname="apps" fieldname="state"/></td>
        <td><ics:listget listname="apps" fieldname="reason"/></td>
        <td><ics:listget listname="apps" fieldname="targetid"/></td>
        <td><ics:listget listname="apps" fieldname="locked"/></td>
        <td><ics:listget listname="apps" fieldname="voided"/></td>
        <td><ics:listget listname="apps" fieldname="lastassetvoided"/></td>
        <td><ics:listget listname="apps" fieldname="assetdate"/></td>
        <td><ics:listget listname="apps" fieldname="lastassetdate"/></td>
        <td><ics:listget listname="apps" fieldname="assetversion"/></td>
        <td><ics:listget listname="apps" fieldname="lastassetversion"/></td>
    </tr>
    </ics:listloop>
</table>
<br/>

<ics:sql sql='<%= ics.ResolveVariables("SELECT targetid, ownerid, count(id) as num FROM ApprovedAssetDeps WHERE ownerid IN (SELECT id FROM ApprovedAssets WHERE assetid =Variables.assetid) GROUP BY targetid,ownerid ORDER BY targetid") %>' table="ApprovedAssetDeps" listname="deptotals"/>
<% if (ics.GetErrno()!=-101) { %>
    Errno: <b><ics:geterrno/></b>, Targets: <b><ics:listget listname="deptotals" fieldname="#numRows"/></b>
    <table class="altClass">
        <tr>
            <th>Nr</th>
            <th>Targetid</th>
            <th>Ownerid</th>
            <th>TotalDeps</th>
        <tr>
        <ics:listloop listname="deptotals">
        <tr>
            <td align="right"><ics:listget listname="deptotals" fieldname="#curRow"/></td>
            <td><ics:listget listname="deptotals" fieldname="targetid"/></td>
            <td><ics:listget listname="deptotals" fieldname="ownerid" /></td>
            <td><ics:listget listname="deptotals" fieldname="num" /></td>
        </tr>
        </ics:listloop>
    </table>
    <br/><a href='ContentServer?pagename=Support/TCPI/AP/ShowHeld&assetid=<ics:getvar name="assetid"/>'>Display also all depenancies</a><br/>
<% } else { %>
    <font color="red">No Depenedents to Display</font> <br/>
<% } %>
</cs:ftcs>
