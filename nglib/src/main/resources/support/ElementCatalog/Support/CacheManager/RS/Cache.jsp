<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%//
// Support/CacheManager/RS/Cache
//
// INPUT
//
// OUTPUT
//%>
<%@ page import="COM.FutureTense.Interfaces.*"
%><%@ page import="COM.FutureTense.Util.*"
%><%@ page import="com.fatwire.cs.core.cache.RuntimeCacheStats"
%><%@ page import="java.util.*"
%><%@ page import="java.text.*"
%><%!
    String getTimeDiff(Date first, Date last){
        if (first == null || last == null) return "unknown";
        return getTimeDiff(first.getTime(),last);
    }
    String getTimeDiff(long first, Date last){
        if (last == null) return "unknown";
        long diff = last.getTime() - first;
        if (diff < 60000) {
            int sec = (int)(diff/1000);
            return Integer.toString(sec) +" sec";
        } else {
            int sec = (int)(diff/(1000*60));
            return Integer.toString(sec) +" min";
        }
    }
    String getLengthString(long time){
        if (time < 0) return "eternal";
        if (time < 1000) {
            return Long.toString(time)+" ms";
        } else if (time < 60000) {
            return Long.toString(time/1000)+" sec";
        } else {
            return Long.toString(time/(1000*60)) +" min";
        }
    }
%><cs:ftcs>
<a href="ContentServer?pagename=Support/CacheManager/RS/CacheVisualizationTable">Google Table</a>&nbsp;|
<a href="ContentServer?pagename=Support/CacheManager/RS/CacheDetailed">Detailed</a>&nbsp;|
<a href="ContentServer?pagename=Support/CacheManager/RS/Cache">Summary</a>&nbsp;|
<a href="ContentServer?pagename=Support/CacheManager/RS/CacheWarnings">Warnings</a>&nbsp;|
<a href="ContentServer?pagename=Support/CacheManager/RS/CacheText">Text</a><br/>
<h3>Resultset Cache Profiler</h3>
<table class="altClass">
      <tr>
          <th>Nr</th>
          <th>Name</th>
          <th>Hit ratio</th>
          <th>Fill ratio</th>
          <th>Size</th>
          <th>Capacity</th>
          <th>Hits</th>
          <th>Misses</th>
          <th>Removed</th>
          <th>Cleared</th>
      </tr><%
      DateFormat df = new SimpleDateFormat("yy/MM/dd HH:mm:ss");
      DecimalFormat pctFormat = new DecimalFormat("0.0%");
      Date now = new Date();
      Set hashes = ftTimedHashtable.getAllCacheNames();
      int i=1;
      for (Iterator itor = hashes.iterator(); itor.hasNext();){
          String key = (String)itor.next();
          ftTimedHashtable ht = ftTimedHashtable.findHash(key);
          if (ht != null) {
              %><tr><td><%= Integer.toString(i++) %></td><%
              %><td><%= key %></td><%
              RuntimeCacheStats stats = ht.getRuntimeStats();
              double total = stats.getHits() + stats.getMisses();
              double max = ht.getCapacity();
              int hit_ratio = total == 0 ? 0 : (int)((stats.getHits() / total)*100);
              String hit_ratio_s = total == 0 ? "NA" : pctFormat.format(stats.getHits() / total);
              int fill_ratio = ht.getCapacity() < 1 ? 0 : (int)((ht.size() / max)*100);
              String fill_ratio_s = ht.getCapacity() < 1 ? "NA" : pctFormat.format(ht.size() / max);


              %><td style="text-align:center; white-space: nowrap"><%= hit_ratio_s %></td><%
              %><td style="text-align:center; white-space: nowrap"><%= fill_ratio_s %></td><%
              %><td style="text-align:right;white-space: nowrap"><%= ht.size() %></td><%
              %><td style="text-align:right;white-space: nowrap"><%= ht.getCapacity() %></td><%
              %><td style="text-align:right;white-space: nowrap"><%= stats.getHits()%></td><%
              %><td style="text-align:right;white-space: nowrap"><%= stats.getMisses()%></td><%
              %><td style="text-align:right;white-space: nowrap"><%= stats.getRemoveCount()%></td><%
              %><td style="text-align:right;white-space: nowrap"><%= stats.getClearCount()%></td><%
          }
          %></tr>
      <% }  %>
  </table>
<br/>
<ul class="subnav">
    <li><b>Name: </b>name of the key of the table</li>
    <li><b>Size: </b>number of entries in the cache for this table</li>
    <li><b>Hits: </b>number of times a cached object is requested from cache and was in cache</li>
    <li><b>Misses: </b>number of times a cached object is requested from cache and was NOT in cache</li>
    <li><b>Removed: </b>number of items removed from cache, either by time based expiration or LRU.</li>
    <li><b>Cleared: </b>number of times the table is cleared. The happens on any update on the table or by catalog.flush().</li>
    <li><b>Capacity: </b>maximum number of items in the cache. (cc.$tablename$CSz)</li>
</ul>
</cs:ftcs>
