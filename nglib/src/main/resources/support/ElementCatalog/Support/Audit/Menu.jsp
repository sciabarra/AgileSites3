<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld"
%><%//
// Support/Audit/Menu
//
// INPUT
//
// OUTPUT
//%>
<%@ page import="COM.FutureTense.Interfaces.FTValList"
%><%@ page import="COM.FutureTense.Interfaces.ICS"
%><%@ page import="COM.FutureTense.Interfaces.IList"
%><%@ page import="COM.FutureTense.Interfaces.Utilities"
%><%@ page import="COM.FutureTense.Util.ftErrors"
%><%@ page import="COM.FutureTense.Util.ftMessage"
%><%!
String buildMenuUrl(String cmd){
return "ContentServer?pagename=Support/Audit/DispatcherFront&#38;cmd=" + cmd ;
}
%>
<cs:ftcs>
<div class="low-risk">
<ul class="entry-header">
<li class="read-only">
     <h2><a href="ContentServer?pagename=Support/Info/collectInfo">Version Check</a></h2>
     <p>Useful to check build date and buid version number to make sure the latest release is installed.<br/>
        Displays following information:</p>
            <ul>
                <li>Displays CPU information of the machine hosting CS</li>
                <li>Displays JVM information of the CS running appserver</li>
                <li>Recursively looks for all CS jars deployed in webapp displaying the build number and created date.</li>
            </ul>

</li>
<li class="read-only">
     <h2><a href='<%= buildMenuUrl("PropFiles") %>'>Configuration Files</a></h2>
     <p>Displays all WebCenter Sites configuration files (includes both *.ini and *.properties files). Useful to check if system is configured properly.</p>
</li>
<li class="read-only">
     <h2><a href='<%= buildMenuUrl("GetVars") %>'>WebCenter Sites Variables</a></h2>
     <p>Displays all active WebCenter Sites variables. Useful for a general system audit</p>
</li>
<li class="read-only">
     <h2><a href='<%= buildMenuUrl("SysVariables") %>'>System Variables</a></h2>
     <p>Displays all java System Properties. Useful for a general system audit</p>
</li>
<li class="read-only">
     <h2><a href='<%= buildMenuUrl("ElementCheck") %>'>Check Elements</a></h2>
     <p>Checks if url column files exist on disk. If file does not exist it gives an option to use an existing element or create a zero byte element. Useful when system goes out of sync due to system crash or disk failure.</p>
</li>
<li class="read-only">
     <h2><a href='<%= buildMenuUrl("SystemSqlCheck") %>'>Check SystemSql</a></h2>
     <p>Checks if url column files exist on disk. If file does not exist it gives an option to use an existing file or create a zero byte file. Useful when system goes out of sync due to system crash or disk failure.</p>
</li>

<li class="read-only">
     <h2><a href='<%= buildMenuUrl("TableDefs") %>'>Show Table Definitions</a></h2>
    <p>Shows definitions for all tables in Systeminfo grouped by systable column.<br/>
    Url columns can be verified (if file exists on disk or not).</p>
</li>
<li class="read-only">
     <h2><a href='<%= buildMenuUrl("TableDefsJDBC") %>'>Show JDBC Table Definitions</a></h2>
    <p>Shows definitions for all tables in Systeminfo grouped by systable column.</p>
</li>

<li class="read-only">
     <h2><a href='<%= buildMenuUrl("Indices") %>'>Full Index List</a></h2>
     <p>Lists all indexes that are used by the tables managed by WebCenter Sites. Useful for gathering system statistics</p>
</li>
<li class="read-only">
     <h2><a href='<%= buildMenuUrl("StorageCheck") %>'>Disk Storage Check</a></h2>
     <p>Displays Disk Storage used/unused Space details</p>
</li>
</div>

<div class="medium-risk">
<ul class="entry-header">

<li class="with-care">
     <h2><a href="ContentServer?pagename=Support/Audit/Default/SystemPageCacheCheck">Check SystemPageCache</a></h2>
     <p>Checks SystemPageCache for missing files on disk. If records found, then there is the possibility the expire.</p>
</li>

