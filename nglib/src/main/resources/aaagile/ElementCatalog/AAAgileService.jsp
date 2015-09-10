<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="publication" uri="futuretense_cs/publication.tld"
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld"
%><%@ taglib prefix="asset" uri="futuretense_cs/asset.tld"
%><%@ taglib prefix="publication" uri="futuretense_cs/publication.tld"
%><%@ taglib prefix="user" uri="futuretense_cs/user.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ page import="COM.FutureTense.Interfaces.*,groovy.lang.GroovyClassLoader,java.lang.reflect.*,java.io.File"
%><%! final String LIB = "AAAgileServices";
      final String API = "AAAgileApi";
      final String SVC = "agilesitesng.services.ServiceDispatcher";
%><cs:ftcs><% // load the library
String result = null ;
try {
    /*
     * Reload will reload all
     * Refresh will reload only the services
     */
    GroovyClassLoader gcl = null;
    boolean refresh = ics.GetVar("refresh") != null;
    if (ics.GetVar("reload") == null)
        gcl = (GroovyClassLoader) application.getAttribute("_" + LIB + "_");
    if (gcl == null) {
        application.setAttribute("_" + LIB + "_", gcl = new groovy.lang.GroovyClassLoader());
        System.out.println("=== Loading API ===");
        String code = ics.ReadPage(API, new FTValList());
        gcl.parseClass(code);
        refresh = true;
    }
    if (refresh) {
        String debug = ics.GetVar("debug");
        if(debug==null) {
          System.out.println("=== Loading LIB from page ===");
          String code = ics.ReadPage(LIB, new FTValList());
          gcl.parseClass(code);
        } else {
          System.out.println("=== Loading LIB from lib ===");
          File code = new File(debug);
          gcl.parseClass(code);
        }
    }
    // read the op
    String op = ics.GetVar("op");
    if (op == null || op.equals("version")) {
        result = gcl.loadClass("agilesites.api.Version").newInstance().toString()
                + "\n"
                + gcl.loadClass("agilesitesng.services.Version").newInstance().toString();
    } else {
        Class clazz = gcl.loadClass(SVC);
        Method method = clazz.getMethod("exec", new Class[]{HttpServletRequest.class, COM.FutureTense.Interfaces.ICS.class, HttpServletResponse.class});
        result = method.invoke(clazz.newInstance(), new Object[] { request, ics, response}).toString();
     }
} catch(Exception ex) {
    result = "ERROR: "+ex.getMessage();
    ex.printStackTrace();
}
%><%= result %></cs:ftcs>
