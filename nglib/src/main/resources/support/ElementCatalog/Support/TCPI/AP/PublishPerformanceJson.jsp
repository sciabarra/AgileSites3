<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ page import="COM.FutureTense.Interfaces.ICS"
%><%@ page import="COM.FutureTense.Interfaces.IList"
%><%@ page import="COM.FutureTense.Interfaces.Utilities"
%><%@ page import="java.util.Date"
%><%@ page import="java.text.*"
%><%@ page import="java.util.Collections"
%><%@ page import="java.util.regex.Matcher"
%><%@ page import="java.util.regex.Pattern"
%><%@ page import="com.fatwire.cs.core.db.PreparedStmt"
%><%@ page import="com.fatwire.cs.core.db.StatementParam"

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
String sql = "SELECT t.name as name, s.id as id, s.cs_sessiondate as cs_sessiondate FROM PubTarget t, PubContext c, PubSession s WHERE c.cs_sessionid=s.id and c.cs_target=t.id ORDER BY s.cs_sessiondate DESC";
String colsmeta="cols: [{id: 'sessionid', label: 'pub sessionid', type: 'number'},{id: 'cs_sessiondate', label: 'Publish End Time', type: 'datetime'},{id: 'target_name', label: 'Destination', type: 'string'},"+
"{id: 'add_pub_list',label: 'Add to PubList',type:'number'},{id: 'mirror_assettypes',label: 'Mirror assettypes',type:'number'},{id: 'mirror_pub_list',label: 'Mirror PubList',type:'number'},"+
"{id: 'send_to_target',label: 'Send to Target',type:'number'},{id: 'mirroring',label: 'Mirroring',type:'number'},{id: 'flush_cache',label: 'Flush Cache',type:'number'},"+
"{id: 'delete_pub_list',label: 'Delete PubList',type:'number'},{id: 'note_publish',label: 'Mark as Published',type:'number'},{id: 'total',label: 'Total Time',type:'number'},{id: 'asset_num',label: 'Number of assets', type:'number'}]";
String[] cols = { "id","cs_sessiondate","target_name","add_pub_list", "mirror_assettypes",
        "mirror_pub_list", "send_to_target", "mirroring",
        "flush_cache", "delete_pub_list", "note_publish", "total",
        "asset_num" };


%><%=responseHandler %>({version:'<%=version %>',reqId:'<%= reqId %>',status:'ok',table:{<%= colsmeta %>,rows:[<%

IList list = ics.SQL("PubSession",sql,"ps", 500, true,  new StringBuffer());
Pattern[] pattern = new Pattern[] {
        Pattern.compile("\\[TIME\\]Done adding assets to AssetPublishList in (\\d{1,}) ms."),
        Pattern.compile("\\[TIME\\]Done mirroring assettypes in (\\d{1,}) ms."),
        Pattern.compile("\\[TIME\\]Done mirroring AssetPublishList in (\\d{1,}) ms."),
        Pattern.compile("\\[TIME\\]Done sending assets to the target in (\\d{1,}) ms."),
        Pattern.compile("\\[TIME\\]Done with mirroring in (\\d{1,}) ms."),
        Pattern.compile("\\[TIME\\]Done flushing the cache on the target in (\\d{1,}) ms."),
        Pattern.compile("\\[TIME\\]Done deleting entries in AssetPublishList in (\\d{1,}) ms."),
        Pattern.compile("\\[TIME\\]Done with NotePublish in (\\d{1,}) ms."),
        Pattern.compile("\\[TIME\\]Publishing took (\\d{1,}) ms for (\\d{1,}) assets.") };

if(list !=null && list.hasData()){
    PreparedStmt ps = new PreparedStmt(
            "SELECT cs_text, cs_serial FROM PubMessage WHERE cs_text LIKE '%TIME]%' AND cs_sessionid=? ORDER BY cs_serial",
            Collections.singletonList("PubMessage"));
    ps.setElement(0, "PubMessage", "cs_sessionid");

   for (int i = 0; i < list.numRows(); i++){
        list.moveTo(i + 1);
        String[] vals= new String[cols.length];
        vals[0]=list.getValue("id");
        vals[1]= "new Date(" + Utilities.calendarFromJDBCString(list.getValue("cs_sessiondate")).getTimeInMillis() +")";
        vals[2]=list.getValue("name");
        StatementParam p = ps.newParam();
        //ics.LogMsg(list.getValue("id"));
        p.setLong(0, Long.parseLong(list.getValue("id")));
        IList history = ics.SQL(ps, p, true);
        if (history != null && history.hasData()) {
            for (int k = 0; k < history.numRows(); k++) {
                history.moveTo(k + 1);
                String text = history.getValue("cs_text");
                //ics.LogMsg(text);
                for (int j = 0; j < pattern.length; j++) {
                    //ics.LogMsg(pattern[j].toString());
                    Matcher m = pattern[j].matcher(text);
                    if (m.matches()) {
                        vals[j+3] =m.group(1);
                        if (j == pattern.length - 1) {
                            vals[j + 4] = m.group(2);
                        }
                        break;
                    }
                }
            }
        }
        %><%= i > 0 ? ",":"" %>{c:[<%
        for (int k=0;k<vals.length;k++){
            %><%= k > 0 ? ",":"" %>{v: <%= (k==2) ?"'"+ org.apache.commons.lang.StringEscapeUtils.escapeJavaScript(vals[k]) +"'":vals[k]  %>}<%
        }
        %>]}<%
   }
}
%>]
}});</cs:ftcs>