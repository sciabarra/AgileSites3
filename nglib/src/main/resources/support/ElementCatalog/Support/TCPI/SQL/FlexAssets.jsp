<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" 
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" 
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" 
%><%//
// Support/TCPI/SQL/FlexAssets
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

<ics:sql sql="select upper(assettype) AS assettype from FlexAssetTypes order by assettype" table="FlexAssetTypes" listname="LstFlexAssetTypes"/>
<ics:listloop listname="LstFlexAssetTypes">
	<ics:callelement element="Support/TCPI/SQL/FlexAssetIndexes">
		<ics:argument name="FlexAssetType" value='<%= ics.ResolveVariables("LstFlexAssetTypes.assettype") %>'/>
	</ics:callelement>
</ics:listloop>
</cs:ftcs>
