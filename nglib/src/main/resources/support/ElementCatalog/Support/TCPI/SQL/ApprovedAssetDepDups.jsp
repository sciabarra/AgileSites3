<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%//
// Support/TCPI/SQL/ApprovedAssetDepDups
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
%><%@ page import="COM.FutureTense.Util.ftMessage"
%><cs:ftcs>
<ics:callelement element="Support/TCPI/SQL/SQLScriptHeader">
    <ics:argument name="scriptname" value="ApprovedAssetDepDups"/>
</ics:callelement>

<ics:sql sql="SELECT DISTINCT targetid FROM ApprovedAssetDeps" table="ApprovedAssetDeps" listname="targets" limit="-1"/>
<ics:listloop listname="targets">
  <ics:callelement element="Support/TCPI/SQL/LastPubFix">
      <ics:argument name="targetid"  value='<%= ics.ResolveVariables("targets.targetid") %>' />
  </ics:callelement>
</ics:listloop>
<ics:callelement element="Support/TCPI/SQL/SQLScriptFooter"/>
</cs:ftcs>