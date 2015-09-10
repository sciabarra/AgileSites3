<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%//
// Support/TCPI/SQL/ApprovedAssetDepsAlignment
//
// INPUT
//
// OUTPUT
//
%><cs:ftcs>
<ics:callelement element="Support/TCPI/SQL/SQLScriptHeader">
    <ics:argument name="scriptname" value="ApprovedAssetDeps-Alignment"/>
</ics:callelement>

<ics:sql sql="SELECT id from PubTarget order by id" table="PubTarget" listname="targets"/>
<ics:listloop listname="targets">
prompt update misaligned ApprovedAssetDeps ON <ics:listget listname="targets" fieldname="id"/>
select 'current time is ' || to_char(sysdate,'YYYY-MM-DD HH24:MI:SS') as cur from dual;
timing start del_orphans
UPDATE ApprovedAssetDeps SET targetid = <ics:listget listname="targets" fieldname="id"/> WHERE targetid <> <ics:listget listname="targets" fieldname="id"/> AND EXISTS (SELECT 1 FROM ApprovedAssets WHERE ApprovedAssetDeps.ownerid = ApprovedAssets.id AND ApprovedAssets.targetid =  <ics:listget listname="targets" fieldname="id"/>);
commit;
timing stop
</ics:listloop>

prompt delete orphant ApprovedAssetDeps
select 'current time is ' || to_char(sysdate,'YYYY-MM-DD HH24:MI:SS') as cur from dual;
timing start del_orphans
DELETE FROM ApprovedAssetDeps WHERE NOT EXISTS (SELECT 1 FROM ApprovedAssets WHERE ApprovedAssetDeps.ownerid = id;
commit;
timing stop

prompt delete orphant PublishedAssets
select 'current time is ' || to_char(sysdate,'YYYY-MM-DD HH24:MI:SS') as cur from dual;
timing start del_orphans

DELETE FROM PublishedAssets where NOT EXISTS (SELECT 1 FROM PubKeyTable WHERE id = PublishedAssets.pubkeyid) ;
commit;
timing stop


prompt delete orphant PubContexts
select 'current time is ' || to_char(sysdate,'YYYY-MM-DD HH24:MI:SS') as cur from dual;
timing start del_orphans

DELETE FROM PubContext WHERE NOT EXISTS (SELECT 1 FROM PubSession WHERE context=PubContext.id);
commit;
timing stop

prompt delete orphant PubMessages
select 'current time is ' || to_char(sysdate,'YYYY-MM-DD HH24:MI:SS') as cur from dual;
timing start del_orphans

DELETE FROM PubMessage WHERE NOT EXISTS (SELECT 1 FROM PubSession WHERE id=PubMessage.sessionid);
commit;
timing stop

<ics:callelement element="Support/TCPI/SQL/SQLScriptFooter"/>
</cs:ftcs>