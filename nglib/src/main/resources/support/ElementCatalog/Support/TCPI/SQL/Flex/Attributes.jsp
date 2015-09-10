<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" 
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" 
%><%//
// Support/TCPI/SQL/Flex/Attributes
//
// INPUT
//
// OUTPUT
//
%><%@ page import="COM.FutureTense.Interfaces.ICS" %>
<cs:ftcs>

<ics:sql sql="select distinct assetattr from FlexAssetTypes order by assetattr" table="FlexAssetTypes" listname="attrPools"/>

<ics:listloop listname="attrPools">

<ics:callelement element="Support/TCPI/SQL/DeleteOrphans">
	<ics:argument name="firsttable"  value='<%= ics.ResolveVariables("attrPools.assetattr_Args") %>'/>
	<ics:argument name="secondtable" value='<%= ics.ResolveVariables("attrPools.assetattr") %>'/>
	<ics:argument name="column1"     value="attributeid"/>
	<ics:argument name="column2"     value="id"/>
</ics:callelement>

<ics:callelement element="Support/TCPI/SQL/DeleteOrphans">
	<ics:argument name="firsttable"  value='<%= ics.ResolveVariables("attrPools.assetattr_Extension") %>'/>
	<ics:argument name="secondtable" value='<%= ics.ResolveVariables("attrPools.assetattr") %>'/>
	<ics:argument name="column1"     value="ownerid"/>
	<ics:argument name="column2"     value="id"/>
</ics:callelement>

</ics:listloop>

</cs:ftcs>
