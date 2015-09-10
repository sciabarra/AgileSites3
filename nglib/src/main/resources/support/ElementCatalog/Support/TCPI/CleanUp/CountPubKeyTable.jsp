<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld"
%><%//
// Support/TCPI/CleanUp/CountPubKeyTable
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
ics.SetVar("tname","PubKeyTable");

boolean delete = "true".equals(ics.GetVar("delete"));
%>

<h3>Check <i><ics:getvar name="tname"/></i> for Missing Assets</h3><br/>
<ics:clearerrno />
<ics:sql sql='<%= ics.ResolveVariables("SELECT count(*) as num FROM Variables.tname") %>' table='<%= ics.GetVar("tname") %>' listname="tcount"/>
Number of rows in the table: <b><ics:listget listname="tcount" fieldname="num"/></b><br/>

<% if (Utilities.goodString(ics.GetVar("targetid"))){
    if (delete){
        %>
        <ics:sql sql='<%= ics.ResolveVariables("SELECT id FROM Variables.tname WHERE targetid = Variables.targetid AND NOT EXISTS (SELECT 1 FROM AssetPublication WHERE assetid = Variables.tname.assetid )") %>' table='<%= ics.ResolveVariables("Variables.tname") %>' listname="assetdel" limit="500" />
        <ics:listloop listname="assetdel">
            <ics:clearerrno />
            <ics:catalogmanager>
                <ics:argument name="ftcmd" value="deleterow"/>
                <ics:argument name="tablename" value="PubKeyTable"  />
                <ics:argument name="id" value='<%= ics.ResolveVariables("assetdel.id") %>'/>
                <ics:argument name="Delete uploaded file(s)" value="yes"/>
            </ics:catalogmanager>
            <%
            if (ics.GetErrno() == 0) {
                %><%= ics.ResolveVariables("assetdel.id") %>: delete successfull <br/><%
            } else {
                %><%= ics.ResolveVariables("assetdel.id") %>: delete failed with errno:<ics:geterrno/><br/><%
            }

            %>
        </ics:listloop>
        <ics:flushcatalog catalog='<%= ics.GetVar("tname") %>' />
        <ics:clearerrno />
        <br/>
        <% } %>
<table class="altClass">
    <tr>
        <th>Target</th>
        <th>Nr of distinct assets</th>
        <th>Nr of missing assets</th>
    </tr>
    <tr>
        <ics:clearerrno />
        <ics:sql sql='<%= ics.ResolveVariables("SELECT name FROM PubTarget WHERE id=Variables.targetid") %>' table="PubTarget" listname="target"/>
        <td>
            <ics:listget listname="target" fieldname="name"/>
        </td>
        <ics:sql sql='<%= ics.ResolveVariables("SELECT count(DISTINCT assetid) as num FROM Variables.tname WHERE targetid = Variables.targetid") %>' table='<%= ics.ResolveVariables("Variables.tname") %>' listname="assettcount"/>
        <td align="right">
            <ics:listget listname="assettcount" fieldname="num"/>
        </td>
        <ics:clearerrno />
        <ics:sql sql='<%= ics.ResolveVariables("SELECT count(id) as num FROM Variables.tname WHERE targetid = Variables.targetid AND NOT EXISTS (SELECT 1 FROM AssetPublication WHERE assetid = Variables.tname.assetid )") %>' table='<%= ics.ResolveVariables("Variables.tname") %>' listname="assetcount"/>
        <td align="right">
            <ics:listget listname="assetcount" fieldname="num"/>
        </td>
        <% if (Integer.parseInt(ics.ResolveVariables("assetcount.num")) > 0){ %>
            <td>
                <a href='ContentServer?pagename=<ics:getvar name="pagename"/>&tname=<ics:getvar name="tname" />&targetid=<ics:getvar name="targetid" />&delete=true'>Delete</a>
            </td>
        <% } %>
    </tr>
</table><br/>
<% } %>

<ics:clearerrno />
<ics:sql sql='<%= ics.ResolveVariables("SELECT DISTINCT t.id as targetid, t.name as name FROM PubKeyTable pk, PubTarget t WHERE pk.targetid=t.id ORDER BY targetid") %>' table="PubKeyTable" listname="targets"/>
<table class="altClass">
    <tr>
        <th>Destination</th>
        <th>Nr of pubkey rows</th>
        <th>Nr of distinct pubkey assets</th>
    </tr>

    <ics:clearerrno />
    <ics:sql sql='<%= ics.ResolveVariables("SELECT pt.name as name, COUNT(pk.id) as num, COUNT(DISTINCT pk.assetid) as num2 FROM Variables.tname pk, PubTarget pt  WHERE pt.id = pk.targetid GROUP BY pt.name ORDER BY pt.name") %>' table='<%= ics.ResolveVariables("Variables.tname") %>' listname="assetcount"/>
    <ics:listloop listname ="assetcount">
    <tr>
        <td><ics:listget listname="assetcount" fieldname="name"/></td>
        <td align="right"><ics:listget listname="assetcount" fieldname="num"/></td>
        <td align="right"><ics:listget listname="assetcount" fieldname="num2"/></td>
    </tr>
    </ics:listloop>
</table>
<br/>
<b>Select a Publish Destination:</b>
<ul class="subnav">
    <ics:listloop listname="targets">
    <li>
        <a href='ContentServer?pagename=<ics:getvar name="pagename"/>&tname=<ics:getvar name="tname" />&targetid=<ics:listget listname="targets" fieldname="targetid"/>'><ics:listget listname="targets" fieldname="name"/></a>
    </li>
    </ics:listloop>
</ul>
</cs:ftcs>
