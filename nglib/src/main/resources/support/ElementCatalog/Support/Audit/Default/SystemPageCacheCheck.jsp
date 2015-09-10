<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ page import="COM.FutureTense.Interfaces.FTValList"
%><%@ page import="COM.FutureTense.Interfaces.ICS"
%><%@ page import="COM.FutureTense.Interfaces.IList"
%><%@ page import="COM.FutureTense.Interfaces.Utilities"
%><%@ page import="COM.FutureTense.Util.ftErrors"
%><%@ page import="COM.FutureTense.Util.ftMessage"
%><%@ page import="java.io.*"
%><cs:ftcs><div class="content"><%

String tblName = "SystemPageCache";
String defdir=null;
String start = ics.GetVar("start");

defdir= ics.ResolveVariables("CS.CatalogDir.SystemPageCache");
defdir= Utilities.osSafeSpec(defdir);
defdir= new java.io.File(defdir).getCanonicalPath();
if (defdir.charAt(defdir.length()-1) != java.io.File.separatorChar) {
    defdir = defdir.concat(java.io.File.separator);
}

ics.ClearErrno();

if (ics.GetVar("start") == null) {ics.SetVar("start",0);}

%><ics:catalogdef listname="table" table='SystemPageCache'/><%

String sqlStatement="SELECT id, pagename, mtime, urlqry, urlhead, urlpage FROM SystemPageCache WHERE id > Variables.start AND etime > {d '2000-01-01'} ORDER BY id";

String sqlCountStatementUrl="SELECT COUNT(id) AS num FROM SystemPageCache WHERE id > Variables.start";

String sqlCountStatement="SELECT COUNT(id) AS num FROM SystemPageCache";

ics.ClearErrno();

