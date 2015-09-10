<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%//
// Support/CacheManager/PageCacheSummaryJson
//
// INPUT
//
// OUTPUT
//
%><%@ page import="COM.FutureTense.Interfaces.ICS"
%><%@ page import="COM.FutureTense.Interfaces.IList"
%><%@ page import="COM.FutureTense.Interfaces.Utilities"
%><%@ page import="java.util.Date"
%><%@ page import="java.text.*"
%><%!
interface Formatter {
    String format(String col, IList list) throws NoSuchFieldException;
}
%><cs:ftcs><%
String tqx = ics.GetVar("tqx");
String tq = ics.GetVar("tq");
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


//tq to hold the query
String sql = "";
String colsmeta="cols: [{id: 'ttl', label: 'Time to Live in minutes', type: 'string'},{id: 'pages', label: 'Number of pages', type: 'number'}]";
String[] cols = new String[]{"ttl","pages"};
Formatter minutesFormatter = new Formatter(){
    public String format(String col, IList list) throws NoSuchFieldException{
        String v=list.getValue(col);
        if("ttl".equals(col)){
            int l = Integer.parseInt(v);
            v="'" + l +" (";
            if (l> 60*24*365){
                int y= l/(60*24*365) ;
                if (y >0) v+= y+"y ";
                l = l%(60*24*365);
            }
            if (l> 60*24){
                int d= l/(60*24) ;
                //System.out.println(d +" "+ l);
                if (d >0) v+= d+"d ";
                l = l%(60*24);
            }
            if (l> 60){
                int h= l/(60);
                if (h >0) v+= h+"h ";
                l = l%60;
            }
            if (l >0) v+= l+"m";
            v+= ")'";
        }
        return v;
    }
};
Formatter hoursFormatter = new Formatter(){
    public String format(String col, IList list) throws NoSuchFieldException{
        String v=list.getValue(col);
        if("ttl".equals(col) ||"age".equals(col) ){
            int l = Integer.parseInt(v);
            v="'" + l +" (";
            if (l> 24*365){
                int y= l/(24*365) ;
                if (y >0) v+= y+"y ";
                l = l%24*365;
            }
            if (l> 24){
                int d= l/(24) ;
                if (d >0) v+= d+"d ";
                l = l%24;
            }
            if (l > 0) v+= l+"h";
            v+= ")'";
        }
        return v;
    }
};
Formatter formatter = minutesFormatter;
if (Utilities.goodString(tq)){
    if("select config".equals(tq)){
        if (ics.GetProperty("cs.dbtype").toLowerCase().contains("oracle")){
            sql="SELECT ttl, COUNT(id) AS pages FROM (select  EXTRACT( HOUR FROM (etime-mtime)) *60 +  EXTRACT( DAY FROM (etime-mtime)) *24*60 + EXTRACT( MINUTE FROM (etime-mtime)) as ttl,id FROM SystemPageCache WHERE etime > CURRENT_TIMESTAMP) GROUP BY ttl ORDER BY ttl";
        }else if (ics.GetProperty("cs.dbtype").toLowerCase().contains("hsqldb")){
           sql = "SELECT t.ttl, COUNT(t.id) AS pages FROM (SELECT DATEDIFF('mi',mtime,etime) ttl, id FROM SystemPageCache WHERE etime > CURRENT_TIMESTAMP)  t GROUP BY t.ttl ORDER BY ttl";
        }else {
            sql = "SELECT t.ttl, COUNT(t.id) AS pages FROM (SELECT DATEDIFF(mi,mtime,etime) ttl, id FROM SystemPageCache WHERE etime > CURRENT_TIMESTAMP) t GROUP BY t.ttl ORDER BY ttl";
        }

        colsmeta="cols: [{id: 'ttl', label: 'Time to Live in minutes', type: 'string'},{id: 'pages', label: 'Number of pages', type: 'number'}]";
        cols = new String[]{"ttl","pages"};
    }else if("select ttl".equals(tq)){
        String datediff;
        if (ics.GetProperty("cs.dbtype").toLowerCase().contains("oracle")){
            datediff="EXTRACT( HOUR FROM (etime-SYSTIMESTAMP )) +  EXTRACT( DAY FROM (etime-SYSTIMESTAMP )) *24";
        }else if (ics.GetProperty("cs.dbtype").toLowerCase().contains("hsqldb")){
            datediff = "DATEDIFF('hh',CURRENT_TIMESTAMP,etime)";
        } else {
            datediff = "DATEDIFF(hh,CURRENT_TIMESTAMP,etime)";
        }
        sql="SELECT t.ttl, count(t.id) as pages FROM (SELECT "+datediff+" ttl, id FROM SystemPageCache WHERE etime > CURRENT_TIMESTAMP) t GROUP BY t.ttl ORDER BY ttl";
        colsmeta="cols: [{id: 'ttl', label: 'Time to Live in hours', type: 'string'},{id: 'pages', label: 'Number of pages', type: 'number'}]";
        cols = new String[]{"ttl","pages"};
        formatter=hoursFormatter;

    }else if("select age".equals(tq)){
        String datediff;
        if (ics.GetProperty("cs.dbtype").toLowerCase().contains("oracle")){
            datediff="EXTRACT( HOUR FROM (SYSTIMESTAMP -mtime)) +  EXTRACT( DAY FROM (SYSTIMESTAMP -mtime)) *24";
        } else if (ics.GetProperty("cs.dbtype").toLowerCase().contains("hsqldb")){
           datediff = "DATEDIFF('hh',mtime,CURRENT_TIMESTAMP)";
        } else {
            datediff = "DATEDIFF(hh,mtime,CURRENT_TIMESTAMP)";
        }

        sql="SELECT t.age, count(t.id) AS pages FROM (SELECT "+datediff+" age, id FROM SystemPageCache WHERE etime > CURRENT_TIMESTAMP) t GROUP BY t.age ORDER BY age DESC";
        colsmeta="cols: [{id: 'age', label: 'Age in hours', type: 'string'},{id: 'pages', label: 'Number of pages', type: 'number'}]";
        cols = new String[]{"age","pages"};
        formatter=hoursFormatter;
    }
}
%><%=responseHandler %>({version:'<%=version %>',reqId:'<%= reqId %>',status:'ok',sig:'<%= sig %>',
table:{<%= colsmeta %>,rows:[<%

IList list = ics.SQL("SystemPageCache",sql,"foobarsql", -1, true,  new StringBuffer());

if(list !=null && list.hasData()){
   for (int i = 0; i < list.numRows(); i++){
      list.moveTo(i + 1);
      %><%= i > 0 ? ",":"" %>{c:[<%
      for (int j=0; j< cols.length; j++){
        %><%= j > 0 ? ",":"" %>{v: <%= formatter.format(cols[j],list) %>}<%
      }
      %>]}<%
   }
}
%>]
}});</cs:ftcs>