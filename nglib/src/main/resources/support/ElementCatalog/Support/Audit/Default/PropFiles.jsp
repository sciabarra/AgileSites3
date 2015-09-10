<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// Support/Audit/Default/PropFiles
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

<%!
class IniFileFilter implements java.io.FileFilter {
    public boolean accept(File f) {
        if(f != null) {
            if(f.isDirectory()) {
                return false;
            }
            String extension = getExtension(f);
            if(extension != null && ("ini".equals(extension) || "properties".equals(extension))) {
                return true;
            }
        }
        return false;
    }

    private String getExtension(File f) {
        if(f != null) {
            String filename = f.getName();
            int i = filename.lastIndexOf('.');
            if(i>0 && i<filename.length()-1) {
                return filename.substring(i+1).toLowerCase();
            };
        }
        return null;
    }
}
%>
<cs:ftcs>
<h3>WebCenter Sites Property Files</h3>
<%
    String inipath = Utilities.osSafeSpec(getServletConfig().getServletContext().getInitParameter("inipath"));
    File[] inifiles = new File(inipath).listFiles(new IniFileFilter());
    java.util.Arrays.sort(inifiles);
%>

<a href="ContentServer?pagename=<%= ics.GetVar("pagename") %>&iniprop=all&cmd=PropFiles">DisplayAll</a>
<table class="altClass" style="width:40%">
    <tr><th align="left">Property File</th></tr>
    <% for (int i=0; i<inifiles.length;i++){ %>
        <tr><td><a href="ContentServer?pagename=<%= ics.GetVar("pagename") %>&iniprop=<%=inifiles[i].getName() %>&cmd=PropFiles"><%=inifiles[i].getName() %></a></td></tr>
    <% } %>
</table>

<%
   String resources = getServletConfig().getServletContext().getRealPath("/WEB-INF/classes");
   String proppath = Utilities.osSafeSpec(resources);
   File[] propfiles = new File(proppath).listFiles(new IniFileFilter());
   java.util.Arrays.sort(propfiles);
%>
<br/><a href="ContentServer?pagename=<%= ics.GetVar("pagename") %>&prop=all&cmd=PropFiles">DisplayAll</a>
<table class="altClass" style="width:40%">
    <tr><th align="left">Property File</th></tr>
    <% for (int i=0; i<propfiles.length; i++){ %>
        <tr><td><a href="ContentServer?pagename=<%= ics.GetVar("pagename") %>&prop=<%=propfiles[i].getName() %>&cmd=PropFiles"><%=propfiles[i].getName() %></a></td></tr>
    <% } %>
</table>
<br/><br/><table class="altClass" style="width:60%">

<%
String iniprop = ics.GetVar("iniprop");
String prop = ics.GetVar("prop");
Properties props = new Properties();
String label="";
if(iniprop != null) {
    if ("all".equals(iniprop)){
        label="all";
        for (int i=0;i<inifiles.length; i++){
            props.load(new FileInputStream(inifiles[i]));
        }
    } else {
        File f = new File(inipath,iniprop).getAbsoluteFile();
        //check for iniprop input
        if(!f.toString().startsWith(new File(inipath).getAbsoluteFile().toString())) {
            throw new ServletException("invalid input");
        }
        props.load(new FileInputStream(f));
        label=f.toString();

    }

}
if(prop != null) {

    if ("all".equals(prop)){
        for (int i=0;i<propfiles.length;i++){
            props.load(new FileInputStream(propfiles[i]));
        }
    } else {

        File f = new File(proppath,prop).getAbsoluteFile();
        //check for iniprop input
        if(!f.toString().startsWith(new File(proppath).getAbsoluteFile().toString())) {
            throw new ServletException("invalid input");
        }

        props.load(new FileInputStream(new File(proppath,prop)));
        label=f.toString();
    }

}
if(props.size() > 0) {
    Set keySet = new TreeSet(props.keySet());
    %><h3><b><%= label%></b></h3><%
    %><tr><th align="left">Property</th><th>Value</th></tr><%

    for(Iterator e=keySet.iterator(); e.hasNext();) {
        String key = (String)e.next();
        String value = props.getProperty(key);
        %><tr><td width="20%"><%= key%></td><td width="80%"><%= value%></td></tr><%
     }
} else {
   %><tr><td>Nothing to display</td></tr><%
}
%></table>
</cs:ftcs>
