<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %><%
//
// Support/TCPI/SQL/Flex/FlexGroups
//
// INPUT
//
// OUTPUT
//
%><%@ page import="COM.FutureTense.Interfaces.ICS" %><cs:ftcs>
<ics:sql sql="select assettype, assetattr from FlexGroupTypes order by assettype " table="FlexGroupTypes" listname="LstflexGroupTypes"/>
<ics:listloop listname="LstflexGroupTypes">

		  <ics:callelement element="Support/TCPI/SQL/DeleteOrphans">
			  <ics:argument name="firsttable"  value='<%= ics.ResolveVariables("LstflexGroupTypes.assettype_AMap") %>'/>
			  <ics:argument name="secondtable" value='<%= ics.ResolveVariables("LstflexGroupTypes.assettype") %>'/>
			  <ics:argument name="column1"     value="ownerid"/>
			  <ics:argument name="column2"     value="id"/>
		  </ics:callelement>

		  <ics:callelement element="Support/TCPI/SQL/DeleteOrphansEqual">
			  <ics:argument name="firsttable"  value='<%= ics.ResolveVariables("LstflexGroupTypes.assettype_AMap") %>'/>
			  <ics:argument name="secondtable" value='<%= ics.ResolveVariables("LstflexGroupTypes.assettype") %>'/>
			  <ics:argument name="column1"     value="inherited"/>
			  <ics:argument name="column2"     value="id"/>
			  <ics:argument name="equal"       value="inherited IS NOT NULL"/>
		  </ics:callelement>

		  <ics:callelement element="Support/TCPI/SQL/DeleteOrphans">
			  <ics:argument name="firsttable"  value='<%= ics.ResolveVariables("LstflexGroupTypes.assettype_Group") %>'/>
			  <ics:argument name="secondtable" value='<%= ics.ResolveVariables("LstflexGroupTypes.assettype") %>'/>
			  <ics:argument name="column1"     value="parentid"/>
			  <ics:argument name="column2"     value="id"/>
		  </ics:callelement>

		  <ics:callelement element="Support/TCPI/SQL/DeleteOrphans">
			  <ics:argument name="firsttable"  value='<%= ics.ResolveVariables("LstflexGroupTypes.assettype_Mungo") %>'/>
			  <ics:argument name="secondtable" value='<%= ics.ResolveVariables("LstflexGroupTypes.assettype") %>'/>
			  <ics:argument name="column1"     value="ownerid"/>
			  <ics:argument name="column2"     value="id"/>
		  </ics:callelement>

		  <ics:callelement element="Support/TCPI/SQL/DeleteOrphans">
			  <ics:argument name="firsttable"  value='<%= ics.ResolveVariables("LstflexGroupTypes.assettype_Root") %>'/>
			  <ics:argument name="secondtable" value='<%= ics.ResolveVariables("LstflexGroupTypes.assettype") %>'/>
			  <ics:argument name="column1"     value="rootid"/>
			  <ics:argument name="column2"     value="id"/>
		  </ics:callelement>

		  <ics:callelement element="Support/TCPI/SQL/DeleteOrphans">
			  <ics:argument name="firsttable"  value='<%= ics.ResolveVariables("LstflexGroupTypes.assettype_AMap") %>'/>
			  <ics:argument name="secondtable" value='<%= ics.ResolveVariables("LstflexGroupTypes.assetattr") %>'/>
			  <ics:argument name="column1"     value="attributeid"/>
			  <ics:argument name="column2"     value="id"/>
		  </ics:callelement>

		  <ics:callelement element="Support/TCPI/SQL/DeleteOrphans">
			  <ics:argument name="firsttable"  value='<%= ics.ResolveVariables("LstflexGroupTypes.assettype_Mungo") %>'/>
			  <ics:argument name="secondtable" value='<%= ics.ResolveVariables("LstflexGroupTypes.assetattr") %>'/>
			  <ics:argument name="column1"     value="attrid"/>
			  <ics:argument name="column2"     value="id"/>
		  </ics:callelement>

		  <ics:callelement element="Support/TCPI/SQL/DeleteOrphansEqual">
			  <ics:argument name="firsttable"  value='<%= ics.ResolveVariables("LstflexGroupTypes.assettype_Mungo") %>'/>
			  <ics:argument name="secondtable" value='<%= ics.ResolveVariables("LstflexGroupTypes.assettype") %>'/>
			  <ics:argument name="column1"     value="assetgroupid"/>
			  <ics:argument name="column2"     value="id"/>
			  <ics:argument name="equal"       value="assetgroupid IS NOT NULL"/>
		  </ics:callelement>

			<ics:sql sql='<%= ics.ResolveVariables("select distinct childtype from LstflexGroupTypes.assettype_Group order by childtype")%>' table='<%= ics.ResolveVariables("LstflexGroupTypes.assettype_Group") %>' listname="LstChildTypes"/>

		  <ics:listloop listname="LstChildTypes">
					 <ics:callelement element="Support/TCPI/SQL/DeleteOrphansEqual">
						 <ics:argument name="firsttable"  value='<%= ics.ResolveVariables("LstflexGroupTypes.assettype_Group") %>'/>
						 <ics:argument name="secondtable" value='<%= ics.ResolveVariables("LstChildTypes.childtype") %>'/>
						 <ics:argument name="column1"     value="childid"/>
						 <ics:argument name="column2"     value="id"/>
						 <ics:argument name="equal"       value='<%= ics.ResolveVariables("childtype=\'LstChildTypes.childtype\'") %>'/>
					 </ics:callelement>
		  </ics:listloop>

		  <ics:callelement element="Support/TCPI/SQL/DelDupsEqual2">
			  <ics:argument name="tablename" value='<%= ics.ResolveVariables("LstflexGroupTypes.assettype_AMap") %>'/>
			  <ics:argument name="keys"      value="ownerid;attributeid"/>
			  <ics:argument name="equality"  value="inherited IS NULL"/>
		  </ics:callelement>

		  <ics:callelement element="Support/TCPI/SQL/DelDupsEqual2">
			  <ics:argument name="tablename" value='<%= ics.ResolveVariables("LstflexGroupTypes.assettype_AMap") %>'/>
			  <ics:argument name="keys"      value="inherited;ownerid;attributeid"/>
			  <ics:argument name="equality"  value="inherited IS NOT NULL"/>
		  </ics:callelement>

</ics:listloop>

</cs:ftcs>
