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
%><cs:ftcs>
 <!--Load the AJAX API-->
    <script type="text/javascript" src="http://www.google.com/jsapi"></script>
    <!--Div that will hold the pie chart-->
    <div id="chart_div"></div>

    <script type="text/javascript">
      google.load("visualization", "1", {packages:["barchart"]});
      google.setOnLoadCallback(drawChart);
      function drawChart() {
        var data = new google.visualization.DataTable();
        data.addColumn('string', 'Cache');
        data.addColumn('number', 'Hit Ratio');
        data.addColumn('number', 'Fill Ratio');
        <%
        DateFormat df = new SimpleDateFormat("yy/MM/dd HH:mm:ss");
        DecimalFormat nf = new DecimalFormat("0.0");
        Date now = new Date();
        Set hashes = ftTimedHashtable.getAllCacheNames();
        int i=0;

        for (Iterator itor = hashes.iterator(); itor.hasNext();){
              String key = (String)itor.next();
              ftTimedHashtable ht = ftTimedHashtable.findHash(key);
              if (ht != null) {
                  RuntimeCacheStats stats = ht.getRuntimeStats();
                  double total = stats.getHits() + stats.getMisses();
                  if ( total > 3){
                      double ratio = (stats.getHits() / total)*100;
                      double max = ht.getCapacity();
                      double fill_ratio = max < 1 ? 0 : (ht.size() / max)*100;

                      %>data.addRow();<%
                      %>data.setValue(<%= i %>, 0, '<%= key %>');<%
                      %>data.setValue(<%= i %>, 1, <%= nf.format(ratio) %>);<%
                      %>data.setValue(<%= i %>, 2, <%= nf.format(fill_ratio)%>);<%
                      i++;
                  }
              }
              %>
        <% }
        %>
        var chart = new google.visualization.BarChart(document.getElementById('chart_div'));

        chart.draw(data, {height: <%= (i *20) + 50 %>, is3D: true, title: 'Cache Performance'});
      }
    </script>

</cs:ftcs>