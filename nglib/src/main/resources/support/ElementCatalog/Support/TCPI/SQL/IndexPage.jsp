<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" 
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" 
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" 
%><%//
// Support/TCPI/SQL/IndexPage
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
%><%@ page import="COM.FutureTense.Util.ftMessage"%>
<cs:ftcs>
<ics:callelement element="Support/general"/>
<div id="content">
<ics:callelement element="Support/Topnav"/>
<% if (ics.UserIsMember("SiteGod")){ %>
	<h3><center>SQL Optimization, Referential Integrity and Cleanup Duplicate Scripts</center></h3>
	<table class="altClass">
		<tr>
    	<th width="20%">SQL Script</th>
    	<th width="10%">View Script</th>
    	<th width="10%">Download Script</th>
    	<th width="60%">Description</th>
		</tr>
		<tr>
      <td>Generate Create Indexes script</td>
      <td><a href='ContentServer?pagename=Support/TCPI/SQL/IndexScript'>View</a></td>
      <td><a href='ContentServer?pagename=Support/TCPI/SQL/Download/IndexScript'>Download</a></td>
      <td><p>This utility generates sql script to create indexes on:<br/>AssetPublication, ApprovedAssetDeps, ApprovedAssets, PubkeyTable, PublishedAssets, PubSession, FlexGroup Definitions, FlexGroups, FlexAsset Definitions and FlexAsset Tables. </p></td>
		</tr>
		<tr>
      <td>Referential Integrity for Flex Assets</td>
	    <td><a href='ContentServer?pagename=Support/TCPI/SQL/Integrity'>View</a></td>
		  <td><a href='ContentServer?pagename=Support/TCPI/SQL/Download/Integrity'>Download</a></td>
			<td><p>This utility generates sql script to delete orphans from:<br/>Attribute pools, FlexGroup Definitions, FlexGroups, FlexAsset Definitions, FlexAsset amd deletes duplicates from AssetPublication.</p></td>
		</tr>
		<tr>
			<td>Referential Integrity for Assets</td>
			<td><a href='ContentServer?pagename=Support/TCPI/SQL/AssetScript'>View</a></td>
			<td><a href='ContentServer?pagename=Support/TCPI/SQL/Download/AssetScript'>Download</a></td>
			<td><p>This utility generates sql script to delete orphans from the following tables:<br/>AssetPublication, ApprovedAssetDeps, ApprovedAssets, AssetExportData, AssetPublishList, PublishedAssets, ActiveList and CheckOutInfo.</p></td>
		</tr>
		<tr>
			<td>ApprovedAssetDeps Alignment</td>
			<td><a href='ContentServer?pagename=Support/TCPI/SQL/ApprovedAssetDepsAlignment'>View</a></td>
			<td><a href='ContentServer?pagename=Support/TCPI/SQL/Download/ApprovedAssetDepsAlignment'>Download</a></td>
			<td><p>This utility generates sql script to:<br/>1) Align the targetid from ApprovedAssets and ApprovedAssetDeps when they are not the same (relationship over ownerid). (Targetid from ApprovedAssetDeps will be set to the targetid from ApprovedAssets)<br/>2) Remove Any record in ApprovedAssetDeps when there is no owner record in ApprovedAssets</p></td>
		</tr>
		<tr>
      <td>ApprovedAssetDeps Duplicates</td>
			<td><a href='ContentServer?pagename=Support/TCPI/SQL/ApprovedAssetDups'>View</a></td>
			<td><a href='ContentServer?pagename=Support/TCPI/SQL/Download/ApprovedAssetDups'>Download</a></td>
			<td><p>This utility generates sql script to:<br/>Remove Duplicates from ApprovedAssetDeps</p></td>
		</tr>
    <tr>
			<td>Drop Temporary Indexes</td>
			<td><a href='ContentServer?pagename=Support/TCPI/SQL/DropTempIndexes'>View</a></td>
			<td><a href='ContentServer?pagename=Support/TCPI/SQL/Download/DropTempIndexes'>Download</a></td>
			<td><p>This utility generates sql script to:<br/>Drop temporary indexes that were created by the Generate Indexes script<br/> This means that all Indexes that were named like "I_FW_INDT_%" will be dropped.</p></td>
		</tr>
		<tr>
			<td>Drop Indexes</td>
			<td><a href='ContentServer?pagename=Support/TCPI/SQL/DropIndexes'>View</a></td>
			<td><a href='ContentServer?pagename=Support/TCPI/SQL/Download/DropIndexes'>Download</a></td>
			<td><p>This utility generates sql script to:<br/>Drop indexes that were created by the Generate Indexes script<br/> This means that all Indexes that were named like "I_FW_IND_%" will be dropped.</p></td>
		</tr>
  </table>
<% } else { %>
	<ics:callelement element="Support/TCPI/LoginForm"/>
<% } %>
<ics:callelement element="Support/Footer"/>
</div>
</cs:ftcs>
