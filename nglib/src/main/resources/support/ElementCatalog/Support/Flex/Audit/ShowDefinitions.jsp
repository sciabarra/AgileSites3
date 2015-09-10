<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld"
%><%
// Support/Flex/Audit/ShowDefinitions
%><cs:ftcs>
<h3>FlexFamily Definitions</h3>
<p>This pages lists the template definitions:  attributes defined and how many assets are using the template definition</p>
<%
String sql ="SELECT assetattr FROM FlexAssetTypes  ORDER BY assetattr ASC ";
%>
<ics:sql sql='<%=sql %>' table="FlexAssetTypes" listname="x" />

<div style="width:50%">
<% if(ics.GetVar("assetattr") !=null){
  for (String type: ics.GetVar("assetattr").split(";")){ %>

  <ics:callelement element="Support/Flex/Audit/ShowAttributes">
    <ics:argument name="assetattr" value='<%= type %>' />
  </ics:callelement>

  <ics:callelement element="Support/Flex/Audit/ShowDefinitionsAssets">
    <ics:argument name="assetattr" value='<%= type %>' />
  </ics:callelement>

  <ics:callelement element="Support/Flex/Audit/ShowDefinitionsParent">
    <ics:argument name="assetattr" value='<%= type %>' />
  </ics:callelement>

<% }
} else {
    %><h1>Please select an attribute type.</h1><%
}
%></div>
</cs:ftcs>
