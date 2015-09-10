<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" 
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" 
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" 
%><%//
// Support/TCPI/SQL/DelDupsEqual
//
// INPUT
//
// OUTPUT
//
%><%@ page import="COM.FutureTense.Interfaces.Utilities" 
%><%@ page import="java.util.*"
%><cs:ftcs>
prompt delete Duplicates from <ics:getvar name="tablename"/> ON <ics:getvar name="keys"/>
timing start del_time
select 'current time is ' || to_char(sysdate,'YYYY-MM-DD HH24:MI:SS') as cur from dual;
<%
StringBuffer sql= new StringBuffer("SELECT min(id) as minid, ");
sql.append(Utilities.replaceAll(ics.GetVar("keys"),";",","));
sql.append(" FROM ");
sql.append(ics.GetVar("tablename"));
sql.append(" WHERE ");
StringTokenizer tz = new StringTokenizer(ics.GetVar("equality"),";");
while(tz.hasMoreTokens()){
	String key = tz.nextToken();
	sql.append(key);
	if (tz.hasMoreTokens()) {
		sql.append(" AND ");
	}
}
sql.append(" GROUP BY ");
sql.append(Utilities.replaceAll(ics.GetVar("keys"),";",","));
sql.append(" HAVING count(id) > 1");

%>
<ics:sql sql='<%= sql.toString() %>' table='<%= ics.GetVar("tablename") %>' listname="dels" limit="5" />
<ics:listloop listname="dels">

DELETE FROM <%= ics.GetVar("tablename") %> 
WHERE id > <ics:listget listname="dels" fieldname="minid"/> AND 
<% tz = new StringTokenizer(ics.GetVar("equality"),";");
while(tz.hasMoreTokens()){
	String key = tz.nextToken();
	%><%= key %> 
<%	if (tz.hasMoreTokens()) {
		%>AND
<%
	}
}
%>AND
<% tz = new StringTokenizer(ics.GetVar("keys"),";");
while(tz.hasMoreTokens()){
	String key = tz.nextToken();
	%><%= key %>=<ics:listget listname="dels" fieldname='<= key >' />
<%	if (tz.hasMoreTokens()) {
		%>AND
<%
	}
}
%>
</ics:listloop>
commit;

timing stop
</cs:ftcs>

