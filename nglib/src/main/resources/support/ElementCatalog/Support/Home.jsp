<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%//
// Support/Home
//
// INPUT
//
// OUTPUT
//
%><cs:ftcs>
<ul class="entry-header">
  <li>
    <h3>General Information</h3>
    <p>The WebCenter Sites Support Tools are intended for use by experienced users with SiteGod privileges to assist in audit, cleanup, help diagnose and resolve problems. These tools can be customized by end users to their need.</p>
  <%
  if (!ics.UserIsMember("SiteGod")){
      %><p><ics:callelement element="Support/Login"/></p><%
  } else {
    %><h3>Overview</h3>
    <ul>
    <li><b>Info:</b> Displays information about current system and appserver properties.</li>
    <li><b>System:</b> Helps general audit of the system and miscellaneous cleanup tools.</li>
    <li><b>Approval:</b> Displays information about approval subsystem, approval affected tables and events.</li>
    <li><b>Cache:</b> Displays information about CacheManager subsystem.</li>
    <li><b>Assets:</b> Displays information about assets.</li>
    <li><b>Flex:</b> Shows the general layout of flex assets and find any missing data.</li>
    <li><b>Misc:</b> Miscellaneous tools which include cluster tests, encoding tests and displays files from filesystem.</li>
    <li><b>Log4J:</b> Dynamically set logger levels if log4j is configured.</li>
    <li><b>Performance:</b>Some basic simple pages for baseline performance testing.</li>
   </ul><%
   }
%></li>
</ul>
<div id="disclaimer" style="width:50%">
<p><div style="text-align: center;font-size:1.5em"><u>SUPPORT TOOLS DISCLAIMER</u></div>
<p>"Support Tools" are a set of diagnostic tools distributed by Oracle ("Oracle").
Incorrect usage of the Support Tools may cause permanent damage to installed Oracle products ("Licensed Software").</p>
<p style="font-size:1.2em">THE USE OF SUPPORT TOOLS ARE NOT COVERED UNDER THE ORACLE MAINTENANCE & SUPPORT AGREEMENTS,
ARE NOT INTENDED TO BE USED IN CONNECTION WITH ANYTHING OTHER THAN ORACLE SOFTWARE.</p>
<p  style="font-size:1.2em"><u>ANY UNAUTHORIZED USE OF SUPPORT TOOLS WILL VOID ALL ORACLE REPRESENTATION AND WARRANTIES FOR LICENSED SOFTWARE.</u></p>
<p>Support Tools are not licensed Oracle products and are provided to Oracle licensees "AS IS".
Oracle makes no representation or warranty of any kind, whether oral or written, whether express,
implied or arising by statute, custom, course of dealing, or trade usage with respect to the use of Developers Tools.
Oracle specifically disclaims any and all implied warranties or conditions of title, merchantability, fitness for a particular purpose
or non-infringement.
Under no circumstances shall Oracle be liable for any damages whatsoever
for the use of Developers Tools including, without limitation, direct,
consequential, incidental or indirect damages, damages for loss of business profit,
business interruption or for damage to the Oracle software or any
of the Oracle Licensee&#39;s systems, data, software or hardware.</p>
</div>

</cs:ftcs>