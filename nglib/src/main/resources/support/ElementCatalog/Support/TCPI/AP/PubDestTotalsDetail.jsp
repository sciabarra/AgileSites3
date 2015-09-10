<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" 
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" 
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" 
%><%//
// Support/TCPI/AP/PubDestTotalDetail
//
// INPUT
//
// OUTPUT
//
%><%@ page import="COM.FutureTense.Interfaces.ICS" 
%><%!
static String sqlA="SELECT count(id) as num FROM ApprovedAssets WHERE assettype='assettypes.assettype' AND targetid=targets.id AND tstate='A'";
static String sqlH="SELECT count(id) as num FROM ApprovedAssets WHERE assettype='assettypes.assettype' AND targetid=targets.id AND tstate='H'";
static String sqlC="SELECT count(id) as num FROM ApprovedAssets WHERE assettype='assettypes.assettype' AND targetid=targets.id AND tstate='C'";
static String sqlT="SELECT count(id) as num FROM ApprovedAssets WHERE assettype='assettypes.assettype' AND targetid=targets.id";

static String sqlAA="SELECT count(id) as num FROM ApprovedAssets WHERE assettype='assettypes.assettype' AND tstate='A'";
static String sqlHA="SELECT count(id) as num FROM ApprovedAssets WHERE assettype='assettypes.assettype' AND tstate='H'";
static String sqlCA="SELECT count(id) as num FROM ApprovedAssets WHERE assettype='assettypes.assettype' AND tstate='C'";
static String sqlTA="SELECT count(id) as num FROM ApprovedAssets WHERE assettype='assettypes.assettype'";

static String sqlAT="SELECT count(id) as num FROM ApprovedAssets WHERE targetid=targets.id AND tstate='A'";
static String sqlHT="SELECT count(id) as num FROM ApprovedAssets WHERE targetid=targets.id AND tstate='H'";
static String sqlCT="SELECT count(id) as num FROM ApprovedAssets WHERE targetid=targets.id AND tstate='C'";
static String sqlTT="SELECT count(id) as num FROM ApprovedAssets WHERE targetid=targets.id";

static String sqlATA="SELECT count(id) as num FROM ApprovedAssets WHERE tstate='A'";
static String sqlHTA="SELECT count(id) as num FROM ApprovedAssets WHERE tstate='H'";
static String sqlCTA="SELECT count(id) as num FROM ApprovedAssets WHERE tstate='C'";
static String sqlTTA="SELECT count(id) as num FROM ApprovedAssets";
%>
<cs:ftcs>

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
	<td><ics:listget listname="assettypes" fieldname="assettype"/></td>
	<ics:listloop listname="targets">
		<td>
			<table cellspacing="1px" bgcolor="#CCFF99" width="100%">
			<tr>
				<td width="25%" style="text-align=right">A</td>
				<td width="25%" style="text-align=right">H</td>
				<td width="25%" style="text-align=right">C</td>
				<td width="25%" style="text-align=right">T</td>
			</tr>
			<tr>
				<ics:sql sql='<%= ics.ResolveVariables(sqlA) %>' table="ApprovedAssets" listname="aa"/>
				<td style="text-align=right"><ics:listget listname="aa" fieldname="num"/></td>

				<ics:sql sql='<%= ics.ResolveVariables(sqlH) %>' table="ApprovedAssets" listname="aa"/>
				<td style="text-align=right"><ics:listget listname="aa" fieldname="num"/></td>

				<ics:sql sql='<%= ics.ResolveVariables(sqlC) %>' table="ApprovedAssets" listname="aa"/>
				<td style="text-align=right"><ics:listget listname="aa" fieldname="num"/></td>

				<ics:sql sql='<%= ics.ResolveVariables(sqlT) %>' table="ApprovedAssets" listname="aa"/>
				<td style="text-align=right"><ics:listget listname="aa" fieldname="num"/></td>
			</tr>
			</table>
		</td>
	</ics:listloop>
	<td>
		<table cellspacing="1px" bgcolor="#CCFF00" width="100%">
		<tr>
			<td width="25%" style="text-align=right">A</td>
			<td width="25%" style="text-align=right">H</td>
			<td width="25%" style="text-align=right">C</td>
			<td width="25%" style="text-align=right">T</td>
		</tr>
		<tr>
			<ics:sql sql='<%= ics.ResolveVariables(sqlAA) %>' table="ApprovedAssets" listname="aa"/>
			<td style="text-align=right"><ics:listget listname="aa" fieldname="num"/></td>

			<ics:sql sql='<%= ics.ResolveVariables(sqlHA) %>' table="ApprovedAssets" listname="aa"/>
			<td style="text-align=right"><ics:listget listname="aa" fieldname="num"/></td>

			<ics:sql sql='<%= ics.ResolveVariables(sqlCA) %>' table="ApprovedAssets" listname="aa"/>
			<td style="text-align=right"><ics:listget listname="aa" fieldname="num"/></td>

			<ics:sql sql='<%= ics.ResolveVariables(sqlTA) %>' table="ApprovedAssets" listname="aa"/>
			<td style="text-align=right"><ics:listget listname="aa" fieldname="num"/></td>
		</tr>
		</table>
	</td>
