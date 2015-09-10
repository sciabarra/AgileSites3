<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" 
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" 
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" 
%><%//
// SysAdmin/PubQueues
//
// INPUT
//
// OUTPUT
//
%><%@ page import="COM.FutureTense.Interfaces.ICS" 
%><%!
static String sqlT="SELECT count(id) as num FROM ApprovedAssets WHERE assettype='assettypes.assettype' AND targetid=targets.id";
static String sqlTA="SELECT count(id) as num FROM ApprovedAssets WHERE assettype='assettypes.assettype'";
static String sqlTT="SELECT count(id) as num FROM ApprovedAssets WHERE targetid=targets.id";
static String sqlTTA="SELECT count(id) as num FROM ApprovedAssets";
%>
<cs:ftcs>
<a href="ContentServer?pagename=Support/TCPI/AP/PubQueues&detail=true">Click here for more detail<a/><br/>

<ics:sql sql="SELECT id,name FROM PubTarget ORDER BY name" table="PubTarget" listname="targets" />
<ics:sql sql="SELECT assettype FROM AssetType ORDER BY assettype" table="AssetType" listname="assettypes" />

<table class="altClass">
<tr>
	<th>Nr</th>
	<th>Assettype</th>
	<ics:listloop listname="targets">
		<th><ics:listget listname="targets" fieldname="name"/></th>
	</ics:listloop>
	<th>Total</th>
</tr>
<ics:listloop listname="assettypes">
<tr>
	<td><ics:listget listname="assettypes" fieldname="#curRow"/></td>
  <ics:listget listname="assettypes" fieldname="assettype" output="tblname"/>
	<td><a href='<%= "ContentServer?pagename=Support/Audit/Default/BodyCheck&tblname="+ics.ResolveVariables("Variables.tblname")%>'><%= ics.GetVar("tblname")%></a></td>
	<ics:listloop listname="targets">
		<ics:sql sql='<%= ics.ResolveVariables(sqlT) %>' table="ApprovedAssets" listname="aa"/>
		<td><ics:listget listname="aa" fieldname="num"/></td>
	</ics:listloop>
	
	<ics:sql sql='<%= ics.ResolveVariables(sqlTA) %>' table="ApprovedAssets" listname="aa"/>
	<td><ics:listget listname="aa" fieldname="num"/></td>
</tr>
</ics:listloop>
<tr>
<td>&nbsp;</td>
<td>Total</td>
	<ics:listloop listname="targets">
		<ics:sql sql='<%= ics.ResolveVariables(sqlTT) %>' table="ApprovedAssets" listname="aa"/>
		<td><ics:listget listname="aa" fieldname="num"/></td>
	</ics:listloop>
  <ics:sql sql='<%= ics.ResolveVariables(sqlTTA) %>' table="ApprovedAssets" listname="aa"/>
	<td><ics:listget listname="aa" fieldname="num"/></td>
</tr>
</table>	
</cs:ftcs>
