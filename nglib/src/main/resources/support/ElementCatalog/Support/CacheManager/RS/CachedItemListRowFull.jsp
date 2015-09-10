<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld"
%><%//
// Support/CacheManager/RS/CachedItemList
//
// INPUT
//
// OUTPUT
//
%><%@ page import="COM.FutureTense.Interfaces.ICS"
%><%@ page import="COM.FutureTense.Interfaces.IList"
%><%@ page import="COM.FutureTense.Interfaces.Utilities"
%><%@ page import="COM.FutureTense.Util.ftTimedHashtable"
%><%@ page import="java.util.*"
%><%@ page import="java.text.*"
%><cs:ftcs><html><head><%
%><satellite:link pagename="Support/css" satellite="true"><satellite:argument name="v" value='<%= ics.GetVar("v") %>'/></satellite:link><%
%><link rel="stylesheet" href='<%=ics.GetVar("referURL")%>' type="text/css" media="screen"/></head><body><%
String key = ics.GetVar("key");
String item = ics.GetVar("item");
int maxRows = 10;
try {
  maxRows = Integer.parseInt(ics.GetVar("maxrows"));
} catch(Exception e) {
}
ftTimedHashtable ht = ftTimedHashtable.findHash(key);
Object rsItem = ht!=null?ht.get(item):null;
if(rsItem instanceof IList) {
    %><table style="border: 3px; width=300px;"><%
    IList list = (IList)rsItem;
    String[] column = new String[list.numColumns()];
    %><tr><%
    for(int c=0; c<list.numColumns(); c++) {
        column[c] = list.getColumnName(c);
        %><th><%=column[c]%></th><%
    }
    %></tr><%
    int max = list.numRows();
    if(max==0) {
      %><td colspan='<%= Integer.toString(column.length) %>'>No rows</td><%
    }

    if(maxRows>=0) {
        max = Math.min(max, maxRows);
    }
    for(int r=1; r<=max; r++) {
        list.moveTo(r);
        %><tr><%
        for(int c=0; c<list.numColumns(); c++) {
        String value = list.getValue(column[c]);
        %><td><%=value%></td><%
        }
        %></tr><%
    }
    %></table><%

    if(max<list.numRows()) {
      %><%= (list.numRows()-max) %> more...<%
    }
} else {
    %>Unable to show contents. <%=rsItem==null?"Item is null":rsItem.getClass().getName() + " is not an IList"%>.<%
}
%></body></html></cs:ftcs>
