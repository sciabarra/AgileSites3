<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// classpath.jsp
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
<cs:ftcs>

<%

String resource_str = ics.GetVar("resourceName");

if (resource_str == null)
    resource_str = "";

String[] resources = resource_str.split("\\s+");

%>

Instructions:<br/>
1. Enter a resource name into the text area. Each resource name must be separated by a whitespace (new line, tab, space, etc.)<br/>
<div style="margin-left: 20px">NOTE: a resource name can either be a fully qualitified class name or a filename. For example:<br/>
    <div style="margin-left: 30px">COM.FutureTense.Util.FBuild</div>
    <div style="margin-left: 30px">satellite.properties</div>
</div>
2. Click "Submit" to get the location of the resource if it exists in the JVM's classpath.<br/>
<br/>
<satellite:form satellite="false" name="clusterform" method="POST">
<input type='hidden' name='pagename' value='<%=ics.GetVar("pagename")%>'/>
  <textarea name="resourceName" rows="10" cols="100"><%= resource_str %></textarea><br/>
  <input type="submit"/>
</satellite:form>

<%

if (!"".equals(resource_str)) {

%>
<table>
  <tr><th>Resource Name</th><th>Location</th></tr>
<%
  for (String r : resources) {
%>
  <tr><td style="padding:0px 10px 0px 0px; "><%= r %></td><%
  
    r = (r.indexOf('/') == 0) ? r : "/" + r;
    
    String r_mod = r.replaceAll("\\.", "/");

    java.net.URL r_result = getClass().getResource(r_mod);

    if (r_result == null) {
    
      r_result = getClass().getResource(r_mod + ".class");
    
    }

    if (r_result == null) {

      r_result = getClass().getResource(r);

    }
    
%><td style="padding:0px 0px 0px 10px; "><%= r_result %></td></tr>
<%
  }
%>
</table>
<%
}
%>


</cs:ftcs>
