<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld"
%><%//
// Support/TCPI/CleanUp/FindWrongTargetidInApprovedAssetDeps
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
%><%@ page import="java.util.*"%>
<cs:ftcs>
<h3>Checks targetid between ApprovedAsset and ApprovedAssetDeps match</h3><br/>
<ics:sql sql ="SELECT id,name FROM PubTarget ORDER BY name" table="PubTarget" listname="targets"/>
<% ArrayList updateList = new ArrayList(); %>
<ics:listloop listname="targets">
<%
    String sql = ics.ResolveVariables("UPDATE ApprovedAssetDeps SET targetid = targets.id WHERE EXISTS (SELECT 'x' FROM ApprovedAssets WHERE ApprovedAssetDeps.ownerid = ApprovedAssets.id AND ApprovedAssets.targetid =  targets.id)");
    updateList.add(sql);
%>
</ics:listloop>

<table class="altClass" style="width:50%">
    <tr>
        <th>Select target</th>
    </tr>
    <ics:listloop listname="targets">
    <tr>
        <td><a href='ContentServer?pagename=<ics:getvar name="pagename"/>&targetid=<ics:listget listname ="targets" fieldname="id"/>'><ics:listget listname ="targets" fieldname="name"/></a></td>
    </tr>
    </ics:listloop>
</table>
<br/>
<% if (Utilities.goodString(ics.GetVar("targetid"))){ %>
    <ics:sql sql ='<%= ics.ResolveVariables("SELECT id,name FROM PubTarget WHERE id = Variables.targetid") %>' table="PubTarget" listname="targets2"/>
    <table class="altClass">
        <tr>
            <th><ics:listget listname ="targets2" fieldname="name"/></th>
            <th>Total</th>
        </tr>
        <ics:listloop listname="targets">
        <tr>
            <td><ics:listget listname ="targets" fieldname="name"/></td>
            <td align="right">
                <% if (!ics.ResolveVariables("targets.id").equals(ics.ResolveVariables("Variables.targetid"))) {
                    String sql = ics.ResolveVariables("SELECT count(id) as num FROM ApprovedAssetDeps WHERE ApprovedAssetDeps.targetid = targets.id AND EXISTS (SELECT 'x' FROM ApprovedAssets WHERE ApprovedAssetDeps.ownerid = ApprovedAssets.id AND ApprovedAssets.targetid =  Variables.targetid)");
                    %><ics:sql sql='<%= sql %>' table="ApprovedAssetDeps" listname="fixme"/>
                    <b><ics:listget listname="fixme" fieldname="num"/></b>
                <% } else { %>0
                <% } %>
            </td>
        </tr></ics:listloop>
    </table>
<% } %>
<pre >
<% for (Iterator itor = updateList.iterator(); itor.hasNext();){
      String sql = (String)itor.next();
%><%= sql %>;
commit;
<% } %>
</pre>
</cs:ftcs>
