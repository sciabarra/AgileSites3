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
    boolean fix = "true".equals(ics.GetVar("fix"));
%>

    <h3>Check <i><ics:getvar name="tname"/></i> for Missing Assets</h3><br/>
    <ics:clearerrno />
    <ics:sql sql='<%= ics.ResolveVariables("SELECT DISTINCT assettype FROM Variables.tname ORDER BY assettype") %>' table='<%= ics.GetVar("tname") %>' listname="assettypes"/>
    <ics:sql sql='<%= ics.ResolveVariables("SELECT id,name  FROM Publication ORDER BY name") %>' table='Publication' listname="sites"/>
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
                <th>AssetType</th>
                <th>Nr of Assets</th>
                <th>Nr of Assets in <ics:getvar name="tname"/></th>
                <th>Nr of Missing Assets</th>
            </tr>
            <tr>
                <td><ics:getvar name="assettype"/></td>
                <ics:clearerrno />
                <ics:sql sql='<%= ics.ResolveVariables("SELECT count(id) as num FROM Variables.assettype") %>' table='<%= ics.ResolveVariables("Variables.assettype") %>' listname="assettablecount"/>
                <td align="right"><ics:listget listname="assettablecount" fieldname="num"/></td>

                <ics:clearerrno />
                <ics:sql sql='<%= ics.ResolveVariables("SELECT count(DISTINCT assetid) as num FROM Variables.tname WHERE assettype=\'Variables.assettype\'") %>' table='<%= ics.ResolveVariables("Variables.tname") %>' listname="assettcount"/>
                <td align="right"><ics:listget listname="assettcount" fieldname="num"/></td>

                <ics:clearerrno />

                <ics:sql sql='<%= ics.ResolveVariables("SELECT count(id) as num FROM Variables.assettype WHERE NOT EXISTS (SELECT 1 FROM Variables.tname t WHERE assettype=\'Variables.assettype\' AND  t.Variables.identifier = Variables.assettype.id)") %>' table='<%= ics.ResolveVariables("Variables.tname") %>' listname="assetcount"/>
                <td align="right"><ics:listget listname="assetcount" fieldname="num"/></td>
            </tr></table>
        </td>
        <%
        if (Integer.parseInt(ics.ResolveVariables("assetcount.num")) > 0){
            if(fix){
                %><td>
                <table>
                <ics:sql sql='<%= ics.ResolveVariables("SELECT id FROM Variables.assettype WHERE NOT EXISTS (SELECT 1 FROM Variables.tname t WHERE assettype=\'Variables.assettype\' AND  t.Variables.identifier = Variables.assettype.id)") %>' table='<%= ics.ResolveVariables("Variables.tname") %>' listname="assets"/>
                <ics:listloop listname="assets">
                <tr><th>Fixed in <ics:getvar name="pubid"/> (pubid)</th></tr>
                <tr><td><ics:listget listname="assets" fieldname="id"/> (assetid)</td></tr>
                <tr><td><ics:getvar name="assettype"/> (assettype)</td></tr>
                    <ics:catalogmanager>
                        <ics:argument name="ftcmd" value="addrow"/>
                        <ics:argument name="tablename" value='<%= ics.GetVar("tname") %>' />
                        <ics:argument name="id" value='<%= ics.genID(true) %>' />
                        <ics:argument name="pubid" value='<%= ics.GetVar("pubid") %>' />
                        <ics:argument name="assettype" value='<%= ics.GetVar("assettype") %>' />
                        <ics:argument name="assetid" value='<%= ics.ResolveVariables("assets.id") %>' />
                    </ics:catalogmanager>
                    <%
                    if (ics.GetErrno() == 0) {
                        %><tr><td>insert successfull </td></tr><%
                    } else {
                        %><tr><td>insert failed with errno:<ics:geterrno/></td></tr><%
                    }
                    %>
                </ics:listloop>
                </table>
                </td>
                <ics:flushcatalog catalog='<%= ics.ResolveVariables("Variables.tname") %>'/>
                <ics:flushcatalog catalog='<%= ics.ResolveVariables("Variables.assettype") %>'/>
                <ics:clearerrno />
                <%
            } else {
                %><td>
                <table><tr><th>Fix in Publication</th></tr>
                <ics:listloop listname="sites">
                    <tr><td><a href='ContentServer?pagename=<ics:getvar name="pagename"/>&tname=<ics:getvar name="tname" />&assettype=<ics:getvar name="assettype"/>&fix=true&pubid=<ics:listget listname="sites" fieldname="id"/>'><ics:listget listname="sites" fieldname="name"/></a></td></tr>
                </ics:listloop>
                </table>
                </td>
                <%
            }
        }
        %>
        </tr></table>
    <% } %>
    <ics:clearerrno />

    <br/>
    <table class="altClass" style="width:40%">
    <tr>
        <th>assettype</th>
    </tr>
    <ics:listloop listname="assettypes">
        <tr>
            <td><a href='ContentServer?pagename=<ics:getvar name="pagename"/>&tname=<ics:getvar name="tname" />&assettype=<ics:listget listname="assettypes" fieldname="assettype"/>'><ics:listget listname="assettypes" fieldname="assettype"/></a></td>
        </tr>
    </ics:listloop>
    </table>
    <% } %>
</cs:ftcs>
