<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="asset" uri="futuretense_cs/asset.tld"
%><%@ taglib prefix="assetset" uri="futuretense_cs/assetset.tld"
%><%@ taglib prefix="commercecontext" uri="futuretense_cs/commercecontext.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="listobject" uri="futuretense_cs/listobject.tld"
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld"
%><%@ taglib prefix="searchstate" uri="futuretense_cs/searchstate.tld"
%><%@ taglib prefix="siteplan" uri="futuretense_cs/siteplan.tld"
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld"
%><%@ page import="COM.FutureTense.Interfaces.*,
                   COM.FutureTense.Util.ftMessage,
                   com.fatwire.assetapi.data.*,
                   com.fatwire.assetapi.*,
                   COM.FutureTense.Util.ftErrors"
%><cs:ftcs><%--

INPUT

OUTPUT

--%>
<%-- Record dependencies for the SiteEntry and the CSElement --%>
<ics:if condition='<%=ics.GetVar("seid")!=null%>'><ics:then><render:logdep cid='<%=ics.GetVar("seid")%>' c="SiteEntry"/></ics:then></ics:if>
<ics:if condition='<%=ics.GetVar("eid")!=null%>'><ics:then><render:logdep cid='<%=ics.GetVar("eid")%>' c="CSElement"/></ics:then></ics:if>

This tool will uninstall the Support Tools.<p/>

The following will be removed from ElementCatalog, SiteCatalog and CSProjects:
<ul>
<li/> - all rows from ElementCatalog where elementname like 'Support/%'
<li/> - all rows from SiteCatalog where pagename like 'Support/%'
<li/> - all rows from CSProjects where projname = 'Support'
</ul><p/>
<b>Use with caution</b>, if you have any customizations here they will be lost. <p/>
If you are sure you wish to proceed, enter "I know what I am doing" in this box and submit.<p/>
<p/>


<satellite:form satellite="false" id="uninstallform" method="POST" >
    <input type="hidden" name="pagename" value='<%=ics.GetVar("pagename") %>'/>
    <input type="text" name="confirm"/>
    <input type="submit"/>
</satellite:form>

The following is a list of exactly what will be deleted:<p/>
<%
boolean delete = false;
String confirm = ics.GetVar("confirm");
if (confirm != null && "I know what I am doing".compareTo(confirm) == 0) delete=true;
%>
<br/><h4>ElementCatalog</h4>
<ics:sql sql="SELECT * from elementcatalog where elementname like \'Support/%\'" table="ElementCatalog" listname="ec" />
<ics:listloop listname="ec">
	<ics:listget listname="ec" fieldname="elementname" output="ename"/>
	elementname=<ics:getvar name="ename"/>
	<%
	if (delete) {
	%>
	<ics:catalogmanager>
		<ics:argument name="ftcmd" value="deleterow" />
		<ics:argument name="tablename" value="ElementCatalog" />
		<ics:argument name="Delete uploaded file(s)" value="yes"/>
		<ics:argument name="tablekey" value="elementname"/>
		<ics:argument name="tablekeyvalue" value='<%=ics.GetVar("ename") %>'/>
	</ics:catalogmanager>
	...delete returned <ics:geterrno/>
	<% } %> <br/>
</ics:listloop>

<br/><h4>SiteCatalog</h4>
<ics:sql sql="SELECT * from sitecatalog where pagename like \'Support/%\'" table="SiteCatalog" listname="sc" />
<ics:listloop listname="sc">
	<ics:listget listname="sc" fieldname="pagename" output="pname"/>
	pagename=<ics:getvar name="pname"/>
	<%
	if (delete) {
	%>
	<ics:catalogmanager>
		<ics:argument name="ftcmd" value="deleterow" />
		<ics:argument name="tablename" value="SiteCatalog" />
		<ics:argument name="Delete uploaded file(s)" value="yes"/>
		<ics:argument name="tablekey" value="pagename"/>
		<ics:argument name="tablekeyvalue" value='<%=ics.GetVar("pname") %>'/>
	</ics:catalogmanager>
	...delete returned <ics:geterrno/>
	<% } %> <br/>
</ics:listloop>

<br/><h4>CSProjects</h4>
<ics:sql sql="SELECT * from csprojects where projname = \'Support\'" table="CSProjects" listname="csp" />
<ics:listloop listname="csp">
	<ics:listget listname="csp" fieldname="id" output="cspid"/>
	id=<ics:getvar name="cspid"/>,  
	projname=<ics:listget listname="csp" fieldname="projname"/> 
	<%
	if (delete) {
	%>
	<ics:catalogmanager>
		<ics:argument name="ftcmd" value="deleterow" />
		<ics:argument name="tablename" value="CSProjects" />
		<ics:argument name="Delete uploaded file(s)" value="yes"/>
		<ics:argument name="tablekey" value="id"/>
		<ics:argument name="tablekeyvalue" value='<%=ics.GetVar("cspid") %>'/>
	</ics:catalogmanager>
	...delete returned <ics:geterrno/>
	<% } %> <br/>
</ics:listloop>

</cs:ftcs>
