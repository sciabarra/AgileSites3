<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// Support/Audit/V7/RevTrack/deleteHistoryVersion
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
<%@ page import="java.io.*"%>
<cs:ftcs>
<%
    String table = ics.GetVar("table");
    String assetid = ics.GetVar("assetid");
    String version = ics.GetVar("version");
    String defdir = ics.GetVar("defdir");
    String force = ics.GetVar("force");
    boolean deleteFailed = false;
    String revisionTable = table + "_History";
    if(defdir!=null && !defdir.equals("")) {
        String sql = "select * from " + revisionTable + " where asset = " + assetid + " and version = " + version;
%>
<ics:sql sql='<%=sql%>' table='<%=revisionTable%>' listname="history"/>
<ics:clearerrno/>
<%
        IList list = ics.GetList("history");
        if(list!=null && list.numRows()==1) {
            list.moveTo(1);
            String filename = defdir + list.getValue("urlobjectdata");
            %>File: <%=filename%><%
            try {
                File file = new File(filename);
                if(file.exists()) {
                    deleteFailed=file.delete();
                } else {
                    deleteFailed = true;
                    %> not found.<%
                }
            } catch(SecurityException se) {
                deleteFailed = true;
                se.printStackTrace();
                %> Not allowed to delete (<%=se.getMessage()%>). Check security settings in appserver and on disk.<%
            }

            String deleteSql = "delete from " + revisionTable + " where asset = " + assetid + " and version = " + version;
            %>
            <ics:sql sql='<%=deleteSql%>' table='<%=revisionTable%>' listname="dummy"/>
            <%
            String color = "black";
            if(ics.GetErrno()!=-502) {
                deleteFailed = true;
                color = "red";
            }
            %>
            <br><span style='<%="color: " + color%>'>Deleted row from <%=revisionTable%> with result <ics:geterrno/>.</span>
            <ics:clearerrno/>
            <%
        } else {
            deleteFailed = true;
            %>
            <br>History table record not found. SQL: <%=sql%>
            <br>Errorno: <ics:geterrno/>
            <%
        }
    }

    if(!deleteFailed || "true".equals(force)) {
        %>
        <ics:catalogmanager>
            <ics:argument name="ftcmd" value="deleterevision"/>
            <ics:argument name="tablename" value='<%=table%>'/>
            <ics:argument name="asset" value='<%=assetid%>'/>
            <ics:argument name="version" value='<%=version%>'/>
        </ics:catalogmanager>
        <%
        String color = "black";
        if(ics.GetErrno()!=0) {
            deleteFailed = true;
            color = "red";
        }
        %>
        <br><span style='<%="color: " + color%>'>Revision deleted with result <ics:geterrno/>.</span>
        <ics:clearerrno/>
        <%
    } else {
        %><br><span style="color: red;">Failed to delete <%=revisionTable%> record. Revision skipped.</span><%
    }
%>
<ics:clearerrno/>
</cs:ftcs>
