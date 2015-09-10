<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" 
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld"
%><%@ taglib prefix="time" uri="futuretense_cs/time.tld"
%><%//
// Support/CacheManager/ShowPagelet
//
// INPUT
//
// OUTPUT
//%>
<%@ page import="COM.FutureTense.Interfaces.FTValList"
%><%@ page import="COM.FutureTense.Interfaces.ICS"
%><%@ page import="COM.FutureTense.Interfaces.IList"
%><%@ page import="COM.FutureTense.Interfaces.Utilities"
%><%@ page import="COM.FutureTense.Util.ftErrors"
%><%@ page import="COM.FutureTense.Util.ftMessage"
%><cs:ftcs><%
%><h3><center>SystemItemCache vs SystemPageCache</center></h3><%
%><time:set name='pagetime'/><%
%><ics:sql sql='select distinct id as assetid from SystemItemCache order by id' listname='idlist' table='SystemItemCache'/>
<table class='altClass'>
    <tr><th>Nr</th><th>pagename</th><th>pages</th></tr>        
        <ics:listloop listname="idlist">
            <ics:listget listname="idlist" fieldname="#numRows" output="totalassets"/>
        </ics:listloop>
    <tr><td colspan="3" style="color:red"><%= ics.GetVar("totalassets")%> assets are cached...</td></tr>
    <ics:listloop listname='idlist'>
        <tr><th colspan="2" style="text-transform:none"><ics:listget listname='idlist' fieldname='assetid'/></th>
			<ics:sql sql='<%= "select spage.pagename as pagename, count(*) as pages from SystemPagecache spage, SystemItemCache sitem where spage.id = sitem.page and sitem.id = \'"+ics.ResolveVariables("idlist.assetid")+"\' group by spage.pagename order by pages desc"%>' listname='pagelist' table='SystemPageCache'/>
        <% int total = 0; %>
        <ics:listloop listname="pagelist">
            <% total += Integer.parseInt(ics.ResolveVariables("pagelist.pages")); %>
        </ics:listloop>
        <th colspan="1"><%= total %> pages will be flushed</th></tr>
        <% int i = 1; %>
        <ics:listloop listname='pagelist'>
            <tr>
                <td><%= i++ %></td>
                <td>
                <satellite:link>
                  <satellite:parameter name='urlbase' value='Satellite'/>
                  <satellite:parameter name='pagename' value='Support/CacheManager/listPagename'/>
                </satellite:link>
                <a href='<%= ics.GetVar("referURL")+"&pname="+ics.ResolveVariables("pagelist.pagename")+"&iname="+ics.ResolveVariables("idlist.assetid")+"&mode=itempages"%>'><ics:resolvevariables name="pagelist.pagename"/></a>
                </td>
                <td><ics:listget listname='pagelist' fieldname='pages'/></td>
            </tr>
        </ics:listloop>
    </ics:listloop>
</table>
It took <time:get name='pagetime'/> Millisecs to calculate..
</cs:ftcs>
