<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld"
%><%
//
// Support/Info/PerformanceStats
//
// INPUT
//
// OUTPUT
//
%><cs:ftcs>
<script type="text/javascript" src="http://www.google.com/jsapi"></script>
<center><h3>Time Debug Instrumentation</h3></center>

    <input type='button' value='Refresh' onclick='return getCacheData()' />
    <input type='button' value='Clear Stats' onclick='return clearStats()' />
    <div id="table_div"></div>

    <script type="text/javascript">
     var table ;
     var sort;
     google.load("visualization", "1", {packages:["table"]});
      google.setOnLoadCallback(drawTable2);
      function drawTable2() {
        table = new google.visualization.Table(document.getElementById('table_div'));
        google.visualization.events.addListener(table, 'sort',
              function(event) {
                sort = [{column: event.column, desc: !event.ascending}];
              });

        getCacheData();
      }
      function getCacheData() {
        var query = new google.visualization.Query('ContentServer?pagename=Support/Info/PerformanceStatsJson');
        query.setTimeout(5);
        //query.setRefreshInterval(10);
        // Send the query with a callback function.
        query.send(handleQueryResponse);
        return true;
      }
      function clearStats() {
        var query = new google.visualization.Query('ContentServer?pagename=Support/Info/PerformanceStatsJson&clear=true');
        query.setTimeout(5);
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

       if (sort) {
           data.sort(sort);

       }
       var options = {allowHtml: true,showRowNumber: true};
       table.draw(data, options);
       }


</script>
</cs:ftcs>