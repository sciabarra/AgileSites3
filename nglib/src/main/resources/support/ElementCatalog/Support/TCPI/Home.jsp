<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld"
%><%//
// Support/TCPI/Home
//
// INPUT
//
// OUTPUT
//
%><cs:ftcs>
<% String[] tables={"AssetPublication","ApprovedAssetDeps","ApprovedAssets","AssetExportData","AssetPublishList","PublishedAssets","ActiveList","CheckOutInfo"}; %>
<div class="low-risk">
<ul class="entry-header">
    <li class="read-only">
         <h2><a href='ContentServer?pagename=Support/TCPI/AP/ShowHeld'><b>DetailStatus</b></a></h2>
         <p>Shows approval detail of an assets</p>
    </li>
    <li class="read-only">
         <h2><a href='ContentServer?pagename=Support/TCPI/AP/PubQueues'><b>ApprovalStats</b></a></h2>
         <p>Calculates and Displays Approval and Publish statistics for all Publish Destinations.</p>
    </li>
    <li class="read-only">
         <h2><a href='ContentServer?pagename=Support/TCPI/AP/ListHeld'><b>ListHeldAssets</b></a></h2>
         <p>Lists Assets that are in a Held State (across all Destinations)</p>
    </li>
    <li class="read-only">
         <h2><a href='ContentServer?pagename=Support/TCPI/CleanUp/CheckDates'><b>CheckDates</b></a></h2>
         <p>Verifies Asset Dates in ApprovedAssets against PublishedAssets</p>
    </li>
    <li class="read-only">
        <h2><a href='ContentServer?pagename=Support/TCPI/AP/PublishPerformance'><b>Publish Performance</b></a></h2>
        <p>Get info on the performance of publishes of type MirrorPublishing if VERBOSE=true is set as a publish argument.</p>
    </li>

</ul>
</div>
<div class="medium-risk">
<ul class="entry-header">
    <li class="with-care">
        <h2><a href='ContentServer?pagename=Support/TCPI/AP/EventForm'><b>Current Events</b></a></h2>
        <p>Lists, Enables, Disables and Destroys all available Events</p>
    </li>

    <li class="with-care">
         <h2><a href='ContentServer?pagename=Support/TCPI/CleanUp/CountAssetRelationTree'><b>AssetRelationTree</b></a></h2>
         <p>This lists the number of missing assets in the database for table AssetRelationTree.</p>
    </li>
    <li class="with-care">
        <h2><a href='ContentServer?pagename=Support/TCPI/AP/CheckPubKeyForPublishable'><b>CheckPubKeyForPublishable</b></a></h2>
        <p>This lists the content of urlkey fields of PubKeyTable for all publishable assets.</p>
    </li>
    <li class="with-care">
         <h2><a href='ContentServer?pagename=Support/TCPI/AP/TopDependencies'><b>TopDependencies</b></a></h2>
        <p>Shows ApprovedAssets that have a lot of dependencies. <br/> Has ability to force approve assets for all targets it is currently approved.</p>
    </li>
    <li class="with-care">
         <h2><a href='ContentServer?pagename=Support/TCPI/CleanUp/CountHeldWithoutChildren'><b>CountHeldWithoutChildren</b></a></h2>
         <p>Checks for assets that are held by do not have any dependants.<br/>This is also an indication that the targetids do not match.</p>
    </li>
        <% for (int i=0; i< tables.length;i++){ %>
         <li class="with-care">
              <h2><a href='ContentServer?pagename=Support/TCPI/CleanUp/CountAssets&tname=<%= tables[i] %>'><b><%= tables[i] %></b></a></h2>
              <p>This lists the number of missing assets in the database for table <%= tables[i] %>.</p>
         </li>
        <% } %>

</ul>
</div>
<div class="high-risk">
<ul class="entry-header">
    <li class="dangerous">
         <h2><a href='ContentServer?pagename=Support/TCPI/AP/UnApprove'><b>UnApprove</b></a></h2>
         <p>Forces Assets out of a Publish Queue.</p>
    </li>
    <li class="dangerous">
         <h2><a href='ContentServer?pagename=Support/TCPI/AP/ForcePublish'><b>ForcePublishAssets</b></a></h2>
         <p>Force approve Assets to a given destination if they have been published to this destination before.</p>
    </li>
    <li class="dangerous">
        <h2><a href='ContentServer?pagename=Support/TCPI/CleanUp/CleanAssetPublishLists'><b>CleanAssetPublishLists</b></a></h2>
        <p>Checks for leftover rows in the tempory publish tables. <br/>There should only be data in these tables when there are not pubsessions running.</p>
    </li>
    <li class="dangerous">
        <h2><a href='ContentServer?pagename=Support/TCPI/CleanUp/CleanPubDataStore'><b>CleanPubDataStore</b></a></h2>
        <p>Checks for leftover rows in FW_PubDataStore.</p>
    </li>
    <li class="dangerous">
        <h2><a href='ContentServer?pagename=Support/TCPI/AP/NotePublish'><b>Mark as Published</b></a></h2>
        <p>Mark approved assets as published to a destination. If the approved assets are already available on the target system, this tools notifies the approval system of that state.</p>
    </li>
    <li class="dangerous">
         <h2><a href='ContentServer?pagename=Support/TCPI/AP/ApproveHeldAndChanged'><b>ApproveHeldAndChanged</b></a></h2>
         <p>List and Approve Assets either in a Held/Changed State.</p>
    </li>
    <li class="dangerous">
         <h2><a href='ContentServer?pagename=Support/TCPI/AP/DuplicatePubkeyFront'><b>RemoveDuplicatePubkeys</b></a></h2>
         <p>Delete Duplicate Pubkeys for Static Publish Destinations</p>
    </li>
    <li class="dangerous">
         <h2><a href='ContentServer?pagename=Support/TCPI/CleanUp/CountAssetsReverse'><b>AssetPublicationReverse</b></a></h2>
        <p>This lists the number of missing AssetPublication table entries for assets in the database.</p>
    </li>
    <li class="dangerous">
         <h2><a href='ContentServer?pagename=Support/TCPI/CleanUp/CountPubKeyTable'><b>PubKeyTable</b></a></h2>
        <p>This lists the number of missing assets in the database for table PubKeyTable.</p>
    </li>
    <li class="dangerous">
        <h2><a href='ContentServer?pagename=Support/TCPI/SQL/Index'><b>SQLScripts</b></a></h2>
        <p>This is the index page to the sql scripts to be run in sqlplus</p>
    </li>
    <li class="dangerous">
         <h2><a href='ContentServer?pagename=Support/TCPI/CleanUp/CountAssetApprAndDeps'><b>CountAssetApprAndDeps</b></a></h2>
         <p>Does a count on ApprovedAssets and ApprovedAssetDeps tables for their references.</p>
    </li>
    <li class="dangerous">
         <h2><a href='ContentServer?pagename=Support/TCPI/CleanUp/FindWrongTargetidInApprovedAssetDeps'><b>FindWrongTargetidInDeps</b></a></h2>
         <p>Checks for the referential integrity between ApprovedAssets and ApprovedAssetDeps via targetid. Time consuming utility.</p>
    </li>
</ul>
</div>

</cs:ftcs>
