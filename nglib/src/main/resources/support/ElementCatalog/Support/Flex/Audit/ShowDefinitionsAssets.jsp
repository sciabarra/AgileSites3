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
2) loop over assettemplates
3) list all assets (assetdef) from that assettemplate
4) loop over asset def
5) get parents for def
6) get attribute for def
7) get assettypes for def, count assets of this type


-->
<ics:clearerrno/>
<ics:sql sql='<%= ics.ResolveVariables("SELECT assettemplate,assettype,assetattr FROM FlexTmplTypes WHERE assetattr = \'Variables.assetattr\' ") %>'  table="FlexTmplTypes" listname="flextmpltypes"/>

<table style="margin-bottom:24px">
<tr>
  <th>Definition</th>
  <th><ics:resolvevariables name="Variables.assetattr"/></th>
</tr>
<ics:listloop listname="flextmpltypes">

    <ics:clearerrno/>
    <ics:sql sql='<%= ics.ResolveVariables("SELECT d.name AS defname, d.id FROM flextmpltypes.assettype d WHERE d.status != \'VO\' ORDER BY d.name") %>' table='<%= ics.ResolveVariables("flextmpltypes.assettype") %>' listname="templates"/>

    <ics:listloop listname="templates">
    <tr>
        <td style="vertical-align:top;width:25%">
            <b><ics:resolvevariables name="templates.defname"/> </b>
            <ics:sql sql='<%= ics.ResolveVariables("SELECT assettype FROM FlexAssetTypes WHERE assetattr=\'Variables.assetattr\' AND assettemplate=\'flextmpltypes.assettype\'") %>' table="FlexAssetTypes" listname="types"/>
            <ics:listloop listname="types">
                <ics:sql sql='<%= ics.ResolveVariables("SELECT count(id) AS num FROM types.assettype WHERE flextemplateid = templates.id AND status != \'VO\'") %>' table='<%= ics.ResolveVariables("types.assettype") %>' listname="assetcount"/>
                <br/><ics:resolvevariables name="types.assettype"/>(<ics:resolvevariables name="assetcount.num"/>)
            </ics:listloop>
        </td>
        <td style="padding:4px 0px 0px 0px">
            <ics:clearerrno/>
            <ics:sql sql='<%= ics.ResolveVariables("SELECT ownerid, productgrouptemplateid, requiredflag as required, multipleflag as multiple FROM flextmpltypes.assettype_TGroup WHERE templates.id=ownerid") %>' table='<%= ics.ResolveVariables("flextmpltypes.assettype_TGroup") %>' listname="parentlist1" />

            <%-- ***** Don't render the parents if there are none to render ***** --%>
            <% if (ics.GetErrno() == 0){ %>
                    Parents:
                    <ics:listloop listname="parentlist1">
                        <ics:clearerrno/>
                        <ics:sql sql='<%= ics.ResolveVariables("SELECT name FROM flextmpltypes.assettemplate WHERE id = parentlist1.productgrouptemplateid") %>' table='<%= ics.ResolveVariables("flextmpltypes.assettemplate") %>' listname="parentname" />
                        <p><a href='#<ics:resolvevariables name="parentname.name"/>'><ics:resolvevariables name="parentname.name"/></a>
                        <%= "T".equals(ics.ResolveVariables("parentlist1.required")) ? "*":"&nbsp;" %>
                        <%= "T".equals(ics.ResolveVariables("parentlist1.multiple")) ? "[M]":"[S]" %>
                        </p>
                    </ics:listloop>
            <% } else { %>
                No flex parents for this definition.
            <% } %>
            <ics:clearerrno/>
            <ics:sql sql='<%= ics.ResolveVariables("SELECT da.ownerid, a.name as aname, a.attributetype as attreditorid, a.status as status, da.attributeid, da.requiredflag as required, da.ordinal as ordinal, ae.type, ae.assettypename as atname, ae.valuestyle FROM flextmpltypes.assettype_TAttr da, flextmpltypes.assetattr a, flextmpltypes.assetattr_Extension ae WHERE a.id=ae.ownerid AND da.ownerid = templates.id AND a.id = da.attributeid ORDER BY ordinal, a.name") %>' table='<%= ics.ResolveVariables("flextmpltypes.assettype_TAttr") %>' listname="templateattributes"/>
            <table  class="altClass">
                 <tr>
                      <th>Attr Name</th>
                      <th>Attr Type</th>
                      <th>Attr Editor</th>
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
                                <ics:sql sql='<%= ics.ResolveVariables("SELECT id, name, description FROM AttrTypes WHERE templateattributes.attreditorid = id") %>' table='AttrTypes' listname="AttributeEditor"/>
                                <ics:resolvevariables name="AttributeEditor.description"/> (<ics:resolvevariables name="AttributeEditor.name"/>)
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
</ics:listloop>
</table>
</cs:ftcs>
