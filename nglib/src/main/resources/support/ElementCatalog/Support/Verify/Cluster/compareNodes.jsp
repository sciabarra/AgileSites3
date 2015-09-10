<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %><%//
// Support/Verify/Cluster/compareNodes
//
// INPUT
// cmd = tablelist, table (with tblname), prop (with propfile)
//
// OUTPUT
//%><%@ page import="java.util.*"%>
<cs:ftcs>
<%
try {
    String num = ics.GetSSVar("cluster.numofnodes");
    int numOfNodes = Integer.parseInt(num);

    String[] responses = new String[numOfNodes];
    String remotePage = "Support/Verify/xml/tablelist";
    String cmd = ics.GetVar("cmd");
    if ("table".equals(cmd)){

    } else if("prop".equals(cmd)){

    }

    for (int i=0; i< numOfNodes;i++){
        String key = "cluster.node." + i + ".url";
        String value = ics.GetSSVar(key);
        %><ics:callelement element="Support/Verify/Cluster/remoteDispatch" >
            <ics:argument name="fp.url" value="<%= value %>"/>
            <ics:argument name="fp.pagename" value="<%= remotePage %>"/>
            <ics:argument name="fp.username" value="<%= ics.GetSSVar("cluster.node." + i + ".username") %>"/>
            <ics:argument name="fp.password" value="<%= ics.GetSSVar("cluster.node." + i + ".password") %>"/>
        </ics:callelement><% responses[i] = ics.GetVar("fp.response");
    }
    for (int i=0; i< numOfNodes; i++){
        for (int j=i+1; j< numOfNodes; j++){
            if(i!=j) {
                out.write("(" +i+ "," + j + ")" + responses[i].equals(responses[j]));
            }
        }
    }
} catch (Exception e) {
    out.write(e.getMessage());
}
%>
</cs:ftcs>
