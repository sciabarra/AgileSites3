<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// Support/Audit/V7/RevTrack/historyPost
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
<%@ page import="java.util.*"%>
<cs:ftcs>
<center><h4>Delete Revision History</h4></center>
<%
    if(ics.UserIsMember("SiteGod")) {
        String table = ics.GetVar("table");
        int max = -1;
        try {
            max = Integer.parseInt(ics.GetVar("max"));
        } catch(NumberFormatException nfe) {
            // ignore
        }
        if(table!=null && max>0) {
            String force = ics.GetVar("force");
            %><p>Deleting revisions for asset type <%=table%>. Keeping at most <%=max%> revisions for each asset...<%
            String sql = "select defdir from SystemInfo where tblname = '" + table + "_History'";
            %><ics:sql sql='<%=sql%>' table="SystemInfo" listname="historyTable"/><%
            IList list = ics.GetList("historyTable");
            String defDir = "";
            if(list!=null && list.numRows()==1) {
                list.moveTo(1);
                defDir = list.getValue("defdir");
            }
            String ids = ics.GetVar("revasset");
            StringTokenizer tok = new StringTokenizer(ids, ";");
            while(tok.hasMoreTokens()) {
                String id = tok.nextToken();
                %>
                <p><%=table%> id <%=id%>:
                <ics:callelement element="Support/Audit/V7/RevTrack/getHistory">
                  <ics:argument name="table" value='<%=table%>'/>
                  <ics:argument name="assetid" value='<%=id%>'/>
                </ics:callelement>
                <%
                IList historyList = ics.GetList("HistoryResults");
                TreeSet versions = new TreeSet();
                for(int r=1; historyList!=null && r<=historyList.numRows(); r++) {
                    historyList.moveTo(r);
                    Integer version = Integer.valueOf(historyList.getValue("versionnum"));
                    versions.add(version);
                }
                int count=0;
                Iterator iVersions = versions.iterator();
                for(int i=0; i<versions.size()-max; i++) {
                    count++;
                    Integer version = (Integer)iVersions.next();
                    %><br>Deleting <%=id%> version <%=version%>...<%
                    %>
                    <ics:callelement element="Support/Audit/V7/RevTrack/deleteHistoryVersion">
                      <ics:argument name="table" value='<%=table%>'/>
                      <ics:argument name="assetid" value='<%=id%>'/>
                      <ics:argument name="version" value='<%=version.toString()%>'/>
                      <ics:argument name="defdir" value='<%=defDir%>'/>
                      <ics:argument name="force" value='<%=force%>'/>
                    </ics:callelement>
                    <%
                }
                %><br><%=count%> out of <%=versions.size()%> revisions deleted.<%
            }
        }
    }
%>
</cs:ftcs>
