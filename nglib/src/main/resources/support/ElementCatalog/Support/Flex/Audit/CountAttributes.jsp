<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld"
%><%//
// Support/Flex/Audit/CountAttributes
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
<h3>Count Attributes</h3>
<p>This page shows how often an attribute is used for assets of type <b><ics:getvar name="assettype"/></b></p>
<% boolean show= false; %>
<ics:clearerrno/>
<ics:sql sql='<%= ics.ResolveVariables("SELECT assetattr FROM FlexAssetTypes WHERE assettype=\'Variables.assettype\'") %>' table="FlexAssetTypes" listname="attributetype"/>
<% if (ics.GetErrno() ==-101){ %>
<ics:clearerrno/>
<ics:sql sql='<%= ics.ResolveVariables("SELECT assetattr FROM FlexGroupTypes WHERE assettype=\'Variables.assettype\'") %>' table="FlexGroupTypes" listname="attributetype"/>
<%}
%>
<% if (show) { %>
    <ics:sql sql='<%= ics.ResolveVariables("SELECT cs_ownerid as assetid, count(id) as num FROM Variables.assettype_Mungo GROUP BY ownerid ORDER BY num DESC, cs_ownerid") %>' table='<%= ics.ResolveVariables("Variables.assettype_Mungo") %>' listname="mungocount" limit="20"/>
    <ics:listloop listname="mungocount">

        <ics:listget listname="mungocount" fieldname="assetid"  />:
        <ics:listget listname="mungocount" fieldname="num"  /><br/>

        <ics:sql sql='<%= ics.ResolveVariables("SELECT attr.name, attr.description FROM attributetype.assetattr attr, Variables.assettype_Mungo mungo WHERE mungo.cs_attrid = attr.id AND mungo.cs_ownerid = mungocount.assetid ORDER BY name") %>' table='<%= ics.ResolveVariables("Variables.assettype_Mungo") %>' listname="attr"/>
            <ics:listloop listname="attr">
                ###<ics:listget listname="attr" fieldname="name"  />:
                <ics:listget listname="attr" fieldname="description"  /><br/>
            </ics:listloop>

    </ics:listloop>
    <hr/>
<% } %>
<ics:clearerrno/>
<ics:sql sql='<%= ics.ResolveVariables("SELECT count(t2.id) as num, t1.id AS id, t1.name AS name FROM attributetype.assetattr t1, Variables.assettype_Mungo t2 WHERE t2.cs_attrid = t1.id GROUP BY t1.id, t1.name ORDER BY num DESC, name") %>' table='<%= ics.ResolveVariables("attributetype.assetattr") %>' listname="attrcount" limit="-1"/>
<table class="altClass">
<tr>
    <th>Nr</th>
    <th>Attribute</th>
    <th>Count</th>
</tr>

<ics:listloop listname="attrcount">
    <tr>
        <td align="right"><ics:listget listname="attrcount" fieldname="#curRow"  /></td>
        <td><ics:listget listname="attrcount" fieldname="name"  /></td>
        <td><ics:listget listname="attrcount" fieldname="num"  /></td>
    </tr>
</ics:listloop>
</table>
</cs:ftcs>
