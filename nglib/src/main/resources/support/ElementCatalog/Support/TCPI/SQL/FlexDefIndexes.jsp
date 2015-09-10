<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" 
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" 
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" 
%><%//
// Support/TCPI/SQL/FlexDefIndexes
//
// INPUT
//
// OUTPUT
//
%><%@ page import="COM.FutureTense.Interfaces.ICS,COM.FutureTense.Interfaces.IList" %>

<cs:ftcs>
<%-- **************************** Flex(Group or Asset)Def_TGroup Table **************************** --%>

<ics:callelement element="Support/TCPI/SQL/CreateIndex">
	<ics:argument name="tablename" value='<%= ics.GetVar("FlexDef") + "_TGROUP" %>'/>
	<ics:argument name="columns"   value="OWNERID,PRODUCTGROUPTEMPLATEID,REQUIREDFLAG,MULTIPLEFLAG"/>
	<ics:argument name="pctfree"   value="0"/>
	<ics:argument name="bitmap"    value="false"/>
</ics:callelement>

<%-- **************************** Flex(Group or Asset)Def_TATTR Table **************************** --%>

<ics:callelement element="Support/TCPI/SQL/CreateIndex">
	<ics:argument name="tablename" value='<%= ics.GetVar("FlexDef") + "_TATTR" %>'/>
	<ics:argument name="columns"   value="OWNERID,ATTRIBUTEID,ORDINAL,REQUIREDFLAG"/>
	<ics:argument name="pctfree"   value="0"/>
	<ics:argument name="bitmap"    value="false"/>
</ics:callelement>

</cs:ftcs>
