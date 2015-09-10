<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld"
%><%//
// Support/CacheManager/RS/CacheVisualization
//
// INPUT
//
// OUTPUT
//
%><%@ page import="COM.FutureTense.Interfaces.*"
%><%@ page import="COM.FutureTense.Util.*"
%><%@ page import="com.fatwire.cs.core.cache.RuntimeCacheStats"
%><%@ page import="java.util.*"
%><%@ page import="java.text.*"
%><cs:ftcs><script type="text/javascript" src="http://www.google.com/jsapi"></script>
<a href="ContentServer?pagename=Support/CacheManager/RS/CacheVisualizationTable">Google Table</a>&nbsp;|
<a href="ContentServer?pagename=Support/CacheManager/RS/CacheDetailed">Detailed</a>&nbsp;|
<a href="ContentServer?pagename=Support/CacheManager/RS/Cache">Summary</a>&nbsp;|
<a href="ContentServer?pagename=Support/CacheManager/RS/CacheWarnings">Warnings</a>&nbsp;|
<a href="ContentServer?pagename=Support/CacheManager/RS/CacheText">Text</a><br/>
<h3>Resultset Cache Profiler</h3>
<input type='button' value='Refresh' onclick='return getCacheData()' />
<div id="table_div"></div>

<script type="text/javascript">
var table ;
var sort;
if (typeof google != 'undefined'){
    google.load("visualization", "1", {packages:["table"]});
    google.setOnLoadCallback(drawTable2);
}else {
    document.location="ContentServer?pagename=Support/CacheManager/RS/CacheDetailed";
}
      function drawTable2() {
        table = new google.visualization.Table(document.getElementById('table_div'));
        google.visualization.events.addListener(table, 'sort',
              function(event) {
                sort = [{column: event.column, desc: !event.ascending}];
              });

        getCacheData();
      }
      function getCacheData() {
        var query = new google.visualization.Query('ContentServer?pagename=Support/CacheManager/RS/CacheJson');
        //query.setRefreshInterval(10);
        // Send the query with a callback function.
        query.send(handleQueryResponse);
        return true;
      }
      function handleQueryResponse(response) {
        if (response.isError()) {
          alert('Error in query: ' + response.getMessage() + ' ' + response.getDetailedMessage());
          return;
        }

       var data = response.getDataTable();

       var formatterReverse = new google.visualization.TableBarFormat({width: 80,base: 0,min:0,max:100, colorPositive: 'red'});
       formatterReverse.format(data, 3);

       var formatter = new google.visualization.TableBarFormat({width: 80,base: 0,min:0,max:100});
       formatter.format(data, 6);

       var date_formatter = new google.visualization.TableDateFormat({pattern: 'MM-dd HH:mm:ss'});
       date_formatter.format(data, 9);
       date_formatter.format(data, 10);
       date_formatter.format(data, 11);
       if (sort) {
           data.sort(sort);

       }
       var options = {allowHtml: true,showRowNumber: true};
       table.draw(data, options);

}
</script>
</cs:ftcs>