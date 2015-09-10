<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%//
// Support/TCPI/AP/ListHeld
//
// INPUT
//
// OUTPUT
//
%><cs:ftcs>
<h3>Held Assets</h3>
<h4>Held Assets per AssetType per Target</h4>
<ics:clearerrno/>
<ics:sql sql="SELECT pt.name as name, aps.assettype as assettype , count(aps.id) as num FROM ApprovedAssets aps, PubTarget pt WHERE aps.tstate IN('H') AND pt.id=aps.targetid GROUP BY pt.name, aps.assettype ORDER BY name, assettype" table="ApprovedAssets" listname="yyy" />
<% if (ics.GetErrno() == -101) { %>
    There are no assets in held state.<br/>
<% } else if (ics.GetErrno() == 0){ %>
    <table class="altClass">
        <tr>
            <th>Target</th>
            <th>AssetType</th>
            <th>Number held</th>
            <th>Number missing assets</th>
            <th>Number of assets</th>
        </tr>
        <ics:listloop listname="yyy">
        <tr>
            <td><ics:listget listname="yyy" fieldname="name"/></td>
            <td><ics:listget listname="yyy" fieldname="assettype"/></td>
            <td align="right"><ics:listget listname="yyy" fieldname="num"/><br/></td>
            <ics:clearerrno/>
            <ics:sql sql='<%= ics.ResolveVariables("SELECT count(assetid) as num FROM AssetPublication WHERE assettype=\'yyy.assettype\' AND assetid not in (SELECT id FROM yyy.assettype)") %>' table="AssetPublication" listname="assetpubs"/>
            <% if (ics.GetErrno() ==0) { %>
                <td align="right"><ics:listget listname="assetpubs" fieldname="num"/></td>
            <% } %>
            <ics:clearerrno/>
            <ics:sql sql='<%= ics.ResolveVariables("SELECT count(id) as num FROM yyy.assettype") %>' table="AssetPublication" listname="assetpubs"/>
            <% if (ics.GetErrno() ==0) { %>
                <td align="right"><ics:listget listname="assetpubs" fieldname="num"/></td>
            <% } %>

        </tr>
        </ics:listloop>
    </table>
  <br/>

    <h4>Held Assets List</h4>
    <ics:clearerrno/>
    <ics:sql sql="SELECT name, assetid, assettype FROM ApprovedAssets, PubTarget WHERE tstate IN ('H') AND ApprovedAssets.targetid=PubTarget.id ORDER BY name,assettype,assetid" table="ApprovedAssets" listname="helds" limit='<%= ics.GetVar("limit") %>'/>
    <table class="altClass">
        <tr>
            <th>Nr</th>
            <th>Target</th>
            <th>AssetType</th>
            <th>Assetid</th>
            <th colspan="3">Asset Status</th>
        </tr>
        <ics:listloop listname="helds">
        <tr>
            <td><ics:listget listname="helds" fieldname="#curRow"/></td>

            <td><ics:listget listname="helds" fieldname="name"/></td>
            <td><ics:listget listname="helds" fieldname="assettype"/></td>
            <td><a href='ContentServer?pagename=Support/TCPI/AP/ShowHeldSummary&assetid=<ics:listget listname="helds" fieldname="assetid"/>'><ics:listget listname="helds" fieldname="assetid"/></a></td>
            <ics:clearerrno/>
            <ics:sql sql='<%= ics.ResolveVariables("SELECT id, status,createddate FROM helds.assettype WHERE id=helds.assetid") %>' table='<%= ics.ResolveVariables("helds.assettype") %>' listname="assetpubs"/>
            <% if (ics.GetErrno() ==0) { %>
                <td align="right">OK</td>
                <td><ics:listget listname="assetpubs" fieldname="status"/></td>
                <td><ics:listget listname="assetpubs" fieldname="createddate"/></td>
            <% } else { %>
                <td align="right" colspan="3"><font color="red">Missing</font></td>
            <% } %>
        </tr>
        </ics:listloop>
    </table>
<% } %></cs:ftcs>
