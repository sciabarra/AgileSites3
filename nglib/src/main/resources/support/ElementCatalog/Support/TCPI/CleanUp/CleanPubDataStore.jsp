<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld"
%><%@ page import="COM.FutureTense.Interfaces.FTValList"
%><%@ page import="COM.FutureTense.Interfaces.ICS"
%><%@ page import="COM.FutureTense.Interfaces.IList"
%><%@ page import="COM.FutureTense.Interfaces.Utilities"
%><%@ page import="COM.FutureTense.Util.ftErrors"
%><%@ page import="COM.FutureTense.Util.ftMessage"
%><cs:ftcs><%

String version = ics.GetProperty("ft.version");

boolean delete = "true".equals(ics.GetVar("delete"));

%><h3>Cleaning up FW_PubDataStore table</h3>
<ics:clearerrno />

<ics:sql sql='SELECT count(id) AS num FROM FW_PubDataStore' table='FW_PubDataStore' listname="runningcount"/>
Number of rows in FW_PubDataStore: <b><ics:listget listname="runningcount" fieldname="num"/></b><br/>

<ics:clearerrno /><%
if (delete){
    %><ics:sql sql='DELETE FROM FW_PubDataStore WHERE NOT EXISTS (SELECT 1 FROM PubSession WHERE id = FW_PubDataStore.PUBSESSION)' table='FW_PubDataStore' listname="tcount"/>
    <ics:clearerrno />
    <ics:sql sql='SELECT count(id) AS num FROM FW_PubDataStore' table='FW_PubDataStore' listname="runningcount"/>
    Number of rows in FW_PubDataStore after cleanup: <b><ics:listget listname="runningcount" fieldname="num"/></b><br/><%
} else {
    %><satellite:form satellite="false" name="sqlplus" method="POST">
    <input type='hidden' name='pagename' value='<%= ics.GetVar("pagename") %>'/>
    <input type='hidden' name='delete' value='true'/>
    <input type='submit' value='Clean FW_PubDataStore'/>
    </satellite:form>
    <p>If there are a lot of rows in the FW_PubDataStore the delete statement will be lengtly and will probably timeout. Better is to clean the table via direct sql by selecting smaller chunks based on time ranges via the PubSession table. For instance for oracle:
    <span style="white-space:pre; font-family:monospace">
    DELETE FROM FW_PubDataStore WHERE NOT EXISTS (SELECT 1 FROM PubSession WHERE id = FW_PubDataStore.PUBSESSION AND cs_sessiondate < sysdate - 100)
    DELETE FROM FW_PubDataStore WHERE NOT EXISTS (SELECT 1 FROM PubSession WHERE id = FW_PubDataStore.PUBSESSION AND cs_sessiondate < sysdate - 90)
    </span>. Continue with lowering the timerange till today.<%
}
%></cs:ftcs>
