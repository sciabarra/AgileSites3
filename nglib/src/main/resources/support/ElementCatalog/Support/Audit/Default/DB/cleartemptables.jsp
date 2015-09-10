<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ page import="COM.FutureTense.Interfaces.FTValList" %>
<%@ page import="COM.FutureTense.Interfaces.ICS" %>
<%@ page import="COM.FutureTense.Interfaces.IList" %>
<%@ page import="COM.FutureTense.Interfaces.Utilities" %>
<%@ page import="COM.FutureTense.Util.ftErrors" %>
<%@ page import="COM.FutureTense.Util.ftMessage"%>
<cs:ftcs>
<h4>List Temporary Tables.</h4>
<pre>
TT tables can be referenced in two places
1) in SystemInfo
2) in the database
If a tt-table is referenced in SystemInfo and is present in the DB you can use CatalogMover to deleted the temp tables.
In other cases, you will need to delete from them the database directly.

by doing:
1) delete from SystemInfo where systable in ('tmp','tmpt'))
2) drop table xxx;

If you are dropping the tt-tables please be sure that no other activity is on the system.
Best is to do a restart of the appserver after the changes in the db.
</pre>

<br/><h4>From SystemInfo</h4>

<% String query = "select tblname from SystemInfo where systable in ('tmp','tmpt')"; %>
<p><%= query %></p>
    <ics:callelement element="Support/Audit/Default/DB/DisplayQuery">
        <ics:argument name="query" value='<%= query %>' />
        <ics:argument name="table" value="SystemInfo" />
    </ics:callelement>

<br/><h4>From DB</h4>
<%
    if (ics.GetProperty("cs.dbtype").indexOf("Oracle")!=-1) {
       query ="select OBJECT_NAME, OBJECT_TYPE, CREATED FROM USER_OBJECTS WHERE OBJECT_TYPE='TABLE' AND OBJECT_NAME LIKE ('TT%') AND CREATED < (SYSDATE-1) ORDER BY OBJECT_NAME";
    }
    else {
         query ="SELECT name FROM sysobjects WHERE uid=101 AND type='U' AND LOWER(name) like ('tt%')";
    }
%>
<p><%= query %></p>
    <ics:callelement element="Support/Audit/Default/DB/DisplayQuery">
        <ics:argument name="query" value='<%= query %>' />
        <ics:argument name="table" value="SystemInfo" />
    </ics:callelement>

</cs:ftcs>
