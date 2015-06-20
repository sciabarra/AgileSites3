<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="asset" uri="futuretense_cs/asset.tld"
%><%@ taglib prefix="assetset" uri="futuretense_cs/assetset.tld"
%><%@ taglib prefix="commercecontext" uri="futuretense_cs/commercecontext.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="listobject" uri="futuretense_cs/listobject.tld"
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld"
%><%@ taglib prefix="siteplan" uri="futuretense_cs/siteplan.tld"
%><%@ taglib prefix="searchstate" uri="futuretense_cs/searchstate.tld"
%><%@ page import="COM.FutureTense.Interfaces.*,
                   COM.FutureTense.Util.ftMessage,
                   COM.FutureTense.Util.ftErrors,
                   java.util.*"
%><cs:ftcs><%-- /Scatterer

INPUT

OUTPUT

--%>
<%! Set<String> common = new HashSet<String>() {{
     add("id");
     add("fw_uid");
     add("name");
     add("description");
     add("subtype");
     add("status");
     add("startdate");
     add("enddate");
     add("createddate");
     add("updateddate");
     add("createdby");
     add("updatedby");
     add("filename");
     add("path");
     add("urlexternaldocxml");
     add("externaldoctype");
     add("urlexternaldoc");
     add("Dimension");
     add("Dimension-parent");
     add("SegRating");    
}};

%><%if(ics.GetVar("c")==null) {%>
<a href="http://localhost:11800/cs/ContentServer?cs.contenttype=text%2Fplain&d=&pagename=AdminSite%2FScatterer&c=Template">Template</a><br>
<a href="http://localhost:11800/cs/ContentServer?cs.contenttype=text%2Fplain&d=&pagename=AdminSite%2FScatterer&c=CSElement">CSElement</a><br>
<a href="http://localhost:11800/cs/ContentServer?cs.contenttype=text%2Fplain&d=&pagename=AdminSite%2FScatterer&c=SiteEntry">SiteEntry</a><br>
<a href="http://localhost:11800/cs/ContentServer?cs.contenttype=text%2Fplain&d=&pagename=AdminSite%2FScatterer&c=PageAttribute">PageAttribute</a><br>
<a href="http://localhost:11800/cs/ContentServer?cs.contenttype=text%2Fplain&d=&pagename=AdminSite%2FScatterer&c=PageDefinition">PageDefinition</a><br>
<% } else { %>  
<% if(ics.GetVar("cid")!=null) { 
%><asset:load name="a" 	
  type='<%=ics.GetVar("c")%>' 
  objectid='<%=ics.GetVar("cid")%>'
/><% } else { %><asset:load name="a" 	
  type='<%=ics.GetVar("c")%>' 
  field="name"
  value='<%=ics.GetVar("c")%>'
/><% } %><asset:scatter name="a" prefix="aa"
/>class <%=ics.GetVar("c") %> {
<%
Set<String> arrays = new HashSet<String>();
Enumeration e = ics.GetVars();
while ( e.hasMoreElements() ) {
  String k = (String)e.nextElement();
  String v = ics.GetVar(k);
  if(!k.startsWith("aa:")) continue;
  if(k.endsWith("_folder")) continue;
  if(k.endsWith("_file")) continue;

  StringTokenizer st = new StringTokenizer(k,":"); 
  if(st.countTokens()==3) {
	  st.nextToken();
	  arrays.add(st.nextToken());
  } else if(st.countTokens()==2) {
	  st.nextToken();
	  String kk = st.nextToken();
      if(common.contains(kk)) continue;
    %><%=  "  String " + kk +";\n" %><%
  } else {
    %><%= "  // " + k + " #" + st.countTokens()+ "\n" %><%  
  }
}
for(String ar: arrays) {
    if(common.contains(ar)) continue;
	%><%="  String[] "+ ar + ";\n" %><%
}
%>
}
<% } %>
</cs:ftcs>