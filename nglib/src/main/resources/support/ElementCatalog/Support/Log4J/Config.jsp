<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// Support/Log4J/Log4J
//
// INPUT
//
// OUTPUT
//%>
<%@ page import="COM.FutureTense.Interfaces.FTValList" %>
<%@ page import="COM.FutureTense.Interfaces.ICS" %>
<%@ page import="COM.FutureTense.Interfaces.IList" %>
<%@ page import="COM.FutureTense.Interfaces.Utilities" %>
<%@ page import="COM.FutureTense.Util.ftErrors" %>
<%@ page import="COM.FutureTense.Util.ftMessage"%>
<%@ page import="org.apache.log4j.*" %>
<%@ page import="org.apache.log4j.spi.*" %>
<%@ page import="java.util.*" %>
<cs:ftcs>copy these lines into log4j.xml if you want to persist the current config

-------
<%  
Logger rootLogger=Logger.getRootLogger();
LoggerRepository loggerRepository=Logger.getRootLogger().getLoggerRepository();

Set loggerNameSet = new TreeSet();

for (Enumeration loggers = loggerRepository.getCurrentLoggers(); loggers.hasMoreElements();){
	Logger logger = (Logger)loggers.nextElement();
	loggerNameSet.add(logger.getName());
	
}
int num=0;

for (Iterator loggers = loggerNameSet.iterator(); loggers.hasNext();){
	Logger logger = loggerRepository.getLogger((String)loggers.next());
	//Level level = logger.getEffectiveLevel();
	Level level = logger.getLevel();
	if ( level!=null){ 
	num++;
	%>
	<logger name="<%= logger.getName() %>">
		<level value="<%= level !=null? level.toString():"(inherited)" %>"></level>
	</logger>
	<%}
}%>
------
</cs:ftcs>