<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld"
%><%//
// Support/TCPI/CleanUp/CountAssetApprAndDeps
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
<%
ics.SetVar("tname","ApprovedAssetDeps");
boolean delete = false;//"true".equals(ics.GetVar("delete"));
%>
<h3>Check <ics:getvar name="tname"/> for Dependencies without a Owner</h3>
<ics:callelement element="Support/TCPI/CleanUp/CountDuplicateTargetid"/>
<hr/>

<ics:clearerrno />
<ics:flushcatalog catalog='<%= ics.GetVar("tname") %>' />
<ics:clearerrno />

<table class="altClass">
    <tr>
        <th>Nr of Distinct Assets</th>
        <th>Nr of Missing Assets</th>
    </tr>
    <tr>
        <ics:clearerrno />
        <ics:sql sql='<%= ics.ResolveVariables("SELECT count(DISTINCT ownerid) as num FROM Variables.tname") %>' table='<%= ics.ResolveVariables("Variables.tname") %>' listname="assettcount"/>
        <td align="right"><ics:listget listname="assettcount" fieldname="num"/></td>
        <ics:clearerrno />
        <ics:sql sql='<%= ics.ResolveVariables("SELECT count(DISTINCT ownerid) as num FROM ApprovedAssetDeps WHERE ownerid NOT IN (SELECT id FROM ApprovedAssets)") %>' table='<%= ics.ResolveVariables("Variables.tname") %>' listname="assetcount"/>
        <td align="right"><ics:listget listname="assetcount" fieldname="num"/></td>
        <% if (delete && Integer.parseInt(ics.ResolveVariables("assetcount.num")) > 0){
            %>
            <ics:sql sql='<%= ics.ResolveVariables("DELETE FROM ApprovedAssetDeps WHERE ownerid NOT IN (SELECT id FROM ApprovedAssets)") %>' table='<%= ics.ResolveVariables("Variables.tname") %>' listname="assetdel"/>
            <% if (ics.GetErrno() == -502) {
                %><td>delete successfull </td><%
            } else {
                %><td>delete failed with errno:<ics:geterrno/></td><%
            }
            %>
        <ics:flushcatalog catalog='<%= ics.GetVar("tname") %>' />
        <ics:clearerrno />
        <%
        }
        %>
    </tr>
</table>
</cs:ftcs>
