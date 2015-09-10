<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" 
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" 
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" 
%><%//
// Support/TCPI/SQL/LastPubFix
//
// INPUT
//
// targetid
// assettype
//
// OUTPUT
//%>
<cs:ftcs>

prompt Align  currentdep from ApprovedAssetDeps for target <ics:getvar name="targetid"/>
timing start del_time
select 'current time is ' || to_char(sysdate,'YYYY-MM-DD HH24:MI:SS') as cur from dual;

UPDATE ApprovedAssetDeps t 
SET lastpub='T'
WHERE 
t.targetid = <ics:getvar name="targetid" />
AND t.assetdeptype='E'
AND t.currentdep  ='F'
AND EXISTS (SELECT 1 FROM ApprovedAssetDeps t2 
WHERE t.ownerid = t2.ownerid 
AND t.targetid  = t2.targetid 
AND t.assetid   = t2.assetid 
AND t.assetdeptype   = t2.assetdeptype 
AND t2.currentdep  ='T');

commit;
timing stop


prompt delete Duplicates from ApprovedAssetDeps for target <ics:getvar name="targetid"/>
timing start del_time
select 'current time is ' || to_char(sysdate,'YYYY-MM-DD HH24:MI:SS') as cur from dual;

DELETE FROM ApprovedAssetDeps t 
WHERE t.targetid = <ics:getvar name="targetid" />
AND t.assetdeptype='E'
AND t.lastpub  ='F'
AND EXISTS (SELECT 1 FROM ApprovedAssetDeps t2 
WHERE t.ownerid = t2.ownerid 
AND t.targetid  = t2.targetid 
AND t.assetid   = t2.assetid 
AND t.assetdeptype   = t2.assetdeptype 
AND t2.lastpub  ='T');

commit;
timing stop

prompt delete Duplicates from ApprovedAssetDeps for target <ics:getvar name="targetid"/>
timing start del_time
select 'current time is ' || to_char(sysdate,'YYYY-MM-DD HH24:MI:SS') as cur from dual;


DELETE FROM ApprovedAssetDeps WHERE rowid IN (
SELECT rowid FROM ApprovedAssetDeps 
WHERE targetid = <ics:getvar name="targetid" />
GROUP BY rowid,ownerid,assetid,assetdeptype
minus
SELECT max(rowid) FROM ApprovedAssetDeps 
WHERE targetid = <ics:getvar name="targetid" />
GROUP BY ownerid,assetid,assetdeptype);

commit;
timing stop

</cs:ftcs>
