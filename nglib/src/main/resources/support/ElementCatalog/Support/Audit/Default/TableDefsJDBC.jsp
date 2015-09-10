<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// Support/Audit/Default/IndicesJDBC
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
<%@ page import="javax.naming.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="javax.sql.*" %>

<cs:ftcs>

<%!
String[] indexes = {"INDEX_NAME","COLUMN_NAME","TYPE","ASC_OR_DESC","CARDINALITY","PAGES","FILTER_CONDITION","NON_UNIQUE"};
int indexNum = indexes.length;
String[] types = {"Statistic","Clustered","Hashed","Other"};

private Connection getConnection(String connectString) throws Exception
{
    InitialContext ic = new InitialContext();
    DataSource ds   =  (DataSource) ic.lookup(connectString);
    return  ds.getConnection();
}

private void printMetaData(DatabaseMetaData dmd, JspWriter out) throws Exception
{

    out.println("<table><tr><td>Database Server Name</td><td>" + dmd.getDatabaseProductName() + "</td></tr>");
    out.println("<tr><td>Database Server Version</td><td>" + dmd.getDatabaseProductVersion() + "</td></tr>");
    out.println("<tr><td>JDBC Driver Version</td><td>" + dmd.getDriverName() + " " + dmd.getDriverVersion() +  "</td></tr>");
    out.println("<tr><td>JDBC Driver URL</td><td>" + dmd.getURL() + "</td></tr></table><br/><br/>");

}

private void printDef(DatabaseMetaData dmd, JspWriter out, String tableName) throws Exception
{

    ResultSet rs = null;
    try {
    rs=dmd.getColumns(null, null, tableName, null);

    String tableResult = "<b>Table Information for " + tableName + "</b><br/><table class=\"altClass\"><tr><th>Schema</th><th>Table Name</th><th>Column Name</th><th>Type</th><th>Size</th><th>Nullable</th></tr>";

    int numRows = 0;

    while(rs.next()) {
        tableResult += "<tr><td>" + rs.getString("TABLE_SCHEM") + "</td>" +
                                    "<td>" + rs.getString("TABLE_NAME") + "</td>" +
                                    "<td>" + rs.getString("COLUMN_NAME") + "</td>" +
                                    "<td>" + rs.getString("TYPE_NAME") + "</td>" +
                                    "<td>" + (rs.getString("COLUMN_SIZE")==null?"":rs.getString("COLUMN_SIZE")) + "</td>" +
                                    "<td>" + rs.getString("IS_NULLABLE") + "</td>" +
                                    "</tr>";

        numRows++;
    }

    tableResult += "</table><br/>";

    if (numRows > 0)
        out.print(tableResult);

    numRows = 0;

    rs = dmd.getIndexInfo(null, null, tableName, false, false);

    tableResult = "<b>Index Information</b><br/><table  class=\"altClass\"><tr><th>Index Name</th><th>Column Name</th><th>Ordinal Position</th><th>Non-Unique</th></tr>";

    while (rs.next()) {
        if (rs.getString("INDEX_NAME") != null) {
            tableResult += "<tr><td>" + rs.getString("INDEX_NAME") + "</td>" +
                                        "<td>" + rs.getString("COLUMN_NAME") + "</td>" +
                                        "<td>" + rs.getString("ORDINAL_POSITION") + "</td>" +
                                        "<td>" + (rs.getBoolean("NON_UNIQUE") ? "true" : "false" ) + "</td></tr>";
            numRows++;
        }
    }

    tableResult += "</table><br/>";

    if (numRows > 0)
            out.print(tableResult);
    }finally {
        if(rs !=null) rs.close();
    }
}


%>

<%
Connection con = null;
String sFormat = ics.GetProperty(ftMessage.propDBConnPicture);

if (!Utilities.goodString(sFormat)) {
    sFormat = "jdbc/$dsn";
}

String connectString = Utilities.replaceAll(sFormat, ftMessage.connpicturesub, ics.GetProperty("cs.dsn"));

try {
    con  =  getConnection(connectString);
    DatabaseMetaData dmd = con.getMetaData();

    boolean makeUpperCase = con.getMetaData().storesUpperCaseIdentifiers();
    ics.ClearErrno();
    %><h3>Overview of ContentServer Table Definitions</h3><%

    printMetaData(dmd, out);

    String t = ics.GetVar("tablename");
    if(t !=null && t.length() > 0 ){
        for (String tableName : t.split(";")){
            if (dmd.storesLowerCaseIdentifiers()) {
                tableName = tableName.toLowerCase();
            }
            else if (dmd.storesUpperCaseIdentifiers()) {
                tableName = tableName.toUpperCase();
            }

            try{
                printDef(dmd,out,tableName);
            } catch (Exception e){
                %><%= e.getMessage() %><%
            }
        }

    }

    String sql="SELECT DISTINCT systable FROM SystemInfo ORDER BY systable DESC";
    IList types= ics.SQL("SystemInfo", sql,"A",-1,true,new StringBuffer());

    %><satellite:form satellite="false" id="tableform" method="POST">
    <input type="hidden" name="pagename" value='<%=ics.GetVar("pagename") %>'/>
    <input type="hidden" name="cmd" value='<%=ics.GetVar("cmd") %>'/>
    <a href="javascript:void(0);" onclick="return checkall()" onmouseover="window.status='Select all tables';return true;" onmouseout="window.status='';return true;">check all</a>&nbsp;
    <input type="submit" name="s" value='Submit'/>
    <table class="altClass"><tr><%

    for (IList type : new COM.FutureTense.Util.IterableIListWrapper(types)){
        sql = "SELECT tblname FROM SystemInfo WHERE systable = '"+ type.getValue("systable") +"' AND tblname NOT IN (\'SystemAssets\') ORDER BY LOWER (tblname) ASC";

        IList list= ics.SQL("SystemInfo", sql,"B",-1,true,new StringBuffer());

        %><td style="vertical-align: top">
        <b>Total <%= ""+ list.numRows() %> tables of type: <%= type.getValue("systable") %></b><br/><%
        for (IList row : new COM.FutureTense.Util.IterableIListWrapper(list)){
            String tableName = row.getValue("tblname");
            String uri = "ContentServer?pagename="+ ics.GetVar("pagename") + "&cmd="+ics.GetVar("cmd") + "&tablename="+tableName;
            %><input type="checkbox" name="tablename" value="<%= tableName %>" /><%= tableName %><br/><%
        }
        %></td><%
    }
    %></tr></table></satellite:form><%
} finally {
    if (con !=null){
        con.close();
    }
}

%>
<script language="JavaScript">
function checkall () {
    var obj = document.forms[0].elements[0];
    var formCnt = obj.form.elements.length;

    for (i=0; i<formCnt; i++) {
        if (obj.form.elements[i].name == "tablename")  {
            if (obj.form.elements[i].checked)
                obj.form.elements[i].checked=false;
             else
                obj.form.elements[i].checked=true;
        }
    }
}
</script>

</cs:ftcs>