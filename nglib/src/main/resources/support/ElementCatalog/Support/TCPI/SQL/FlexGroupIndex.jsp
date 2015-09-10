<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" 
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" 
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" 
%><%--
// Support/TCPI/SQL/FlexGroupIndex
//
// INPUT
//
//
// FlexGroup
_Amap
_Extension (no new indexes)
_Group
_Mungo
_Publish   (no new indexes)
_RMap      (no new indexes)
_Root      (no new indexes)
//
// OUTPUT
//
--%><%@ page import="COM.FutureTense.Interfaces.ICS" 
%><%@ page import="COM.FutureTense.Interfaces.IList" 
%><cs:ftcs>
<%-- **************************** FlexGroup Table **************************** --%>

<ics:callelement element="Support/TCPI/SQL/CreateIndex">
	<ics:argument name="tablename" value='<%= ics.GetVar("FlexGroupName") %>'/>
	<ics:argument name="columns"   value="FLEXGROUPTEMPLATEID,ID"/>
	<ics:argument name="pctfree"   value="0"/>
	<ics:argument name="bitmap"    value="false"/>
</ics:callelement>


<%-- **************************** _Group FlexGroup Tables **************************** --%>

<ics:callelement element="Support/TCPI/SQL/CreateIndex">
	<ics:argument name="tablename" value='<%= ics.GetVar("FlexGroupName") + "_GROUP" %>'/>
	<ics:argument name="columns"   value="PARENTID,PRIMARYCOUNT,CHILDID"/>
	<ics:argument name="pctfree"   value="0"/>
	<ics:argument name="bitmap"    value="false"/>
</ics:callelement>

<ics:callelement element="Support/TCPI/SQL/CreateIndex">
	<ics:argument name="tablename" value='<%= ics.GetVar("FlexGroupName") + "_GROUP" %>'/>
	<ics:argument name="columns"   value="PARENTID,PRIMARYCOUNT,CHILDTYPE,CHILDID"/>
	<ics:argument name="pctfree"   value="0"/>
	<ics:argument name="bitmap"    value="false"/>
</ics:callelement>

<ics:callelement element="Support/TCPI/SQL/CreateIndex">
	<ics:argument name="tablename" value='<%= ics.GetVar("FlexGroupName") + "_GROUP" %>'/>
	<ics:argument name="columns"   value="PARENTID,CHILDID,PRIMARYCOUNT"/>
	<ics:argument name="pctfree"   value="0"/>
	<ics:argument name="bitmap"    value="false"/>
</ics:callelement>

<ics:callelement element="Support/TCPI/SQL/CreateIndex">
	<ics:argument name="tablename" value='<%= ics.GetVar("FlexGroupName") + "_GROUP" %>'/>
	<ics:argument name="columns"   value="CHILDID,PARENTID,ID,REFCOUNT"/>
	<ics:argument name="pctfree"   value="0"/>
	<ics:argument name="bitmap"    value="false"/>
</ics:callelement>


<%-- **************************** _Mungo FlexGroup Tables **************************** --%>

<ics:callelement element="Support/TCPI/SQL/CreateIndex">
	<ics:argument name="tablename" value='<%= ics.GetVar("FlexGroupName") + "_MUNGO" %>'/>
	<ics:argument name="columns"   value="ASSETVALUE"/>
	<ics:argument name="pctfree"   value="0"/>
	<ics:argument name="bitmap"    value="false"/>
</ics:callelement>


<%-- **************************** _AMap FlexGroup Tables **************************** --%>

<ics:callelement element="Support/TCPI/SQL/CreateIndex">
	<ics:argument name="tablename" value='<%= ics.GetVar("FlexGroupName") + "_AMAP" %>'/>
	<ics:argument name="columns"   value="OWNERID, INHERITED,ATTRIBUTEID"/>
	<ics:argument name="pctfree"   value="0"/>
	<ics:argument name="bitmap"    value="false"/>
</ics:callelement>

<ics:callelement element="Support/TCPI/SQL/CreateIndex">
	<ics:argument name="tablename" value='<%= ics.GetVar("FlexGroupName") + "_AMAP" %>'/>
	<ics:argument name="columns"   value="ATTRIBUTEID,INHERITED,OWNERID"/>
	<ics:argument name="pctfree"   value="0"/>
	<ics:argument name="bitmap"    value="false"/>
</ics:callelement>

<ics:callelement element="Support/TCPI/SQL/CreateIndex">
	<ics:argument name="tablename" value='<%= ics.GetVar("FlexGroupName") + "_AMAP" %>'/>
	<ics:argument name="columns"   value="ATTRIBUTEID,INHERITED"/>
	<ics:argument name="pctfree"   value="0"/>
	<ics:argument name="bitmap"    value="false"/>
</ics:callelement>

<ics:callelement element="Support/TCPI/SQL/CreateIndex">
	<ics:argument name="tablename" value='<%= ics.GetVar("FlexGroupName") + "_AMAP" %>'/>
	<ics:argument name="columns"   value="OWNERID,ATTRIBUTEID,INHERITED"/>
	<ics:argument name="pctfree"   value="0"/>
	<ics:argument name="bitmap"    value="false"/>
</ics:callelement>

</cs:ftcs>
