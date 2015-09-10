<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ page import="COM.FutureTense.Interfaces.ICS"
%><%@ page import="COM.FutureTense.Interfaces.IList"
%><%@ page import="COM.FutureTense.Interfaces.Utilities"
%><%@ page import="java.util.*"
%><%@ page import="java.text.*"
%><%@ page import="java.util.Collections"
%><%@ page import="java.util.regex.Matcher"
%><%@ page import="java.util.regex.Pattern"
%><%@ page import="com.fatwire.cs.core.db.PreparedStmt"
%><%@ page import="com.fatwire.cs.core.db.StatementParam"
%><%!

long diff(String d1, String d2){
    return Math.abs(Utilities.calendarFromJDBCString(d2).getTimeInMillis() -Utilities.calendarFromJDBCString(d1).getTimeInMillis())/1000;
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
String sql = "SELECT t.name as name, s.id as id, s.cs_status as cs_status, s.cs_sessiondate as cs_sessiondate, s.cs_enddate as cs_enddate FROM PubTarget t, PubContext c, PubSession s WHERE c.cs_sessionid=s.id AND c.cs_target=t.id AND s.cs_sessiondate BETWEEN ? AND ? ORDER BY s.cs_sessiondate DESC";

PreparedStmt ps = new PreparedStmt(
    sql,Arrays.asList(new String[]{"PubTarget", "PubContext" , "PubSession"}));
ps.setElement(0, "PubSession", "cs_sessiondate");
ps.setElement(1, "PubSession", "cs_enddate");
StatementParam p = ps.newParam();
long t1=Utilities.calendarFromJDBCString(ics.GetVar("startdate")).getTimeInMillis();
long t2=Utilities.calendarFromJDBCString(ics.GetVar("enddate")).getTimeInMillis();
p.setTimeStamp(0, new java.sql.Timestamp(t1 < t2 ? t1:t2));
p.setTimeStamp(1, new java.sql.Timestamp(t1 < t2 ? t2:t1));


String colsmeta="cols: [{id: 'sessionid', label: 'pub sessionid', type: 'number'},{id: 'cs_sessiondate', label: 'Publish Start Time', type: 'datetime'},{id: 'target_name', label: 'Destination', type: 'string'},"+
"{id: 'cs_status', label: 'Status', type: 'string'},{id: 'gatherer',label: 'Gatherer',type:'number'},{id: 'packager',label: 'Packager',type:'number'},{id: 'transporter',label: 'Transporter',type:'number'},"+
"{id: 'unpacker',label: 'Unpacker',type:'number'},{id: 'cacheflusher',label: 'Flush Cache',type:'number'},"+
"{id: 'total',label: 'Total Time',type:'number'},{id: 'asset_num',label: 'Number of assets', type:'number'}]";
String[] cols = { "id","cs_sessiondate","target_name","status","gatherer", "packager",
        "transporter", "unpacker", "cacheflusher", "total","asset_num" };


%><%=responseHandler %>({version:'<%=version %>',reqId:'<%= reqId %>',status:'ok',table:{<%= colsmeta %>,rows:[<%

IList list = ics.SQL(ps, p, true);

String[] types= new String[]{"Gatherer","Packager","Transporter","Unpacker","CacheFlusher"};

double[] elapsed= new double[7];
int[] nums= new int[7];

if(list !=null && list.hasData()){
   ps = new PreparedStmt(
        "SELECT component, started,lastupdate FROM FW_PubProgress WHERE pubsession=? AND started IS NOT NULL",
            Collections.singletonList("FW_PubProgress"));
   ps.setElement(0, "FW_PubProgress", "pubsession");


   PreparedStmt pstot = new PreparedStmt(
        "SELECT cs_text from PubMessage WHERE cs_status='__ASSTS_PUBLISHD__' AND cs_sessionid=?",
            Collections.singletonList("PubMessage"));
   pstot.setElement(0, "PubMessage", "cs_sessionid");
   int i = 0;
   for (; i < list.numRows(); i++){
        list.moveTo(i + 1);
        String[] vals= new String[cols.length];
        vals[0]=list.getValue("id");
        vals[1]= "new Date(" + Utilities.calendarFromJDBCString(list.getValue("cs_sessiondate")).getTimeInMillis() +")";
        vals[2]=list.getValue("name");
        vals[3]=list.getValue("cs_status");
        p = ps.newParam();
        p.setLong(0, Long.parseLong(list.getValue("id")));
        IList history = ics.SQL(ps, p, true);
        if (history != null && history.hasData()) {
            for (int k = 0; k < history.numRows(); k++) {
                history.moveTo(k + 1);
                String text = history.getValue("component");
                for (int j = 0; j < types.length; j++) {
                    if (types[j].equals(text)) {
                        long d = diff(history.getValue("started"),history.getValue("lastupdate"));
                        elapsed[j] += d;
                        nums[j]++;
                        vals[j+4] = Long.toString(d);
                        break;
                    }
                }
            }
        }
        p = pstot.newParam();

        p.setLong(0, Long.parseLong(list.getValue("id")));
        history = ics.SQL(pstot, p, true);
        if (history != null && history.hasData()) {
            history.moveTo(1);
            String text = history.getValue("cs_text");
            elapsed[6] += Integer.parseInt(text);
            nums[6]++;

            vals[cols.length-1]=text;
        }
        if (Utilities.goodString(list.getValue("cs_enddate")) && Utilities.goodString(list.getValue("cs_sessiondate"))){
            long total1=diff(list.getValue("cs_enddate"),list.getValue("cs_sessiondate"));
            elapsed[5] += total1;
            nums[5]++;
            vals[cols.length-2]= Long.toString(total1);
        }

        %><%= i > 0 ? ",":"" %>{c:[<%
        for (int k=0;k<vals.length;k++){
            %><%= k > 0 ? ",":"" %>{v: <%= (k==2 || k==3) ?"'"+ org.apache.commons.lang.StringEscapeUtils.escapeJavaScript(vals[k]) +"'":vals[k]  %>}<%
        }
        %>]}<%
   }
   if (i>0){
    %>,{c:[{v: null},{v: null},{v: 'AVERAGE'},{v: null}<%

    for (int k=0;k<elapsed.length;k++){
        %>,{v: <%= nums[k] ==0 ? "": Long.toString(Math.round(elapsed[k]/nums[k]))  %>}<%
    }
    %>]}<%
   }

}
%>]
}});</cs:ftcs>