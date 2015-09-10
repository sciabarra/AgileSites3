<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// Support/Audit/Default/Indices
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
String dbType = ics.GetProperty("cs.dbtype");
String defaultElementName = null;
if (dbType.equals("Oracle")) {
    defaultElementName = "Support/Audit/Default/IndicesOracle";
}
else if (dbType.equals("DB2")) {
    defaultElementName = "Support/Audit/Default/IndicesDB2";
}
else if (dbType.equals("SQLAnywhere")) {
    defaultElementName = "Support/Audit/Default/IndicesSQLAnywhere";
}
else {
    defaultElementName = "Support/Audit/Default/IndicesJDBC";
}

if (ics.IsElement(defaultElementName)) {
	ics.CallElement(defaultElementName,null);
} else {
	%>There is no element to display the indices on your database type (<%= dbType %>).<br><%
}
%>
</cs:ftcs>