<li class="with-care">
     <h2><a href='<%= buildMenuUrl("AllTables") %>'>Full TableCount</a></h2>
    <p>Counts rows for all tables in Systeminfo grouped by systable column.</p>
        <ul>
            <li>Useful for database caching entries in the configuration file (futuretense.ini)</li>
            <li>Url columns of tables other than elementcatalog can be verified (if file exists on disk or not)</li>
        </ul>

</li>
<li class="with-care">
     <h2><a href='<%= buildMenuUrl("CountTables") %>'>Group TableCount</a></h2>
    <p>Counts rows for all tables in Systeminfo grouped by WebCenter Sites subsystem (namely assetframework, approval, publish, workflow, engage, etc.,). Useful for a general system audit.<br/>
        Other usages:</p>
        <ul>
            <li>Useful for database caching entries in the configuration file (futuretense.ini)</li>
            <li>Url columns of tables other than elementcatalog can be verified (if file exists on disk or not)</li>
        </ul>

</li>
<li class="with-care">
     <h2><a href='<%= buildMenuUrl("CountAssets") %>'>Count Assets per Site</a></h2>
     <p>Counts the number of assets per Site per AssetType.</p>
</li>
<li class="with-care">
     <h2><a href='<%= buildMenuUrl("AssetPub") %>'>AssetPublication Analyzer</a></h2>
     <p>Analyzes AssetPublication table looking for Orphan Assets, Duplicates or Bad Publications. Useful to clean up the database.</p>
</li>
<li class="with-care">
     <h2><a href='<%=buildMenuUrl("DB/Menu") %>'>DB Menu</a></h2>
     <p>Checks DB integrity. Runs database queries to find out consistency of the system which are normally not available through the WebCenter Sites UI.</p>
</li>
</ul>
</div>

<div class="high-risk">
<ul class="entry-header">
<li class="dangerous">
     <h2><a href='<%= buildMenuUrl("Security") %>'>Security</a></h2>
     <p>This utility provides a listing of all standard/utility URLs where access restrictions should be considered, plus a listing of all standard user names and password.</p>
     <p><b>It is strongly recommended that access to URLs are restricted and that all standard passwords are changed before going live.</b></p>
</li>
<li class="dangerous">
     <h2><a href='<%=buildMenuUrl("Workflow/CleanWorkflow") %>'>Clean Workflow Tables</a></h2>
    <p>Clears Finished Workflow History. Useful when workflow history becomes unmanageable and requires maintainance.<br/>
           Note: This tool does not backup any history, once history is deleted it is lost for ever.
    </p>
</li>
<li class="dangerous">
     <h2><a href='<%=buildMenuUrl("Publishing/ClearAssetPubList") %>'>Clear AssetPublishList</a></h2>
     <p>Displays count of assets published for all publish sessions finished/incomplete so far. Usually AssetPublishList is cleaned up after a successful publish but there might be times
            when a publish is incomplete or failed due to other reasons and records are left out in this table (these are no longer used and uses up db space as well as disk space)<br/>
            This tool deletes all non-running publish session records from this table.</p>
</li>
<li class="dangerous">
     <h2><a href='<%=buildMenuUrl("Publishing/ClearPubApprovalTarget") %>'>Clear PubHistoryPerTarget</a></h2>
    <p>Displays count of assets approved and published so far to a particular destination and recursively deletes all data for a specific target. Useful when you want to start-over with a particular destination.</p>
</li>
<li class="dangerous">
     <h2><a href='<%=buildMenuUrl("Publishing/ClearPubApproval") %>'>Clear EntirePubHistory</a></h2>
    <p>Displays count of assets approved and published so far to any destination and recursively deletes all data.</p>
</li>
<%-- experimental --%>
<li class="dangerous">
     <h2><a href='<%=buildMenuUrl("Publishing/CleanPubhistoryFront") %>'>Clean Publish History</a></h2>
    <p>Displays publish history per destination and gives options to delete publish history.</p>
</li>
<li class="dangerous">
     <h2><a href='<%=buildMenuUrl("RevTrack/historyFront") %>'>Clean RevTrack History</a></h2>
    <p>Gives option to delete revision tracking history or reduce the number of revisions proactively cleaning up necessary data.</p>
</li>
</ul>
</div>
</ul>
</cs:ftcs>
