<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" 
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" 
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" 
%><%//
// Support/TCPI/SQL/FlexGroupDefs
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

<ics:sql sql="select upper(assettype) AS assettype from FlexGrpTmplTypes order by assettype" table="FlexGrpTmplTypes" listname="LstFlexGrpTmplTypes"/>
<ics:listloop listname="LstFlexGrpTmplTypes">
	<ics:callelement element="Support/TCPI/SQL/FlexDefIndexes">
		<ics:argument name="FlexDef" value='<%= ics.ResolveVariables("LstFlexGrpTmplTypes.assettype") %>'/>
	</ics:callelement>
</ics:listloop>
</cs:ftcs>
