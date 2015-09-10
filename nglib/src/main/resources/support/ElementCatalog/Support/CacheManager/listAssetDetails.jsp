<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld"
%><%@ taglib prefix="asset" uri="futuretense_cs/asset.tld"
%><%//
// Support/CacheManager/listAssetDetails
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
%><%@ page import="COM.FutureTense.Util.ftMessage"
%><cs:ftcs><ics:clearerrno/>
<ics:sql sql='<%= ics.ResolveVariables("SELECT id,mdate FROM SystemItemCache WHERE page = Variables.pid ORDER BY id,mdate") %>' listname="items" table="SystemItemCache" />
<% if  (ics.GetErrno() == -101) { %>
    There are no items cached for page <ics:getvar name="pid"/>!<br/>
<% } else { %>
<table class="altClass">
    <tr>
        <th width="5%">Nr</th>
        <th widht="25%">Asset</th>
        <th width="15%">ModTime</th>
        <th width="35%">Name</th>
        <th width="10%">Updateddate</th>
        <th width="10%">Status</th>
    </tr>
    <ics:listloop listname="items">
    <% String id = ics.ResolveVariables("items.id"); %>
    <tr>
        <td align="right"><ics:resolvevariables name="items.#curRow"/></td>
        <td><a href='ContentServer?pagename=Support/CacheManager/listByItemPost&#38;idlist=<%= id %>'><%= id %></a></td>
        <td><ics:listget listname="items" fieldname="mdate"/></td>
        <% if (id.startsWith("asset-")) {
            int t = id.indexOf(":");
            String cid = id.substring(6,t);
            ics.ClearErrno();
          %><asset:list type='<%= id.substring(t+1) %>' list="assetList" excludevoided="false" field1="id" value1='<%= cid %>'/>
            <td><ics:listget listname="assetList" fieldname="name"/></td>
            <td><ics:listget listname="assetList" fieldname="updateddate"/></td>
            <td><ics:listget listname="assetList" fieldname="status"/></td>
        <% } else { %>
            <td colspan="3">&nbsp;</td>
        <% } %>
    </tr>
    </ics:listloop>
</table>
<% }
%></cs:ftcs>
