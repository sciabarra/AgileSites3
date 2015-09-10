<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld"
%><%
//
// Support/Info/PerformanceStatsJson
//
// INPUT
//
// OUTPUT
//
%><%@ page import="COM.FutureTense.Interfaces.FTValList"
%><%@ page import="COM.FutureTense.Interfaces.ICS"
%><%@ page import="COM.FutureTense.Interfaces.IList"
%><%@ page import="COM.FutureTense.Interfaces.Utilities"
%><%@ page import="COM.FutureTense.Util.ftErrors"
%><%@ page import="COM.FutureTense.Util.ftMessage"
%><%@ page import="java.math.BigDecimal"
%><%@ page import="java.util.concurrent.ConcurrentHashMap"
%><%@ page import="java.util.regex.MatchResult"
%><%@ page import="java.util.regex.Matcher"
%><%@ page import="java.util.regex.Pattern"
%><%@ page import="java.util.Comparator"
%><%@ page import="org.apache.log4j.AppenderSkeleton"
%><%@ page import="org.apache.log4j.Logger"
%><%@ page import="org.apache.log4j.Level"
%><%@ page import="org.apache.log4j.spi.LoggingEvent"
%><%@ page import="java.text.*"
%><%!

private Logger log;

private Level oldLevel;
private boolean oldAdditivity;
private ConcurrentHashMap<String, Stat> stats = new ConcurrentHashMap<String, Stat>();
public void jspInit() {
  stats.clear();
  log = Logger.getLogger(StatisticsAppender.TIME_DEBUG);
  if (log.getAppender("stats") == null) {
      oldLevel = log.getLevel();
      oldAdditivity = log.getAdditivity();
      if (!log.isDebugEnabled()){
        log.setLevel(Level.DEBUG);
        //log.setAdditivity(false);
      }

      StatisticsAppender a = new StatisticsAppender(stats);
      a.setName("stats");
      a.activateOptions();
      log.addAppender(a);
  }


}

public void jspDestroy() {
  if (log !=null) {
      log.removeAppender("stats");
      log.setLevel(oldLevel);
      //log.setAdditivity(oldAdditivity);
  }
  stats.clear();
}

public Stat[] getStats() {
    synchronized (stats) {
        return stats.values().toArray(new Stat[0]);
    }
}


static class StatisticsAppender extends AppenderSkeleton {
    static final String TIME_DEBUG = "com.fatwire.logging.cs.time";


    private Pattern pagePattern = Pattern
            .compile("Execute page ([^ ]*) Hours: (\\d{1,}) Minutes: (\\d{1,}) Seconds: (\\d{1,}):(\\d{3})");

    private Pattern elementPattern = create("element", true);

    private Pattern preparedStatementPattern = create("prepared statement",
            false);

    private Pattern queryPattern = create("query", false); // select,insert,delete,update

    private Pattern updatePattern = create("update statement", true);

    private Pattern queryPatternWithDot = create("query", true);

    private ConcurrentHashMap<String, Stat> stats;

    StatisticsAppender(ConcurrentHashMap<String, Stat> stats){
        this.stats=stats;
    }

    //@Override
    protected void append(LoggingEvent event) {
        if (event == null)
            return;
        if (TIME_DEBUG.equals(event.getLoggerName())) {
            // it's ours
            if (event.getMessage() != null) {
                try {
                    parseIt(String.valueOf(event.getMessage()));
                } catch(Exception e){
                    e.printStackTrace();
                }
            }
        }
    }

    //@Override
    public void close() {
        stats.clear();
    }

    //@Override
    public boolean requiresLayout() {
        return false;
    }

    private void parseIt(String s) throws Exception {

        String[] pr = this.pageResult(pagePattern.matcher(s));
        if (pr.length == 2) {
            update("page", pr[0], Long.parseLong(pr[1]));
            return;
        }
        String[] r = result(elementPattern.matcher(s));
        if (r.length == 2) {
            update("element", r[0], Long.parseLong(r[1]));
            return;
        }
        r = result(preparedStatementPattern.matcher(s));
        if (r.length == 2) {
            update("sql", getStatementType(r[0]), Long.parseLong(r[1]));
            return;

        }
        r = result(queryPattern.matcher(s));
        if (r.length == 2) {
            update("sql", getStatementType(r[0]), Long.parseLong(r[1]));
            return;

        }
        r = result(queryPatternWithDot.matcher(s));
        if (r.length == 2) {
            update("sql", getStatementType(r[0]), Long.parseLong(r[1]));
            return;

        }
        r = result(updatePattern.matcher(s));
        if (r.length == 2) {
            update("sql", getStatementType(r[0]), Long.parseLong(r[1]));
            return;

        }

    }

    private void update(String type, String subType, long time) {
        if (time > 3722801423L) return; // do not log large values do to bug in CS when turning on time debug.
        String n = subType != null ? (type + "-" + subType) : type;
        Stat s = stats.get(n);
        if (s == null) {
            s = new Stat(type, subType);
            stats.put(n, s);

        }
        s.update(time);

    }

    private void update(String type, long time) {
        update(type, null, time);

    }

