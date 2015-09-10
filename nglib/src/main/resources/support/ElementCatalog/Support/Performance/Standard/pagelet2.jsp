<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld"
%><cs:ftcs><%
int max = Integer.parseInt(ics.GetVar("max"));
int a = Integer.parseInt(ics.GetVar("a"));
if ( a<1) a=1;
int level=Integer.parseInt(ics.GetVar("level"));
if (level <1) level=1;
if (level !=1){
    %><html><body><%
}
%><div style="border:<%= Integer.toString(level) %>px; background-color: rgb(<%= Integer.toString(256-(a*256)/max) %>,255,255);">
color: rgb(<%= Integer.toString(256-(a*256)/max) %>,255,255),
created: <b><%= new java.util.Date() %></b>,
a:<b><%= ics.GetVar("a") %></b>,
max:<b><%= ics.GetVar("max") %></b>,
level:<b><%= ics.GetVar("level") %></b>,

<satellite:link pagename='<%= ics.GetVar("pagename") %>' outstring="url_self"><%
  %><satellite:parameter name="a" value='<%= ics.GetVar("a") %>'/><%
  %><satellite:parameter name="max" value='<%= Integer.toString(max) %>'/><%
  %><satellite:parameter name="level" value='<%= ics.GetVar("level") %>'/><%
  %><satellite:parameter name="ft_ss" value='true'/><%
%></satellite:link><%
%><a href='<%= ics.GetVar("url_self") %>'>a=<%= ics.GetVar("a") %></a>
<%
level--;
for (int i=a; i<=max && level > 0;i++){
    %><satellite:page pagename='<%= ics.GetVar("pagename") %>'><%
      %><satellite:parameter name="a" value='<%= Integer.toString(i) %>'/><%
      %><satellite:parameter name="max" value='<%= Integer.toString(max) %>'/><%
      %><satellite:parameter name="level" value="1"/><%
    %></satellite:page>
<%
}

%></div><%
if (level ==1){
    %></body></html><%
}
%></cs:ftcs>
