<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" 
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" 
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" 
%><%//
// Support/TCPI/SQL/DelDups
//
// INPUT
//
// OUTPUT
//
%><%@ page import="COM.FutureTense.Interfaces.Utilities" 
%><%@ page import="java.util.*"%>
<cs:ftcs>
prompt delete Duplicates from <ics:getvar name="tablename"/> ON <ics:getvar name="keys"/>
timing start del_time
select 'current time is ' || to_char(sysdate,'YYYY-MM-DD HH24:MI:SS') as cur from dual;

DELETE FROM
<%= ics.GetVar("tablename") %> A
WHERE
A.rowid >
ANY (SELECT B.rowid
FROM
<%= ics.GetVar("tablename") %> B
WHERE
<%
StringTokenizer tz = new StringTokenizer(ics.GetVar("keys"),";");
while(tz.hasMoreTokens()){
	String key = tz.nextToken();
	%>A.<%= key %> = B.<%= key 
%><%	if (tz.hasMoreTokens()) { %>AND
<%	}
}
%>);
commit;
timing stop
</cs:ftcs>
