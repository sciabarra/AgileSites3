<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="time" uri="futuretense_cs/time.tld" %>
<%//
// Support/CacheManager/ShowInvalidRows
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
<script language="JavaScript">
function checkall () {
    var obj = document.forms[0].elements[0];
    var formCnt = obj.form.elements.length;
    for (i=0; i<formCnt; i++) {
    	if (obj.form.elements[i].name == "pagedata")  {
            if (obj.form.elements[i].checked)
    		obj.form.elements[i].checked=false;
            else
                obj.form.elements[i].checked=true;
        }
	else if (obj.form.elements[i].name == "itemdata")  {
            if (obj.form.elements[i].checked)
    		obj.form.elements[i].checked=false;
            else
               	obj.form.elements[i].checked=true;
	}
    }	
}
</script>
<%!
public String DeletePage(String pid, ICS ics) 
{
	String id = pid;
	StringBuffer err = new StringBuffer(); 
	String sName1 = "SystemItemCache";
	String sName2 = "SystemPageCache";
	String sQuery1 = "delete from " + sName1 + " where page = "+ pid;
	String sQuery2 = "delete from " + sName2 + " where id = "+ pid;
	
	IList sList1 = ics.SQL(sName1, sQuery1, "sList1", -1, true, err);
	IList sList2 = ics.SQL(sName2, sQuery2, "sList2", -1, true, err);

	String pagedelete = "";
	if (ics.GetErrno()!=0)
		pagedelete +=  "Error Deleting rows: " + ics.GetErrno();
	else	
		pagedelete += "Delete Successful";

	return pagedelete;
}

public String DeleteItem(String pid, ICS ics) 
{
	String id = pid;
	StringBuffer err = new StringBuffer(); 
	String sName1 = "SystemItemCache";
	String sQuery1 = "delete from " + sName1 + " where page = "+ pid;
	
	IList sList1 = ics.SQL(sName1, sQuery1, "sList1", -1, true, err);

	String itemdelete = "";
	if (ics.GetErrno()!=0)
		itemdelete +=  "Error Deleting rows: " + ics.GetErrno();
	else	
		itemdelete += "Delete Successful";

	return itemdelete;
}
%>

<center><h3>System PageCache Tables</h3></center>

<%
String thisPage = ics.GetVar("pagename");
String nofiles = ics.GetVar("pagedata");
String noparent = ics.GetVar("itemdata");

if (nofiles != null){
%>
<table class="altClass">
<%
  java.util.StringTokenizer tz = new java.util.StringTokenizer(nofiles,";");
  int i=1;
  while (tz.hasMoreTokens()) {
      String token = tz.nextToken();
%>
    <tr><td><%= i++ %></td><td>Deleting Page: <%= token %></td><td><%= DeletePage(token, ics) %></td></tr>
<% } %>
</table>
<% }
else if (noparent != null){
%>
<table class="altClass">
<%
  java.util.StringTokenizer tz = new java.util.StringTokenizer(noparent,";");
  int i=1;
  while (tz.hasMoreTokens()) {
      String token = tz.nextToken();
%>
    <tr><td><%= i++ %></td><td>Deleting Item: <%= token %></td><td><%= DeleteItem(token, ics) %></td></tr>
<% } %>
</table>
<% } %>
<br/>

