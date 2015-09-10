<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
 %><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" 
 %><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" 
 %><%//
// Support/Audit/Default/cleanPubHistory
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
%><%@ page import="java.io.*"
%><%@ page import="java.util.*"
%><%@ page import="javax.naming.*" 
%><%@ page import="java.sql.*" 
%><%@ page import="javax.sql.*" 
%><%!
public boolean delete(String file) {
    boolean success = (new File(file)).delete();
    if (!success) {
        // Deletion failed
    }
    return success;
}

%>
<cs:ftcs>
    <h3 align="center">PubSessions deleted</h3>
    <table class="altClass">
        <tr>
            <th>Pubsession</th>
            <th>Deleted?</th>
        </tr>
        <%
        
        String var=ics.GetVar("var").trim();
        String workfolder;
        workfolder = ics.GetProperty("request.folder","batch.ini",true);
        boolean isNum;
        try {
            float i=Float.parseFloat(var);
            isNum=true;
        } catch (NumberFormatException e) {
            isNum=false;
            
        }
        if (isNum==true) {
            String s1="DELETE FROM PubSession WHERE id="+var;
            String s2="DELETE FROM PubMessage WHERE cs_sessionid="+var;
            String s3="DELETE FROM PubContext WHERE cs_sessionid="+var;
	        %>
	        <ics:sql sql='<%= s1 %>' table="PubSession" listname="temp1" limit="-1"/>
	        <ics:sql sql='<%= s2 %>' table="PubMessage" listname="temp2" limit="-1"/>
	        <ics:sql sql='<%= s3 %>' table="PubContext" listname="temp3" limit="-1"/>
	        <tr>
            <td>
                <%= var %>
            </td>
            <%
            String filepath=workfolder+var+"Output.html";
            if (!delete(filepath)) {
	            %><td>failed</td><%
            } else {
    	        %><td>success</td><%
            }
			%></tr><%            
        }
        if (isNum==false) {
        	String s;
            if (var.equals("all"))  //do all
            {
                s="SELECT id from PubSession";
            }else {
                s="SELECT id FROM PubSession WHERE cs_sessiondate < '"+var+"'";
            }
            %><ics:sql sql='<%= s %>' table="PubSession" listname="temp" limit="-1"/><%
            IList list=ics.GetList("temp");
            int i=1;
            if (!list.hasData()) {
	            %><tr><td>There are no pub sessions</td><td></td><td></td></tr><%
            } else {
                while (i<=list.numRows()) {
                    list.moveTo(i);
                    String sid=list.getValue("id");
                    String s1="DELETE FROM PubSession WHERE id="+sid;
                    String s2="DELETE FROM PubMessage WHERE cs_sessionid="+sid;
                    String s3="DELETE FROM PubContext WHERE cs_sessionid="+sid;
                    i++;
		            %>
		            <ics:sql sql='<%= s1 %>' table="PubSession" listname="temp1" limit="1"/>
		            <ics:sql sql='<%= s2 %>' table="PubMessage" listname="temp2" limit="1"/>
		            <ics:sql sql='<%= s3 %>' table="PubContext" listname="temp3" limit="1"/>
		            <tr>
	                <td><%= sid %></td>
	                <%
	                String filepath=workfolder+sid+"Output.html";
	                if (!delete(filepath)) {
	                	%><td>failed</td><%
	                } else {
	           			%><td>success</td><%
	                }
	                %></tr><%
		         }
            }
        }
    %></table>
</cs:ftcs>
