<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%
//
// Support/Log4J/Info
//
//
%><cs:ftcs>
<h2>Current Commons Logging Factory Configuration</h2>
<%
        org.apache.commons.logging.LogFactory lf = org.apache.commons.logging.LogFactory.getFactory();
        for (String n:lf.getAttributeNames()){
            %><%= n +"=" + lf.getAttribute(n) %><br/><%
        }

%>
<h2>How to configure log4j</h2>
<p>
Currently log4j is not configured for ContentServer. Below are the steps of what needs to be done to configure log4j.
</p>
<ol>
<li>
<p>
Download <a href="http://repo1.maven.org/maven2/log4j/log4j/1.2.15/log4j-1.2.15.jar">log4j-1.2.15.jar</a> (version 1.2.12 or above, this has TRACE level support, see <a href="http://wiki.apache.org/logging-log4j/TraceDebate">TraceDebate</a>) and put this in WEB-INF/lib
</p>
</li>
<li>
<p>A file log4j.xml needs to be created in WEB-INF/log4j.xml. This a a sample of such a file.
<code>
<% String log4j_xml = ics.ReadPage("Support/Log4J/Log4J_xml",null);
%><br/><%= log4j_xml.replace("<", "&lt;").replace(">","&gt;").replace("\n","<br/>\n") %>
</code>
</p>
</li>
<li>
<p>

web.xml should be changed to have <a href="http://static.springframework.org/spring/docs/2.0.0/api/org/springframework/web/util/Log4jConfigListener.html">spring configure log4j</a>.<br/>
<br/>
Web.xml<br/>
<code>
    &lt;context-param&gt;<br/>
        &lt;param-name&gt;log4jConfigLocation&lt;/param-name&gt;<br/>
        &lt;param-value&gt;/WEB-INF/log4j.xml&lt;/param-value&gt;<br/>
    &lt;/context-param&gt;<br/>
[...]<br/>
    &lt;!-- log4j should be the first listener --&gt;<br/>
    &lt;listener&gt;<br/>
        &lt;listener-class&gt;org.springframework.web.util.Log4jConfigListener&lt;/listener-class&gt;<br/>
    &lt;/listener&gt;<br/>
    &lt;listener&gt;<br/>
        &lt;listener-class&gt;org.springframework.web.util.IntrospectorCleanupListener&lt;/listener-class&gt;<br/>
    &lt;/listener&gt;<br/>
    &lt;listener&gt;<br/>
        &lt;listener-class&gt;org.apache.commons.logging.impl.ServletContextCleaner&lt;/listener-class&gt;<br/>
    &lt;/listener&gt;<br/>
    &lt;listener&gt;<br/>
        &lt;listener-class&gt;org.springframework.web.context.ContextLoaderListener&lt;/listener-class&gt;<br/>
    &lt;/listener&gt;<br/>
    &lt;listener&gt;<br/>
        &lt;listener-class&gt;org.apache.myfaces.webapp.StartupServletContextListener&lt;/listener-class&gt;<br/>
    &lt;/listener&gt;
</code>
<br/>
</p>
</li>
<li>
<p>

Next to that you need to change commons-logging.properties. It does not need to know about about a logging implementation, as it defaults to log4j if this is found on the classpath.<br/>
<br/>
It turned out that commons-logging-1.1 has a nice feature if multiple commons-logging.properties files are found on the class path.<br/>
If you set in the property priority=100 in commons-logging.properties file JCL will use this property to decide that file to use. A higher priority takes precedent over a lower priority file.
<br/>
<br/>
Set in <%= getServletConfig().getServletContext().getRealPath("/WEB-INF/classes/commons-logging.properties") %><br/>
<br/>
<code>
priority=100<br/>
logging.file=<%=org.apache.commons.logging.LogFactory.getFactory().getAttribute("logging.file") %><br/>
</code>
<br/>
That is all that needs to be in this file.
</p>
</li>
</ol>
<p>
The log4j.xml can take system properties as configuration parameters, see for instance <a href="http://osdir.com/ml/jakarta.log4j.user/2003-09/msg00186.html">http://osdir.com/ml/jakarta.log4j.user/2003-09/msg00186.html</a>
</p>
<p>
Per logger appenders (like write to logfile, send to db, send to central logger via tcp) can be configured. A selected list of appenders can be found at (http://logging.apache.org/log4j/docs/api/org/apache/log4j/AppenderSkeleton.html).
</p>
</cs:ftcs>