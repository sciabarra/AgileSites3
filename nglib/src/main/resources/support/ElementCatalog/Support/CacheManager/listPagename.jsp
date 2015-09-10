<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld"
%><%//
// Support/CacheManager/listPagename
//
// INPUT
//
// OUTPUT
//
%><%@ page import="COM.FutureTense.Interfaces.FTValList"
%><%@ page import="COM.FutureTense.Interfaces.ICS"
%><%@ page import="COM.FutureTense.Interfaces.IList"
%><%@ page import="COM.FutureTense.Interfaces.Utilities"
%><%@ page import="COM.FutureTense.Util.ftErrors"
%><%@ page import="COM.FutureTense.Util.ftMessage"
%><%@ page import="java.util.Map"
%><%@ page import="java.util.Date"
%><%@ page import="com.fatwire.cs.core.db.Util"
%><%!
static String getRenderMode(String qs){
    Map map = Utilities.getParams(qs);
    String rm = (String)map.get("rendermode");
    if (rm == null) rm = "live";
    return rm;
}

static String isSS(String qs){
    Map map = Utilities.getParams(qs);
    return (String)map.get("ft_ss");
}

static String getPagename(String qs){
    Map map = Utilities.getParams(qs);
    return (String)map.get("pagename");
}

static String getQSStripped(String qs){
    Map map = Utilities.getParams(qs);
    map.remove("ft_ss");
    map.remove("rendermode");
    map.remove("pagename");
    return Utilities.stringFromValList(map);
}
%><cs:ftcs><% Date now = new Date(); %>
<h3>Detail Inventory of ContentServer Cache</h3>
<% if ("full".equals(ics.GetVar("mode"))) { %>
<table class="altClass">
    <tr>
      <th style="align:right">Nr</th>
        <th align="left">Pagename</th>
        <th>Total</th>
    </tr>
    <ics:sql sql="SELECT pagename, count(id) AS num FROM SystemPageCache GROUP BY pagename ORDER BY num desc" table="SystemPageCache" listname="pages"/>
    <% int i=1; %>
    <ics:listloop listname="pages">
    <tr>
      <td><%= i++ %></td>
        <td><a href='ContentServer?pagename=Support/CacheManager/listPagename&pname=<ics:resolvevariables name="pages.pagename"/>&mode=detail'><ics:resolvevariables name="pages.pagename"/></a></td>
        <td><ics:resolvevariables name="pages.num"/></td>
    </tr>
    </ics:listloop>
    <ics:sql sql="SELECT count(id) AS num FROM SystemPageCache" table="SystemPageCache" listname="pages"/>
    <ics:listloop listname="pages">
    <tr>
        <td colspan="2"><b>Total</b></td>
        <td><ics:resolvevariables name="pages.num"/></td>
    </tr>
    </ics:listloop>
    <ics:sql sql='<%= "SELECT count(id) AS num FROM SystemPageCache WHERE etime < {ts \'"+Util.formatJdbcDate( new Date()) +"\'}" %>' table="SystemPageCache" listname="pages"/>
    <ics:listloop listname="pages">
    <% String num = ics.ResolveVariables("pages.num");
    if (num !=null && Integer.parseInt(num) >0){
        %><tr style='background-color:red'>
        <td colspan="2"><b>Expired</b></td>
        <td><b><ics:resolvevariables name="pages.num"/></b></td>
    </tr>
    <%}%>
    </ics:listloop>

</table>
<% } else if ("itempages".equals(ics.GetVar("mode"))) { %>
<ics:sql sql='<%= ics.ResolveVariables("SELECT * FROM SystemPageCache sp, SystemItemCache si WHERE sp.id=si.page and sp.pagename=\'Variables.pname\' and si.id=\'Variables.iname\' ORDER BY sp.etime") %>' table="SystemPageCache" listname="pages"/>
<table class="altClass">
    <tr>
        <th width="5%">Nr</th>
        <th width="15%">Pagename</th>
        <th width="10%">Render Mode</th>
        <th width="5%">SatS</th>
        <th width="25%">QueryString (Remainder)</th>
        <th width="15%">ModTime</th>
        <th width="15%">ExpiryTime</th>
    </tr>
    <% int j=1; %>
    <ics:listloop listname="pages">
    <tr>
        <td><%= j++ %></td>
        <% String qs = ics.ResolveVariables("pages.@urlqry"); %>
        <td><a href='ContentServer?pagename=Support/CacheManager/listItemsByPage&pid=<ics:resolvevariables name="pages.id"/>'><%= getPagename(qs) %></a></td>
        <td><%= getRenderMode(qs) %></td>
        <td><%= isSS(qs) %></td>
        <td><%= getQSStripped(qs) %></td>
        <td><ics:resolvevariables name="pages.mtime"/></td>
        <td><ics:resolvevariables name="pages.etime"/></td>
    </tr>
    </ics:listloop>
</table>
<% } else { %>
<ics:sql sql='<%= ics.ResolveVariables("SELECT * FROM SystemPageCache WHERE pagename=\'Variables.pname\' ORDER BY etime") %>' table="SystemPageCache" listname="pages"/>
<table class="altClass">
    <tr>
        <th width="5%">Nr</th>
        <th width="15%">Pagename</th>
        <th width="10%">Render Mode</th>
        <th width="5%">SatS</th>
        <th width="25%">QueryString (Remainder)</th>
        <th width="15%">ModTime</th>
        <th width="15%">ExpiryTime</th>
    </tr>
    <% int k=1; %>
    <ics:listloop listname="pages">
    <tr <%= now.after(Util.parseJdbcDate(ics.ResolveVariables("pages.etime"))) ? "style='background-color:red'":"" %>>
        <td><%= k++ %></td>
        <% String qs = ics.ResolveVariables("pages.@urlqry");
        String pid = ics.ResolveVariables("pages.id");
        %>
        <td><a href='ContentServer?pagename=Support/CacheManager/listItemsByPage&pid=<%= pid %>' onmouseover="div_show(this,'<%= pid %>')" onmouseout="div_hide()"><%= getPagename(qs) %></a></td>
        <td><%= getRenderMode(qs) %></td>
        <td><%= isSS(qs) %></td>
        <td><%= getQSStripped(qs) %></td>
        <td><ics:resolvevariables name="pages.mtime"/></td>
        <td><ics:resolvevariables name="pages.etime"/></td>
    </tr>
    </ics:listloop>
</table>
<% }
%><div id="hoverbox" style="position: absolute; visibility: hidden; width: 90%; background: #FFF;"></div>
<script type="text/javascript">
function div_show(obj,key){
    new Ajax.Request('ContentServer', {
      method: 'get',
      parameters: {pagename:'Support/CacheManager/ShowCachedPageEscaped',pid: key},
      onSuccess: function(response){
            var result = response.responseText;
            showPagelet(obj,result);
      },
      onFailure: function(){ showPagelet(obj,'Something went wrong...'); }
    });

}
function div_hide(){
        //div.style.visibility = 'hidden';
}
function showPagelet(obj,result){
    var div= $('hoverbox');
    div.innerHTML=result;
    var oTop  = 0;
    var oLeft = 0;
    // find object position on the page
    do {oLeft+=obj.offsetLeft; oTop+=obj.offsetTop} while (obj=obj.offsetParent);
    // set the position of invisible div
    div.style.top  = (oTop  + 20) + 'px';
    div.style.left = (oLeft + 20) + 'px';
    div.style.visibility = 'visible';
}


</script>
</cs:ftcs>
