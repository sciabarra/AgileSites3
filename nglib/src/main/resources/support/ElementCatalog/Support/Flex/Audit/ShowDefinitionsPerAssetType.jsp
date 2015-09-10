<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld"
%><%@ page import="COM.FutureTense.Interfaces.FTValList"
%><%@ page import="COM.FutureTense.Interfaces.ICS"
%><%@ page import="COM.FutureTense.Interfaces.IList"
%><%@ page import="COM.FutureTense.Interfaces.Utilities"
%><%@ page import="COM.FutureTense.Util.ftErrors"
%><%@ page import="COM.FutureTense.Util.ftMessage"
%><cs:ftcs>
<h4>Template Definitions for '<ics:getvar name="assetattr"/>' FlexFamily</h4>
<!--
1) list all assettemplates fropm FlexAssetTypes
2) loop over assettemplates
3) list all assets (assetdef) from that assettemplate
4) loop over asset def
5) get parents for def
6) get attribute for def
7) get assettypes for def, count assets of this type


-->
<ics:clearerrno/>
<ics:sql sql='<%= ics.ResolveVariables("SELECT DISTINCT assettemplate, assetattr, \'flextemplateid\' as tid FROM FlexAssetTypes WHERE assetattr=\'Variables.assetattr\'") %>' table="FlexAssetTypes" listname="tmpltypes"/>


<ics:listloop listname="tmpltypes">
<ics:sql sql='<%= ics.ResolveVariables("SELECT assettemplate FROM FlexTmplTypes WHERE assettype = \'tmpltypes.assettemplate\' ") %>'  table="FlexTmplTypes" listname="fgt"/>

<ics:clearerrno/>
<ics:sql sql='<%= ics.ResolveVariables("SELECT d.name AS defname, d.id FROM tmpltypes.assettemplate d WHERE d.status != \'VO\' ORDER BY d.name") %>' table='<%= ics.ResolveVariables("tmpltypes.assettemplate") %>' listname="templates"/>

<table class="altClass">
    <tr>
      <th>Definition</th>
      <th><ics:resolvevariables name="Variables.assetattr"/></th>
    </tr>
    <ics:listloop listname="templates">
    <tr>
        <td width="25%" valign="top">
            <b><ics:resolvevariables name="templates.defname"/> </b>
            <ics:sql sql='<%= ics.ResolveVariables("SELECT assettype FROM FlexAssetTypes WHERE assetattr=\'Variables.assetattr\' AND assettemplate=\'tmpltypes.assettemplate\'") %>' table="FlexAssetTypes" listname="types"/>
            <ics:listloop listname="types">
                <ics:sql sql='<%= ics.ResolveVariables("SELECT count(id) AS num FROM types.assettype WHERE tmpltypes.tid = templates.id AND status != \'VO\'") %>' table='<%= ics.ResolveVariables("types.assettype") %>' listname="assetcount"/>
                <br/><ics:resolvevariables name="types.assettype"/>(<ics:resolvevariables name="assetcount.num"/>)
            </ics:listloop>
        </td>
        <td>
            <ics:sql sql='<%= ics.ResolveVariables("SELECT da.ownerid, a.name as aname, a.attributetype as attreditorid, a.status as status, da.attributeid, da.requiredflag as required, da.ordinal as ordinal, ae.type, ae.assettypename as atname, ae.valuestyle FROM tmpltypes.assettemplate_TAttr da, tmpltypes.assetattr a, tmpltypes.assetattr_Extension ae WHERE a.id=ae.ownerid AND da.ownerid = templates.id AND a.id = da.attributeid ORDER BY ordinal, a.name") %>' table='<%= ics.ResolveVariables("tmpltypes.assettemplate_TAttr") %>' listname="templateattributes"/>
            <ics:clearerrno/>
            <ics:sql sql='<%= ics.ResolveVariables("SELECT ownerid, productgrouptemplateid, requiredflag as required, multipleflag as multiple FROM tmpltypes.assettemplate_TGroup WHERE templateattributes.ownerid=ownerid") %>' table='<%= ics.ResolveVariables("tmpltypes.assettemplate_TGroup") %>' listname="parentlist1" />

            <%-- ***** Don't render the parents if there are none to render ***** --%>
            <% if (ics.GetErrno() == 0){ %>
                <table cellspacing="0">
                    <tr>
                    <th width="30%">Parent Name</th>
                    </tr>
                    <ics:listloop listname="parentlist1">
                        <tr>
                                <ics:clearerrno/>
                                <ics:sql sql='<%= ics.ResolveVariables("SELECT name FROM fgt.assettemplate WHERE id = parentlist1.productgrouptemplateid ") %>' table='<%= ics.ResolveVariables("fgt.assettemplate") %>' listname="parentname" />
                                    <td><ics:resolvevariables name="parentname.name"/><% if ("T".equals(ics.ResolveVariables("parentlist1.required"))){ %> * <% } %>
                                    <% if ("T".equals(ics.ResolveVariables("parentlist1.multiple"))){ %>
                                        [M]
                                    <% } else { %>
                                        [S]
                                    <% } %>
                                </td>
                        </tr>
                    </ics:listloop>
                </table>
            <% } else { %>
                No flex parents for this definition.
            <% } %>

            <br/>
            <ics:clearerrno/>


            <table cellspacing="0">
                 <tr>
                      <th width="40%">Attr Name</th>
                      <th width="20%">Attr Type</th>
                      <th width="20%">Attr Editor</th>
                 </tr>
                <ics:listloop listname="templateattributes">
                    <tr>
                        <td><ics:resolvevariables name="templateattributes.aname"/>
                        <% if ("T".equals(ics.ResolveVariables("templateattributes.required"))){ %> * <% } %>
                        </td>
                        <td>
                        <ics:resolvevariables name="templateattributes.type"/>
                            <% if ("asset".equals(ics.ResolveVariables("templateattributes.type"))){ %>
                             (<ics:resolvevariables name="templateattributes.atname"/>)
                        <% } %>
                       [<ics:resolvevariables name="templateattributes.valuestyle"/>]
                       </td>
                        <td>
                            <% if ( (ics.ResolveVariables("templateattributes.attreditorid") != null) && (ics.ResolveVariables("templateattributes.attreditorid").length() > 0)) { %>
                                <ics:sql sql='<%= ics.ResolveVariables("SELECT id, name FROM AttrTypes WHERE templateattributes.attreditorid = id") %>' table='AttrTypes' listname="AttributeEditor"/>
                                <ics:resolvevariables name="AttributeEditor.name"/>
                            <% } else { %>
                                &nbsp;
                            <% } %>
                        </td>
                        <ics:clearerrno/>
                    </tr>
                </ics:listloop>
            </table>

        </td>
        <ics:clearerrno/>
    </tr>
    </ics:listloop>
</table>
</ics:listloop>
<br/><br/><br/>
</cs:ftcs>
