<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" 
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" 
%><%//
// Support/TCPI/AP/AssetsOutsideApproval
//
// INPUT
//
// OUTPUT
//
%><%@ page import="COM.FutureTense.Interfaces.Utilities" 
%><cs:ftcs>
<h3>Assets outside the approval process</h3>
<% if (!Utilities.goodString(ics.GetVar("pubid"))){ %>
<ics:sql sql="SELECT id, t2.name as name FROM Publication t2 ORDER BY t2.name" table="Publication" listname="sites" />
<br/><table class="altClass">
    <tr>
        <th>Sites</th>
    </tr>
	<ics:listloop listname ="sites">
	<tr>
		<td><a href='ContentServer?pagename=<ics:getvar name="pagename"/>&pubid=<ics:listget listname="sites" fieldname="id"/>'><ics:listget listname="sites" fieldname="name"/></a></td>
	</tr>
	</ics:listloop>
</table>
<% } else if (!Utilities.goodString(ics.GetVar("targetid"))){ %>
<ics:sql sql="SELECT id, t2.name as name FROM PubTarget t2 ORDER BY t2.name" table="PubTarget" listname="targets" />
<br/><table>
    <tr>
        <th>Destinations</th>
    </tr>
	<ics:listloop listname ="targets">
	<tr>
		<td><a href='ContentServer?pagename=<ics:getvar name="pagename"/>&pubid=<ics:getvar name="pubid"/>&targetid=<ics:listget listname="targets" fieldname="id"/>'><ics:listget listname="targets" fieldname="name"/></a></td>
	</tr>
	</ics:listloop>
</table>
<% } else if (!Utilities.goodString(ics.GetVar("assettype"))){ %>
<ics:sql sql="SELECT id, t2.name as name FROM PubTarget t2 ORDER BY t2.name" table="PubTarget" listname="targets" />
<ics:sql sql='<%= ics.ResolveVariables("SELECT DISTINCT t1.assettype as assettype FROM AssetPublication t1 WHERE t1.pubid = Variables.pubid ORDER BY t1.assettype") %>' table="AssetPublication" listname="assettypes" />
<ics:sql sql='<%= ics.ResolveVariables("SELECT t2.name as name FROM Publication t2 WHERE id = Variables.pubid") %>' table="Publication" listname="sites" />
<br/><h3>Site: <ics:listget listname="sites" fieldname="name"/></h3>
<br/><table class="altClass">
    <tr>
        <th>assettype</th>
    	<ics:listloop listname ="targets">
             <th><ics:listget listname="targets" fieldname="name"/></th>
    	</ics:listloop>
    </tr>
    <ics:listloop listname ="assettypes">
	<tr>
		<td><ics:listget listname="assettypes" fieldname="assettype"/></td>
        <ics:listloop listname ="targets">
    		<ics:sql sql='<%= ics.ResolveVariables("SELECT count(t1.assetid) as num FROM AssetPublication t1 WHERE t1.assetid NOT IN (SELECT assetid FROM ApprovedAssets WHERE targetid = targets.id AND assettype=\'assettypes.assettype\') AND t1.pubid = Variables.pubid AND assettype=\'assettypes.assettype\'") %>' table="ApprovedAssets" listname="unapproved" />
    		<td><a href='ContentServer?pagename=<ics:getvar name="pagename"/>&targetid=<ics:listget listname="targets" fieldname="id"/>&assettype=<ics:listget listname="assettypes" fieldname="assettype"/>&pubid=<ics:getvar name="pubid"/>'><ics:listget listname="unapproved" fieldname="num"/></a></td>
    	</ics:listloop>
	</tr>
	</ics:listloop>
</table>
<% } else { %>
<ics:sql sql='<%= ics.ResolveVariables("SELECT t2.name as name FROM Publication t2 WHERE id = Variables.pubid") %>' table="Publication" listname="sites" />
<p><b>Site: </b><a href='ContentServer?pagename=<ics:getvar name="pagename"/>'><ics:listget listname="sites" fieldname="name"/></a>&nbsp;&nbsp;&nbsp;
<b>Assettype: </b><a href='ContentServer?pagename=<ics:getvar name="pagename"/>&pubid=<ics:getvar name="pubid"/>'><ics:getvar name="assettype"/></a></p>
<ics:sql sql='<%= ics.ResolveVariables("SELECT name as name FROM PubTarget WHERE id = Variables.targetid") %>' table="PubTarget" listname="targets" />
<br/><h3><ics:listget listname="targets" fieldname="name"/></h3>
<ics:sql sql='<%= ics.ResolveVariables("SELECT t2.name as name, t2.status, t2.updateddate ,t2.createddate, t1.assetid as id FROM AssetPublication t1, Variables.assettype t2 WHERE  t1.assetid = t2.id AND NOT EXISTS (SELECT 1 FROM ApprovedAssets WHERE assetid = t1.assetid AND assettype = \'Variables.assettype\' AND targetid=Variables.targetid) AND t1.pubid = Variables.pubid AND t1.assettype = \'Variables.assettype\' ORDER BY updateddate desc") %>' table="ApprovedAssets" listname="unapproved" />

<br/><table class="altClass">
	<tr>
    	<th>Nr</th>
    	<th>name</th>
    	<th>assetid</th>
    	<th>status</th>
    	<th>createddate</th>
    	<th>updateddate</th>
	</tr>
	<ics:listloop listname ="unapproved">
	<tr>
		<td><ics:listget listname="unapproved" fieldname="#curRow"/></td>
		<td><ics:listget listname="unapproved" fieldname="name"/></td>
		<td><a href='ContentServer?pagename=OpenMarket/Xcelerate/Actions/ContentDetailsFront&AssetType=<ics:getvar name="assettype"/>&id=<ics:listget listname="unapproved" fieldname="id" />'><ics:listget listname="unapproved" fieldname="id"/></a></td>
		<td><ics:listget listname="unapproved" fieldname="status"/></td>
		<td><ics:listget listname="unapproved" fieldname="createddate"/></td>
		<td><ics:listget listname="unapproved" fieldname="updateddate"/></td>
	</tr>
	</ics:listloop>
</table>
<% }  %>
</cs:ftcs>
