<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// Support/Verify/Cluster/CheckSyncdirTime
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
<%@ page import="java.io.File" %>
<%@ page import="java.io.FileOutputStream" %>
<%@ page import="java.util.Date" %>
<cs:ftcs>
<h4>Test timstamps of files in sync dir</h4>
<div>It is now: <%= new java.util.Date() %></div><br><%
String syncDir = ics.GetProperty("ft.usedisksync");
if (syncDir == null || syncDir.length() ==0) {
    %><br><br>ft.usedisksync is not defined in the futuretense.ini.<br><br><%
} else {
    String filename = null;
    filename = "synctest";
    String syncFileName = syncDir + File.separatorChar + "event" + File.separatorChar + filename;
    File syncFile = new File(syncFileName);
    if (syncFile.exists()){
        long lastTouched = 0L;
        try {
            lastTouched = syncFile.lastModified();
            Date date = new Date(lastTouched);
            %>Last checked time for [<%= syncFileName %>]:<%= date.toString() %><br><%
        }  catch(Exception e)  {
            lastTouched = 0L;
            %>IOException checking last modified time for [<%= syncFileName %>]: <%= e.getMessage() %><br><%
        }
    }
    try  {
        FileOutputStream stream = new FileOutputStream(syncFile);
        stream.write(32);
        stream.close();
        %>Updated last modified time for [<%= syncFileName %>].<br><%
    } catch(Exception e) {
        %>IOException updating last modified time for [<%= syncFileName %>]: <%= e.getMessage() %><br><%
    }
    if (syncFile.exists()){
        long lastTouched = 0L;
        try {
            lastTouched = syncFile.lastModified();
            Date date = new Date(lastTouched);
            %>Last checked time for [<%= syncFileName %>]:<%= date.toString() %><br><%
        }  catch(Exception e)  {
            lastTouched = 0L;
            %>IOException checking last modified time for [<%= syncFileName %>]: <%= e.getMessage() %><br><%
        }
    }
}
%>
</cs:ftcs>
