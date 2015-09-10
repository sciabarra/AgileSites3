<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// Support/Verify/Cluster/LockTest
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
<h3>File Lock test</h3>
<%
if (Utilities.fileLockLoadOK()) {

out.write("run: "+ ics.genID(true));
out.write("<br>");

out.write("request: " + request.getRequestURL().toString());
out.write("<br>");


String syncDir = ics.GetProperty("ft.usedisksync");

String fName = syncDir + "/locktest_lock";
out.write("lock file used : " + fName + " at " + new java.util.Date());
out.write("<br>");


boolean lockState = Utilities.lockFile(fName);

out.write("file locked: <b>" + lockState + "</b> on " + Thread.currentThread().getName() + " at " + new java.util.Date());
out.write("<br>");
if (lockState) {
        try {
                Thread.sleep(5000);
        } catch (Exception e){
                e.printStackTrace();
        }
        lockState=Utilities.unlockFile(fName);
        out.write("file unlocked: " + lockState + " on " + Thread.currentThread().getName() + " at " + new java.util.Date());
        out.write("<br>");
}

out.write("end");
out.write("<br>");

} else {

%><h2>Lock library not loaded</h2>Test did not continue<br><%

}
%>
</cs:ftcs>

