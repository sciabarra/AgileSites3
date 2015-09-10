<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// Support/Flex/Audit/ShowAssetsWithMissingAttributes
//
// INPUT
//
// OUTPUT
//%>
<%@ page import="COM.FutureTense.Interfaces.FTValList" %>
<%@ page import="COM.FutureTense.Interfaces.ICS" %>
<%@ page import="COM.FutureTense.Interfaces.IList" %>
<%@ page import="COM.FutureTense.Interfaces.Utilities" %>
<%@ page import="COM.FutureTense.Util.ftErrors" %>
<%@ page import="COM.FutureTense.Util.ftMessage"%>
<cs:ftcs>
<h3>Assets with missing attributes</h3>

<ics:clearerrno/>
<ics:sql sql='<%= ics.ResolveVariables("SELECT assettemplate, assetattr, \'flextemplateid\' as tid FROM FlexAssetTypes WHERE assettype=\'Variables.assettype\'") %>' table="FlexAssetTypes" listname="types"/>
<% if (ics.GetErrno() ==-101){ %>
    <ics:clearerrno/>
    <ics:sql sql='<%= ics.ResolveVariables("SELECT assettemplate, assetattr, \'flexgrouptemplateid\' as tid FROM FlexGroupTypes WHERE assettype=\'Variables.assettype\'") %>' table="FlexGroupTypes" listname="types"/>
<%}
%>
<ics:clearerrno/>
<ics:sql sql='<%= ics.ResolveVariables("SELECT id,name,status,createddate FROM Variables.assettype WHERE types.tid = Variables.templateid AND status!=\'VO\' AND NOT EXISTS (SELECT 1 FROM Variables.assettype_Mungo WHERE cs_attrid = Variables.attributeid AND cs_ownerid= Variables.assettype.id) ORDER BY name") %>' table='<%= ics.ResolveVariables("Variables.assettype_Mungo") %>' listname="assets"/>
<p><ics:getvar name="assettype"/> for template &quot;<ics:getvar name="templatename"/>&quot; and attribute &quot;<ics:getvar name="attributename"/>&quot; <br/></p>

<table class="altClass">
    <tr>
        <th>Nr</th>
        <th>id</th>
        <th>name</th>
        <th>status</th>
        <th>createddate</th>
    </tr>

<ics:listloop listname="assets">
    <tr>
        <td><ics:resolvevariables name="assets.#curRow"/></td>
        <td><ics:resolvevariables name="assets.id"/></td>
        <satellite:link>
            <satellite:parameter name="assettype" value='<%= ics.ResolveVariables("Variables.assettype")  %>'/>
            <satellite:parameter name="assetid" value='<%= ics.ResolveVariables("assets.id") %>'/>
            <satellite:parameter name="pagename" value="Support/Flex/Audit/Parents"/>
            <satellite:parameter name="OUTSTRING" value="theURL"/>
        </satellite:link>
        <td><a href='<%= ics.GetVar("theURL") %>'/><ics:resolvevariables name="assets.name"/></a></td>
        <td><ics:resolvevariables name="assets.status"/></td>
        <td><ics:resolvevariables name="assets.createddate"/></td>
    </tr>
</ics:listloop>
</table>
</cs:ftcs>
