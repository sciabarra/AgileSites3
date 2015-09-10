<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"%>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"%>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld"%>
<%//
// Support/CacheManager/listPagename
//
// INPUT
//
// OUTPUT
//
%>
<%@ page import="COM.FutureTense.Interfaces.FTValList"%>
<%@ page import="COM.FutureTense.Interfaces.ICS"%>
<%@ page import="COM.FutureTense.Interfaces.IList"%>
<%@ page import="COM.FutureTense.Interfaces.Utilities"%>
<%@ page import="COM.FutureTense.Util.ftErrors"%>
<%@ page import="COM.FutureTense.Util.ftMessage"%>
<%@ page import="java.util.Map"%>
<%!
static String getRenderMode(String qs){
	Map map = Utilities.getParams(qs);
	String rm = (String)map.get("rendermode");
	if (rm == null) rm = "live";
	return rm;
}

static String isSS(String qs){
	Map map = Utilities.getParams(qs);
	return (String)map.get("ft_ss");
}

static String getPagename(String qs){
	Map map = Utilities.getParams(qs);
	return (String)map.get("pagename");
}

static String getQSStripped(String qs){
	Map map = Utilities.getParams(qs);
	map.remove("ft_ss");
	map.remove("rendermode");
	map.remove("pagename");
	return Utilities.stringFromValList(map);
}
%>
<cs:ftcs>
<h3>WebCenter Sites Cache</h3>

<% if ("full".equals(ics.GetVar("mode"))) { %>
<table class="altClass">
	<tr>
		<th>Pagename</th>	
		<th>Total</th>
	</tr>
    <ics:sql sql="SELECT id, count(page) AS num FROM SystemItemCache GROUP BY id ORDER BY num DESC, id" table="SystemItemCache" listname="items"/>
    <ics:listloop listname="items">
	<tr>
		<td><a href='ContentServer?pagename=CacheManager/listByItemPost&idlist=<ics:resolvevariables name="items.id"/>'><ics:resolvevariables name="items.id"/></a></td>	
		<td><ics:resolvevariables name="items.num"/></td>
	</tr>
    </ics:listloop>
    <ics:sql sql="SELECT count(id) AS num FROM SystemItemCache" table="SystemItemCache" listname="pages"/>
    <ics:listloop listname="pages">
	<tr>
		<td><b>Total</b></td>	
		<td><ics:resolvevariables name="pages.num"/></td>
	</tr>
    </ics:listloop>
</table>
<% } else { %>
<ics:sql sql='<%= ics.ResolveVariables("SELECT * FROM SystemPageCache WHERE pagename=\'Variables.pname\' ORDER BY etime") %>' table="SystemPageCache" listname="pages"/>
<table class="altClass">
	<tr>
		<th>Pagename</th>	
		<th>Rendermode</th>
		<th>SatS</th>		
		<th>QueryString (Remainder)</th>	
		<th>ModTime</th>
		<th>ExpiryTime</th>
	</tr>
	<ics:listloop listname="pages">
    <tr>
        <% String qs = ics.ResolveVariables("pages.@urlqry"); %>
        <td nowrap><a href='ContentServer?pagename=CacheManager/listItemsByPage&pid=<ics:resolvevariables name="pages.id"/>'><%= getPagename(qs) %></a></td>
        <td><%= getRenderMode(qs) %></td>
        <td><%= isSS(qs) %></td>
        <td><%= getQSStripped(qs) %></td>
        <!-- <ics:resolvevariables name="pages.@urlqry"/> -->
        <td nowrap><ics:resolvevariables name="pages.mtime"/></td>
        <td nowrap><ics:resolvevariables name="pages.etime"/></td>
    </tr>
	</ics:listloop>
</table>
<% } %>
</cs:ftcs>
