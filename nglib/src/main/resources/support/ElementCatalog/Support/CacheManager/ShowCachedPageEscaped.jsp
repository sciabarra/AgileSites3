<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><cs:ftcs><ics:sql sql='<%= ics.ResolveVariables("SELECT urlpage FROM SystemPageCache WHERE id = Variables.pid") %>' listname="page" table="SystemPageCache" /><%
if (ics.GetErrno() == 0){
    String text=ics.ResolveVariables("page.@urlpage");
    int count = text.length();
    int whitecount=0;
    for (int i=0; i< count;i++){
        if (Character.isWhitespace(text.charAt(i))) whitecount++;
    }
    %><div class="pagelet-summary" onclick="this.parentNode.style.visibility = 'hidden';">length=<%= Integer.toString(count)%>, whitespace=<%= count >0?Integer.toString(whitecount*100/count) :"0"%>%. Hold mouse over pagelet to see it with whitespace.</div><%
    %><div class="pagelet-inner"><ics:callelement element="Support/CacheManager/listPageMarkers"><ics:argument name="pagebody" value="<%= text %>"/></ics:callelement></div><%
    %><div class="pagelet-body" onmouseover="this.style.whiteSpace='pre';" onmouseout="this.style.whiteSpace='normal';"><%=
  org.apache.commons.lang.StringEscapeUtils.escapeHtml(text)
  %></div><%
} else {
    out.write("Not in cache");
}
%></cs:ftcs>