if(Utilities.goodString(ics.GetVar("id"))) {
    for (String i: ics.GetVar("id").split(";")){
        String delStatement = "UPDATE SystemPageCache SET etime = {d '1999-01-01'} WHERE id = " +i;
        %><ics:sql sql='<%= delStatement %>' table='SystemPageCache' listname="deleteme"/><%
    }
    %>Make sure that after you have delete files from ContentServer cache, also flush the Satellite Servers as they will not be flushed by this tool.<%
}
%>

    <h3>Are all SystemPageCache files present on disk?</h3>
    <br/>Defdir: <b><%= defdir %></b><br/>

    <ics:sql sql='<%= ics.ResolveVariables(sqlCountStatement) %>' table='<%= tblName %>' listname="totalcount" />
    <ics:clearerrno/>

    <%
    if (Utilities.goodString(ics.GetVar("start"))) {
        int numrows = 0, badrows = 0;
    %>
    <br/><br/>limiting to <ics:getvar name="limit" /> rows per upload field.
    <ics:sql sql='<%= ics.ResolveVariables(sqlCountStatementUrl) %>' table='<%= tblName %>' listname="count" />

    <% int rows_to_be_done = 0;try {rows_to_be_done= Integer.parseInt(ics.ResolveVariables("count.num")); } catch(Exception e) {}%>
    <ics:clearerrno />
    <ics:sql sql='<%= ics.ResolveVariables(sqlStatement) %>' table='<%= tblName %>' listname="bodies" limit='<%= ics.GetVar("limit") %>'/>
    <%
    if (ics.GetErrno() == 0){
            boolean foundBad=false;
    %>
    <satellite:form satellite="false" method="POST">
    <input type="hidden" name="pagename" value='<ics:getvar name="pagename"/>'/>
    <table class="altClass">
        <ics:listloop listname="bodies"><%
            numrows++;
            boolean[] p = new boolean[3];
            //urlqry, qryhead, urlpage

            p[0]=Utilities.goodString(ics.ResolveVariables("bodies.urlqry")) && Utilities.fileExists(defdir + ics.ResolveVariables("bodies.urlqry")) && new File(defdir,ics.ResolveVariables("bodies.urlqry")).length()>0;
            p[1]=Utilities.goodString(ics.ResolveVariables("bodies.urlhead")) && Utilities.fileExists(defdir + ics.ResolveVariables("bodies.urlhead"));
            p[2]=Utilities.goodString(ics.ResolveVariables("bodies.urlpage")) && Utilities.fileExists(defdir + ics.ResolveVariables("bodies.urlpage"))&& new File(defdir,ics.ResolveVariables("bodies.urlpage")).length()>0;
            if (p[0] == false || p[1]==false || p[2]==false){
                foundBad=true; badrows++;
                if (badrows==1) {
                  %><tr>
                        <th>Nr</th>
                        <th><input type="checkbox" name="all" value='all' onclick="checkall(this.checked, this.form,'id') " /></th>
                        <th>id</th>
                        <th>pagename</th>
                        <th>mtime</th>
                        <th>urlqry</th>
                        <th>urlhead</th>
                        <th>urlpage</th>
                   </tr><%
                }
             %><tr>
                <td align="right"><ics:resolvevariables name="bodies.#curRow" /></td>
                <td><input type="checkbox" name="id" value='<ics:resolvevariables name="bodies.id" />' /></td>
                <td><ics:resolvevariables name="bodies.id" /></td>
                <td><ics:resolvevariables name="bodies.pagename" /></td>
                <td><ics:resolvevariables name="bodies.mtime" /></td>

                <td><%= p[0] ?"FOUND":"NOT FOUND" %></td>
                <td><%= p[1] ?"FOUND":"NOT FOUND" %></td>
                <td><%= p[2] ?"FOUND":"NOT FOUND" %></td>

             </tr><%
            }
           %></ics:listloop>
    </table>
    <input type="hidden" name="start" value='<ics:resolvevariables name="bodies.id" />'/>
    <input type="hidden" name="limit" value='<ics:getvar name="limit" />'/>
    <% if (badrows>0) { %>
      <br/><input type="submit" name="command" value="Expire Selected Rows"/>
    <% } %></satellite:form>
    <%
    if (badrows>0) {
        %>Total Rows with missing files: <b><%= badrows%></b><br/><%
    }
    if (rows_to_be_done - numrows > 0) {
        int limit = 2500;try {limit= Integer.parseInt(ics.GetVar("limit")); } catch(Exception e) {}
        if (limit<2) limit=2;
        %>Rows remaining to be scanned: <b><%= Integer.toString(rows_to_be_done - numrows) %></b><br/><%
        %><a href='ContentServer?pagename=<ics:getvar name="pagename"/>&limit=<%= Integer.toString(limit / 2 ) %>&start=<ics:resolvevariables name="bodies.id" />'><b>&gt;&gt;</b> - Next <%= Integer.toString(limit / 2) %> Rows</a><%
        %><a href='ContentServer?pagename=<ics:getvar name="pagename"/>&limit=<%= Integer.toString(limit) %>&start=<ics:resolvevariables name="bodies.id" />'><b>&gt;&gt;</b> - Next <%= Integer.toString(limit) %> Rows</a><%
        %><a href='ContentServer?pagename=<ics:getvar name="pagename"/>&limit=<%= Integer.toString(limit * 2 ) %>&start=<ics:resolvevariables name="bodies.id" />'><b>&gt;&gt;</b> - Next <%= Integer.toString(limit * 2) %> Rows</a><%
        %><a href='ContentServer?pagename=<ics:getvar name="pagename"/>&limit=<%= Integer.toString(limit * 10) %>&start=<ics:resolvevariables name="bodies.id" />'><b>&gt;&gt;</b> - Next <%= Integer.toString(limit*10) %> Rows</a><br/><%
    }
    if (numrows > 0 && !foundBad){
        %><strong>Scanned <%= numrows%> SystemPageCache rows and all were fine!</strong><br/><br/><%
    }
} else if (ics.GetErrno() == -101) {
    %>No rows found!<br><%
} else {
    %>Error no is: <%= ics.GetErrno() %><br><%
}
    }
    %>
</div>
<script language="JavaScript" type="text/javascript">
function checkall (bool,form,name) {
    var e=form.elements;
    for (i=0; i<e.length; i++) {
        if (e[i].name == name)  {
            e[i].checked=bool;
        }
    }
}
</script>
</cs:ftcs>
