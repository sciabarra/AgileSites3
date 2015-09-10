<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%
//
// Support/ApplicationPage
//
// INPUT
//
// OUTPUT
//
long t1 = System.nanoTime(); %><cs:ftcs><!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<% 
if("true".equals(ics.GetVar("ft_ss"))) { throw new ServletException("Satellite can not be a client"); } 
%><html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
<ics:callelement element="Support/general"/><body>
<ics:callelement element="Support/Topnav"/><div class="content" id="content">
<ics:setvar name="errno" value="0" /><ics:callelement element='<%= ics.GetVar("pagename") %>'/></div>
<ics:callelement element="Support/Footer"/><script type="text/javascript">var elapsed=<%= Long.toString((System.nanoTime()-t1)/1000) %>;</script></body>
</html>
</cs:ftcs>