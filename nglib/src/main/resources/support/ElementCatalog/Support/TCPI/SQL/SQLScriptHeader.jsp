<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" 
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" 
%><%//
// Support/TCPI/SQL/SQLScriptHeader
//
// INPUT
//
// OUTPUT
//%>
<cs:ftcs>
set pagesize 999
set heading off
spool <ics:getvar name="scriptname"/>-<%= new java.text.SimpleDateFormat("yyyy-MM-dd-HH-mm-ss").format(new java.util.Date()) %>.lst
</cs:ftcs>
