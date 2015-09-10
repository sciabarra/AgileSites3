<%@ page contentType="text/html; charset=utf-8"
%><%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld"
%><%//
// Support/DB/Queries
//
// INPUT
//
// OUTPUT
//
%><%@ page import="COM.FutureTense.Interfaces.FTValList"
%><%@ page import="COM.FutureTense.Interfaces.ICS"
%><%@ page import="COM.FutureTense.Interfaces.IList"
%><%@ page import="COM.FutureTense.Interfaces.Utilities"
%><%@ page import="COM.FutureTense.Util.ftErrors"
%><%@ page import="COM.FutureTense.Util.ftMessage"
%><cs:ftcs>
<center><h3>WebCenter Sites Queries</h3></center>
<%
String queryid = ics.GetVar("queryid");

String query[][] = {
{"SELECT pagename, rootelement FROM  SiteCatalog WHERE rootelement NOT IN (SELECT elementname FROM ElementCatalog)","SiteCatalog","Shows SiteCatalog entries without a rootelement"},
{"SELECT DISTINCT acl FROM SiteCatalog s","SiteCatalog","Shows distinct acls FROM the SiteCatalog" },
{"SELECT tblname,acl  FROM SystemInfo ORDER BY acl, tblname","SystemInfo","Shows acl's for tablenames"},
{"SELECT acl, count(pagename) as num  FROM  SiteCatalog s GROUP BY acl ORDER  BY acl","SiteCatalog","Shows number of SiteCatalog entries per acl"},
{"SELECT * FROM SiteCatalog s WHERE pagecriteria is not null  ORDER BY LOWER(cscacheinfo)","SiteCatalog","Shows SiteCatalog enrties with PageCriteria defined"},
{"SELECT DISTINCT cscacheinfo,sscacheinfo  FROM  SiteCatalog s ORDER BY cscacheinfo","SiteCatalog","Shows cacheinfo entries."},
{"SELECT DISTINCT csstatus  FROM  SiteCatalog s ORDER BY s.csstatus","SiteCatalog","Shows distinct csstatusses FROM SiteCatalog"}
};

if (queryid!=null){
    int qid = Integer.parseInt(queryid);
    if (qid >=0 && qid < query.length) {
        %>
        <h4><%= query[qid][2] %></h4>
        <%= query[qid][0] %><br>
        <ics:callelement element="Support/Audit/Default/DB/DisplayQuery">
            <ics:argument name="query" value='<%= query[qid][0] %>' />
            <ics:argument name="table" value='<%= query[qid][1] %>' />
        </ics:callelement>
        <br>
        <%
        if (qid > 0) {
            %><a href='ContentServer?pagename=Support/Audit/DispatcherFront&#38;cmd=DB/Queries&#38;queryid=<%= (qid - 1) %>'>Previous</a>&nbsp;<%
        }
         if (qid < query.length -1) {
            %><a href='ContentServer?pagename=Support/Audit/DispatcherFront&#38;cmd=DB/Queries&#38;queryid=<%= (qid + 1) %>'>Next</a><%
        }
        %><br><%
    }
}
%><table class="altClass"><%
for (int i=0; i< query.length; i++){
    %><tr>
    <td><a href='ContentServer?pagename=Support/Audit/DispatcherFront&#38;cmd=DB/Queries&#38;queryid=<%=i %>'>Query <%= i %></a></td>
    <td><%= query[i][2] %></td>
    </tr>
<% } %></table><%

%>
</cs:ftcs>
