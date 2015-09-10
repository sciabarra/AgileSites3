<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// Support/Audit/V7/Publishing/cleanPubhistoryFront
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
<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>

<cs:ftcs>
    <center><h4>List of Pubsessions to delete</h4></center>
    <table class="altClass">
        <tr>
            <th>Pubsession</th>
            <th>Date</th>
            <th>Message</th>
            <th>Delete?</th>
        </tr>
        
        <% String s="SELECT ps.id AS id, ps.cs_sessiondate AS sessdate, pm.cs_text AS text FROM PubSession ps INNER JOIN PubMessage pm ON ps.id = pm.cs_sessionid"; %>
        <ics:sql sql='<%= s %>' table="PubSession" listname="temp" limit="0"/>
        <%
        IList list=ics.GetList("temp");
        //int i=list.currentRow();
        int i=1;
        if (!list.hasData()) {
        %><td>There is no pub sessions</td>
        <td></td><td></td><%
        } else {
            while (i<=list.numRows()) {
                
                list.moveTo(i);
                String id=list.getValue("id");
                String date=list.getValue("sessdate");
                String text=list.getValue("text");
                i++;
        %>
        <tr>
            <td><a href="ContentServer?pagename=Support/Audit/DispatcherFront&#38;cmd=Publishing/OpenHtml&#38;var=<%= id %>"><%= id %></a></td>
            <td><%= date %></td>
            <td><%= text %></td>
        <td><a href="ContentServer?pagename=Support/Audit/DispatcherFront&#38;cmd=Publishing/CleanPubhistory&#38;var=<%= id %>">Delete</a></td>     </tr>
        <%
            }
        }
        %>
    </table>
    <br/> Delete by Date <br/>
    <satellite:form satellite="false" method="post">
        <INPUT type="text" name="var">&nbsp;yyyy-mm-dd hh:mm:ss
        <input type="hidden" name="pagename" value="Support/Audit/DispatcherFront">
        <input type="hidden" name="cmd" value="Publishing/CleanPubhistory"><br/><br/>
        &nbsp;<INPUT type="submit" value="Send">&nbsp;<INPUT type="reset">
    </satellite:form>
    <br/>
    <a href="ContentServer?pagename=Support/Audit/DispatcherFront&#38;cmd=Publishing/CleanPubhistory&#38;var=all">DeleteAll</a>    
</cs:ftcs>