<h4>SystemPageCache</h4>
<time:set name="pagetime"/>
<%
try
{
	String sTableName = "SystemInfo";
	String sQuery = "select defdir from SystemInfo where tblname='SystemPageCache'";
	StringBuffer errstr = new StringBuffer();
	IList defdirList = ics.SQL(sTableName, sQuery, "iList", -1, true, errstr);
	String sFilepath = "";
	if(defdirList != null && defdirList.hasData())
	{
		defdirList.moveTo(1);
		sFilepath = defdirList.getValue("defdir");
		out.println("defdir=" + sFilepath);
	}
%>
<satellite:form satellite="false" id="tableform" method="POST">
    <input type="hidden" name="pagename" value='<%=ics.GetVar("pagename") %>'/>
    <input type="hidden" name="cmd" value='<%=ics.GetVar("cmd") %>'/> 
    <table class="altClass" style="width:70%">
	<tr>
	    <th></th>
	    <th>Pageid</th>
	    <th>PageName</th>
	    <th>PageUrl</th>
	</tr>
<%	
	sTableName = "SystemPageCache";
	sQuery = "select id, pagename, urlpage from SystemPageCache";
        //sQuery3 = "select sp.id, sp.pagename, count(si.id) as deps from systempagecache sp, systemitemcache si where sp.id=si.page group by sp.id,sp.pagename order by deps desc";
	File fObj = null;
	boolean bNoFalseEntries = true;
	IList pageList = ics.SQL(sTableName, sQuery, "pageList", -1, true, errstr);
	if(pageList != null && pageList.hasData())
	{
		int numRows = pageList.numRows();
		String sPageurl = null;
		
		for (int count=1; count<=numRows; count++)
		{
			pageList.moveTo(count);
			sPageurl = sFilepath + pageList.getValue("urlpage");
			fObj = new File(sPageurl);
			if(!fObj.isFile())				
			{
				out.println("<tr>");
				out.println("<td><input name=\"pagedata\" type=\"checkbox\" value=" + pageList.getValue("id") +" /></td>");
				out.println("<td>" + pageList.getValue("id") + "</td>");
				out.println("<td>" + pageList.getValue("pagename") + "</td>");
				out.println("<td>"+ pageList.getValue("urlpage") + "</td>");
				out.println("</tr>");
				bNoFalseEntries = false;;
			}
		}
	}
	if(bNoFalseEntries)
	{
		out.println("<tr><td colspan=\"4\">SystemPageCache is in Sync with FileSystem</td></tr>");
	}
} catch(Exception e) {
	e.printStackTrace(new java.io.PrintWriter(out));
}
%>
</table>
<br/>
<a href="javascript:void(0);" onclick="return checkall()" onmouseover="window.status='Check all';return true;" onmouseout="window.status='';return true;">CheckAll</a>&nbsp;<input type="Submit" name="DeletePage" value="DeletePage"><br/><br/>
SystemPageCache urlpage took <time:get name="pagetime"/> ms 
<br/><br/>

<h4>SystemItemCache</h4>
<time:set name="itemtime"/>
<ics:sql table="SystemItemCache" listname="cachedItems" sql="select count(si.id) as num from systemitemcache si where not exists (select null from systempagecache sp where sp.id = si.page)" />

<ics:sql table="SystemItemCache" listname="cacheItems" sql="select count(si.id) as num, si.page from systemitemcache si where not exists (select null from systempagecache sp where sp.id = si.page) group by page order by num desc" />

Items (SystemItemCache) without a referenced parent (SystemPageCache): <ics:listget listname="cachedItems" fieldname="num" /><br/>
<table class="altClass" style="width:50%">
	<tr><th></th><th>page</th><th>total</th></tr>
        <ics:listloop listname="cacheItems">
        <tr>
            <td><input name="itemdata" type="checkbox" value='<ics:resolvevariables name="cacheItems.page"/>' /></td>
            <td><ics:listget listname="cacheItems" fieldname="page"/></td>
            <td><ics:listget listname="cacheItems" fieldname="num"/></td>
        </tr>
        </ics:listloop>
</table>

<br/><a href="javascript:void(0);" onclick="return checkall()" onmouseover="window.status='Check all';return true;" onmouseout="window.status='';return true;">CheckAll</a>
&nbsp;<input type="Submit" name="DeleteItem" value="DeleteItem"><br/>
</satellite:form> 

SystemItemCache took <time:get name="itemtime"/> ms 
</cs:ftcs>
