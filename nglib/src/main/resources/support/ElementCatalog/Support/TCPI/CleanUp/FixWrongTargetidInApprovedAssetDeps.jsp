<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld"
%><%//
// Support/TCPI/CleanUp/FixWrongTargetidInApprovedAssetDeps
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
<h3>Checks Targetid Between ApprovedAsset and ApprovedAssetDeps Match</h3>
<% boolean fixme = "true".equals(ics.GetVar("fix")); %>
<ics:sql sql ="SELECT id,name FROM PubTarget ORDER BY name" table="PubTarget" listname="targets"/>
<ics:copylist to="targets2" from="targets"/>

<% if (ics.GetVar("assettype") != null) { %>
    <h5><ics:getvar name="assettype"/></h5>
    <table class="altClass">
        <tr>
            <th>Destinations</th>
            <ics:listloop listname="targets2">
                <th><ics:listget listname="targets2" fieldname="name"/></th>
            </ics:listloop>
        </tr>
        <ics:listloop listname="targets">
        <tr>
            <td><ics:listget listname ="targets" fieldname="name"/></td>
            <ics:listloop listname="targets2">
            <td>
            <% if (!ics.ResolveVariables("targets.id").equals(ics.ResolveVariables("targets2.id"))) { %>
                <a href='ContentServer?pagename=<ics:getvar name="pagename"/>&fix=true&targetOK=<ics:resolvevariables name="targets.id"/>&targetBad=<ics:resolvevariables name="targets2.id"/>&assettype=<ics:resolvevariables name="Variables.assettype"/>'><b>fix me</b></a>
                <% if (fixme) { %>
                    <ics:sql sql='<%= ics.ResolveVariables("UPDATE ApprovedAssetDeps SET targetid = targets.id WHERE ApprovedAssetDeps.targetid = targets2.id AND EXISTS (SELECT \'x\' FROM ApprovedAssets WHERE ApprovedAssetDeps.ownerid = ApprovedAssets.id AND ApprovedAssets.targetid =  targets.id AND ApprovedAssets.assettype = \'Variables.assettype\')") %>' table="ApprovedAssetDeps" listname="fixme"/>
                    <!-- errno:<ics:geterrno /> -->
                    <br/><b>fixed <ics:resolvevariables name="targets2.id"/> for <ics:getvar name="Variabes.assettype"/> on target <ics:resolvevariables name="targets.id"/></b>
                    <ics:flushcatalog catalog="ApprovedAssetDeps"/>
                <% }
               }
            %>
            </td>
            </ics:listloop>
        </tr>
        </ics:listloop>
    </table><br/>
<% } %>
<ics:clearerrno/>
<ics:sql sql ="SELECT assettype FROM AssetType ORDER BY assettype" table="AssetType" listname="assettypes"/>
<table class="altClass" style="width:50%">
    <tr><th>AssetType</th></tr>
    <ics:listloop listname="assettypes">
    <tr>
        <td><a href='ContentServer?pagename=<ics:getvar name="pagename"/>&assettype=<ics:listget listname ="assettypes" fieldname="assettype"/>'><ics:listget listname ="assettypes" fieldname="assettype"/></a></td>
    </tr>
    </ics:listloop>
</table>
</cs:ftcs>
