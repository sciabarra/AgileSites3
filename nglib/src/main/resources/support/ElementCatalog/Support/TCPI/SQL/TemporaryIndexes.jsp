<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" 
%><%
//
// Support/TCPI/SQL/TemporaryIndexesScript
//
// INPUT
//
// OUTPUT
//
%><cs:ftcs>

<ics:callelement element="Support/TCPI/SQL/CreateTempIndex">
	<ics:argument name="tablename" value="APPROVEDASSETDEPS"/>
	<ics:argument name="columns"   value="ASSETTYPE, TARGETID, ASSETDATE, CURRENTDEP, ASSETDEPTYPE, ASSETID, OWNERID,DEPMODE"/>
	<ics:argument name="pctfree"   value="0"/>
	<ics:argument name="bitmap"    value="false"/>
</ics:callelement>

<ics:callelement element="Support/TCPI/SQL/CreateTempIndex">
	<ics:argument name="tablename" value="APPROVEDASSETDEPS"/>
	<ics:argument name="columns"   value="CURRENTDEP,ASSETDEPTYPE,ASSETDATE,ASSETTYPE,TARGETID"/>
	<ics:argument name="pctfree"   value="0"/>
	<ics:argument name="bitmap"    value="false"/>
</ics:callelement>

</cs:ftcs>
