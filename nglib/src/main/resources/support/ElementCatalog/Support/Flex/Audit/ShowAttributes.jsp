<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// Support/Flex/Audit/ShowAttributes
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
<h4>Attribute Definitions for '<ics:getvar name="assetattr"/>' FlexFamily</h4>
<ics:sql sql='<%= ics.ResolveVariables("SELECT a.name as aname, a.attributetype as attreditorid, a.status as status, ae.type, ae.assettypename as atname, ae.valuestyle FROM Variables.assetattr a, Variables.assetattr_Extension ae WHERE a.id=ae.ownerid ORDER BY UPPER(a.name)") %>' table='<%= ics.ResolveVariables("Variables.assetattr") %>' listname="templateattributes"/>


<table class="altClass">
     <tr>
          <th>Attr Name</th>
          <th>Attr Type</th>
          <th>Attr Editor</th>
     </tr>
    <ics:listloop listname="templateattributes">
        <tr>
            <td><ics:resolvevariables name="templateattributes.aname"/></td>
            <td>
            <ics:resolvevariables name="templateattributes.type"/>
                <% if ("asset".equals(ics.ResolveVariables("templateattributes.type"))){ %>
                 (<ics:resolvevariables name="templateattributes.atname"/>)
            <% } %>
           [<ics:resolvevariables name="templateattributes.valuestyle"/>]
           </td>
            <td>
                <% if ( (ics.ResolveVariables("templateattributes.attreditorid") != null) && (ics.ResolveVariables("templateattributes.attreditorid").length() > 0)) { %>
                    <ics:sql sql='<%= ics.ResolveVariables("SELECT id, name,description FROM AttrTypes WHERE templateattributes.attreditorid = id") %>' table='AttrTypes' listname="AttributeEditor"/>
                    <ics:resolvevariables name="AttributeEditor.description"/> (<ics:resolvevariables name="AttributeEditor.name"/>)
                <% } else { %>
                    &nbsp;
                <% } %>
            </td>
            <ics:clearerrno/>
        </tr>
    </ics:listloop>
</table>
<br/>
</cs:ftcs>