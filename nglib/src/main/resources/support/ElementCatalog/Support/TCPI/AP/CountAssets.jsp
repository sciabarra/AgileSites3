<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" 
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" 
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" 
%><%//
// SysAdmin/CountAssets
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
<ics:callelement element="Support/general"/>
<div id="content">
<ics:callelement element="Support/Topnav"/>
<h3>Count Assets per Site</h3>
<ics:clearerrno/>
<ics:sql sql="SELECT count(id) as num FROM Publication" table="Publication" listname="sites"/>
Number of sites: <b><ics:listget listname="sites" fieldname="num"/></b><br/>
<ics:clearerrno/>

<ics:sql sql="SELECT s.name as name, count(ap.assetid) as num FROM Publication s, AssetPublication ap WHERE ap.pubid=s.id GROUP BY s.name ORDER BY name" table="AssetPublication" listname="apc"/>
<table class="altClass">
    <tr>
        <th>site</th>
        <th>Total</th>
    </tr>
    <ics:listloop listname="apc">
    <tr>
        <td><ics:listget listname="apc" fieldname="name"/></td>
        <td><ics:listget listname="apc" fieldname="num"/></td>
    </tr>
    </ics:listloop>
</table>

<ics:clearerrno/>
<ics:sql sql="SELECT s.name as name, ap.assettype as assettype, count(ap.assetid) as num FROM Publication s, AssetPublication ap WHERE ap.pubid=s.id GROUP BY s.name,ap.assettype ORDER BY s.name,ap.assettype" table="AssetPublication" listname="apc"/>
<table class="altClass">
    <tr>
    	<th>Nr</th>
    	<th>site</th>
    	<th>assettype</th>
    	<th>total assetpub for site</th>
    	<th>total assetpub </th>
    	<th>total assets</th>
    </tr>
    <ics:listloop listname="apc">
	<tr>
		<td><ics:listget listname="apc" fieldname="#curRow"/></td>
		<td><ics:listget listname="apc" fieldname="name"/></td>
		<td><ics:listget listname="apc" fieldname="assettype"/></td>
		<td align="right"><ics:listget listname="apc" fieldname="num"/></td>
		<ics:sql sql='<%= ics.ResolveVariables("SELECT count(DISTINCT assetid) as num FROM AssetPublication WHERE assettype=\'apc.assettype\'") %>' table='AssetPublication' listname="apc2"/>
		<td align="right"><ics:listget listname="apc2" fieldname="num"/></td>

		<ics:sql sql='<%= ics.ResolveVariables("SELECT count(id) as num FROM apc.assettype") %>' table='<%= ics.ResolveVariables("apc.assettype") %>' listname="ac"/>
		<td align="right"><ics:listget listname="ac" fieldname="num"/></td>
	</tr>
    </ics:listloop>
</table>
<ics:callelement element="Support/Footer"/>
</div>
</cs:ftcs>
