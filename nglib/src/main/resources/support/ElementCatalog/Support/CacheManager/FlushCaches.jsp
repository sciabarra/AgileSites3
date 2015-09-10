<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// Support/CacheManager/FlushCaches
//
// INPUT
//
// OUTPUT
//%>
<%@ page import="COM.FutureTense.Interfaces.FTValList" %>
<%@ page import="COM.FutureTense.Interfaces.ICS" %>
<%@ page import="COM.FutureTense.Interfaces.IList" %>
<%@ page import="COM.FutureTense.Interfaces.Utilities"
%><%@ page import="COM.FutureTense.Util.*"
%><%@ page import="java.util.*"
%><%@ page import="COM.FutureTense.Util.ftMessage"%>
<cs:ftcs>
<script language="JavaScript">
function checkall () {
    var obj = document.forms[0].elements[0];
    var formCnt = obj.form.elements.length;
    for (i=0; i<formCnt; i++) {
      if (obj.form.elements[i].name == "table")  {
         if (obj.form.elements[i].checked)
                obj.form.elements[i].checked=false;
         else
             obj.form.elements[i].checked=true;
      }
    }
}
</script>
<h3>Flush Tables</h3>
<%
String thisPage = ics.GetVar("pagename");
String cmd = ics.GetVar("cmd");
String tables = ics.GetVar("table");
if (tables != null){
%>
<table class="altClass">
<%

  int i=1;
  for (String key : tables.split(";")) {
       ftTimedHashtable ht = ftTimedHashtable.findHash(key);
       if (ht != null) {
           ht.clear();
           %><tr><td><%= i++ %></td><td>Flushing: <%= key %></td></tr><%
       }
   }
   %>
</table>
<% } %>
<satellite:form satellite="false" id="tableform" method="POST">
    <input type="hidden" name="pagename" value='<%=ics.GetVar("pagename") %>'/>
    <input type="hidden" name="cmd" value='<%=ics.GetVar("cmd") %>'/>
<a href="javascript:void(0);" onclick="return checkall()" onmouseover="window.status='Check all';return true;" onmouseout="window.status='';return true;">CheckAll</a>&nbsp;<input type="Submit" name="Submit" value="Flush"><br/><br/>
<% for (Object o: ftTimedHashtable.getAllCacheNames()){
        String key = (String)o;
        %><input name="table" type="checkbox" value='<%= key %>'/><%= key %><br/>
<% }%>
<br/><a href="javascript:void(0);" onclick="return checkall()" onmouseover="window.status='Check all';return true;" onmouseout="window.status='';return true;">CheckAll</a>&nbsp;<input type="Submit" name="Submit" value="Flush">
</satellite:form>
</cs:ftcs>
