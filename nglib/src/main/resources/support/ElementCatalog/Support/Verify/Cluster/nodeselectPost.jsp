<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// Support/Verify/Cluster/nodeselectPost
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
<%@ page import="java.util.*"%>

<cs:ftcs>
<h3>Cluster nodes Response</h3>
<%
String[] consts = {"type","url","username","password"};
int numOfNodes = Integer.parseInt(ics.GetVar("numofnodes"));
ics.SetSSVar("cluster.numofnodes",numOfNodes);

for (int i=0; i< numOfNodes;i++){
    for (int j=0; j<consts.length;j++){
        String key = "cluster.node." + i + "." + consts[j];
        String value = ics.GetVar(key);
        ics.SetSSVar(key,value);
    }
}
%>
<br/><b>Get SessionVariables</b><br/>
<%
for (int i=0; i< numOfNodes;i++){
    for (int j=0; j<consts.length;j++){
        String key = "cluster.node." + i + "." + consts[j];
        String value = ics.GetSSVar(key);
        %><b><%= key %></b>:<%= value %><br><%
    }
}
%>
<br/><b>Post start.......</b><br/>
<%
for (int i=0; i< numOfNodes;i++){
    String key = "cluster.node." + i + ".url";
    String value = ics.GetSSVar(key);
    %>
    <ics:callelement element="Support/Verify/Cluster/remoteDispatch" >
        <ics:argument name="fp.url" value="<%= value %>"/>
        <ics:argument name="fp.pagename" value="Support/Verify/Cluster/helloVars"/>
        <ics:argument name="fp.username" value="<%= ics.GetSSVar("cluster.node." + i + ".username") %>"/>
        <ics:argument name="fp.password" value="<%= ics.GetSSVar("cluster.node." + i + ".password") %>"/>
    </ics:callelement>
        <b>response:</b><%= ics.GetVar("fp.response") %><%
}
%>
<br/><b>.......Post end</b>
</cs:ftcs>
