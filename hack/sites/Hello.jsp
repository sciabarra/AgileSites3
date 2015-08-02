<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld"
%><%@ page import="COM.FutureTense.Interfaces.*,groovy.lang.GroovyClassLoader"
%><cs:ftcs><ics:if condition='<%=ics.GetVar("tid")!=null%>'
><ics:then><render:logdep cid='<%=ics.GetVar("tid")%>' c="Template"
/></ics:then></ics:if
><% // TODO log a dependency with the Controller and the lib
GroovyClassLoader gcl = null;
if(ics.GetVar("refresh")==null)
    gcl = (GroovyClassLoader)application.getAttribute("Lib");
if(gcl==null) {
    application.setAttribute("Lib", gcl = new groovy.lang.GroovyClassLoader());
    String rp1 = ics.ReadPage(ics.GetVar("site")+"/Lib", new FTValList());
    System.out.println(rp1);
    gcl.parseClass(rp1);
}
Class clazz = gcl.parseClass(
"class HelloCtl extends Hello {"+
"  public String apply() {"+
"      return hello(\"world\");"+
"  } " +
"}");
String output =  clazz.getMethod("apply").invoke(clazz.newInstance()).toString();
%><%= output %>
</cs:ftcs>