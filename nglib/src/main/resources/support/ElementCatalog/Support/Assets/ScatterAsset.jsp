<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld"
%><%@ taglib prefix="asset" uri="futuretense_cs/asset.tld"
%><%//
// Support/Assets/ScatterAsset
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
%><%@ page import="java.util.*"
%><cs:ftcs><h3>Load Asset</h3>
<satellite:form satellite="false" method="GET">
<input type="hidden" name="pagename" value='<%= ics.GetVar("pagename") %>'/>
<input type="hidden" name="cmd" value='<%= ics.GetVar("cmd") %>'/>
Asset Type: <input type="text" name="assettype" /> Asset ID: <input type="text" name="assetid" /><br/>
<input type="submit" value="Submit"/><br/>
</satellite:form>
<br/>
<%
if (ics.GetVar("assettype") != null && !ics.GetVar("assettype").equals("") && ics.GetVar("assetid") != null && !ics.GetVar("assetid").equals("")) {
    %><asset:load name="theAsset" type='<%=ics.GetVar("assettype")%>' objectid='<%=ics.GetVar("assetid")%>' /><%
    if (ics.GetErrno() == 0) {
        %><asset:scatter name="theAsset" prefix="myAsset" /><br/>
          <br/><h3>Asset Variables (<%= ics.GetVar("assettype") %>:<%= ics.GetVar("assetid") %>)</h3>
          <table class="altClass"><%
            Set<String> vars =  new TreeSet<String>();
            for (Enumeration e = ics.GetVars(); e.hasMoreElements();) {
              String sVarName = (String)e.nextElement();
              if (sVarName.startsWith("myAsset:")){
                  vars.add(sVarName);
              }
            }
            for (String var:vars){
                String sVarValue = ics.GetVar( var );
                %><tr><td><%= var %></td><td><%= sVarValue %></tr><%
             }
             %></table><%
    } else {
        %>Error Loading <%= ics.GetVar("assettype") %>:<%= ics.GetVar("assetid") %>!<br/><%
    }
}
%></cs:ftcs>
