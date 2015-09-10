<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%//
// Support/CacheManager/PageCacheSummary
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
%><cs:ftcs><script type="text/javascript" src="http://www.google.com/jsapi"></script>
<center><h3>Page Cache Summary</h3></center>
<div id="config"></div>
<div id="ttl"></div>
<div id="age"></div>
<script type="text/javascript">
var state=0;
if (typeof google != 'undefined'){
    google.load('visualization', '1', {packages: ['columnchart']});
    google.setOnLoadCallback(drawChart);
} else {
    state=1;
    $('config').textContent='This browser can not access the Google Visualizations API over the internet. Nothing to show. Please enable a internet connection and come back.';
}

function drawChart() {
    state=1;
    getData();
}

function getData(){
    if (state !=1) return;
    state=2;

    execute('config','Configured Time to Live');
    execute('ttl','Life expectancy of pages in cache');
    execute('age','Age of pages in cache');
    return true;
}
function execute(tq,title) {
    if (typeof google != 'undefined'){
        $(tq).style.width='90%'
        $(tq).style.height='300px';
    }

    var query = new google.visualization.Query('ContentServer?pagename=Support/CacheManager/PageCacheSummaryJson');
    //query.setRefreshInterval(10);
    // Send the query with a callback function.
    query.setQuery('select ' + tq);

    query.send(handleQueryResponse);
    function handleQueryResponse(response) {
        if (response.isError()) {
          alert('Error in query: ' + response.getMessage() + ' ' + response.getDetailedMessage());
          return;
        }

        var data = response.getDataTable();

        var chart = new google.visualization.ColumnChart($(tq));
        chart.draw(data, {'title': title, logScale: true});
    }
}
</script>
</cs:ftcs>