</tr>
</ics:listloop>

<tr>
<td>&nbsp;</td>
<td>Total</td>
	<ics:listloop listname="targets">
	<td>
		<table cellspacing="1px" bgcolor="#CCFF00" width="100%">
		<tr>
			<td width="25%" style="text-align=right">A</td>
			<td width="25%" style="text-align=right">H</td>
			<td width="25%" style="text-align=right">C</td>
			<td width="25%" style="text-align=right">T</td>
		</tr>
		<tr>
			<ics:sql sql='<%= ics.ResolveVariables(sqlAT) %>' table="ApprovedAssets" listname="aa"/>
			<td style="text-align=right"><ics:listget listname="aa" fieldname="num"/></td>

			<ics:sql sql='<%= ics.ResolveVariables(sqlHT) %>' table="ApprovedAssets" listname="aa"/>
			<td style="text-align=right"><ics:listget listname="aa" fieldname="num"/></td>

			<ics:sql sql='<%= ics.ResolveVariables(sqlCT) %>' table="ApprovedAssets" listname="aa"/>
			<td style="text-align=right"><ics:listget listname="aa" fieldname="num"/></td>

			<ics:sql sql='<%= ics.ResolveVariables(sqlTT) %>' table="ApprovedAssets" listname="aa"/>
			<td style="text-align=right"><ics:listget listname="aa" fieldname="num"/></td>
		</tr>
		</table>
	</td>
	</ics:listloop>
	<td>
		<table cellspacing="1px" bgcolor="#CCFF99" width="100%">
		<tr>
			<td width="25%" style="text-align=right">A</td>
			<td width="25%" style="text-align=right">H</td>
			<td width="25%" style="text-align=right">C</td>
			<td width="25%" style="text-align=right">T</td>
		</tr>
		<tr>
			<ics:sql sql='<%= ics.ResolveVariables(sqlATA) %>' table="ApprovedAssets" listname="aa"/>
			<td style="text-align=right"><ics:listget listname="aa" fieldname="num"/></td>

			<ics:sql sql='<%= ics.ResolveVariables(sqlHTA) %>' table="ApprovedAssets" listname="aa"/>
			<td style="text-align=right"><ics:listget listname="aa" fieldname="num"/></td>

			<ics:sql sql='<%= ics.ResolveVariables(sqlCTA) %>' table="ApprovedAssets" listname="aa"/>
			<td style="text-align=right"><ics:listget listname="aa" fieldname="num"/></td>

			<ics:sql sql='<%= ics.ResolveVariables(sqlTTA) %>' table="ApprovedAssets" listname="aa"/>
			<td style="text-align=right"><ics:listget listname="aa" fieldname="num"/></td>
		</tr>
		</table>
	</td>
</tr>
</table>	
</cs:ftcs>
