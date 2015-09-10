<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" 
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" 
%><%//
// Support/TCPI/SQL/SQLScriptFooter
//
// INPUT
//
// OUTPUT
//%>
<cs:ftcs>
prompt exiting script
select 'current time is ' || to_char(sysdate,'YYYY-MM-DD HH24:MI:SS') as cur from dual;
spool off
exit;
</cs:ftcs>
