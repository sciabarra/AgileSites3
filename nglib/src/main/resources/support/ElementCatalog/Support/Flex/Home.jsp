<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld"
%><%//
// Support/Flex/Home
//
// INPUT
//
// OUTPUT
//
%><cs:ftcs>
<div class="low-risk">
<ul class="entry-header">
    <li class="read-only">
         <h2><a href="ContentServer?pagename=Support/Flex/Audit/ShowDefinitionsFront"><b>ShowDefinitions</b></a></h2>
         <p>Displays the basic structure of an assettype with its definition, associated parents (immediate) and attributes.</p>
    </li>
    <li class="read-only">
         <h2><a href="ContentServer?pagename=Support/Flex/Audit/ShowDefinitionTree"><b>ShowDefinitionTree</b></a></h2>
         <p>Displays parent definitions with their heirarchy and attributes on each, useful for a quick overview.</p>
    </li>
    <li class="read-only">
         <h2><a href="ContentServer?pagename=Support/Flex/Audit/ShowParentsFront"><b>ShowParents</b></a></h2>
         <p>Displays all parents of a given assettype with associated data of attributes and other parent inforamtion.</p>
    </li>
    <li class="read-only">
         <h2><a href="ContentServer?pagename=Support/Flex/Audit/CountDefinitionsFront"><b>CountDefinitions</b></a></h2>
         <p>Counts total number of assets for a given definition.</p>
    </li>
    <li class="read-only">
         <h2><a href="ContentServer?pagename=Support/Flex/Audit/CountAttributesFront"><b>CountAttributes</b></a></h2>
         <p>Counts total usage of attributes for a given assettype.</p>
    </li>
    <li class="read-only">
         <h2><a href="ContentServer?pagename=Support/Flex/Audit/ShowMissingAttributesFront"><b>ShowMissingAttributes</b></a></h2>
         <p>For a given assetype, displays how many assets do not have all the required attributes.</p>
    </li>
</ul>
</div>
<div class="medium-risk">
&nbsp;</div>
<div class="high-risk">
&nbsp;</div>
</cs:ftcs>
