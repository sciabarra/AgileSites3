<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld"
%><%//
// Support/TCPI/PubKeys/UpdateBatch
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
%><%@ page import="com.openmarket.basic.interfaces.*"
%><%@ page import="com.openmarket.xcelerate.interfaces.*"
%><cs:ftcs><%
if (!Utilities.goodString(ics.GetVar("limit"))){
    ics.SetVar("limit","500");
}
boolean delete = "true".equals(ics.GetVar("delete"));
%>
<% if (delete) { %>
    <ics:clearerrno />
    <ics:sql sql="SELECT id,urlkey FROM PubKeyTable WHERE urlkey NOT LIKE('%/%') ORDER BY id" table="PubKeyTable" listname="pubkeys" limit='<%= ics.GetVar("limit") %>' />
    <ics:clearerrno />
    <% ILockManager lockManager = null; %>

    <ics:listloop listname="pubkeys">
        <% try {
            if (lockManager == null) lockManager = LockManagerFactory.make(ics);
            lockManager.enterWriteLock("ApprovedAssets");
            %><ics:clearerrno />
            <!-- id is <ics:listget listname="pubkeys" fieldname="id"/></br>
            urlkey is <ics:listget listname="pubkeys" fieldname="urlkey"/></br>
            @urlkey is <ics:listget listname="pubkeys" fieldname="@urlkey"/></br>
            <ics:geterrno />
            -->
            <% StringBuffer buffy = new StringBuffer(ics.ResolveVariables("pubkeys.id")).insert(3,'/').insert(7,'/').insert(11,'/');  %>
            urlkey_folder is <%= buffy.toString() %></br>
            <!-- check if urlkey is empty -->
            <% if (!ics.ResolveVariables("pubkeys.@urlkey").startsWith("<!--File not found")){ %>
                <ics:catalogmanager >
                    <ics:argument name="ftcmd" value="updaterow" />
                    <ics:argument name="tablename" value="PubKeyTable" />
                    <ics:argument name="id" value='<%= ics.ResolveVariables("pubkeys.id") %>' />
                    <ics:argument name="urlkey_folder" value='<%= buffy.toString() %>' />
                    <ics:argument name="urlkey_file" value='<%= ics.ResolveVariables("pubkeys.urlkey") %>' />
                    <ics:argument name="urlkey" value='<%=ics.ResolveVariables("pubkeys.@urlkey") %>' />
                </ics:catalogmanager>
                <%
                if (ics.GetErrno() == 0) {
                    %><%= ics.ResolveVariables("pubkeys.id") %>: move successfull <br/><%
                } else {
                    %><%= ics.ResolveVariables("pubkeys.id") %>: move failed with errno:<ics:geterrno/><br/><%
                }
            } else {
                    %><%= ics.ResolveVariables("pubkeys.id") %>: move failed because the urlkey was not found on disk<br/>
                        <ics:catalogmanager >
                            <ics:argument name="ftcmd" value="deleterow" />
                            <ics:argument name="tablename" value="PubKeyTable" />
                            <ics:argument name="id" value='<%= ics.ResolveVariables("pubkeys.id") %>' />
                            <ics:argument name="Delete uploaded file(s)" value="yes" />
                        </ics:catalogmanager>
                    <%
            }
        } finally {
            if (lockManager != null) lockManager.leaveWriteLock("ApprovedAssets");
        }
        %>
    </ics:listloop>
<% } %>
<ics:clearerrno />
</cs:ftcs>