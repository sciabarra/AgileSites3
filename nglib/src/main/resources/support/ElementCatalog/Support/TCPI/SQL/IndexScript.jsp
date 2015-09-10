<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" 
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" 
%><%//
// Support/TCPI/SQL/IndexScript
//
// INPUT
//
// OUTPUT
//%>
<cs:ftcs>

<ics:callelement element="Support/TCPI/SQL/SQLScriptHeader">
	<ics:argument name="scriptname" value="index"/>
</ics:callelement>

<ics:callelement element="Support/TCPI/SQL/AssetIndexes"/>
<ics:callelement element="Support/TCPI/SQL/FlexAssetDefs"/>
<ics:callelement element="Support/TCPI/SQL/FlexAssets"/>
<ics:callelement element="Support/TCPI/SQL/FlexGroupDefs"/>
<ics:callelement element="Support/TCPI/SQL/FlexGroups"/>
<ics:callelement element="Support/TCPI/SQL/TemporaryIndexes"/>

<ics:callelement element="Support/TCPI/SQL/SQLScriptFooter"/>
</cs:ftcs>
