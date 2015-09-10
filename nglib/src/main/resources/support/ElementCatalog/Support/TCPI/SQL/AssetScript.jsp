<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" 
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" 
%><%//
// Support/TCPI/SQL/AssetScript
//
// INPUT
//
// OUTPUT
//
%><%@ page import="COM.FutureTense.Interfaces.ICS" 
%><%@ page import="COM.FutureTense.Interfaces.Utilities" %>
<cs:ftcs>
<ics:callelement element="Support/TCPI/SQL/SQLScriptHeader">
<ics:argument name="scriptname" value="missing-assets"/>
</ics:callelement>
<%
String[] tables={"AssetPublication","ApprovedAssetDeps","ApprovedAssets","AssetExportData","AssetPublishList","PublishedAssets","ActiveList","CheckOutInfo"};
for (int i=0; i< tables.length;i++){
	%>
	<ics:callelement element="Support/TCPI/SQL/AssetSQL">
		<ics:argument name="tname"      value='<%= tables[i] %>' />
		<ics:argument name="identifier" value="assetid"/>
	</ics:callelement>
	<%
}
%>
<ics:callelement element="Support/TCPI/SQL/SQLScriptFooter"/>
</cs:ftcs>
