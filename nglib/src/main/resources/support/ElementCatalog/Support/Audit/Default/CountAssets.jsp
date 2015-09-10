<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" 
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" 
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" 
%><%//
// Support/Audit/Default/CountAssets
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
<h3><center>Count Assets per Site</center></h3>

<center>
<ics:clearerrno/>
<ics:sql sql="SELECT count(id) as num FROM Publication" table="Publication" listname="sites"/>
Total Number of Sites: <b><ics:listget listname="sites" fieldname="num"/></b><br/>
<ics:clearerrno/>

<ics:sql sql="SELECT s.name as name, count(ap.assetid) as num FROM Publication s, AssetPublication ap WHERE ap.pubid=s.id GROUP BY s.name ORDER BY name" table="AssetPublication" listname="apc"/>
<table class="altClass" style="width:50%">
    <tr>
        <th>Site</th>
        <th>Total</th>
    </tr>
    <ics:listloop listname="apc">
    <tr>
        <td><ics:listget listname="apc" fieldname="name"/></td>
        <td><ics:listget listname="apc" fieldname="num"/></td>
    </tr>
    </ics:listloop>
</table>
</center>
<br/><br/>
<ics:clearerrno/>
<table class="altClass">
    <tr>
    	<th>Nr</th>
        <th>AssetType</th>
    	<th>Total Assetpub for Site</th>
    	<th>Total Assetpub </th>
    	<th>Total Assets</th>
    </tr>
    <ics:listloop listname="apc">
        <tr><td colspan="5"><b>Site: <font color="blue"><ics:listget listname="apc" fieldname="name"/></font></b></td></tr>
        <ics:sql sql='<%=ics.ResolveVariables("select ap.assettype as assettype, count(ap.assetid) as num from publication s, assetpublication ap where ap.pubid=s.id and s.name=\'apc.name\' group by ap.assettype order by ap.assettype")%>' table="AssetPublication" listname="apc1"/>
        <ics:listloop listname="apc1">
    	<tr>
    		<td><ics:listget listname="apc1" fieldname="#curRow"/></td>            
    		<td><ics:listget listname="apc1" fieldname="assettype"/></td>
    		<td><ics:listget listname="apc1" fieldname="num"/></td>
    		<ics:sql sql='<%= ics.ResolveVariables("SELECT count(DISTINCT assetid) as num FROM AssetPublication WHERE assettype=\'apc1.assettype\'") %>' table='AssetPublication' listname="apc2"/>
    		<td><ics:listget listname="apc2" fieldname="num"/></td>
    		<ics:sql sql='<%= ics.ResolveVariables("SELECT count(id) as num FROM apc1.assettype") %>' table='<%= ics.ResolveVariables("apc1.assettype") %>' listname="apc3"/>
    		<td><ics:listget listname="apc3" fieldname="num"/></td>
    	</tr>
        </ics:listloop>
    </ics:listloop>
</table>
</cs:ftcs>
