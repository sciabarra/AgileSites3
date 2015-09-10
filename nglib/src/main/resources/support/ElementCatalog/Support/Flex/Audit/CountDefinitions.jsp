<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld"
%><%//
// Support/Flex/Audit/CountDefenitions
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
%><cs:ftcs>
<h3>Count Definitions</h3>
<p>This pages show how often a template is used for assets of type <b><ics:getvar name="assettype"/></b></p>
<ics:clearerrno/>
<ics:sql sql='<%= ics.ResolveVariables("SELECT assettemplate, \'flextemplateid\' as tid FROM FlexAssetTypes WHERE assettype=\'Variables.assettype\'") %>' table="FlexAssetTypes" listname="types"/>
<% if (ics.GetErrno() ==-101){ %>
    <ics:clearerrno/>
    <ics:sql sql='<%= ics.ResolveVariables("SELECT assettemplate, \'flexgrouptemplateid\' as tid FROM FlexGroupTypes WHERE assettype=\'Variables.assettype\'") %>' table="FlexGroupTypes" listname="types"/>
<% } %>
<ics:clearerrno/>
<ics:sql sql='<%= ics.ResolveVariables("SELECT count(a.id) as num, t.name as name FROM Variables.assettype a, types.assettemplate t WHERE a.types.tid = t.id  AND a.status!=\'VO\' GROUP BY t.name ORDER BY name") %>' table='<%= ics.GetVar("assettype") %>' listname="templatecount"/>
<table class="altClass">
    <tr>
        <th>Template name</th>
        <th>Num of assets</th>
    </tr>
    <ics:listloop listname="templatecount">
    <tr>
        <td><ics:listget listname="templatecount" fieldname="name"/></td>
        <td><ics:listget listname="templatecount" fieldname="num"/></td>
        </tr>
        </ics:listloop>
        <ics:clearerrno/>
        <ics:sql sql='<%= ics.ResolveVariables("SELECT count(id) as num FROM Variables.assettype a WHERE a.types.tid IS NULL AND status!=\'VO\'") %>' table='<%= ics.GetVar("assettype") %>' listname="templatecount"/>
        <tr>
        <td>No template</td>
        <td><ics:listget listname="templatecount" fieldname="num"/></td>
    </tr>
</table>
</cs:ftcs>
