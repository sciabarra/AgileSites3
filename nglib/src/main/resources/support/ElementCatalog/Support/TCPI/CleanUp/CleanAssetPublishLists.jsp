<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld"
%><%//
// Support/TCPI/CleanUp/CleanAssetPublishLists
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
ics.SetVar("status","status");
String version = ics.GetProperty("ft.version");
String majorversion = version.substring(0,1);
if (Integer.parseInt(majorversion) > 5) {
    ics.SetVar("status", "cs_status");
}

if (!Utilities.goodString(ics.GetVar("tname"))) {
    ics.SetVar("tname","AssetPublishList");
}

if (bContinue) {
    boolean delete = "true".equals(ics.GetVar("delete"));

%>
    <h3><center>Checking <ics:getvar name="tname" /> for non-running PubSessions</center></h3>
    <ics:clearerrno />
    <ics:flushcatalog catalog='<%= ics.GetVar("tname") %>' />
    <ics:clearerrno />
    <ics:sql sql='<%= ics.ResolveVariables("SELECT count(id) AS num FROM PubSession ps WHERE ps.Variables.status =\'R\'") %>' table='<%= ics.GetVar("tname") %>' listname="runningcount"/>
    Number of running pubsessions: <b><ics:listget listname="runningcount" fieldname="num"/></b><br/>

    <ics:clearerrno />
    <ics:sql sql='<%= ics.ResolveVariables("SELECT count(*) as num FROM Variables.tname") %>' table='<%= ics.GetVar("tname") %>' listname="tcount"/>
    Number of rows in the table: <b><ics:listget listname="tcount" fieldname="num"/></b><br/>

    <ics:clearerrno />
    <ics:sql sql='<%= ics.ResolveVariables("SELECT COUNT(DISTINCT pubsession) AS num FROM Variables.tname  WHERE NOT EXISTS (SELECT \'x\' FROM PubSession ps WHERE ps.id = Variables.tname.pubsession AND ps.Variables.status =\'R\')") %>' table='<%= ics.GetVar("tname") %>' listname="pscount"/>
    Number of leftover pubsessions: <b><ics:listget listname="pscount" fieldname="num"/></b>
    <ics:clearerrno />
    <ics:sql sql='<%= ics.ResolveVariables("SELECT COUNT(id) AS num FROM Variables.tname  WHERE NOT EXISTS (SELECT \'x\' FROM PubSession ps WHERE ps.id = Variables.tname.pubsession AND ps.Variables.status =\'R\')") %>' table='<%= ics.GetVar("tname") %>' listname="assetscount"/>
    Nr of Assets: <b><ics:listget listname="assetscount" fieldname="num"/></b><br/>
    <hr/>

    <% if (delete && Integer.parseInt(ics.ResolveVariables("pscount.num")) > 0){ %>
        <ics:sql sql='<%= ics.ResolveVariables("DELETE FROM Variables.tname WHERE NOT EXISTS (SELECT \'x\' FROM PubSession ps WHERE ps.id = Variables.tname.pubsession AND ps.Variables.status =\'R\')") %>' table='<%= ics.ResolveVariables("Variables.tname") %>' listname="psdel"/>
        <% if (ics.GetErrno() == -502) {
            %><td>delete successfull </td><%
        } else {
            %><td>delete failed with errno:<ics:geterrno/></td><%
        }
        %>
        <ics:clearerrno />
        <ics:flushcatalog catalog='<%= ics.GetVar("tname") %>' />
        <ics:clearerrno />
    <%
    }
    if (delete && Utilities.goodString(ics.GetVar("pubtable"))){
    %>
        <table class="altClass">
            <tr>
                <td>
                <ics:sql sql='<%= ics.ResolveVariables("SELECT DISTINCT sessionid FROM Variables.pubtable WHERE NOT EXISTS (SELECT \'x\' FROM PubSession ps WHERE ps.id = Variables.pubtable.sessionid AND ps.Variables.status =\'R\')") %>' table='<%= ics.ResolveVariables("Variables.pubtable") %>' listname="sessionids" limit='<%= ics.GetVar("limit") %>'/>
                Deleting <%= ics.ResolveVariables("sessionids.#numRows") %> sesionids  from <%= ics.ResolveVariables("Variables.pubtable") %><br/>
                <ics:listloop listname="sessionids">
                    Deleting sessionid: <%= ics.ResolveVariables("sessionids.sessionid") %>:
                    <ics:catalogmanager>
                        <ics:argument name="ftcmd" value="deleterow"/>
                        <ics:argument name="tablename" value='<%= ics.ResolveVariables("Variables.pubtable") %>'/>
                        <ics:argument name="tablekey" value="sessionid"/>
                        <ics:argument name="tablekeyvalue" value='<%= ics.ResolveVariables("sessionids.sessionid") %>'/>
                        <ics:argument name="Delete uploaded file(s)" value="yes"/>
                    </ics:catalogmanager>
                    <ics:geterrno/><br/>
                </ics:listloop>
                </td>
                </tr>
        </table>
        <%
    }
    %>
    <ics:sql sql="SELECT assettypename FROM ComplexAssets ORDER BY assettypename" table="ComplexAssets" listname="complexassets"/>
    <table class="altClass">
        <tr>
            <th>TableName</th>
            <th>Nr of leftover PubSessions</th>
            <th>Nr of Assets</th>
            <th>Action</th>
        </tr>
        <ics:listloop listname="complexassets">
        <tr>
            <% String tblname = ics.ResolveVariables("complexassets.assettypename") + "_Publish"; %>
            <% String sql = "SELECT tblname FROM SystemInfo WHERE tblname='"+ tblname+ "'";  %>
            <ics:clearerrno />
            <ics:sql sql='<%= sql %>'  table="SystemInfo" listname="pubtable"/>
                <td><ics:resolvevariables name="pubtable.tblname"/></td>
                <% if (ics.GetErrno() == 0 ) { %>
                    <ics:sql sql='<%= ics.ResolveVariables("SELECT COUNT(DISTINCT sessionid) AS num FROM pubtable.tblname WHERE NOT EXISTS (SELECT \'x\' FROM PubSession ps WHERE ps.id = pubtable.tblname.sessionid AND ps.Variables.status =\'R\')") %>' table='<%= ics.ResolveVariables("pubtable.tblname") %>' listname="pscount"/>

                    <td><ics:listget listname="pscount" fieldname="num"/></td>
                    <ics:clearerrno />
                    <ics:sql sql='<%= ics.ResolveVariables("SELECT COUNT(id) AS num FROM pubtable.tblname WHERE NOT EXISTS (SELECT \'x\' FROM PubSession ps WHERE ps.id = pubtable.tblname.sessionid AND ps.Variables.status =\'R\')") %>' table='<%= ics.ResolveVariables("pubtable.tblname") %>' listname="assetcount"/>

                    <td><ics:listget listname="assetcount" fieldname="num"/></td>

                    <% if (Integer.parseInt(ics.ResolveVariables("pscount.num")) > 0){ %>
                        <td><a href='ContentServer?pagename=Support/TCPI/CleanUp/CleanAssetPublishLists&pubtable=<%= ics.ResolveVariables("pubtable.tblname") %>&delete=true'>fixme</a></td>
                    <%
                    }
                }
                %>
        </tr>
        </ics:listloop>
    </table>
<% } %>
</cs:ftcs>
