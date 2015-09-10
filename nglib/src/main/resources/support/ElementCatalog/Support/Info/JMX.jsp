<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld"
%><%//
// Support/Info/JMX
//
// INPUT
//
// OUTPUT
//
%><%@ page import="COM.FutureTense.Interfaces.ICS"
%><%@ page import="java.util.*"
%><%@ page import="java.io.IOException"
%><%@ page import="javax.servlet.jsp.JspWriter"
%><%@ page import="javax.management.*"
%><%@ page import="java.lang.management.ManagementFactory"
%><%@ page import="javax.management.openmbean.CompositeData"
%><%@ page import="javax.management.openmbean.TabularData"
%><%@ page import="javax.management.openmbean.CompositeType"
%><%@ page import="org.apache.commons.logging.Log"
%><%@ page import="org.apache.commons.logging.LogFactory"
%><%!


Log log;
private Comparator<ObjectName> comparator = new Comparator<ObjectName>(){
     public int compare(ObjectName o1, ObjectName o2){
         return o1.toString().compareTo(o2.toString());
     }

     public boolean    equals(Object obj){
        return false;
     }
};

public void jspInit(){
    //ManagementFactory.getPlatformMBeanServer().getDomains();
    log = LogFactory.getLog("com.fatwire.cs.logging.devtools");
}

class BeanRenderer {
    private MBeanServer mBeanServer = null;

    BeanRenderer(MBeanServer server){
        mBeanServer=server;
    }

    int listBeans( JspWriter writer, String qry , String pagename, int prev) throws IOException    {

        Set names = null;
        try {
            names=mBeanServer.queryNames(new ObjectName(qry), null);
            //writer.println("<p>OK - Number of results: " + names.size());
            //writer.println("</p>");
        } catch (Exception e) {
            writer.println("Error - " + e.toString());
            return 0;
        }

        TreeSet<ObjectName> n = new TreeSet<ObjectName>(comparator);
        n.addAll(names);

        int bid=prev;
        boolean display= prev + n.size() < 15;

        for( Iterator<ObjectName> it= n.iterator(); it.hasNext();) {
            ObjectName oname=it.next();
            bid++;
            writer.print("<li><a style=\"display:block\" href=\"ContentServer?pagename="+ pagename +"&qry=" + java.net.URLEncoder.encode(oname.toString()) +"\"");
            if (!display) writer.print(" onmouseover=\"document.getElementById('bean"+bid+"').style.display='inline'\" onmouseout=\"document.getElementById('bean"+bid+"').style.display='none'\"");
            writer.print("><b>" + oname.toString() +"</b></a>");
            writer.println("<ul id=\"bean"+bid+"\" style=\"list-style-position:inside"+(!display? ";display:none": "")+"\">");

            try {
                MBeanInfo minfo=mBeanServer.getMBeanInfo(oname);
                String code=minfo.getClassName();
                if ("org.apache.commons.modeler.BaseModelMBean".equals(code)) {
                    code=(String)mBeanServer.getAttribute(oname, "modelerType");
                }
                writer.print("<li>modelerType: " + code);
                writer.println("</li>");
                MBeanAttributeInfo attrs[]=minfo.getAttributes();
                Object value=null;

                for( int i=0; i< attrs.length; i++ ) {
                    if( ! attrs[i].isReadable() ) continue;
                    if( ! isSupported( attrs[i].getType() )) continue;
                    String attName=attrs[i].getName();
                    if( "modelerType".equals( attName)) continue;
                    if( attName.indexOf( "=") >=0 ||
                            attName.indexOf( ":") >=0 ||
                            attName.indexOf( " ") >=0 ) {
                        continue;
                    }

                    try {
                        value=mBeanServer.getAttribute(oname, attName);
                    } catch(UnsupportedOperationException e){
                        //ignore, trying to read what we don't have access too or where the internal state does not allow reading
                    } catch( Throwable t) {
                        log.info("Error getting attribute " + oname +
                            " " + attName + " " + t.toString());
                        continue;
                    }
                    if( value==null ) continue;
                    writer.print("<li><i>"+attName + "</i>: ");
                    printValue(writer,value);
                    writer.println("</li>");
                }
            } catch (Exception e) {
                // Ignore
            }
            writer.println("</ul></li>");
        }
        return n.size();
    }
}
private void printValue(JspWriter writer,Object value) throws IOException{
    if (value==null) return;
    if (value instanceof CompositeData) {
        printCompositeData(writer,(CompositeData) value);
    } else if (value instanceof TabularData) {
        printTabularData(writer,(TabularData) value);
    } else if(value.getClass().isArray()){
        if (CompositeData.class.isAssignableFrom(value.getClass().getComponentType()) || TabularData.class.isAssignableFrom(value.getClass().getComponentType())){
            writer.print("<ul>" );
            for (Object o: (Object[])value){
                writer.print("<li>");
                printValue(writer,o);
                writer.print("</li>");
            }
            writer.print("</ul>");
        } else {
            String valueString= String.valueOf(Arrays.asList((Object[])value)) ;
            writer.print("<span style=\"white-space:pre\">");
            writer.print(escape(valueString));
            writer.print("</span>");
        }
    } else {
        String valueString= value.toString();
        writer.print("<span style=\"white-space:pre\">");
        writer.print(escape(valueString));
        writer.print("</span>");

    }

}

