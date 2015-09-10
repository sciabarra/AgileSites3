<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="deliverytype" uri="futuretense_cs/deliverytype.tld" %>
<%//
// Support/TCPI/AP/DuplicatePubkeyFront
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
<center><h4>Overview of Duplicate Pubkeys</h4></center>
<%
  String ptid = ics.GetVar("ptid");
  String ptname = ics.GetVar("ptname");
%>

<% if (ics.GetVar("ptid")==null) { %>
    <ics:setvar name="errno" value="0"/>
    <ics:selectto table="PubTarget" listname="pubTgts" what="id,name,type"/>
    <ics:if condition='<%= ics.GetErrno()==0%>'>
    <ics:then>
    <b>Select a Publish Destination:</b>
    <ul class="subnav">
    <ics:listloop listname="pubTgts">
        <deliverytype:load name="dtype" objectid='<%= ics.ResolveVariables("pubTgts.type")%>'/>
        <deliverytype:get name="dtype" field="name" output="dname"/>
        <li>
        <a href='ContentServer?pagename=<ics:getvar name="pagename"/>&ptid=<ics:resolvevariables name="pubTgts.id"/>&ptname=<ics:resolvevariables name="pubTgts.name"/> (<ics:getvar name="dname"/>)'>
        <ics:resolvevariables name="pubTgts.name"/> (<ics:getvar name="dname"/>)</a>
        </li>
    </ics:listloop>
    </ul>
    </ics:then>
    <ics:else>
        No Destinations Available
    </ics:else>
    </ics:if>
<% } else { %>
    <h3><%= ics.GetVar("ptname")%></h3><br/>
    <% if(ics.GetVar("pubkeyid")!=null) { %>
        <% String query1="DELETE FROM PubKeyTable WHERE id=Variables.pubkeyid AND newkey='N' AND EXISTS (SELECT 1 FROM PubKeyTable B WHERE PubKeyTable.localkey = B.localkey AND PubKeyTable.targetid = B.targetid AND B.newkey='D')"; %>

        <ics:sql sql="<%=ics.ResolveVariables(query1)%>" listname="duplist1" table="PubKeyTable"/>

        <ics:catalogmanager>
           <ics:argument name="ftcmd" value="flushcatalog" />
           <ics:argument name="tablename" value="PubKeyTable" />
        </ics:catalogmanager>

        <% if (ics.GetErrno()!=0) { %>
            Error: <ics:geterrno/><BR>
        <% } %>
    <% } %>

    <% String query= "SELECT id, newkey, localkey, assetid FROM PubKeyTable A WHERE A.targetid=Variables.ptid AND A.newkey='N' AND EXISTS (SELECT 1 FROM PubKeyTable B WHERE A.localkey = B.localkey AND A.targetid = B.targetid AND B.newkey='D')"; %>

    <ics:sql sql="<%=ics.ResolveVariables(query)%>" listname="duplist" table="PubKeyTable"/>

    <%
     IList list=ics.GetList("duplist");
     int i = 1;
     int counter = list.numRows();

     if (counter<=0) {
    %>
       There are no duplicate keys.
    <% } else { %>
        <table class='altClass'>
        <tr><th>pubid</th><th>newkey</th><th>assetid</th><th>localkey</th><th>delete?</th></tr>
        <%
        while(i <= counter)
        {
          list.moveTo(i);
          i++;
          String id=list.getValue("id");
          String newkey=list.getValue("newkey");
          String assetid=list.getValue("assetid");
          String localkey=list.getValue("localkey");
        %>
          <tr>
              <td><%=id%></td>
              <td><%=newkey%></td>
              <td><%=assetid%></td>
              <td><%=localkey%></td>
          <td><a href='ContentServer?pagename=<ics:getvar name="pagename"/>&ptid=<%=ptid%>&ptname=<%=ptname%>&pubkeyid=<%=id%>&delete=true'>fixme</a></td>
          </tr>
        <% } %>
        </table>
    <% } %>
<% } %>
</cs:ftcs>