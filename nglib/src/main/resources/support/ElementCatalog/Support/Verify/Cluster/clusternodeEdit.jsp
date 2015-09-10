<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// Support/Verify/Cluster/clusternodeEdit 
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
<% int nodeNr = Integer.parseInt(ics.GetVar("node")); %>
<table>
<tr>
  <td colspan="2">Cluster node: <%=nodeNr %></td>
</tr>
<tr>
  <td style="text-align:right">type: </td><td><select size="1" name="cluster.node.<%=nodeNr %>.type">
  <option selected value="cm">ContentManagement</option>
  <option value="cd">ContentDelivery</option>
  </select>
  </td>
</tr>
<tr>
  <td style="text-align:right">url: </td>
  <td><input type="text" name="cluster.node.<%=nodeNr %>.url" size="32" value="http://localhost:7001/servlet/"></td>
</tr>
  <td style="text-align:right">username: </td>
  <td><input type="text" name="cluster.node.<%=nodeNr %>.username" size="32" value="jumpstart"></td>
<tr>
  <td style="text-align:right">password: </td>
  <td><input type="password" name="cluster.node.<%=nodeNr %>.password" size="32" value="jumpstart"></td>
</tr>
</table>
</cs:ftcs>
