<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" 
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" 
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" 
%><%//
// Support/TCPI/SQL/FlexGroups
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
<ics:sql sql="select upper(assettype) AS assettype from FlexGroupTypes order by assettype" table="FlexGroupTypes" listname="LstFlexGroupTypes"/>
<ics:listloop listname="LstFlexGroupTypes">
	<ics:callelement element="Support/TCPI/SQL/FlexGroupIndex">
		<ics:argument name="FlexGroupName" value='<%= ics.ResolveVariables("LstFlexGroupTypes.assettype") %>'/>
	</ics:callelement>
</ics:listloop>
</cs:ftcs>
