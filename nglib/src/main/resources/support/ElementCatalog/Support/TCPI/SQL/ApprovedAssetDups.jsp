<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" 
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" 
%><%//
// Support/TCPI/SQL/ApprovedAssetDups
//
// INPUT
//
// OUTPUT
//%>
<cs:ftcs>
<ics:callelement element="Support/TCPI/SQL/SQLScriptHeader">
	<ics:argument name="scriptname" value="ApprovedAssetDups"/>
</ics:callelement>


<ics:sql sql="SELECT DISTINCT assettype, targetid FROM ApprovedAssetDeps WHERE assetdate IS NULL AND currentdep='T' AND assetdeptype='E'" table="ApprovedAssetDeps" listname="targets" limit="-1"/>
<ics:listloop listname="targets">
  <ics:callelement element="Support/TCPI/SQL/DelDupsEqual2">
	  <ics:argument name="tablename" value="ApprovedAssetDeps"/>
	  <ics:argument name="keys"      value="depmode;assetid;ownerid"/>
	  <ics:argument name="equality"  value='<%= ics.ResolveVariables("assettype=\'targets.assettype\';targetid=targets.targetid;assetdate IS NULL;currentdep=\'T\';assetdeptype=\'E\'") %>'/>
  </ics:callelement>
</ics:listloop>

<ics:sql sql="SELECT DISTINCT targetid FROM ApprovedAssetDeps" table="ApprovedAssetDeps" listname="targets" limit="-1"/>
<ics:listloop listname="targets">
  <ics:callelement element="Support/TCPI/SQL/LastPubFix">
	  <ics:argument name="targetid"  value='<%= ics.ResolveVariables("targets.targetid") %>' />
  </ics:callelement>
</ics:listloop>
 
<ics:callelement element="Support/TCPI/SQL/SQLScriptFooter"/>
</cs:ftcs>
