<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" 
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" 
%><%//
// Support/TCPI/SQL/Flex/FlexAssetDefs
//
// INPUT
//
// OUTPUT
//
%><%@ page import="COM.FutureTense.Interfaces.ICS" %>
<cs:ftcs>

<ics:sql sql="select assettemplate, assettype, assetattr from FlexTmplTypes order by assettype" table="FlexTmplTypes" listname="LstflexAssetDefs"/>

<ics:listloop listname="LstflexAssetDefs">

		  <ics:callelement element="Support/TCPI/SQL/DeleteOrphans">
			  <ics:argument name="firsttable"  value='<%= ics.ResolveVariables("LstflexAssetDefs.assettype_TGroup") %>'/>
			  <ics:argument name="secondtable" value='<%= ics.ResolveVariables("LstflexAssetDefs.assettype") %>'/>
			  <ics:argument name="column1"     value="ownerid"/>
			  <ics:argument name="column2"     value="id"/>
		  </ics:callelement>

		  <ics:callelement element="Support/TCPI/SQL/DeleteOrphans">
			  <ics:argument name="firsttable"  value='<%= ics.ResolveVariables("LstflexAssetDefs.assettype_TGroup") %>'/>
			  <ics:argument name="secondtable" value='<%= ics.ResolveVariables("LstflexAssetDefs.assettemplate") %>'/>
			  <ics:argument name="column1"     value="productgrouptemplateid"/>
			  <ics:argument name="column2"     value="id"/>
		  </ics:callelement>

		  <ics:callelement element="Support/TCPI/SQL/DeleteOrphans">
			  <ics:argument name="firsttable"  value='<%= ics.ResolveVariables("LstflexAssetDefs.assettype_TAttr") %>'/>
			  <ics:argument name="secondtable" value='<%= ics.ResolveVariables("LstflexAssetDefs.assettype") %>'/>
			  <ics:argument name="column1"     value="ownerid"/>
			  <ics:argument name="column2"     value="id"/>
		  </ics:callelement>

		  <ics:callelement element="Support/TCPI/SQL/DeleteOrphans">
			  <ics:argument name="firsttable"  value='<%= ics.ResolveVariables("LstflexAssetDefs.assettype_TAttr") %>'/>
			  <ics:argument name="secondtable" value='<%= ics.ResolveVariables("LstflexAssetDefs.assetattr") %>'/>
			  <ics:argument name="column1"     value="attributeid"/>
			  <ics:argument name="column2"     value="id"/>
		  </ics:callelement>

</ics:listloop>

</cs:ftcs>
