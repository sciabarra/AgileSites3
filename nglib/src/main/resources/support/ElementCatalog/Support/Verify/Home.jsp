<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld"
%><%@ taglib prefix="user" uri="futuretense_cs/user.tld"
%><%//
// Support/Verify/Home
//
// INPUT
//
// OUTPUT
//%>
<%@ page import="COM.FutureTense.Interfaces.FTValList" %>
<%@ page import="COM.FutureTense.Interfaces.ICS" %>
<%@ page import="COM.FutureTense.Interfaces.IList" %>
<%@ page import="COM.FutureTense.Interfaces.Utilities" %>
<%@ page import="COM.FutureTense.Util.ftErrors" %>
<%@ page import="COM.FutureTense.Util.ftMessage"%>
<cs:ftcs>
<div class="low-risk">
<ul class="entry-header">
    <li class="read-only">
        <h2><a href="ContentServer?pagename=Support/Verify/Files/ftcslog">Sites Log</a></h2>
        <p>Displays last few lines from futuretense.txt / sites.log (does not tail the log). To get latest log entries refresh the page. <br/>
               To get full log file add &full=yes at the end of url and refresh the page. <br/>
               To clear log file add &clearlog=true at the end of url and refresh the page.
        </p>
    </li>
        <li class="read-only">
             <h2><a href="ContentServer?pagename=Support/Verify/Cluster/CheckSyncdirTime">CheckSyncdirTime</a></h2>
             <p>Check if the time of a file on disks in the usedisksync/event folder is about the same as the current jvm.<br/>
             We have seen problems in the past, where the shared drive was not correctly time sync'ed.</p>
        </li>

        <li class="read-only">
            <h2><a href="ContentServer?pagename=Support/Verify/i18n/UnicodeChart">Unicode Chart</a></h2>
            <p>Check the display of different Unicode characters</p>
    </li>
    <li class="read-only">
         <h2><a href="ContentServer?pagename=Support/Verify/Cluster/HttpSession">HttpSession</a></h2>
         <p>Displays Basic session infomation</p>
    </li>
    <li class="read-only">
         <h2><a href="ContentServer?pagename=Support/Verify/Cluster/multicast">Multicast Test</a></h2>
         <p>Tool for testing multicast</p>
    </li>
</ul>
</div>
<div class="medium-risk">
<ul class="entry-header">
        <li class="with-care">
             <h2><a href="ContentServer?pagename=Support/Verify/Cluster/TestFS">File System Test</a></h2>
             <p>Test the performance of the shared file system.</p>
        </li>
        <li class="with-care">
             <h2><a href="ContentServer?pagename=Support/Verify/Cluster/LockTest">LockTest</a></h2>
             <p>Locks a file in the sync dir.<br/>
             Try to lock the same file from an other jvm, it should fail. Only useful when cs cluster is enabled</p>
        </li>
        <li class="with-care">
             <h2><a href="ContentServer?pagename=Support/Verify/Cluster/ClusterTest">Basic Cluster Test</a></h2>
            <p>Test unique id generation and session persistence. This element is designed to test failover of a cluster. It should work on all clusterable appservers. </p>
            <p>It shows following things: </p>
            <ol style="margin-left=20px;">
                <li> the runtime.hashcode. This shows you which jvm runs the request. In a multi-jvm environment you should see different values for different browsers. </li>
                <li> the name of the thread that executed the request. This is important is you would test concurrency. </li>
                <li> the current session id. </li>
                <li> an counter on the session. </li>
                <li> an counter on the ContentServer unique id. </li>
            </ol>
            <p>With this info you can 'see' the 'state' between requests.</p>
            <ol style="margin-left=20px;">
                <li>what jvm executes your request. In case of failover the jvm id should change. If it changes when the jvm's are all up, session stickyness does not work.</li>
                <li> the counter on the session. In case of failover the counter drops to 0 again, session failover does not work. This is a appserver setup issue.</li>
                <li> If between requests the unique id are not sequantial amongst jvm's, CS clustering does not work. </li>
            </ol>
            <p>Please keep in mind that each jvm keeps it's own pool of unique id's. By default
              this pool is of 100 ids. So it can be the jvm 1 is using numbers 0-99 while
              jvm 2 is using numbers 100-199. If a single jvm reaches 99, it get the next
              pool of id's. In case of jvm 1 that would be 200-299. When you test with this
              element, the same browser (IE) on the same machine is using the same session.
              So if you have a browser open and a session is assinged by the appserver to
              that browser, and you start an new IE on that same machine, that new IE will
              use the same session as the old IE. If you want to use multiple session use
              both IE and Netscape or use multiple machines. </p>
            <p>To test, call the page from multiple browsers running on diffenent machines
              multiple time. Make sure that to notice the expected behaviour for the jvm id,
              session counter and unique id. The shut one appserver jvm down and reload the
              page in your open browsers. Again verify the results to make sure the session
              counter keeps increasing, and for some browsers the jvm id changes. </p>
        </li>
        <li class="with-care">
            <h2><a href="ContentServer?pagename=Support/Verify/i18n/encoding">Unicode Form Post</a></h2>

            <p>Post some unicode(UTF-8) chars to a CS table. Test creates a table jsp01 (if not exist) and posts unicode characters into the table and retrieves it back from the table.
                   If the characters posted are grabled on retreival then UTF-8 settings either on CS/Appserver/OS might be wrong. <br/>
                   Unicode chars used for test (can be changed by user) are latin1, latinA, greek, arabic and japanese. Following methods are employed during post:</p>
                   <ul style="margin-left=20px;">
                       <li> method=get </li>
                       <li> method=post enctype=application/x-www-form-urlencoded </li>
                       <li> method=post enctype=multipart/form-data </li>
                   </ul>
        </li>

</ul>
</div>
<div class="high-risk">
<ul class="entry-header">
    <li class="dangerous">
         <h2><a href="ContentServer?pagename=Support/Verify/xml/exportFront">DB to XML</a></h2>
         <p>Displays all tables listed in SystemInfo table (temporary tables are filtered) in a choice box and an optinal textarea for user-defined query.
                Selecting a table with empty query will output all table data in xml format. To output a subset of data, select the table and input a query to filter data.
                Displays output for only one table at a time.
         Tips:</p>
         <ul style="margin-left=20px;">
             <li>Use browsers SaveAs to save the output to an xml.</li>
             <li>Use browsers back button to go back into the tool.</li>
         </ul>
    </li>
    <li class="dangerous">
        <h2><a href="ContentServer?pagename=Support/Verify/Cluster/nodeFront">Cluster Nodes</a></h2>
        <p>Runs Connectivity tests on Cluster Nodes (use appservers http port of cluster nodes).<br/>
        Enter number of nodes in the cluster on page1. Next page displays url, username and password fields for each cluster node. Fill in relevant info and click submit.
        Element posts a page to all cluster nodes and displays the response of each cluster node. Verify response is same across all cluster nodes.</p>
    </li>
</ul>
</div>
</cs:ftcs>
