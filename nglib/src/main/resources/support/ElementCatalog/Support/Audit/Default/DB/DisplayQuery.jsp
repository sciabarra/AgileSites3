<%@ page contentType="text/html; charset=utf-8"
%><%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%//
// Support/Audit/Default/DB/DisplayQuery
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
    String query = ics.GetVar("query");
    String table = ics.GetVar("table");
    String listname = null;
    StringBuffer errstr = new StringBuffer();
    ics.ClearErrno();
    int count=0;
    IList resultList = ics.SQL(table, query, listname, -1, true, errstr);
    if (ics.GetErrno()==0 && resultList.hasData()){
        int numrows = resultList.numRows();
        int numcols = resultList.numColumns();
        ics.SetVar("queryTotal",numrows);
        %>
        <table class="altClass">

        <tr>
        <th>Nr</th>
        <%
        for (int jj=0; jj< numcols; jj++){
            %><th><%= resultList.getColumnName(jj) %></th><%
        }
        %></tr>
        <%

        for (int i=1; i<=numrows; i++) {
            resultList.moveTo(i);
            %><tr><td><%= i %><%
            for (int j=0; j< numcols; j++){
                %><td><%= "" + resultList.getValue(resultList.getColumnName(j)) %></td><%
            }
            %></tr><%
        }
        %></table><%
    } else if (ics.GetErrno() == -101) {
        ics.SetVar("queryTotal",0);
        %>Query returned no rows<br><%

    } else if (ics.GetErrno() == -502) {
        ics.SetVar("queryTotal",0);
        %>Rows deleted<br><%
    } else if (ics.GetErrno() == -105) {
        ics.SetVar("queryTotal",0);
        %>Database error<br><%

    } else {
        ics.SetVar("queryTotal",0);
        %>db query returned errno: <ics:geterrno /> <br><%
    }
    ics.ClearErrno();
%>
</cs:ftcs>
