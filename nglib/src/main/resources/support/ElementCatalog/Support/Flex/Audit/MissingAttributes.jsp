<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld"
%><%//
// Support/Flex/Audit/MissingAttributes
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
<h3>Missing Attributes</h3>
<p>This page lists, for assetype <b><ics:getvar name="assettype"/></b>, all templates, required attributes and how many assets do not have all the required attributes definied (currently) by their template. If this number if greater than 0 then a link is presented to inspect those assets.</p>

<ics:clearerrno/>
<ics:sql sql='<%= ics.ResolveVariables("SELECT assettemplate, assetattr, \'flextemplateid\' as tid FROM FlexAssetTypes WHERE assettype=\'Variables.assettype\'") %>' table="FlexAssetTypes" listname="types"/>
<% if (ics.GetErrno()==-101){ %>
    <ics:clearerrno/>
    <ics:sql sql='<%= ics.ResolveVariables("SELECT assettemplate, assetattr, \'flexgrouptemplateid\' as tid FROM FlexGroupTypes WHERE assettype=\'Variables.assettype\'") %>' table="FlexGroupTypes" listname="types"/>
<% } %>
<ics:clearerrno/>

<ics:sql sql='<%= ics.ResolveVariables("SELECT d.name AS defname, da.ownerid, a.name as aname, a.status, da.attributeid FROM types.assettemplate d, types.assettemplate_TAttr da, types.assetattr a WHERE d.id = da.ownerid AND a.id = da.attributeid AND da.requiredflag =\'T\' order by d.name, da.ownerid, a.name") %>' table='<%= ics.ResolveVariables("types.assettemplate_TAttr") %>' listname="templateattributes"/>
<table class="altClass">
<tr>
    <th>Template</th>
    <th><ics:resolvevariables name="types.assetattr"/></th>
    <th><ics:getvar name="assettype"/>_Mungo</th>
    <th><ics:getvar name="assettype"/>_Amap</th>
</tr>
<% String curTemplate =""; %>
<ics:listloop listname="templateattributes">
    <tr>
        <!-- td><ics:resolvevariables name="templateattributes.ownerid"/></td -->
        <% if(curTemplate.equals(ics.ResolveVariables("templateattributes.defname"))){
            %><td>&nbsp;</td><%
        } else {
            %><td><b><ics:resolvevariables name="templateattributes.defname"/></b></td><%
            curTemplate = ics.ResolveVariables("templateattributes.defname");
        }
        %>
        <td><ics:resolvevariables name="templateattributes.aname"/></td>
        <!-- td><ics:resolvevariables name="templateattributes.attributeid"/></td -->
        <ics:clearerrno/>
        <ics:sql sql='<%= ics.ResolveVariables("SELECT count(id) AS num FROM Variables.assettype WHERE types.tid = templateattributes.ownerid AND status!=\'VO\' AND NOT EXISTS (SELECT 1 FROM Variables.assettype_Mungo WHERE cs_attrid = templateattributes.attributeid AND cs_ownerid = Variables.assettype.id AND cs_assetgroupid IS NULL)") %>' table='<%= ics.ResolveVariables("Variables.assettype_Mungo") %>' listname="myCounter"/>
        <%
        if (Integer.parseInt(ics.ResolveVariables("myCounter.num"))>0){
            %><td><a href='ContentServer?pagename=Support/Flex/Audit/ShowAssetsWithMissingAttributes&templateid=<ics:resolvevariables name="templateattributes.ownerid"/>&attributeid=<ics:resolvevariables name="templateattributes.attributeid"/>&attributename=<ics:resolvevariables name="templateattributes.aname"/>&templatename=<ics:resolvevariables name="templateattributes.defname"/>&assettype=<ics:getvar name="assettype"/>'><ics:resolvevariables name="myCounter.num"/></a></td>
        <% } else {
            %><td>0</td>
        <% } %>

        <ics:clearerrno/>
        <ics:sql sql='<%= ics.ResolveVariables("SELECT count(id) AS num FROM Variables.assettype WHERE types.tid = templateattributes.ownerid AND status!=\'VO\' AND NOT EXISTS (SELECT 1 FROM Variables.assettype_AMap WHERE attributeid = templateattributes.attributeid AND ownerid = Variables.assettype.id AND inherited IS NULL)") %>' table='<%= ics.ResolveVariables("Variables.assettype_AMap") %>' listname="myCounter"/>
        <%
        if (Integer.parseInt(ics.ResolveVariables("myCounter.num"))>0){
            %><td><a href='ContentServer?pagename=Support/Flex/Audit/ShowAssetsWithMissingAttributes&templateid=<ics:resolvevariables name="templateattributes.ownerid"/>&attributeid=<ics:resolvevariables name="templateattributes.attributeid"/>&attributename=<ics:resolvevariables name="templateattributes.aname"/>&templatename=<ics:resolvevariables name="templateattributes.defname"/>&assettype=<ics:getvar name="assettype"/>'><ics:resolvevariables name="myCounter.num"/></a></td>
        <% } else {
            %><td>0</td>
        <% } %>


    </tr>
</ics:listloop>
</table>
</cs:ftcs>
