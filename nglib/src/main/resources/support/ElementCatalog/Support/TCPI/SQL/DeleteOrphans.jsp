<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" 
%><%//
// Support/TCPI/SQL/DeleteOrphans
//
// INPUT
//
// OUTPUT
//
%><cs:ftcs>
prompt delete Orphans from <ics:getvar name="firsttable"/> by <ics:getvar name="secondtable"/>
timing start del_time
select 'current time is ' || to_char(sysdate,'YYYY-MM-DD HH24:MI:SS') as cur from dual;

<ics:resolvevariables name="DELETE FROM Variables.firsttable WHERE NOT EXISTS (SELECT 1 FROM Variables.secondtable WHERE Variables.firsttable.Variables.column1 = Variables.column2)"/>;
commit;
timing stop
</cs:ftcs>
