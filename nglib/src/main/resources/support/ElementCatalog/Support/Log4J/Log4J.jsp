<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld"
%><%
//
// Support/Log4J/Log4J
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
%><%@ page import="org.apache.log4j.*"
%><%@ page import="org.apache.log4j.spi.*"
%><%@ page import="java.util.*"
%><%!
    private String[] levels = "TRACE,DEBUG,INFO,WARN,ERROR,OFF".split(",");
%><cs:ftcs><h1>Dynamic Log4J Control</h1>
<%  String logName=ics.GetVar("log");
    if (null!=logName) {
        Logger log=("root".equals(logName) ?
            Logger.getRootLogger() : Logger.getLogger(logName));
        log.setLevel(Level.toLevel(ics.GetVar("level"),Level.DEBUG));
    }
    Logger rootLogger=Logger.getRootLogger();
    LoggerRepository loggerRepository=Logger.getRootLogger().getLoggerRepository();

%>

<form>
<table border="1">
<tr>
<th>Num</th>
<th>Level</th>
<th>Logger</th>
<th>Set New Level</th>
</tr>
<tr>
<td>0</td><td><%= rootLogger.getLevel() %></td><td><%= rootLogger.getName() %></td>
<td><% for (int i=0; i< levels.length;i++){
        %><a href='ContentServer?pagename=<%= ics.GetVar("pagename") %>&log=root&level=<%=levels[i] %>'><%=levels[i] %></a> <%
        }
%></td>
</tr>
<%
Set loggerNameSet = new TreeSet();

for (Enumeration loggers = loggerRepository.getCurrentLoggers(); loggers.hasMoreElements();){
    Logger logger = (Logger)loggers.nextElement();
    loggerNameSet.add(logger.getName());

}
int num=0;

boolean showAll = "true".equals(ics.GetVar("showAll")) ;
for (Iterator loggers = loggerNameSet.iterator(); loggers.hasNext();){
        Logger logger = loggerRepository.getLogger((String)loggers.next());
        num++;
        if (logger.getLevel() !=null || showAll){
        %><tr>
                <td><%= Integer.toString(num) %></td>
                <td><%= logger.getLevel() !=null? logger.getLevel().toString():"(inherited: "+ logger.getEffectiveLevel()+")" %></td>
                <td><%= logger.getName() %></td>
                <td><% for (int i=0; i< levels.length;i++){
                    %><a href='ContentServer?pagename=<%= ics.GetVar("pagename") %>&log=<%= logger.getName() %>&level=<%=levels[i] %>&showAll=<%=showAll%>'><%=levels[i] %></a> <%
                }
                %></td>
          </tr>
        <%}
}%>

<tr><td></td><td><input type="text" name="log"/></td><td>
<input type="hidden" name="pagename" value='<ics:getvar name="pagename"/>'/>
<select name="level"><% for (int i=0; i< levels.length;i++){ %><option><%=levels[i] %></option><%}%>
</select> <input type="submit" value="Add New Logger"/></td></tr>

</table>
</form>
Show <a href='ContentServer?pagename=<%= ics.GetVar("pagename") %>&showAll=true'>all known loggers</a> -
Show <a href='ContentServer?pagename=<%= ics.GetVar("pagename") %>'>show configured loggers</a><br/>
Show <a href='ContentServer?pagename=<%= ics.GetVar("pagename") +"Config" %>'>show current logger levels as xml config.</a>
</cs:ftcs>