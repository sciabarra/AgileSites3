<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld"
%><%
//
// Support/Log4J/Log4j_xml
//
// INPUT
//
// OUTPUT
//
%><%@ page import="COM.FutureTense.Interfaces.ICS"
%><cs:ftcs><?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE log4j:configuration SYSTEM "http://logging.apache.org/log4j/docs/api/org/apache/log4j/xml/log4j.dtd">
<log4j:configuration xmlns:log4j="http://jakarta.apache.org/log4j/" debug="false">
    <appender name="console" class="org.apache.log4j.ConsoleAppender">
        <param name="Target" value="System.out" />
        <param name="Threshold" value="info" />
        <layout class="org.apache.log4j.PatternLayout">
            <param name="ConversionPattern" value="%d{ABSOLUTE} %-5p [%c{1}] %m%n" />
        </layout>
    </appender>
    <appender name="file" class="org.apache.log4j.RollingFileAppender">
        <param name="file" value="<%= COM.FutureTense.Interfaces.Utilities.osSafeSpec(getServletConfig().getServletContext().getInitParameter("inipath") +"/futuretense.txt") %>"/>
        <param name="MaxFileSize" value="50MB"/>
        <param name="MaxBackupIndex" value="15"/>
        <param name="append" value="true"/>
        <param name="bufferedIO" value="false"/>
        <param name="BufferSize" value="256"/>
        <layout class="org.apache.log4j.PatternLayout">
            <param name="ConversionPattern" value="%d{ISO8601}[%-5p][%-17.17t][%c{4}] %m%n"/>
        </layout>
    </appender>

    <logger name="com.fatwire">
        <level value="info"></level>
    </logger>
    <logger name="com.fatwire.logging.cs.auth">
        <level value="info"/>
    </logger>
    <logger name="com.fatwire.logging.cs.blobserver">
        <level value="info"/>
    </logger>
    <logger name="com.fatwire.logging.cs.cache.page">
        <level value="info"/>
    </logger>
    <logger name="com.fatwire.logging.cs.cache.resultset">
        <level value="info"/>
    </logger>
    <logger name="com.fatwire.logging.cs.core.http.HttpAccess">
        <level value="info"/>
    </logger>
    <logger name="com.fatwire.logging.cs.core.uri.assembler">
        <level value="info"/>
    </logger>
    <logger name="com.fatwire.logging.cs.core.uri.definition">
        <level value="info"/>
    </logger>
    <logger name="com.fatwire.logging.cs.db">
        <level value="info"/>
    </logger>
    <logger name="com.fatwire.logging.cs.event">
        <level value="info"/>
    </logger>
    <logger name="com.fatwire.logging.cs.export">
        <level value="info"/>
    </logger>
    <logger name="com.fatwire.logging.cs.filelock">
        <level value="info"/>
    </logger>
    <logger name="com.fatwire.logging.cs.firstsite.filter">
        <level value="info"/>
    </logger>
    <logger name="com.fatwire.logging.cs.install">
        <level value="info"/>
    </logger>
    <logger name="com.fatwire.logging.cs.jsp">
        <level value="info"/>
    </logger>
    <logger name="com.fatwire.logging.cs.request">
        <level value="info"/>
    </logger>
    <logger name="com.fatwire.logging.cs.satellite.cache">
        <level value="info"/>
    </logger>
    <logger name="com.fatwire.logging.cs.satellite.host">
        <level value="info"/>
    </logger>
    <logger name="com.fatwire.logging.cs.satellite.request">
        <level value="info"/>
    </logger>
    <logger name="com.fatwire.logging.cs.satellite">
        <level value="info"/>
    </logger>
    <logger name="com.fatwire.logging.cs.session">
        <level value="info"/>
    </logger>
    <logger name="com.fatwire.logging.cs.sync">
        <level value="info"/>
    </logger>
    <logger name="com.fatwire.logging.cs.time">
        <level value="info"/>
    </logger>
    <logger name="com.fatwire.logging.cs.visitor.object">
        <level value="info"/>
    </logger>
    <logger name="com.fatwire.logging.cs.visitor.ruleset">
        <level value="info"/>
    </logger>
    <logger name="com.fatwire.logging.cs.xcelerate.advantage.recommendation">
        <level value="info"/>
    </logger>
    <logger name="com.fatwire.logging.cs.xcelerate.approval">
        <level value="info"/>
    </logger>
    <logger name="com.fatwire.logging.cs.xcelerate.asset">
        <level value="info"/>
    </logger>
    <logger name="com.fatwire.logging.cs.xcelerate.assetmaker">
        <level value="info"/>
    </logger>
    <logger name="com.fatwire.logging.cs.xcelerate.template">
        <level value="info"/>
    </logger>
    <logger name="com.fatwire.logging.cs.xcelerate">
        <level value="info"/>
    </logger>
    <logger name="com.fatwire.logging.cs.xml">
        <level value="info"/>
    </logger>
    <logger name="com.fatwire.logging.cs">
        <level value="info"/>
    </logger>
    <logger name="org.apache.commons.httpclient.HttpClient">
        <level value="warn"/>
    </logger>
    <logger name="org.apache.commons.httpclient.HttpMethodBase">
        <level value="error"/>
    </logger>
    <logger name="httpclient.wire.content">
        <level value="warn"/>
    </logger>
    <logger name="httpclient.wire.header">
        <level value="warn"/>
    </logger>

    <!-- Setup the Root category -->
    <root>
        <priority value="info" />
        <appender-ref ref="file" />
    </root>
</log4j:configuration>
</cs:ftcs>