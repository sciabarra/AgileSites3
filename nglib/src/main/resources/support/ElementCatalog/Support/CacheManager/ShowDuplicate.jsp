<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld"
%><%//
// Support/CacheManager/ShowDuplicate
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
%><%@ page import="java.util.*"
%><cs:ftcs><h3>Cached Pages</h3><%
StringBuffer errstr = new StringBuffer();
String query = "select pagename from SiteCatalog order by lower(pagename)";
query="SELECT pagename, count(id) AS num FROM SystemPageCache GROUP BY pagename ORDER BY num desc";
IList results = ics.SQL("SystemPageCache" /*"SiteCatalog"*/, query, null, -1, true, errstr);
int rows = results.numRows();
int x=0;
for (int i = 1; i <= rows; i++) {
    results.moveTo(i);
    String pagename = results.getValue("pagename");
    int num = Integer.parseInt(results.getValue("num"));
    if (ics.isCacheable(pagename)){ //assuming ss and cscacheinfo are both set the same
        String[] criteria = ics.pageCriteriaKeys(pagename); //no dups possible if
        if (criteria.length > 0 && num >1){
            out.print("<a href=\"javascript:showDups(this,'"+pagename+"')\">" + pagename +"</a> | ");
            if ( ++x % 4==0) out.print("<br/>");
        }
    }
}

%><div id="hoverbox" style="position: absolute; visibility: hidden; width: 90%; background: #FFF;"></div>
<div id="dups" style="width: 100%; background: #FFF;"></div>
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
function showDups(obj,key){
    $('hoverbox').style.visibility = 'hidden';
    new Ajax.Request('ContentServer', {
      method: 'get',
      parameters: {pagename:'Support/CacheManager/ShowDuplicateDiv',pname: key},
      onSuccess: function(response){
         $('dups').innerHTML=response.responseText;
      },
      onFailure: function(){ $('dups').innerHTML='Something went wrong...'; }
    });

}

function div_hide(){
}
function showPagelet(obj,result){
    var div= $('hoverbox');

    div.innerHTML=result;
    var oTop  = 0;
    var oLeft = 0;
    // find object position on the page
    do {oLeft+=obj.offsetLeft; oTop+=obj.offsetTop} while (obj=obj.offsetParent);
    // set the position of invisible div
    div.style.top  = (oTop  + 10) + 'px';
    div.style.left = (oLeft + 20) + 'px';
    div.style.visibility = 'visible';
}
</script></cs:ftcs>