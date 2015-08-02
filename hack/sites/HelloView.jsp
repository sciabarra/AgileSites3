<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld"
%><%@ page import="COM.FutureTense.Interfaces.*,groovy.lang.GroovyClassLoader"
%><%!
 String LIB = "HelloLib1"; //versioned lib
 String CTL = "HelloCtl";
%><cs:ftcs><ics:if condition='<%=ics.GetVar("tid")!=null%>'
><ics:then><render:logdep cid='<%=ics.GetVar("tid")%>' c="Template"
/></ics:then></ics:if
><% // TODO log a dependency with the Controller and the lib
GroovyClassLoader gcl = null;
if(ics.GetVar("refresh")==null)
    gcl = (GroovyClassLoader)application.getAttribute(LIB);
if(gcl==null) {
    application.setAttribute(LIB, gcl = new groovy.lang.GroovyClassLoader());
    String rp1 = ics.ReadPage(ics.GetVar("site")+"/"+LIB, new FTValList());
    System.out.println(rp1);
    gcl.parseClass(rp1);
}
String rp2 = ics.ReadPage(ics.GetVar("site")+ "/" + CTL, new FTValList());
Class clazz = gcl.parseClass(rp2);
String output =  clazz.getMethod("apply").invoke(clazz.newInstance()).toString();
%><%= output %>
</cs:ftcs>