<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld"
%><cs:ftcs><ics:getvar name="pagename"/> ft_ss=<ics:getvar name="ft_ss"/> style=<ics:getvar name="style"/><br/><%
String style=ics.GetVar("style");
int cb = 0;

if (ics.GetVar("cb") !=null){
    cb= Integer.parseInt(ics.GetVar("cb"));
}else {
    cb = Long.valueOf(System.currentTimeMillis()%5).intValue();
}
int items=1000;
if (ics.GetVar("items") !=null){
    items= Integer.parseInt(ics.GetVar("items"));
}
String sleep= ics.GetVar("sleep");
if ("element".equals(style)){
    for (int i=0; i< items; i++){
        %><render:callelement elementname="Support/Performance/Standard/simple" scoped="local"><render:argument name="id" value="<%= Integer.toString(i) %>"/><render:argument name="cb" value="<%= Integer.toString(cb) %>"/><render:argument name="sleep" value="<%= sleep %>"/><render:argument name="ft_ss" value='<%= ics.GetVar("ft_ss") %>'/></render:callelement><br/><%
    }
} else if ("embedded".equals(style)){
    for (int i=0; i< items; i++){
        %><render:contentserver pagename="Support/Performance/Standard/simple"><render:argument name="id" value="<%= Integer.toString(i) %>"/><render:argument name="cb" value="<%= Integer.toString(cb) %>"/><render:argument name="sleep" value="<%= sleep %>"/></render:contentserver><br/><%
    }
}else {
    for (int i=0; i< items; i++){
        %><render:satellitepage pagename="Support/Performance/Standard/simple"><render:argument name="id" value="<%= Integer.toString(i) %>"/><render:argument name="cb" value="<%= Integer.toString(cb) %>"/><render:argument name="sleep" value="<%= sleep %>"/></render:satellitepage><br/><%
    }
}
%></cs:ftcs>