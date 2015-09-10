<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// Support/Audit/Default/FlushTables
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
<h2><center>Flush Tables</center></h2>
<%
String thisPage = ics.GetVar("pagename");
String cmd = ics.GetVar("cmd");
String tables = ics.GetVar("table");
if (tables != null){
%>
<table class="altClass">
<%
  java.util.StringTokenizer tz = new java.util.StringTokenizer(tables,";");
  int i=1;
  while (tz.hasMoreTokens()) {
      String token = tz.nextToken();
%>
    <tr><td><%= i++ %></td><td>Flushing: <%= token %></td><td><%= ics.FlushCatalog(token) %></td></tr>
<% } %>
</table>
<% } %>
<ics:sql sql="SELECT tblname FROM SystemInfo WHERE tblname !='SystemAssets' ORDER BY LOWER(tblname)" listname="catalogs" table="SystemInfo"/>
<satellite:form satellite="false" method="POST">
<input type="hidden" name="pagename" value="<%=thisPage %>"/>
<input type="hidden" name="cmd" value="<%=cmd %>"/>
&nbsp;<a href="javascript:void(0);" onclick="return checkall()" onmouseover="window.status='Check all';return true;" onmouseout="window.status='';return true;">CheckAll</a>
&nbsp;<input type="Submit" name="Submit" value="Flush"><hr/>
	<ics:listloop listname="catalogs">
		<input name="table" type="checkbox" value='<ics:resolvevariables name="catalogs.tblname"/>'/><ics:resolvevariables name="catalogs.tblname"/><br/>
	</ics:listloop><hr/>
&nbsp;<a href="javascript:void(0);" onclick="return checkall()" onmouseover="window.status='Check all';return true;" onmouseout="window.status='';return true;">CheckAll</a>
&nbsp;<input type="Submit" name="Submit" value="Flush">
</satellite:form>
</cs:ftcs>