    private String getStatementType(String s) {

        int t = s == null ? -1 : s.trim().indexOf(" ");
        if (t != -1) {
            return s.trim().substring(0, t).toLowerCase();
        }
        return "unknown";
    }

    private Pattern create(String type, boolean dot) {
        return Pattern.compile("Executed " + type + " (.+?) in (\\d{1,})ms"
                + (dot ? "." : ""), Pattern.DOTALL);
    }

    private String[] pageResult(Matcher m) {
        String[] r = new String[0];
        if (m.matches()) {
            MatchResult mr = m.toMatchResult();
            if (mr.groupCount() == 5) {

                long t = Long.parseLong(mr.group(2)) * (3600000L);
                t += Long.parseLong(mr.group(3)) * (60000L);
                t += Long.parseLong(mr.group(4)) * (1000L);
                t += Long.parseLong(mr.group(5));
                r = new String[2];
                r[0] = mr.group(1).trim();
                r[1] = Long.toString(t);

            }

        }
        return r;
    }

    private String[] result(Matcher m) {
        String[] r = new String[0];
        if (m.matches()) {
            MatchResult mr = m.toMatchResult();
            r = new String[mr.groupCount()];
            for (int i = 0; i < mr.groupCount(); i++) {
                r[i] = mr.group(i + 1).trim();

            }
        }
        return r;
    }
}

static class Stat {
    private String type;
    private String subType;
    private long min = Long.MAX_VALUE;
    private long max = Long.MIN_VALUE;
    private int count = 0;
    private BigDecimal total = BigDecimal.valueOf(0);

    Stat(String type, String subType) {
        this.type = type;
        this.subType = subType;

    }

    synchronized void update(long t) {
        count++;
        total = total.add(BigDecimal.valueOf(t));
        min = Math.min(min, t);
        max = Math.max(max, t);

    }

    String getType() {
        return type;
    }

    String getSubType() {
        return subType;
    }

    long getMin() {
        return count == 0 ? 0 : min;
    }

    long getMax() {
        return count == 0 ? 0 : max;
    }

    int getCount() {
        return count;
    }

    long getTotal() {
        return total.longValue();
    }

    void reset() {
        min = Long.MAX_VALUE;
        max = Long.MIN_VALUE;
        count = 0;
        total = BigDecimal.valueOf(0);
    }

    double getAverage() {
        if (count == 0)
            return Double.NaN;
        return total.divide(BigDecimal.valueOf(count), 2,
                BigDecimal.ROUND_HALF_UP).doubleValue();
    }
}

static class StatComparator implements Comparator<Stat>{
    public int compare(Stat m, Stat f){
        int c1= code(m);
        int c2=code(f);
        if(c1 < 6){
            return c1 - c2;
        }
        if (c2 < 6){
            return 1;
        }
        if (c1!=c2){
            return c1-c2;
        }
        if (m.getSubType() == null)         return -1;
        if (f.getSubType() == null)         return 1;
        //by now we are sql with unknown subtype, or element

        return m.getSubType().compareTo(f.getSubType());




    }
    String[] t = new String[]{"select","update","insert","delete"};
    private int code(Stat m){
        if ("page".equals(m.getType())){
            return 1;
        }else if ("sql".equals(m.getType())){
            for (int i=0;i<t.length;i++){
                if (t[i].equals(m.getSubType())){
                    return 2+i;
                }
            }
            return 6;
        } else if ("element".equals(m.getType())){
            return 7;
        }else {
            return 8;
        }

    }
}
%><cs:ftcs><%
if ("true".equals(ics.GetVar("detach"))){
    if (log !=null){log.removeAppender("stats");}
}
if ("true".equals(ics.GetVar("clear"))){
    stats.clear();

}

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
cols: [{id: 'type', label: 'Type', type: 'string'},
     {id: 'subtype', label: 'Subtype', type: 'string'},
     {id: 'count', label: 'Count', type: 'number'},
     {id: 'average', label: 'Average', type: 'number'},
     {id: 'total', label: 'Total', type: 'number'},
     {id: 'min', label: 'Min', type: 'number'},
     {id: 'max', label: 'Max', type: 'number'}
    ],
rows:[
<%
    DecimalFormat nf = new DecimalFormat("0.0");
    DecimalFormat tf = new DecimalFormat("0");

    Stat[] stats = getStats();
    java.util.Arrays.sort(stats, new StatComparator());

    for (int i=0; i < stats.length;i++){
        Stat stat = stats[i];
        %>{c:[<%
        %>{v: '<%= stat.getType() %>'}, <%
        %>{v: '<%= stat.getSubType() !=null ? stat.getSubType() :""%>'}, <%
        %>{v: <%= stat.getCount() %>}, <%
        %>{v: <%= nf.format(stat.getAverage()) %>, f: '<%= nf.format(stat.getAverage()) %>'}, <%
        %>{v: <%= tf.format(stat.getTotal()) %>, f: '<%= tf.format(stat.getTotal()) %>'}, <%
        %>{v: <%= stat.getMin() %>}, <%
        %>{v: <%= stat.getMax() %>}<%
        %>]}<%= ((i+1) < stats.length)?",":"" %><%
      }
      %>
]
}});
</cs:ftcs>