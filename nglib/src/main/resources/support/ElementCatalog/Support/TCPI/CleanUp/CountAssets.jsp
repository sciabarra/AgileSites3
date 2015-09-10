<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld"
%><%//
// Support/TCPI/CleanUp/CountAssets
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
boolean bContinue=true;

if (!Utilities.goodString(ics.GetVar("identifier"))){
    bContinue=false;
    %><font color='red'>Indentifier not found.</font><%
}

if (!Utilities.goodString(ics.GetVar("tname"))) {
    ics.SetVar("tname","AssetPublication");
}

if (bContinue) {
    boolean delete = "true".equals(ics.GetVar("delete"));
%>

    <h3>Check <i><ics:getvar name="tname"/></i> for Missing Assets</h3><br/>
    <ics:clearerrno />
    <ics:clearerrno />
    <ics:sql sql='<%= ics.ResolveVariables("SELECT DISTINCT assettype FROM Variables.tname ORDER BY assettype") %>' table='<%= ics.GetVar("tname") %>' listname="assettypes"/>

    <ics:sql sql='<%= ics.ResolveVariables("SELECT count(*) as num FROM Variables.tname") %>' table='<%= ics.GetVar("tname") %>' listname="tcount"/>
    Number of rows in the table: <b><ics:listget listname="tcount" fieldname="num"/></b><br/>
    <ics:clearerrno />

    <% if (Utilities.goodString(ics.GetVar("assettype"))){
        IList assetTypes = ics.GetList("assettypes");
        int num = assetTypes.numRows();
        for (int i=1; i<=  num;i++){
            assetTypes.moveTo(i);
            if (ics.GetVar("assettype").equals(assetTypes.getValue("assettype"))){
                if (i+1<=num) {
                    i++;
                    assetTypes.moveTo(i);
                    %><a href='ContentServer?pagename=<ics:getvar name="pagename"/>&tname=<ics:getvar name="tname" />&assettype=<%= assetTypes.getValue("assettype") %>'>Next >> <%= assetTypes.getValue("assettype") %></a><%
                    i=num+1;
                }
            }
        }


        %>
        <table class="altClass"><tr>
        <td>
            <table>
            <tr>
                <th>assettype</th>
                <th>Nr of assets</th>
                <th>Nr of assets in <ics:getvar name="tname"/></th>
                <th>Nr of missing assets</th>
            </tr>
            <tr>
                <td><ics:getvar name="assettype"/>
                <ics:clearerrno />
                <ics:sql sql='<%= ics.ResolveVariables("SELECT count(id) as num FROM Variables.assettype") %>' table='<%= ics.ResolveVariables("Variables.assettype") %>' listname="assettablecount"/>
                <td align="right"><ics:listget listname="assettablecount" fieldname="num"/></td>

                <ics:clearerrno />
                <ics:sql sql='<%= ics.ResolveVariables("SELECT count(DISTINCT assetid) as num FROM Variables.tname WHERE assettype=\'Variables.assettype\'") %>' table='<%= ics.ResolveVariables("Variables.tname") %>' listname="assettcount"/>
                <td align="right"><ics:listget listname="assettcount" fieldname="num"/></td>

                <ics:clearerrno />

                <ics:sql sql='<%= ics.ResolveVariables("SELECT count(id) as num FROM Variables.tname WHERE assettype=\'Variables.assettype\' AND NOT EXISTS (SELECT \'x\' FROM Variables.assettype  t WHERE t.id=Variables.tname.Variables.identifier)") %>' table='<%= ics.ResolveVariables("Variables.tname") %>' listname="assetcount"/>
                <td align="right"><ics:listget listname="assetcount" fieldname="num"/></td>
             </tr></table>
        </td>
        <%
        if (Integer.parseInt(ics.ResolveVariables("assetcount.num")) > 0){
            if (delete){
                %><td>
                <table>
                <ics:sql sql='<%= ics.ResolveVariables("DELETE FROM Variables.tname WHERE assettype=\'Variables.assettype\' AND NOT EXISTS (SELECT \'x\' FROM Variables.assettype  t WHERE t.id=Variables.tname.Variables.identifier)") %>' table='<%= ics.ResolveVariables("Variables.tname") %>' listname="assetdel"/>
                <%
                if (ics.GetErrno() == -502) {
                    %><tr><td>delete successfull </td></tr><%
                } else {
                    %><tr><td>delete failed with errno:<ics:geterrno/></td></tr><%
                }
                %>
                <ics:flushcatalog catalog='<%= ics.ResolveVariables("Variables.tname") %>'/>
                <ics:clearerrno />
                </table>
                </td>
                <%
            } else {
                %><!-- td><a href='ContentServer?pagename=<ics:getvar name="pagename"/>&tname=<ics:getvar name="tname" />&assettype=<ics:getvar name="assettype"/>&delete=true'>fix</a></td --><%
            }
        }
        %>
        </tr></table><br/>
    <%
    }
    %>
    <ics:clearerrno />
    <table class="altClass" style="width:40%">
    <tr>
        <th>Nr</th>
        <th>assettype</th>
    </tr>
    <ics:listloop listname="assettypes">
        <tr>
        <td><ics:listget listname="assettypes" fieldname="#curRow"/></td>
        <td><a href='ContentServer?pagename=<ics:getvar name="pagename"/>&tname=<ics:getvar name="tname" />&assettype=<ics:listget listname="assettypes" fieldname="assettype"/>'><ics:listget listname="assettypes" fieldname="assettype"/></a></td>
        </tr>
    </ics:listloop>
    </table>
    <% } %>
</cs:ftcs>
