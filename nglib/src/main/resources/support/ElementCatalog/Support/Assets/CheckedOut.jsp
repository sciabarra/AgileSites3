<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld"
%><%//
// Support/Assets/CheckedOut
//
// INPUT
//
// OUTPUT
//
%><%@ page import="COM.FutureTense.Interfaces.FTValList"
%><%@ page import="COM.FutureTense.Interfaces.ICS"
%><%@ page import="COM.FutureTense.Interfaces.IList"
%><%@ page import="COM.FutureTense.Interfaces.Utilities"
%><%@ page import="COM.FutureTense.Util.ftErrors"
%><%@ page import="COM.FutureTense.Util.ftMessage"
%><cs:ftcs><%

    StringBuffer errstr = new StringBuffer();
    ics.ClearErrno();
    int count=0;

IList revTracked = ics.SQL("RTInfo", "SELECT tblname FROM RTInfo ORDER BY tblname", "rtinfo", -1, true, errstr);

if (revTracked !=null && revTracked.hasData()){

    for (int i=1; i<= revTracked.numRows(); i++){
        revTracked.moveTo(i);
        String tablename = revTracked.getValue("tblname");
        %>Revision tracked table <b><%= tablename %></b><%
        IList locked = ics.SQL(tablename+"_t", "SELECT asset,versiondate,versionnum,lockedby,createdby,annotation FROM " + tablename +"_t WHERE lockedby !='DefaultReader'  ORDER BY asset ASC,versionnum DESC", tablename, -1, true, errstr);
        if (locked !=null && locked.hasData()){
            %><br/><table><%
            for (int j=1; j<= locked.numRows(); j++){
                locked.moveTo(j);
                %><tr><%
                %><td><%= tablename %></td><%
                %><td><%= locked.getValue("asset") %></td><%
                %><td><%= locked.getValue("versiondate") %></td><%
                %><td><%= locked.getValue("versionnum") %></td><%
                %><td><%= locked.getValue("lockedby") %></td><%
                %><td><%= locked.getValue("createdby") %></td><%
                %><td><%= locked.getValue("annotation") %></td><%
                %></tr><%
            }
            %></table><%
        }else {
            %> No rows locked<br/><%
        }
    }
} else {
    %>No tables are revision tracked.<%
}
%></cs:ftcs>