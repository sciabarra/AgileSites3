<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld"
%><cs:ftcs><hr/><%
int max = Integer.parseInt(ics.GetVar("max"));
%>
created: <b><%= new java.util.Date() %></b>&nbsp;<%= ics.genID(true) %><br>
a:<b><%= ics.GetVar("a") %></b><br>
max:<b><%= ics.GetVar("max") %></b><br>
level:<b><%= ics.GetVar("level") %></b><br>
sessionid: <%= ics.SessionID() %><br>
page: <b><%= ics.pageURL() %></b><br>
cacheable: <b><%= ics.isCacheable(ics.GetVar("pagename")) %></b><br>
headers: <b><%= ics.grabHeaders() %></b><br>
<hr/>
<satellite:link pagename='<%= ics.GetVar("pagename") %>' outstring="url_self"><%
  %><satellite:parameter name="a" value='<%= ics.GetVar("a") %>'/><%
  %><satellite:parameter name="max" value='<%= Integer.toString(max) %>'/><%
  %><satellite:parameter name="level" value='<%= ics.GetVar("level") %>'/><%
%></satellite:link><%
%><a href='<%= ics.GetVar("url_self") %>'>a=<%= ics.GetVar("a") %>, level=<%= ics.GetVar("level") %></a><br/>
<satellite:link pagename='<%= ics.GetVar("pagename") %>' outstring="url_self" satellite="true"><%
  %><satellite:parameter name="a" value='<%= ics.GetVar("a") %>'/><%
  %><satellite:parameter name="max" value='<%= Integer.toString(max) %>'/><%
  %><satellite:parameter name="level" value='<%= ics.GetVar("level") %>'/><%
%></satellite:link><%
%><a href='<%= ics.GetVar("url_self") %>'>a=<%= ics.GetVar("a") %>, level=<%= ics.GetVar("level") %>(Satellite)</a><br/>
<satellite:link pagename='<%= ics.GetVar("pagename") %>' outstring="url_self" satellite="false"><%
  %><satellite:parameter name="a" value='<%= ics.GetVar("a") %>'/><%
  %><satellite:parameter name="max" value='<%= Integer.toString(max) %>'/><%
  %><satellite:parameter name="level" value='<%= ics.GetVar("level") %>'/><%
  %><satellite:parameter name="ft_ss" value='true'/><%
%></satellite:link><%
%><a href='<%= ics.GetVar("url_self") %>'>a=<%= ics.GetVar("a") %>, level=<%= ics.GetVar("level") %>(ft_ss=true)</a><br/>
<%
int a = Integer.parseInt(ics.GetVar("a"));
int level = Integer.parseInt(ics.GetVar("level"));
int nextLevel = level-1;

for (int i=a; i<=max && level > 1;i++){
    %><satellite:page pagename='Support/Performance/Standard/pagelet'><%
      %><satellite:parameter name="a" value='<%= Integer.toString(i) %>'/><%
      %><satellite:parameter name="max" value='<%= Integer.toString(max) %>'/><%
      %><satellite:parameter name="level" value='<%= Integer.toString(nextLevel) %>'/><%
    %></satellite:page>
<%
}
%></cs:ftcs>
