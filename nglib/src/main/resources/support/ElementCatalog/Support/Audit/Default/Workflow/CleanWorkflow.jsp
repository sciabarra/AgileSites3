<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld"
%><%//
// Support/Audit/V7/Workflow/CleanWorkflow
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
%><%@ page import="COM.FutureTense.Util.ftMessage"
%><cs:ftcs><%
ics.SetVar("tname","Assignment");
if (!Utilities.goodString(ics.GetVar("limit"))){
    ics.SetVar("limit","500");
}
boolean delete = "true".equals(ics.GetVar("delete"));

long now = System.currentTimeMillis();
%>

<h3>Clean Workflow Tables</h3>
<PRE>This Tool Deletes Completed Workflow History</PRE>

<% if (delete) { %>
    <ics:clearerrno />
    <table class="altClass">
    <ics:sql sql='<%= ics.ResolveVariables("select id from WorkflowObjects where cs_status!=\'A\'")%>' table="WorkflowObjects" listname="objects" limit='<%= ics.GetVar("limit") %>'/>
    <% if (ics.GetList("objects").hasData()) { %>
    <tr><th>WorkflowTable</th><th>ID</th><th>Delete?</th></tr>
    <ics:listloop listname="objects">
        <ics:sql sql='<%= ics.ResolveVariables("select id from Assignment where cs_ownerid=objects.id")%>' table="Assignment" listname="assignments"/>
        <ics:listloop listname="assignments">
            <ics:clearerrno />
            <ics:catalogmanager>
                <ics:argument name="ftcmd" value="deleterow"/>
                <ics:argument name="tablename" value="Assignment"   />
                <ics:argument name="id" value='<%= ics.ResolveVariables("assignments.id") %>'/>
                <ics:argument name="Delete uploaded file(s)" value="yes"/>
            </ics:catalogmanager>
            <% if (ics.GetErrno() == 0) { %>
                <tr><td>Assignment</td><td><%= ics.ResolveVariables("assignments.id") %></td><td>delete successfull</td></tr>
            <% } else { %>
                <tr><td>Assignment</td><td><%= ics.ResolveVariables("assignments.id") %></td><td>delete failed with errno:<ics:geterrno/></td></tr>
            <% } %>
        </ics:listloop>
        <ics:clearerrno />
        <ics:catalogmanager>
            <ics:argument name="ftcmd" value="deleterow"/>
            <ics:argument name="tablename" value="WorkflowObjects"  />
            <ics:argument name="id" value='<%= ics.ResolveVariables("objects.id") %>'/>
        </ics:catalogmanager>
        <% if (ics.GetErrno() == 0) { %>
            <tr><td>WorkflowObjects</td><td><%= ics.ResolveVariables("objects.id") %></td><td>delete successfull</td></tr>
        <% } else { %>
            <tr><td>WorkflowObjects</td><td><%= ics.ResolveVariables("objects.id") %></td><td>delete failed with errno:<ics:geterrno/></td></tr>
        <% } %>
    </ics:listloop>
    <% } %>
    </table>
<% } %>

<ics:clearerrno />
<ics:flushcatalog catalog="WorkflowObjects"/>
<ics:sql sql='<%= ics.ResolveVariables("select count(id) as num from WorkflowObjects where cs_status!=\'A\'")%>' table="WorkflowObjects" listname="objects"/>
<ics:clearerrno />
<ics:flushcatalog catalog="Assignment"/>
<ics:sql sql='<%= ics.ResolveVariables("select count(id) as num from Assignment where exists(select 1 from WorkflowObjects where cs_status!=\'A\' and id=Assignment.cs_ownerid)")%>' table="Assignment" listname="assignments"/>
<ics:clearerrno />
<% if (Integer.parseInt(ics.ResolveVariables("objects.num")) > 0 ) { %>
    <a href='ContentServer?pagename=<ics:getvar name="pagename"/>&delete=true&cmd=Workflow/CleanWorkflow&limit=<ics:getvar name="limit" />'>Click here to remove </a><%= ics.ResolveVariables("objects.num")%> WorkflowObjects and <%= ics.ResolveVariables("assignments.num")%> Assignments. A maximum of <ics:getvar name="limit" /> WorkflowObjects will be removed per action.<br/>
<% } else { %>
    <hr/><font color="red">No WorkflowObjects and Assignments to Cleanup.</font><br/>
<% } %>

<ics:clearerrno />
<ics:sql sql='<%= ics.ResolveVariables("select * from WorkflowObjects where cs_status!=\'A\'")%>' table="WorkflowObjects" listname="objects" limit='<%= ics.GetVar("limit") %>'/>
<% if (ics.GetList("objects").hasData()) { %>
    <ics:catalogdef listname="objectdef" table="WorkflowObjects"/>
    <h4>WorkflowObjects</h4>
    <table class="altClass">
        <tr>
        <ics:listloop listname="objectdef">
            <th style="text-transform:none"><ics:listget listname="objectdef" fieldname="COLNAME"/></th>
        </ics:listloop>
        </tr>
        <ics:listloop listname="objects">
            <tr>
             <ics:listloop listname="objectdef">
                <td><ics:listget listname="objects" fieldname='<%= ics.ResolveVariables("objectdef.COLNAME")%>'/></td>
             </ics:listloop>
            </tr>
        </ics:listloop>
    </table>
<% } %>

<ics:clearerrno />
<ics:sql sql='<%= ics.ResolveVariables("select * from Assignment where exists(select 1 from WorkflowObjects where cs_status!=\'A\' and id=Assignment.cs_ownerid)")%>' table="Assignment" listname="assignments" limit='<%= ics.GetVar("limit") %>'/>
<% if (ics.GetList("assignments").hasData()) { %>
    <ics:catalogdef listname="assigndef" table="Assignment"/>
    <h4>Assignment</h4>
    <table class="altClass">
        <tr>
        <ics:listloop listname="assigndef">
            <th style="text-transform:none"><ics:listget listname="assigndef" fieldname="COLNAME"/></th>
        </ics:listloop>
        </tr>
        <ics:listloop listname="assignments">
            <tr>
             <ics:listloop listname="assigndef">
                <td><ics:listget listname="assignments" fieldname='<%= ics.ResolveVariables("assigndef.COLNAME")%>'/></td>
             </ics:listloop>
            </tr>
        </ics:listloop>
    </table>
<% } %>

</cs:ftcs>
