<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" 
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" 
%><%//
// Support/TCPI/SQL/AssetSQL
//
// INPUT
//
// OUTPUT
//
%><%@ page import="COM.FutureTense.Interfaces.ICS" 
%><%@ page import="COM.FutureTense.Interfaces.Utilities" %>
<cs:ftcs>
<%
boolean bContinue=true;

if (!Utilities.goodString(ics.GetVar("identifier"))){
	bContinue=false;
%>prompt Variable indentifier not found when building this script.<%
}

if (!Utilities.goodString(ics.GetVar("tname"))) {
	ics.SetVar("tname","AssetPublication");
}

if (bContinue) {
%>
	<ics:clearerrno />
	<ics:sql sql='<%= ics.ResolveVariables("SELECT DISTINCT assettype FROM Variables.tname ORDER BY assettype") %>' table='<%= ics.GetVar("tname") %>' listname="assettypes"/>
	<ics:listloop listname="assettypes">
select 'current time is ' || to_char(sysdate,'YYYY-MM-DD HH24:MI:SS') as cur from dual;
timing start del_time
prompt Deleting orphant <ics:listget listname="assettypes" fieldname="assettype"/> assets from <ics:getvar name="tname" />

<%= ics.ResolveVariables("DELETE FROM Variables.tname WHERE assettype=\'assettypes.assettype\' AND NOT EXISTS (SELECT 1 FROM assettypes.assettype  t WHERE t.id=Variables.tname.Variables.identifier);") %>
commit;
timing stop
	</ics:listloop>
<%
}
%>
</cs:ftcs>