private  void printTabularData(JspWriter writer,TabularData td) throws IOException {
    Set<String> keys=td.getTabularType().getRowType().keySet();

    writer.write("<table>");
    writer.write("<tr>");
    for (String key:keys){
        writer.write("<th>");
        writer.write(escape(key));
        writer.write("</th>");
    }
    writer.write("</tr>");
    for (Object o : td.values()) {
        if (o instanceof CompositeData) {
            CompositeData cd=(CompositeData) o;
            writer.write("<tr>");
            for (String key:keys){
                writer.write("<td>");
                printValue(writer,cd.get(key));
                writer.write("</td>");
            }
            writer.write("</tr>");
        }
    }
    writer.write("</table>");
}

private void printCompositeData(JspWriter out,CompositeData cd) throws IOException {

    CompositeType ct = cd.getCompositeType();
    out.print("<ul>");
    for (String key : ct.keySet()) {
        out.print("<li><i>"+key + "</i>: ");
        printValue(out,cd.get(key));
        out.print("</li>");
    }
    out.print("</ul>");
}

String escape(String value){
    return value==null?"":org.apache.commons.lang.StringEscapeUtils.escapeHtml(value);
}


boolean isSupported( String type ) {
    return true;
}

%><cs:ftcs><%
Set<String> domains = new TreeSet<String>();
ArrayList<MBeanServer> servers = MBeanServerFactory.findMBeanServer(null);
out.write("<!-- number of servers: "+ servers.size() +" -->");
for (MBeanServer mBeanServer: servers){
    domains.addAll(Arrays.asList(mBeanServer.getDomains()));
    // java.lang.management.ManagementFactory.OPERATING_SYSTEM_MXBEAN_NAME
}

if (!domains.contains("java.lang")){
    MBeanServer pl= ManagementFactory.getPlatformMBeanServer();
    domains.addAll(Arrays.asList(pl.getDomains()));
    servers.add(pl);

}
%><form style="border:0; margin: 0;display:inline" name="query" action="ContentServer" method="GET"><input type="hidden" name="pagename" value='<ics:getvar name="pagename"/>'/>
  Query: <input type="text" name="qry" size="50" value='<%= ics.GetVar("qry") !=null? ics.GetVar("qry"): "*:*" %>'/> <a href='ContentServer?pagename=<ics:getvar name="pagename"/>'>all jmx beans</a>
</form>domains: <%
for (String domain : domains){
    %> <a href='ContentServer?pagename=<ics:getvar name="pagename"/>&qry=<%= domain %>:*'>'<%=domain%>:*'</a><%
}

String qry=ics.GetVar("qry");
if( qry == null ) {
    qry = "*:*";
}

out.print("<ol style=\"margin-top:0\">");
int prev=0;
for (MBeanServer mBeanServer: servers){
    prev += new BeanRenderer(mBeanServer).listBeans( out, qry ,ics.GetVar("pagename"),prev);
}
out.println("</ol>");
%></cs:ftcs>