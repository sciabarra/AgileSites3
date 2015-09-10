<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld"
%><cs:ftcs><html><head><title>Wrapper for <ics:getvar name="pagename"/>, layoutstyle=<ics:getvar name="layoutstyle"/>, innerstyle=<ics:getvar name="innerstyle"/>, items=<ics:getvar name="items"/> ft_ss=<ics:getvar name="ft_ss"/></title></head><body><%
String style=ics.GetVar("innerstyle");
String layoutstyle=ics.GetVar("layoutstyle");

int cb = 0;
if (ics.GetVar("cb") !=null){
    cb= Integer.parseInt(ics.GetVar("cb"));
}else {
    cb = Long.valueOf(System.currentTimeMillis()%5).intValue();
}
int items=10;
if (ics.GetVar("items") !=null){
    items= Integer.parseInt(ics.GetVar("items"));
}
String sleep = ics.GetVar("sleep");
%>
<render:getpageurl  pagename='<%=ics.GetVar("pagename")%>' outstr="theURL">
  <render:argument name="innerstyle" value='<%= style %>' />
  <render:argument name="layoutstyle" value="<%= layoutstyle %>"/>
  <render:argument name="cb" value="<%= Integer.toString(cb) %>"/>
  <render:argument name="items" value="<%= Integer.toString(items) %>"/>
  <render:argument name="sleep" value="<%= sleep %>"/>
</render:getpageurl>
<a href=''>reload</a><br/>

<render:getpageurl  pagename='<%=ics.GetVar("pagename")%>' outstr="theURL">
  <render:argument name="innerstyle" value='<%= style %>' />
  <render:argument name="layoutstyle" value="<%= layoutstyle %>"/>
  <render:argument name="cb" value="<%= Integer.toString(Long.valueOf(System.currentTimeMillis()%5).intValue()) %>"/>
  <render:argument name="items" value="<%= Integer.toString(items) %>"/>
  <render:argument name="sleep" value="<%= sleep %>"/>
</render:getpageurl>
<a href='<%=ics.GetVar("theURL")%>'>random cb value</a><br/>

<render:getpageurl  pagename='<%=ics.GetVar("pagename")%>' outstr="theURL">
  <render:argument name="innerstyle" value="element"/>
  <render:argument name="layoutstyle" value="<%= layoutstyle %>"/>
  <render:argument name="cb" value="<%= Integer.toString(cb) %>"/>
  <render:argument name="items" value="<%= Integer.toString(items) %>"/>
  <render:argument name="sleep" value="<%= sleep %>"/>
</render:getpageurl>
<a href='<%=ics.GetVar("theURL")%>'>element style</a><br/>
<render:getpageurl  pagename='<%=ics.GetVar("pagename")%>' outstr="theURL">
  <render:argument name="innerstyle" value="embedded"/>
  <render:argument name="layoutstyle" value="<%= layoutstyle %>"/>
  <render:argument name="cb" value="<%= Integer.toString(cb) %>"/>
  <render:argument name="items" value="<%= Integer.toString(items) %>"/>
  <render:argument name="sleep" value="<%= sleep %>"/>
</render:getpageurl>
<a href='<%=ics.GetVar("theURL")%>'>embedded style</a><br/>
<render:getpageurl  pagename='<%=ics.GetVar("pagename")%>' outstr="theURL">
  <render:argument name="innerstyle" value="pagelet"/>
  <render:argument name="layoutstyle" value="<%= layoutstyle %>"/>
  <render:argument name="cb" value="<%= Integer.toString(cb) %>"/>
  <render:argument name="items" value="<%= Integer.toString(items) %>"/>
  <render:argument name="sleep" value="<%= sleep %>"/>
</render:getpageurl>
<a href='<%=ics.GetVar("theURL")%>'>pagelet style</a><br/>
<%
if ("element".equals(layoutstyle)){
        %><render:callelement elementname="Support/Performance/Standard/layout" scoped="local"><render:argument name="style" value="<%= style %>"/><render:argument name="cb" value="<%= Integer.toString(cb) %>"/><render:argument name="items" value="<%= Integer.toString(items) %>"/><render:argument name="sleep" value="<%= sleep %>"/><render:argument name="ft_ss" value='<%= ics.GetVar("ft_ss") %>'/></render:callelement><br/><%
} else if ("embedded".equals(layoutstyle)){
        %><render:contentserver pagename="Support/Performance/Standard/layout"><render:argument name="style" value="<%= style %>"/><render:argument name="cb" value="<%= Integer.toString(cb) %>"/><render:argument name="items" value="<%= Integer.toString(items) %>"/><render:argument name="sleep" value="<%= sleep %>"/></render:contentserver><br/><%
}else {
        %><render:satellitepage pagename="Support/Performance/Standard/layout"><render:argument name="style" value="<%= style %>"/><render:argument name="cb" value="<%= Integer.toString(cb) %>"/><render:argument name="items" value="<%= Integer.toString(items) %>"/><render:argument name="sleep" value="<%= sleep %>"/></render:satellitepage><br/><%
}
%></body></html></cs:ftcs>