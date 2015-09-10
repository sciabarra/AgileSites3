<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><cs:ftcs><%
String redir = "Support/Home";
if (ics.GetVar("redir") !=null){
    redir=ics.GetVar("redir");
}
if (!ics.UserIsMember("SiteGod")){
%>
    <html><head><meta http-equiv="refresh" content='5;URL=ContentServer?pagename=<%= redir %>'></head><body>Login Failed.</body></html>
<% } else { %>
    <html><head><meta http-equiv="refresh" content='0;URL=ContentServer?pagename=<%= redir %>'></head><body></body></html>
<% }
%></cs:ftcs>