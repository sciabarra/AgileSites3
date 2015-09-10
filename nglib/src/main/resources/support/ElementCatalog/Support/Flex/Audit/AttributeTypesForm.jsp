<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld"
%><%//
// Support/Flex/Audit/AssetTypeForm
//
// INPUT
//
// OUTPUT
//
%><%@ page import="COM.FutureTense.Interfaces.ICS"
%><cs:ftcs>
<%
String sql ="SELECT assettype, description FROM AssetType WHERE assettype IN ("
+"SELECT assetattr FROM FlexAssetTypes "
+") "
+"ORDER BY assettype ASC";
String pagename="Support/Flex/Audit/" + ics.GetVar("PostPage");
%>
<h3><ics:getvar name="PostPage"/></h3>
<ics:sql sql='<%=sql %>' table="FlexAssetTypes" listname="assettypes"/>
Select Flex Attribute type(s):
<form method="GET" action="ContentServer">
    <select name="assetattr" size='<ics:listget listname="assettypes" fieldname="#numRows"/>' multiple="multiple">
        <ics:listloop listname="assettypes">
            <option value='<ics:listget listname="assettypes" fieldname="assettype"/>'><ics:listget listname="assettypes" fieldname="description" /></option>
        </ics:listloop>
    </select>
    <input type="hidden" name="pagename"  value='<%= pagename %>'/>
    <input type="submit" value="submit"/>
</form>
</cs:ftcs>
