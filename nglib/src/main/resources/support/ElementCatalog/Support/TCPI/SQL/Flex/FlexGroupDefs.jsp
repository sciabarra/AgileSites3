<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" 
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" 
%><%//
// Support/TCPI/SQL/Flex/FlexGroupDefs
//
// INPUT
//
// OUTPUT
//
%><%@ page import="COM.FutureTense.Interfaces.ICS" %>
<cs:ftcs>

<ics:sql sql="select assettype, assetattr from FlexGrpTmplTypes order by assettype" table="FlexGrpTmplTypes" listname="LstflexGroupDefs"/>

<ics:listloop listname="LstflexGroupDefs">

		  <ics:callelement element="Support/TCPI/SQL/DeleteOrphans">
			  <ics:argument name="firsttable"  value='<%= ics.ResolveVariables("LstflexGroupDefs.assettype_TGroup") %>'/>
			  <ics:argument name="secondtable" value='<%= ics.ResolveVariables("LstflexGroupDefs.assettype") %>'/>
			  <ics:argument name="column1"     value="ownerid"/>
			  <ics:argument name="column2"     value="id"/>
		  </ics:callelement>

		  <ics:callelement element="Support/TCPI/SQL/DeleteOrphans">
			  <ics:argument name="firsttable"  value='<%= ics.ResolveVariables("LstflexGroupDefs.assettype_TGroup") %>'/>
			  <ics:argument name="secondtable" value='<%= ics.ResolveVariables("LstflexGroupDefs.assettype") %>'/>
			  <ics:argument name="column1"     value="productgrouptemplateid"/>
			  <ics:argument name="column2"     value="id"/>
		  </ics:callelement>

		  <ics:callelement element="Support/TCPI/SQL/DeleteOrphans">
			  <ics:argument name="firsttable"  value='<%= ics.ResolveVariables("LstflexGroupDefs.assettype_TAttr") %>'/>
			  <ics:argument name="secondtable" value='<%= ics.ResolveVariables("LstflexGroupDefs.assettype") %>'/>
			  <ics:argument name="column1"     value="ownerid"/>
			  <ics:argument name="column2"     value="id"/>
		  </ics:callelement>

		  <ics:callelement element="Support/TCPI/SQL/DeleteOrphans">
			  <ics:argument name="firsttable"  value='<%= ics.ResolveVariables("LstflexGroupDefs.assettype_TAttr") %>'/>
			  <ics:argument name="secondtable" value='<%= ics.ResolveVariables("LstflexGroupDefs.assetattr") %>'/>
			  <ics:argument name="column1"     value="attributeid"/>
			  <ics:argument name="column2"     value="id"/>
		  </ics:callelement>

</ics:listloop>

</cs:ftcs>
