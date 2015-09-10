<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld"
%><cs:ftcs><%
int max = Integer.parseInt(ics.GetVar("max"));
%>a:<%= ics.GetVar("a") %>,level:<%= ics.GetVar("level") %>, max:<%= ics.GetVar("max") %><br/><%

int a = Integer.parseInt(ics.GetVar("a"));
int level = Integer.parseInt(ics.GetVar("level"));
int nextLevel = level-1;

for (int i=a; i<=max && level > 1;i++){
    %><satellite:page pagename='<%= ics.GetVar("pagename") %>'><%
      %><satellite:parameter name="a" value='<%= Integer.toString(i) %>'/><%
      %><satellite:parameter name="max" value='<%= Integer.toString(max) %>'/><%
      %><satellite:parameter name="level" value='<%= Integer.toString(nextLevel) %>'/><%
    %></satellite:page><%
}
%></cs:ftcs>
