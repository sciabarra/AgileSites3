<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" 
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" 
%><%//
// Support/TCPI/SQL/FlexAssetIndexes
//
// INPUT
//
// OUTPUT
//
%><%@ page import="COM.FutureTense.Interfaces.ICS,COM.FutureTense.Interfaces.IList" %>
<cs:ftcs>
<%-- **************************** FlexAsset_AMap Table **************************** --%>
<ics:callelement element="Support/TCPI/SQL/CreateIndex">
	<ics:argument name="tablename" value='<%= ics.GetVar("FlexAssetType") + "_AMAP" %>'/>
	<ics:argument name="columns"   value="OWNERID,INHERITED,ATTRIBUTEID"/>
	<ics:argument name="pctfree"   value="0"/>
	<ics:argument name="bitmap"    value="false"/>
</ics:callelement>

<ics:callelement element="Support/TCPI/SQL/CreateIndex">
	<ics:argument name="tablename" value='<%= ics.GetVar("FlexAssetType") + "_AMAP" %>'/>
	<ics:argument name="columns"   value="ATTRIBUTEID,INHERITED,OWNERID"/>
	<ics:argument name="pctfree"   value="0"/>
	<ics:argument name="bitmap"    value="false"/>
</ics:callelement>

<ics:callelement element="Support/TCPI/SQL/CreateIndex">
	<ics:argument name="tablename" value='<%= ics.GetVar("FlexAssetType") + "_AMAP" %>'/>
	<ics:argument name="columns"   value="ATTRIBUTEID,INHERITED"/>
	<ics:argument name="pctfree"   value="0"/>
	<ics:argument name="bitmap"    value="false"/>
</ics:callelement>

<ics:callelement element="Support/TCPI/SQL/CreateIndex">
	<ics:argument name="tablename" value='<%= ics.GetVar("FlexAssetType") + "_AMAP" %>'/>
	<ics:argument name="columns"   value="OWNERID,ATTRIBUTEID,INHERITED"/>
	<ics:argument name="pctfree"   value="0"/>
	<ics:argument name="bitmap"    value="false"/>
</ics:callelement>

<%-- **************************** FlexAsset_Mungo Table **************************** --%>

<ics:callelement element="Support/TCPI/SQL/CreateIndex">
	<ics:argument name="tablename" value='<%= ics.GetVar("FlexAssetType") + "_MUNGO" %>'/>
	<ics:argument name="columns"   value="ASSETVALUE"/>
	<ics:argument name="pctfree"   value="0"/>
	<ics:argument name="bitmap"    value="false"/>
</ics:callelement>

</cs:ftcs>
