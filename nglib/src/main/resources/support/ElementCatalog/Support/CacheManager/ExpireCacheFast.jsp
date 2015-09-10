<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld"
%><%//
// Support/CacheManager/blowCacheFast
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
<%@ page import="COM.FutureTense.Util.ftStatusCode"%>
<%@ page import="COM.FutureTense.Cache.*"%>
<%@ page import="java.util.*"%>
<cs:ftcs>
<h3>Expire System PageCache</h3>
<%
String thisPage = ics.GetVar("pagename");
if (ics.GetVar("expire")!=null) {
%>
<br/>

<ics:sql sql="DELETE FROM SystemItemCache" listname="blowlist" table="SystemItemCache"/>
SystemItemCache Errno: <ics:geterrno/> (-502 is ok)<br>
<ics:flushcatalog catalog="SystemItemCache"/>

<ics:sql sql="UPDATE SystemPageCache SET etime = {d '1999-01-01'}" listname="blowlist" table="SystemPageCache"/>
SystemPageCache Errno: <ics:geterrno/> (-502 is ok)<br>
<ics:flushcatalog catalog="SystemPageCache"/>

<ics:clearerrno/>
<a href="CacheServer">Cleanup expired files</a><br/>
<%} else { %>
<br/>
<ics:sql sql="SELECT count(*) as itemnum FROM SystemItemCache" listname="itemlist" table="SystemItemCache"/>
Total <b><ics:listget listname="itemlist" fieldname="itemnum"/></b> SystemItemCache rows will be deleted.<br/>
<ics:sql sql='<%= "SELECT count(*) as pagenum FROM SystemPageCache WHERE etime > {d \'"+ Calendar.getInstance().get(Calendar.YEAR) +"-01-01\'}" %>' listname="pagelist" table="SystemPageCache"/>
Total <b><ics:listget listname="pagelist" fieldname="pagenum"/></b> SystemPageCache (with filesystem data) will be expired.
<satellite:form satellite="false" method="POST">
<input type="hidden" name="pagename" value='<%=thisPage %>'/>
<b>Do you want to expire all cache? </b>&nbsp;<input type="Submit" name="expire" value="Expire"><br/>
</satellite:form>
<% } %>
</cs:ftcs>
