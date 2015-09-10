<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld"
%><%@ page import="COM.FutureTense.Interfaces.FTValList"
%><cs:ftcs>
<h3>Standard Performance Test Pages</h3>
<p>The idea of these sets of pages is to present to baseline testing, in a comparable way. So that it is possible to compare this install against another in your environment, to compare yourself with other customers.

The script below, is a simple pagelet to test the performance of WebCenter Sites and Satellite in full caching mode, over different page sizes.
The script can also be <satellite:link pagename="Support/Performance/Standard/script"/><a href='<ics:getvar name="referURL"/>'>downloaded</a>.</p>
<p>The prerequisites of the script are:</p>
<ul>
<li>UNIX with bash shell</li>
<li>Apache ab, part of Apache httpd server</li>
<li>wget</li>
<li>gnuplot, version 3.7 or later</li>
<li>The path to Satellite is /cs/Satellite, it is easy to change this in the script.</li>
</ul>
<br/><br/>
<code><%= org.apache.commons.lang.StringEscapeUtils.escapeHtml(ics.ReadPage("Support/Performance/Standard/script",new FTValList())) %></code>
<table>
<tr>
<th>WebCenter Sites</th>
<th>Satellite</th>
<th>default arguments</th>
<th>description</th>
</tr>
<tr>
<td><satellite:link pagename="Support/Performance/Standard/lorem"/><a href='<ics:getvar name="referURL"/>'>lorem</a></td>
<td><satellite:link pagename="Support/Performance/Standard/lorem" satellite="true"/><a href='<ics:getvar name="referURL"/>'>lorem</a></td>
    <td>size=8196&amp;cb=1</td>
    <td>fully cached page, 1 pagelet, takes attribute 'size' for size of the page in bytes. The parameter cb stands for cache buster and is intended to replicate the same page content under different urls.</td>
</tr>
<tr>
<td><satellite:link pagename="Support/Performance/Standard/wrapper"/><a href='<ics:getvar name="referURL"/>'>wrapper</a></td>
<td><satellite:link pagename="Support/Performance/Standard/wrapper" satellite="true"/><a href='<ics:getvar name="referURL"/>'>wrapper</a></td>
    <td>items=1&amp;innerstyle=pagelet&amp;layoutstyle=pagelet&amp;cb=1&amp;rendermode=live</td>
    <td>Traditional uncached wrapper, with cached layout style. Has option to call layout via various render:calltemplate styles</td>
</tr>
<tr>
<td><satellite:link pagename="Support/Performance/Standard/cachedWrapper"/><a href='<ics:getvar name="referURL"/>'>cachedWrapper</a></td>
<td><satellite:link pagename="Support/Performance/Standard/cachedWrapper" satellite="true"/><a href='<ics:getvar name="referURL"/>'>cachedWrapper</a></td>
    <td>items=1&amp;innerstyle=pagelet&amp;layoutstyle=pagelet&amp;cb=1&amp;rendermode=live</td>
    <td>Same as above, but now the wrapper is cached too</td>
</tr>
<tr>
    <td><satellite:link pagename="Support/Performance/Standard/cacheControl"/><a href='<ics:getvar name="referURL"/>'>cacheControl</a></td>
    <td><satellite:link pagename="Support/Performance/Standard/cacheControl" satellite="true"/><a href='<ics:getvar name="referURL"/>'>cacheControl</a></td>
    <td>a=1&amp;max=5&amp;level=3</td>
    <td>Showcase for setting Cache-Control: max-age via an xml element</td>
</tr>
<tr>
<td><satellite:link pagename="Support/Performance/Standard/pagelet"/><a href='<ics:getvar name="referURL"/>'>pagelet</a></td>
<td><satellite:link pagename="Support/Performance/Standard/pagelet" satellite="true"/><a href='<ics:getvar name="referURL"/>'>pagelet</a></td>
    <td>a=1&amp;max=5&amp;level=3</td>
    <td>Nesting pagelet, the number of nested pagelets is from 'a' to 'max', and from 'level' to 1.</td>
</tr>
<tr>
<td><satellite:link pagename="Support/Performance/Standard/pagelet2"/><a href='<ics:getvar name="referURL"/>'>pagelet2</a></td>
<td><satellite:link pagename="Support/Performance/Standard/pagelet2" satellite="true"/><a href='<ics:getvar name="referURL"/>'>pagelet2</a></td>

    <td>a=1&amp;max=50&amp;level=2</td>
    <td>Flat innner pagelets, the number of nested pagelets is from 'a' to 'max'.</td>
</tr>
<tr>
<td><satellite:link pagename="Support/Performance/Standard/simple"/><a href='<ics:getvar name="referURL"/>'>simple</a></td>
<td><satellite:link pagename="Support/Performance/Standard/simple" satellite="true"/><a href='<ics:getvar name="referURL"/>'>simple</a></td>
    <td>id=1&amp;cb=1&amp;rendermode=live</td>
    <td>Very simple pagelet, logging one compositional dependancy against id value</td>
</tr>
</table>
</cs:ftcs>
