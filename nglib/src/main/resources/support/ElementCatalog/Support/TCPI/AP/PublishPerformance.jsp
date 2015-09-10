<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ page import="COM.FutureTense.Interfaces.*"
%><%@ page import="COM.FutureTense.Util.*"
%><%@ page import="java.util.*"
%><%@ page import="java.text.*"
%><cs:ftcs><script type="text/javascript" src="http://www.google.com/jsapi"></script>
<h3>Publish Sessions Elapsed Time</h3><%

Calendar now = Calendar.getInstance();
Calendar yesterday = Calendar.getInstance();
yesterday.add(Calendar.DAY_OF_MONTH, -1);

%>

Get pubsession date between <input type='text' id='startdate' value='<%= Utilities.sqlDate(yesterday)%>'/>
 and <input type='text' id='enddate' value='<%= Utilities.sqlDate(now) %>'/><input type='button' value='Load data' onclick='return fetchData()' />
<div id="message" style="display: none"><img id="loadingimg" src="js/dojox/image/resources/images/loading.gif" onerror="this.remove();"/><b id="messageText">Getting data. Please wait...</b></div>
<div id="legend" style="display: none"><p>Elapsed times are in milliseconds.</p></div>
<div id="table_div"></div>

<script type="text/javascript">
var table ;
var sort;

if (typeof google != 'undefined'){
    google.load("visualization", "1", {packages:["table"]});
    google.setOnLoadCallback(drawTable);
}else {
    document.location="ContentServer?pagename=Support/Home";
}
function drawTable() {

    table = new google.visualization.Table(document.getElementById('table_div'));
    google.visualization.events.addListener(table, 'sort',
      function(event) {
        sort = [{column: event.column, desc: !event.ascending}];
      });

}
function fetchData() {
    $('message').style.visibility='visible';
    $('message').style.display='block';

    var query = new google.visualization.Query('ContentServer?pagename=Support/TCPI/AP/PublishPerformanceJson&startdate=' +$('startdate').value +'&enddate='+$('enddate').value);
    // Send the query with a callback function.
    query.send(handleQueryResponse);
    return true;
}
function handleQueryResponse(response) {
    $('message').style.display='none';
    if (response.isError()) {
      alert('Error in query: ' + response.getMessage() + ' ' + response.getDetailedMessage());
      return;
    }
    $('legend').style.visibility='visible';
    $('legend').style.display='block';

    var data = response.getDataTable();

    if (sort) {
           data.sort(sort);

    }
    var options = {allowHtml: true,showRowNumber: true};
    table.draw(data, options);
 }

</script>
</cs:ftcs>