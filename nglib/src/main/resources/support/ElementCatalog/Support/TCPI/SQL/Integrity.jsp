<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" 
%><%//
// Support/TCPI/SQL/Integrity
//
// INPUT
//
// OUTPUT
//
%><%@ page import="COM.FutureTense.Interfaces.ICS" %><cs:ftcs>
<ics:callelement element="Support/TCPI/SQL/SQLScriptHeader">
	<ics:argument name="scriptname" value="integrity"/>
</ics:callelement>

<ics:callelement element="Support/TCPI/SQL/DelDups">
	<ics:argument name="tablename" value="AssetPublication"/>
	<ics:argument name="keys"      value="assetid;pubid"/>
</ics:callelement>


<ics:callelement element="Support/TCPI/SQL/Flex/Attributes"/>
<ics:callelement element="Support/TCPI/SQL/Flex/FlexGroupDefs"/>
<ics:callelement element="Support/TCPI/SQL/Flex/FlexGroups"/>
<ics:callelement element="Support/TCPI/SQL/Flex/FlexAssetDefs"/>
<ics:callelement element="Support/TCPI/SQL/Flex/FlexAssets"/>

<ics:callelement element="Support/TCPI/SQL/SQLScriptFooter"/>
</cs:ftcs>
