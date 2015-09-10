<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%//
// Support/CacheManager/RS/Cache
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
%><cs:ftcs><%
String tqx = ics.GetVar("tqx");
/*
A set of colon-delimited key/value pairs for standard or custom parameters. Pairs are separated by semicolons. Here is a list of the standard parameters defined by the Visualization protocol:

    * reqId - [Required in request; Data source must handle] A numeric identifier for this request. This is used so that if a client sends multiple requests before receiving a response, the data source can identify the response with the proper request. Send this value back in the response.
    * version - [Optional in request; Data source must handle] The version number of the Google Visualization protocol. Current version is 0.5. If not sent, assume the latest version.
    * sig - [Optional in request; Optional for data source to handle] A hash of the DataTable sent to this client in any previous requests to this data source. This is an optimization to avoid sending identical data to a client twice. See Optimizing Your Request below for information about how to use this.
    * out - [Optional in request; Data source must handle] A string describing the format for the returned data. It can be any of the following values:
          o json - [Default value] A JSON response string (described below)
          o html - A basic HTML table with rows and columns. If this is used, the only thing that should be returned is an HTML table with the data; this is useful for debugging, as described in the Response Format section below.
          o csv - Comma-separated values. If this is used, the only thing returned is a CSV data string.
      Note that the only data type that a visualization built on the Google Visualization API will ever request is json. See Response Format below for details on each type.
    * responseHandler - [Optional in request; Data source must handle] The string name of the JavaScript handling function on the client page that will be called with the response. If not included in the request, the value is "google.visualization.Query.setResponse". This will be sent back as part of the response; see Response Format below to learn how.
*/
String reqId = "0";
String version ="0.5";
String sig="5982206968295329967";
String responseHandler="google.visualization.Query.setResponse";
if (Utilities.goodString(tqx)){
    String[] pairs = tqx.split(";");
    for (String pair: pairs){
        int t= pair.indexOf(":");
        //ics.LogMsg(pair);
        if (t >1){
            String name=pair.substring(0,t);
            String value=pair.substring(t+1);
            if ("reqId".equals(name)){
               reqId=value;
            }else if ("out".equals(name)){
                //current version only supports json, other values should set an error response
            }else if ("version".equals(name)){
                version= value;
            }else if ("sig".equals(name)){
                sig= Integer.toString(value.hashCode());
            }else if ("responseHandler".equals(name)){
                responseHandler= value;
            }
        }
    }
}

%><%=responseHandler %>({version:'<%=version %>',reqId:'<%= reqId %>',status:'ok',sig:'<%= sig %>',table:{
cols: [{id: 'cachename', label: 'Name', type: 'string'},
     {id: 'size', label: 'Size', type: 'number'},
     {id: 'capacity', label: 'Capacity', type: 'number'},
     {id: 'fillratio', label: 'Fill Ratio', type: 'number'},
     {id: 'hits', label: 'Hits', type: 'number'},
     {id: 'misses', label: 'Misses', type: 'number'},
     {id: 'hitratio', label: 'Hit Ratio', type: 'number'},
     {id: 'removed', label: 'Removed', type: 'number'},
     {id: 'cleared', label: 'Cleared', type: 'number'},
     {id: 'created', label: 'Created', type: 'datetime'},
     {id: 'pruned', label: 'Last Pruned', type: 'datetime'},
     {id: 'flushed', label: 'Last Flushed', type: 'datetime'},
     {id: 'timeout', label: 'Timeout', type: 'number'},
     {id: 'expireswhenempty', label: 'Expires When Empty', type: 'boolean'},
     {id: 'itemexpires', label: 'Cache Items Expire When Idle', type: 'boolean'},
     {id: 'inotify', label: 'INotify', type: 'boolean'},
     {id: 'links', label: 'Links', type: 'number'}
    ],
rows:[
<%


DateFormat df = new SimpleDateFormat("yyyy,M,d,H,m,s");
DecimalFormat nf = new DecimalFormat("0.0");
Date now = new Date();
Set hashes = ftTimedHashtable.getAllCacheNames();
int i=1;
for (Iterator itor = hashes.iterator(); itor.hasNext();){
      String key = (String)itor.next();
      ftTimedHashtable ht = ftTimedHashtable.findHash(key);
      if (ht != null) {
          RuntimeCacheStats stats = ht.getRuntimeStats();
          double total = stats.getHits() + stats.getMisses();
          double ratio = total ==0?0: (stats.getHits() / total)*100;
          double max = ht.getCapacity();
          double fill_ratio = max < 1 ? 0 : (ht.size() / max)*100;


          %>{c:[
          {v: '<%= key %>'}, <%
          %>{v: <%= ht.size() %>},<%
          %>{v: <%= ht.getCapacity() %>},<%
          %>{v: <%= nf.format(fill_ratio) %>, f: '<%= nf.format(fill_ratio) %> %'},<%
          %>{v: <%= stats.getHits()%>},<%
          %>{v: <%= stats.getMisses()%>},<%
          %>{v: <%= nf.format(ratio) %>, f: '<%= nf.format(ratio) %> %'},<%
          %>{v: <%= stats.getRemoveCount()%>},<%
          %>{v: <%= stats.getClearCount()%>},<%
          %>{v: new Date(<%= df.format(stats.getCreatedDate()) %>)},<%
          %>{v: new Date(<%= df.format(stats.getLastPrunedDate()) %>)},<%
          %>{v: new Date(<%= df.format(stats.getLastFlushedDate())%>)},<%
          %>{v: <%= ht.getTimeout() ==-1 ? Integer.MAX_VALUE : ht.getTimeout() %>, f: '<%= getLengthString(ht.getTimeout())%>'},<%
          %>{v: <%= ht.getCacheExpiresWhenEmpty()%>},<%
          %>{v: <%= ht.getCacheItemsExpireWhenIdle()%>},<%
          %>{v: <%= stats.hasINotifyObjects() %>},<%
          %>{v: <%= ht.getLinks().size() %>}<%
          %>]}<%= itor.hasNext()?",":"" %><%
      }
      %>
<% }
%>]
}});</cs:ftcs>
