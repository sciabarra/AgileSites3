<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld"
%><%//
// Support/TCPI/CleanUp/CountPubKeyTable
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
%><%@ page import="COM.FutureTense.Util.ftMessage"%>
<cs:ftcs>
<%
ics.SetVar("tname","PubKeyTable");

String defdir= ics.ResolveVariables("CS.CatalogDir.Variables.tname");
defdir= Utilities.osSafeSpec(defdir);
defdir= new java.io.File(defdir).getCanonicalPath();
if (defdir.charAt(defdir.length()-1) != java.io.File.separatorChar) {
    defdir = defdir.concat(java.io.File.separator);
}
long now = System.currentTimeMillis();
%>

<h3>Touching bodies on <ics:getvar name="tname" /></h3>
<ics:clearerrno />
<ics:sql sql='<%= ics.ResolveVariables("SELECT urlkey as urlkey FROM Variables.tname") %>' table='<%= ics.GetVar("tname") %>' listname="bodies" limit="-1"/>
<ics:listloop listname="bodies">
    <%
    java.io.File fName = new java.io.File(defdir + ics.ResolveVariables("bodies.urlkey") );
    if (fName.exists()){
        fName.setLastModified(now);
        //%>Settting modified timestamp on <%= fName.toString() %><br/><%
    } else {
        %><%= fName.toString() %>not found!<br/><%
    }
    %>
</ics:listloop>
<ics:clearerrno />
</cs:ftcs>
