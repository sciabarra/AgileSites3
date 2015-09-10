<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" 
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" 
%><%//
// Support/TCPI/SQL/Flex/FlexAssets
//
// INPUT
//
// OUTPUT
//
%><%@ page import="COM.FutureTense.Interfaces.ICS" %>
<cs:ftcs>

<ics:sql sql="select assettype,assetattr,assetgroup from FlexAssetTypes order by assettype " table="FlexAssetTypes" listname="LstflexAssetTypes"/>

<ics:listloop listname="LstflexAssetTypes">

		  <ics:callelement element="Support/TCPI/SQL/DeleteOrphans">
			  <ics:argument name="firsttable"  value='<%= ics.ResolveVariables("LstflexAssetTypes.assettype_AMap") %>'/>
			  <ics:argument name="secondtable" value='<%= ics.ResolveVariables("LstflexAssetTypes.assettype") %>'/>
			  <ics:argument name="column1"     value="ownerid"/>
			  <ics:argument name="column2"     value="id"/>
		  </ics:callelement>

		  <ics:callelement element="Support/TCPI/SQL/DeleteOrphansEqual">
			  <ics:argument name="firsttable"  value='<%= ics.ResolveVariables("LstflexAssetTypes.assettype_AMap") %>'/>
			  <ics:argument name="secondtable" value='<%= ics.ResolveVariables("LstflexAssetTypes.assetgroup") %>'/>
			  <ics:argument name="column1"     value="inherited"/>
			  <ics:argument name="column2"     value="id"/>
			  <ics:argument name="equal"       value="inherited IS NOT NULL"/>
		  </ics:callelement>

		  <ics:callelement element="Support/TCPI/SQL/DeleteOrphans">
			  <ics:argument name="firsttable"  value='<%= ics.ResolveVariables("LstflexAssetTypes.assettype_Mungo") %>'/>
			  <ics:argument name="secondtable" value='<%= ics.ResolveVariables("LstflexAssetTypes.assettype") %>'/>
			  <ics:argument name="column1"     value="ownerid"/>
			  <ics:argument name="column2"     value="id"/>
		  </ics:callelement>

		  <ics:callelement element="Support/TCPI/SQL/DeleteOrphans">
			  <ics:argument name="firsttable"  value='<%= ics.ResolveVariables("LstflexAssetTypes.assettype_AMap") %>'/>
			  <ics:argument name="secondtable" value='<%= ics.ResolveVariables("LstflexAssetTypes.assetattr") %>'/>
			  <ics:argument name="column1"     value="attributeid"/>
			  <ics:argument name="column2"     value="id"/>
		  </ics:callelement>

		  <ics:callelement element="Support/TCPI/SQL/DeleteOrphans">
			  <ics:argument name="firsttable"  value='<%= ics.ResolveVariables("LstflexAssetTypes.assettype_Mungo") %>'/>
			  <ics:argument name="secondtable" value='<%= ics.ResolveVariables("LstflexAssetTypes.assetattr") %>'/>
			  <ics:argument name="column1"     value="attrid"/>
			  <ics:argument name="column2"     value="id"/>
		  </ics:callelement>

		  <ics:callelement element="Support/TCPI/SQL/DeleteOrphansEqual">
			  <ics:argument name="firsttable"  value='<%= ics.ResolveVariables("LstflexAssetTypes.assettype_Mungo") %>'/>
			  <ics:argument name="secondtable" value='<%= ics.ResolveVariables("LstflexAssetTypes.assetgroup") %>'/>
			  <ics:argument name="column1"     value="assetgroupid"/>
			  <ics:argument name="column2"     value="id"/>
			  <ics:argument name="equal"       value="assetgroupid IS NOT NULL"/>
		  </ics:callelement>

		  <ics:callelement element="Support/TCPI/SQL/DelDupsEqual2">
			  <ics:argument name="tablename" value='<%= ics.ResolveVariables("LstflexAssetTypes.assettype_AMap") %>'/>
			  <ics:argument name="keys"      value="ownerid;attributeid"/>
			  <ics:argument name="equality"  value="inherited IS NULL"/>
		  </ics:callelement>

		  <ics:callelement element="Support/TCPI/SQL/DelDupsEqual2">
			  <ics:argument name="tablename" value='<%= ics.ResolveVariables("LstflexAssetTypes.assettype_AMap") %>'/>
			  <ics:argument name="keys"      value="inherited;ownerid;attributeid"/>
			  <ics:argument name="equality"  value="inherited IS NOT NULL"/>
		  </ics:callelement>

</ics:listloop>

</cs:ftcs>
