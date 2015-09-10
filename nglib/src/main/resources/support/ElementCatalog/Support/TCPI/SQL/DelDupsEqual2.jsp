<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" 
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" 
%><%//
// Support/TCPI/SQL/DelDupsEqual
//
// INPUT
//
// OUTPUT
//
%><%@ page import="COM.FutureTense.Interfaces.Utilities,java.util.*" 
%><cs:ftcs>
prompt delete Duplicates from <ics:getvar name="tablename"/> ON <ics:getvar name="keys"/>
timing start del_time
select 'current time is ' || to_char(sysdate,'YYYY-MM-DD HH24:MI:SS') as cur from dual;

DELETE FROM <%= ics.GetVar("tablename") %> WHERE rowid IN (
SELECT rowid FROM <%= ics.GetVar("tablename") %> 
WHERE 
<%
StringTokenizer tz = new StringTokenizer(ics.GetVar("equality"),";");
while(tz.hasMoreTokens()){
	String key = tz.nextToken();
	%><%= key %> 
<%	if (tz.hasMoreTokens()) {
		%>AND
<%
	}
}
%>GROUP BY rowid,<%= Utilities.replaceAll(ics.GetVar("keys"),";",",") %>
minus
SELECT min(rowid) FROM <%= ics.GetVar("tablename") %> 
WHERE
<%
tz = new StringTokenizer(ics.GetVar("equality"),";");
while(tz.hasMoreTokens()){
	String key = tz.nextToken();
	%><%= key %> 
<%	if (tz.hasMoreTokens()) {
		%>AND
<%
	}
}
%>GROUP BY <%= Utilities.replaceAll(ics.GetVar("keys"),";",",") %>);
commit;

timing stop
</cs:ftcs>

