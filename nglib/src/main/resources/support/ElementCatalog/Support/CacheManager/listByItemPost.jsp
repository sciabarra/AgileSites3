<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"%>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"%>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld"%>
<%//
// Support/CacheManager/flushByItemPost
//
// INPUT
//
// OUTPUT
//
%>
<%@ page import="java.util.StringTokenizer"%>
<%@ page import="COM.FutureTense.Interfaces.FTValList"%>
<%@ page import="COM.FutureTense.Interfaces.ICS"%>
<%@ page import="COM.FutureTense.Interfaces.IList"%>
<%@ page import="COM.FutureTense.Interfaces.Utilities"%>
<%@ page import="COM.FutureTense.Util.ftErrors"%>
<%@ page import="COM.FutureTense.Util.ftMessage"%>
<%@ page import="COM.FutureTense.Util.ftStatusCode"
%><%@ page import="java.util.Date"
%><%@ page import="com.fatwire.cs.core.db.Util"
%><cs:ftcs>
<h3>List Pages by Item</h3><BR/>
<%
String idval = ics.GetVar("idlist");
String errorMsg = null;

if (!Utilities.goodString(idval)){
    ics.SetErrno(ftErrors.badparams);
    errorMsg="You must specify at least one ID to list";
} else {
    String idList = Utilities.replaceAll(idval,";","','");
    idList = "'"+ idList +"'";
    Date now = new Date();
%>
    <ics:sql sql='<%= "SELECT SystemItemCache.id as id, SystemPageCache.id as pid, SystemPageCache.urlqry, SystemPageCache.mtime,SystemPageCache.etime FROM SystemPageCache, SystemItemCache WHERE SystemItemCache.page = SystemPageCache.id AND SystemItemCache.id IN (" + idList +") ORDER BY id,mtime" %>' table="SystemPageCache,SystemItemCache" listname="pages" limit="1000"/>
    <% if (ics.GetList("pages").numRows() ==1000) {%><p>Limiting output to 1000 rows.</p><%}%>
    <table class="altClass">
        <tr>
            <th widht="5%">Nr</th>
            <th width="30%">Asset</th>
            <th width="20%">ModTime</th>
            <th width="45%">Query String</th>
        </tr>
        <ics:listloop listname="pages">
        <tr <%= now.after(Util.parseJdbcDate(ics.ResolveVariables("pages.etime"))) ? "style='background-color:red'":"" %>>
            <td nowrap align="right"><ics:resolvevariables name="pages.#curRow"/></td>
            <td nowrap><ics:resolvevariables name="pages.id"/></td>
            <td nowrap><ics:resolvevariables name="pages.mtime"/></td>
            <td><a href='ContentServer?pagename=Support/CacheManager/listItemsByPage&pid=<ics:resolvevariables name="pages.pid"/>'><ics:resolvevariables name="pages.@urlqry"/></a></td>
        </tr>
        </ics:listloop>
    </table>
<%
    ics.ClearErrno();
}
%>

<% if (ics.GetErrno() < 0) { %>
    Error: <%=errorMsg%>
<% } %>
</cs:ftcs>
