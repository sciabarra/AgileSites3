<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" 
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %><%
//
// Support/TCPI/SQL/AssetIndexes
//
// INPUT
//
// OUTPUT
//
%><cs:ftcs>
<%-- **************************** AssetPublication Table **************************** --%>


<ics:callelement element="Support/TCPI/SQL/CreateIndex">
	<ics:argument name="tablename" value="ASSETPUBLICATION"/>
	<ics:argument name="columns"   value="PUBID,ASSETID"/>
	<ics:argument name="pctfree"   value="0"/>
	<ics:argument name="bitmap"    value="false"/>
</ics:callelement>

<ics:callelement element="Support/TCPI/SQL/CreateIndex">
	<ics:argument name="tablename" value="ASSETPUBLICATION"/>
	<ics:argument name="columns"   value="PUBID, ASSETTYPE, ASSETID"/>
	<ics:argument name="pctfree"   value="10"/>
	<ics:argument name="bitmap"    value="false"/>
</ics:callelement>

<ics:callelement element="Support/TCPI/SQL/CreateIndex">
	<ics:argument name="tablename" value="ASSETPUBLICATION"/>
	<ics:argument name="columns"   value="ASSETTYPE,PUBID,ASSETID"/>
	<ics:argument name="pctfree"   value="10"/>
	<ics:argument name="bitmap"    value="false"/>
</ics:callelement>

<ics:callelement element="Support/TCPI/SQL/CreateIndex">
	<ics:argument name="tablename" value="ASSETPUBLICATION"/>
	<ics:argument name="columns"   value="ASSETID"/>
	<ics:argument name="pctfree"   value="0"/>
	<ics:argument name="bitmap"    value="false"/>
</ics:callelement>


<%-- **************************** Approval Tables **************************** --%>

<ics:callelement element="Support/TCPI/SQL/CreateIndex">
	<ics:argument name="tablename" value="APPROVEDASSETDEPS"/>
	<ics:argument name="columns"   value="ASSETTYPE"/>
	<ics:argument name="pctfree"   value="10"/>
	<ics:argument name="bitmap"    value="true"/>
</ics:callelement>

<ics:callelement element="Support/TCPI/SQL/CreateIndex">
	<ics:argument name="tablename" value="APPROVEDASSETDEPS"/>
	<ics:argument name="columns"   value="TARGETID,ASSETID,LASTPUB"/>
	<ics:argument name="pctfree"   value="0"/>
	<ics:argument name="bitmap"    value="false"/>
</ics:callelement>

<ics:callelement element="Support/TCPI/SQL/CreateIndex">
	<ics:argument name="tablename" value="APPROVEDASSETS"/>
	<ics:argument name="columns"   value="TARGETID,ASSETTYPE,ID"/>
	<ics:argument name="pctfree"   value="0"/>
	<ics:argument name="bitmap"    value="false"/>
</ics:callelement>

<ics:callelement element="Support/TCPI/SQL/CreateIndex">
	<ics:argument name="tablename" value="APPROVEDASSETS"/>
	<ics:argument name="columns"   value="TARGETID,STATE,LOCKED,ASSETID,ASSETDATE"/>
	<ics:argument name="pctfree"   value="0"/>
	<ics:argument name="bitmap"    value="false"/>
</ics:callelement>

<ics:callelement element="Support/TCPI/SQL/CreateIndex">
	<ics:argument name="tablename" value="APPROVEDASSETS"/>
	<ics:argument name="columns"   value="TARGETID,STATE,LOCKED,ASSETID,ASSETDATE"/>
	<ics:argument name="pctfree"   value="0"/>
	<ics:argument name="bitmap"    value="false"/>
</ics:callelement>


<ics:callelement element="Support/TCPI/SQL/CreateIndex">
	<ics:argument name="tablename" value="APPROVEDASSETS"/>
	<ics:argument name="columns"   value="TARGETID,TSTATE,LOCKED,ASSETID"/>
	<ics:argument name="pctfree"   value="0"/>
	<ics:argument name="bitmap"    value="false"/>
</ics:callelement>

<%-- **************************** Publish Tables **************************** --%>

<ics:callelement element="Support/TCPI/SQL/CreateIndex">
	<ics:argument name="tablename" value="PUBKEYTABLE"/>
	<ics:argument name="columns"   value="TARGETID,ID,URLKEY"/>
	<ics:argument name="pctfree"   value="0"/>
	<ics:argument name="bitmap"    value="false"/>
</ics:callelement>


<ics:callelement element="Support/TCPI/SQL/CreateIndex">
	<ics:argument name="tablename" value="PUBKEYTABLE"/>
	<ics:argument name="columns"   value="TARGETID,ASSETID,URLKEY"/>
	<ics:argument name="pctfree"   value="0"/>
	<ics:argument name="bitmap"    value="false"/>
</ics:callelement>

<ics:callelement element="Support/TCPI/SQL/CreateIndex">
	<ics:argument name="tablename" value="PUBLISHEDASSETS"/>
	<ics:argument name="columns"   value="ASSETTYPE"/>
	<ics:argument name="pctfree"   value="0"/>
	<ics:argument name="bitmap"    value="false"/>
</ics:callelement>

<ics:callelement element="Support/TCPI/SQL/CreateIndex">
	<ics:argument name="tablename" value="PUBSESSION"/>
	<ics:argument name="columns"   value="STATUS"/>
	<ics:argument name="pctfree"   value="0"/>
	<ics:argument name="bitmap"    value="false"/>
</ics:callelement>

<ics:callelement element="Support/TCPI/SQL/CreateIndex">
	<ics:argument name="tablename" value="PUBSESSION"/>
	<ics:argument name="columns"   value="CONTEXT"/>
	<ics:argument name="pctfree"   value="0"/>
	<ics:argument name="bitmap"    value="false"/>
</ics:callelement>

</cs:ftcs>
