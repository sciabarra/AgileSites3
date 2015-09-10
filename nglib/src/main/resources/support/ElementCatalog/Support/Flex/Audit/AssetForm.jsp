<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld"
%><%//
// Support/Flex/Audit/AssetForm
//
// INPUT
//
// OUTPUT
//
%><cs:ftcs><%
String sql ="SELECT assettype, description FROM AssetType WHERE assettype IN ("
+"SELECT assettype FROM FlexGroupTypes "
+"UNION "
+"SELECT assettype FROM FlexAssetTypes "
+") "
+"ORDER BY assettype ASC";
String pagename="Support/Flex/Audit/" + ics.GetVar("PostPage");
%>
<h3>Show <ics:getvar name="PostPage"/></h3>
<ics:sql sql='<%=sql %>' table="FlexAssetTypes" listname="assettypes"/>

<form method="GET" action="ContentServer">
    <input type="hidden" name="pagename"  value='<%= pagename %>'/>
    Flex Asset Name :&nbsp;
    <select name="assettype" size="1">
        <ics:listloop listname="assettypes">
            <option value='<ics:listget listname="assettypes" fieldname="assettype"/>'><ics:listget listname="assettypes" fieldname="assettype" /></option>
        </ics:listloop>
    </select>

    &nbsp;&nbsp;<input type="submit" value="submit"/>
</form>
</cs:ftcs>