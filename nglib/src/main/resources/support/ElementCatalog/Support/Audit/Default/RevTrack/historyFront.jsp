<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="asset" uri="futuretense_cs/asset.tld" %>
<%//
// Support/Audit/V7/RevTrack/historyFront
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
<html><head><title>History cleanup</title></head><body>
<center><h4>Overview of Revision History</h4></center>
<%
    int pageSize = 1000;
    if(ics.UserIsMember("SiteGod")) {
        String table = ics.GetVar("table");
        if(table==null) {
    %>
            <ics:sql sql="select * from SystemInfo" listname="tableList" table="SystemInfo"/>
            <satellite:form satellite="false" method="POST">
                <input type="hidden" name="pagename" value="Support/Audit/DispatcherFront">
                <input type="hidden" name="cmd" value="RevTrack/historyFront">
                <select name="table">
                    <option value="">--Select a Table--</option>
                    <ics:listloop listname="tableList">
                      <ics:listget listname="tableList" fieldname="tblname" output="AssetType"/>
                      <ics:callelement element="OpenMarket/Xcelerate/Actions/RevisionTracking/CheckTrackingEnabled">
                          <ics:argument name="AssetType" value='<%=ics.GetVar("AssetType")%>'/>
                      </ics:callelement>
                      <%
                          if("true".equals(ics.GetVar("trackingenabled"))) {
                              %><option value='<%=ics.GetVar("AssetType")%>'><ics:getvar encoding="default" name="AssetType"/></option><%
                          }
                      %>
                    </ics:listloop>
                </select>
                <input type="submit" name="Select table to clean" value="Select Table">
            </satellite:form>
    <%
        } else {
            %>
<script language="JavaScript">
function debug(obj) {
    var dbg = document.getElementById("debug");
    for(i in obj) {
        dbg.value += i + "=" + obj[i] + "\n";
    }
}
function selectAll(val) {
    var obj = document.forms[0].elements[0];
    var formCnt = obj.form.elements.length;
    for (i=0; i<formCnt; i++) {
        if (obj.form.elements[i].name == "revasset")
            obj.form.elements[i].checked=val;
    }
}
function selectFirstFew() {
    var checkboxes = document.getElementsByName("revasset");
    var count=0;
    for(i in checkboxes) {
        if(count<100) {
            checkboxes[i].checked = true;
        }
        count++;
    }
}
</script>
            <%
            String showHistory = ics.GetVar("showHistory");
            if(!"true".equals(showHistory)) {
                showHistory = "false";
            }
            int pageNr = 0;
            try {
                pageNr = Integer.parseInt(ics.GetVar("pageNr"));
            } catch(Exception e) {
            }
            String sql = "select id, name from " + table + " order by id";
            %>
            <ics:sql sql='<%=sql%>' listname="assetList" table='<%=table%>'/>
            <satellite:form satellite="false" id="theForm" method="POST">
            <input type="hidden" name="table" value='<%=table%>'>
            <input type="hidden" name="pagename" value="Support/Audit/DispatcherFront">
            <input type="hidden" name="cmd" value="RevTrack/historyPost">
            <p>Number of revisions to keep:
            <select name="max">
            <option value="">--Select a number--</option>
            <%
                for(int i=1; i<30; i++) {
                    %><option value='<%=i%>'><%=i%></option><%
                }
            %>
            </select>
            <p><a href="javascript:selectAll(true)">SelectAll</a>
            &nbsp;&nbsp;<a href="javascript:selectAll(false)">SelectNone</a>
            &nbsp;&nbsp;<a href="javascript:selectFirstFew()">SelectFirst-100</a><br/>
            <table class="altClass">
            <tr><th>Delete?</th><th>Name</th><th>AssetID</th><th>Revisions</th></tr>
            <%
            IList list = ics.GetList("assetList");
            if(list!=null) {
                int start = pageNr*pageSize+1;
                int end = (pageNr+1)*pageSize;
                if(end>list.numRows()) {
                    end = list.numRows();
                }
                %><br/>Showing <%=start%> to <%=end%> out of <%=list.numRows()%> assets.<%
                for(int i=start; i<=end; i++) {
                    list.moveTo(i);
                    String id = list.getValue("id");
                    String name = list.getValue("name");
                    if("true".equals(showHistory)) {
                        %>
                        <ics:callelement element="Support/Audit/V7/RevTrack/getHistory">
                          <ics:argument name="table" value='<%=table%>'/>
                          <ics:argument name="assetid" value='<%=id%>'/>
                        </ics:callelement>
                        <%
                    }
                    %>
                <tr>
                    <td><input name='revasset' type='checkbox' value='<%=id%>'/></td>
                    <td><%=name%></td>
                    <td><%=id%></td>
                    <%
                    if("true".equals(showHistory)) {
                        IList historyList = ics.GetList("HistoryResults");
                        %><td><%=historyList!=null?historyList.numRows():0%></td><%
                    }
                    %></tr><%
                }
                %>Page: <%
                int pages = 1+(list.numRows()-1)/pageSize;
                for(int p=0; p<pages; p++) {
                    String url = "ContentServer?pagename="+ics.GetVar("pagename")+"&cmd="+ics.GetVar("cmd")+"&table="+table+"&pageNr="+p+"&showHistory="+showHistory;
                    %>&nbsp;<a href='<%=url%>'><%=p+1%></a><%
                }
              }
              %>
              </table>
                <br/><br/><input type="submit" name="Delete revisions" value="Delete revisions"/>
                <p>Force delete revisions, even if errors are encountered: <input type="checkbox" name="force" value="true"/>
                </p>
                </satellite:form>
            <%
        }
    } else {
        %>
        Please log in with a user with SiteGod privileges.
        <%
    }
%>
</body></html>
</cs:ftcs>
