<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// Support/Verify/Cluster/nodeselect
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
<%
   int numOfNodes;
   if (ics.GetVar("numofnodes")!=null) {
      numOfNodes=Integer.parseInt(ics.GetVar("numofnodes"));
   } else {
       numOfNodes=4;
   }
%>
<satellite:form satellite="false" method="POST">
<input type="hidden" name="pagename" value="Support/Verify/Cluster/nodeselectPost"/>
<input type="hidden" name="numofnodes" value="<%= numOfNodes %>"/>

<table class="altClass" style="width:50%">
<% for (int i=0; i<numOfNodes; i++){ %>
    <tr><td colspan="2">
    <ics:callelement element="Support/Verify/Cluster/clusternodeEdit" >
        <ics:argument name="node" value="<%= Integer.toString(i) %>"/>
    </ics:callelement>
    </td></tr>
<% } %>
<tr>
  <td><input type="submit" value="Sumit" name="Submit">
  &nbsp;<input type="reset" value="Reset" name="Reset"></td>
  <td>&nbsp;</td>
</tr>
</table>
</satellite:form>
</cs:ftcs>
