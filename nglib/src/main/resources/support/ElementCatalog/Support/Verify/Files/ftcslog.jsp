<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld"
%><%//

//
// INPUT
//
// OUTPUT
//%>
<%@ page import="COM.FutureTense.Interfaces.FTValList"
%><%@ page import="COM.FutureTense.Interfaces.ICS"
%><%@ page import="COM.FutureTense.Interfaces.IList"
%><%@ page import="COM.FutureTense.Interfaces.Utilities"
%><%@ page import="COM.FutureTense.Util.ftErrors"
%><%@ page import="COM.FutureTense.Util.ftMessage"
%><%@ page import="java.io.*"
%><%@ page import="java.util.*"
%><%@ page import="java.util.regex.*"
%><cs:ftcs><%
Object logfile = org.apache.commons.logging.LogFactory.getFactory().getAttribute("logging.file");

if (logfile instanceof String ){
    if (new File(logfile.toString()).exists()){

        String regex = ics.GetVar("regex");
        Pattern pattern =null;
        if (Utilities.goodString(regex)){
            pattern= Pattern.compile(regex);
        }



        out.println("<a href=\"ContentServer?dbytes="+ics.GetVar("dbytes") +"&pagename="+ics.GetVar("pagename") +"\">reload</a> ");
        out.println("<a href=\"ContentServer?dbytes=10240&pagename="+ics.GetVar("pagename") +"\">10k</a> ");
        out.println("<a href=\"ContentServer?dbytes=102400&pagename="+ics.GetVar("pagename") +"\">100k</a> ");
        out.println("<a href=\"ContentServer?dbytes=1024000&pagename="+ics.GetVar("pagename") +"\">1Mb</a> ");
        out.println("<a href=\"ContentServer?dbytes=5242880&pagename="+ics.GetVar("pagename") +"\">5Mb</a> ");
        %><form style="border:0; margin: 0;display:inline" name="regex" action="ContentServer" method="GET"><input type="hidden" name="pagename" value='<ics:getvar name="pagename"/>'/>
          <input type="text" name="regex" size="40"/>
        </form><%
        out.println("LogFile location: <b>"+ logfile+"</b><br/>");
        %><pre><%
        RandomAccessFile file = new RandomAccessFile(logfile.toString(), "r");
        long filelength = file.length();
        long filepointer = filelength - Long.parseLong(ics.GetVar("dbytes"));
        if (filepointer <0) filepointer = 0;
        if (pattern !=null) filepointer=0;
        if (filepointer>0) file.seek( filepointer );
        String line = null;
        if (filepointer>0) file.readLine(); //read first broken line and throw it away
        int count = 0;
        while( (line = file.readLine()) != null ) {
          if (pattern ==null){
            out.println( org.apache.commons.lang.StringEscapeUtils.escapeHtml(line) );
          }else {
            Matcher m = pattern.matcher(line);
            if(m.find()){
                out.println( Integer.toString(count) +" "+  org.apache.commons.lang.StringEscapeUtils.escapeHtml(line));
            }
          }
          count++;
        }
        out.println("\nTotal Lines: <b>"+ count+"</b>");
        file.close();
        %></pre><%
    } else {
        %>The log file does not exist at <%= logfile %>.<%
    }
}else {
    %>The logging.file property can not be found in commons-logging.properties<%
}
%></cs:ftcs>