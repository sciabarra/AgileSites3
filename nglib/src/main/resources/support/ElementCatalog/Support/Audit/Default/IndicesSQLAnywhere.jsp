<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// Support/Audit/Default/IndicesSQLAnywhere
//
// INPUT
//
// OUTPUT
//%>
<%@ page import="COM.FutureTense.Interfaces.FTValList" %>
<%@ page import="COM.FutureTense.Interfaces.ICS" %>
<%@ page import="COM.FutureTense.Interfaces.IList" %>
<%@ page import="COM.FutureTense.Interfaces.Utilities" %>
<%@ page import="COM.FutureTense.Util.ftErrors" %>
<%@ page import="COM.FutureTense.Util.ftMessage"%>
<cs:ftcs>
<% 
String query = "SELECT t.table_name as tblname, i.index_name as indexname, c.column_name as columnname, ic.sequence as sequence FROM systable t, sysixcol ic, sysindex i,  syscolumn c "
+" WHERE "
+"t.creator = 101 "
+"AND t.table_id =  c.table_id  "
+"AND t.table_id =  ic.table_id  "
+"AND t.table_id =  i.table_id  "
+"AND ic.index_id = i.index_id  "
+"AND ic.column_id = c.column_id "
+"ORDER BY LOWER(t.table_name), i.index_name, ic.sequence,c.column_name";
%>
<h3><center>Lists all indexes</center></h3>
<ics:callelement element="Support/Audit/Default/DB/DisplayQuery">
	<ics:argument name="query" value='<%= query %>' />
	<ics:argument name="table" value='SystemInfo' />
</ics:callelement>

</cs:ftcs>
