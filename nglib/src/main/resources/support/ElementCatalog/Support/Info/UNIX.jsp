<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld"
%><%//
// Support/Info/UNIX
//
// INPUT
//
//OUTPUT
//
%><%@ page import="java.io.*"
%><cs:ftcs><h3>Low level UNIX info</h3>
<h3>ContentServer file system locations</h3>
<%

File[] location= new File[4];
String[] desc =" javax.servlet.context.tempdir,ft.usedisksync,SystemPageCache,MungoBlobs".split(",");

location[0]= (File)(getServletConfig().getServletContext().getAttribute("javax.servlet.context.tempdir"));
location[1] = new File(ics.GetProperty("ft.usedisksync"));
location[2] = new File(ics.ResolveVariables("CS.CatalogDir.SystemPageCache"));
location[3] = new File(ics.ResolveVariables("CS.CatalogDir.MungoBlobs"));

for (int i=0; i< location.length;i++){
    %><b><%=desc[i] %></b>: <%= location[i].getCanonicalPath() %><br/><%
}
%><h3>procfs info</h3><%
String[] procs ="/proc/mounts,/proc/cpuinfo,/proc/diskstats,/proc/meminfo,/proc/modules,/proc/uptime,/proc/version,/proc/self/environ,/proc/self/limits".split(",");
for (String p:procs){
    File f = new File(p);
    if (f.exists() && f.canRead()){
      try {
        %><b><%=p %></b><pre><%= org.apache.commons.io.FileUtils.readFileToString(f,null) %></pre><%
       } catch (Exception e){
           e.printStackTrace(new PrintWriter(out));
       }
    }
}
%></cs:ftcs>