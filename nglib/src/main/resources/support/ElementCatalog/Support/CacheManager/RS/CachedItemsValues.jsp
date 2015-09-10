<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="string" uri="futuretense_cs/string.tld"
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld"
%><%//
// Support/CacheManager/RS/CachedItems
//
// INPUT
//
// OUTPUT
//%>
<%@ page import="COM.FutureTense.Interfaces.FTValList"
%><%@ page import="COM.FutureTense.Interfaces.ICS"
%><%@ page import="COM.FutureTense.Interfaces.IList"
%><%@ page import="COM.FutureTense.Interfaces.Utilities"
%><%@ page import="COM.FutureTense.Util.ftErrors"
%><%@ page import="COM.FutureTense.Util.ftMessage"
%><%@ page import="COM.FutureTense.Util.ftTimedHashtable"
%><%@ page import="com.fatwire.cs.core.cache.RuntimeCacheStats"
%><%@ page import="java.util.*"
%><%@ page import="java.text.*"
%><cs:ftcs>
<h3>Resultset Cache Profiler - Item Detail View for <string:stream variable="key"/></h3>
    <table class="altClass">
    <%
        DateFormat df = new SimpleDateFormat("yy/MM/dd HH:mm:ss");
        Date now = new Date();
        String key = ics.GetVar("key");
        ftTimedHashtable ht = null;
        if (key !=null){
            ht=ftTimedHashtable.findHash(key);
        }
        if (ht != null) {  %>
            <tr>
                <th>Nr</th>
                <th>Class</th>
                <th>hasData</th>
                <th>Rows</th>
                <th>Columns</th>
                <th>toString()</th>
            </tr>
            <%
            int i=1;
            for (Enumeration e = ht.elements(); e.hasMoreElements() && i < 1500;){
                Object item = e.nextElement();
                %><tr><td><%= Integer.toString(i++) %></td><%
                if (item ==null) {
                    %><td colspan="6">null</td><%
                }else {
                    %><td colspan="1"><%= (item instanceof IList) ? "IList" : item.getClass().getName() %></td><%
                    %><td colspan="1"><%= (item instanceof IList) ? ((IList)item).hasData() :"" %></td><%
                    %><td colspan="1"><%= (item instanceof IList) ? ((IList)item).numRows() :"" %></td><%
                    %><td colspan="1"><%= (item instanceof IList) ? ((IList)item).numColumns() :"" %></td><%
                    %><td colspan="1"><%= (item instanceof IList) ? "" : item%></td><%
                }
                %></tr>
            <% }
        } else {
            %><tr><td><string:stream variable="key"/> not found</td></tr><%
        }
         %>
    </table>
</cs:ftcs>
