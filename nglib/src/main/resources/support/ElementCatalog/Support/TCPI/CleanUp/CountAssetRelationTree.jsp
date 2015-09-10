<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld"
%><%//
// Support/TCPI/CleanUp/CountAssetRelationTree
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
<h3>Check <i>AssetRelationTree</i> for Missing Assets</h3><br/>
<% boolean doDelete ="true".equals(ics.GetVar("delete")); %>

<ics:sql sql="SELECT art.nparentid as nparentid, art.oid as assetid, art.otype as type FROM AssetRelationTree art WHERE art.oid NOT IN (SELECT assetid FROM AssetPublication)" table="AssetRelationTree" listname="art"/>
Number of assets in AssetRelationTree without a valid entry in AssetPublication: <b><ics:listget listname="art" fieldname="#numRows"/></b>
<table class="altClass">
<tr><th>assettype</th><th>assetid</th><th>nparentid</th></tr>
<ics:listloop listname="art" >
    <tr>
        <td><ics:listget listname="art" fieldname="type"/></td>
        <td><ics:listget listname="art" fieldname="assetid"/></td>
        <td align="right"><ics:listget listname="art" fieldname="nparentid"/></td>
    </tr>
</ics:listloop>
</table>
<% try {
    if (doDelete && Integer.parseInt(ics.ResolveVariables("art.#numRows")) > 0){
       %><ics:clearerrno/>
        <% String sql = ics.ResolveVariables("DELETE FROM AssetRelationTree WHERE  oid NOT IN (SELECT assetid FROM AssetPublication)"); ics.LogMsg(sql); %>
        <ics:sql sql="<%= sql %>" table="AssetRelationTree" listname="xxx"/>
        Errno after sql: <ics:geterrno/><br/>
        <ics:flushcatalog catalog="AssetRelationTree"/>
        <ics:clearerrno/><%
    }
} catch (Exception e){
    %><%= e.getMessage() %><br/><%
}
%>
<br/><b>This cannot be fixed by this tool.</b><br/>

<ics:sql sql='<%="SELECT art.nparentid as nparentid, art.nid as nid ,art.oid as assetid, art.otype as type FROM AssetRelationTree art WHERE art.nparentid <> 0 AND art.nparentid NOT IN (SELECT nid FROM AssetRelationTree)"%>' table="AssetRelationTree" listname="art"/>
Number of assets in AssetRelationTree without a valid parent: <b><ics:listget listname="art" fieldname="#numRows"/></b>
<table class="altClass">
    <tr><th>assettype</th><th>assetid</th><th>nid</th><th>nparentid</th></tr>
    <ics:listloop listname="art" >
    <tr>
        <td><ics:listget listname="art" fieldname="type"/></td>
        <td><ics:listget listname="art" fieldname="assetid"/></td>
        <td align="right"><ics:listget listname="art" fieldname="nid"/></td>
        <td align="right"><ics:listget listname="art" fieldname="nparentid"/></td>
    </tr>
    </ics:listloop>
</table>
<ics:clearerrno/>
</cs:ftcs>
