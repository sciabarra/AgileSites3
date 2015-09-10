<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld"
%><%//
// Support/TCPI/AP/ShowHeld
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
%><cs:ftcs>
<h3>Detail View - Asset Dependents</h3>
<% if (ics.GetVar("assetid")!=null) { %>
<%//<b>Assetid: <ics:getvar name="assetid" /></b><hr/> %>

<ics:sql sql='<%= ics.ResolveVariables("SELECT * FROM ApprovedAssets WHERE assetid =Variables.assetid ORDER BY targetid") %>' table="ApprovedAssets" listname="apps"/>
<ics:listget listname="apps" fieldname="assettype" output="assettype"/>

<ics:sql sql='<%= ics.ResolveVariables("SELECT status, name, updatedby, updateddate FROM Variables.assettype WHERE id=Variables.assetid") %>' table='<%=ics.GetVar("assettype")%>' listname="thisAsset"/>

<ics:sql sql='<%= ics.ResolveVariables("SELECT pubid as value FROM AssetPublication WHERE assetid=Variables.assetid") %>' table='AssetPublication' listname="sites"/>


<%// ********************* RENDER ASSET INFORMATION ********************* %>
<h4><ics:listget listname="thisAsset" fieldname="name" /></h4>
<h5>
assetid =  <ics:getvar name="assetid" /> <BR/>
assettype =  <ics:getvar name="assettype" /> <BR/>
status = <ics:listget listname="thisAsset" fieldname="status" /><BR/>
updatedby = <ics:listget listname="thisAsset" fieldname="updatedby" /><BR/>
updateddate = <ics:listget listname="thisAsset" fieldname="updateddate" /><BR/>
sites = <ics:listloop listname="sites">
        <ics:listget listname="sites" fieldname="value" output="pubid"/>
        <% if ("0".equals(ics.GetVar("pubid"))){ %>All Sites<%} else { %>
        <ics:sql sql='<%= ics.ResolveVariables("SELECT name as value FROM Publication WHERE id=Variables.pubid") %>' table='Publication' listname="sitename"/>
        <ics:listget listname="sitename" fieldname="value"/>, <%}%>
    </ics:listloop><BR/>
</h5>

<%// ********************* RENDER PUBKEY TABLE RECORDS ********************* %>

<ics:sql sql='<%= ics.ResolveVariables("SELECT * FROM PubKeyTable WHERE assetid=Variables.assetid ORDER BY targetid") %>' table="PubKeyTable" listname="keys"/>
DEBUG: SQL errno = <ics:geterrno/>

<table class="altClass">
<tr><th colspan="6">PubKeyTable</th></tr>
<tr>
    <th>#</th>
    <th>id</th>
    <th>targetid</th>
    <th>newkey</th>
    <th>permanent</th>
    <th>localkey</th>

</tr>

<ics:listloop listname="keys">
    <tr align="center">
        <td><ics:listget listname="keys" fieldname="#curRow"/></td>
        <td><ics:listget listname="keys" fieldname="id"/></td>
        <td><ics:listget listname="keys" fieldname="targetid"/></td>
        <td><ics:listget listname="keys" fieldname="newkey" /></td>
        <td><ics:listget listname="keys" fieldname="ispermanent"/></td>
        <td><ics:listget listname="keys" fieldname="localkey"/></td>
     </tr>
    <ics:sql sql='<%= ics.ResolveVariables("SELECT pubkeyid, assettype, assetid, assetdate FROM PublishedAssets WHERE pubkeyid=keys.id") %>' table="PublishedAssets" listname="publishedassets"/>
    <%
    if (ics.GetErrno()!=-101) {
        %><ics:listloop listname="publishedassets">
        <tr>
            <td align="right" colspan="2">&nbsp;</td>
            <td align="right">PublishedAssets <ics:listget listname="publishedassets" fieldname="#curRow"/></td>
            <td colspan="2"><a href='ContentServer?pagename=Support/TCPI/AP/ShowHeld&assetid=<ics:listget listname="publishedassets" fieldname="assetid" />'><ics:listget listname="publishedassets" fieldname="assettype" /> -
                <ics:listget listname="publishedassets" fieldname="assetid" /></a></td>
            <td><ics:listget listname="publishedassets" fieldname="assetdate" /></td>
        </tr>
        </ics:listloop>
    <%}%>

</ics:listloop>
</table>
Legend:<br/>
<ul>
<li>newkey: N=new, never published, D=published, comp deps specified, I=comp deps are unknown</li>
<li>permanent: Y=yes (a publish point)</li>
</ul>
<br/>

<%// ********************* RENDER APPROVEDASSETS RECORDS FOR THE CURRENT ASSET ********************* %>
<table class="altClass">
    <tr><th colspan="12">ApprovedAssets</th></tr>
    <tr>
        <th>#</th>
        <th>id</th>
        <%//th>assetid</th%>
        <%//th>asset type</th%>
        <th>targetid</th>
        <th>state</th>
        <th>tstate</th>
        <th>reason</th>
        <th>treason</th>
        <th nowrap="true">voided status <br/>(approved)</th>
        <th nowrap="true">voided status<br/> @last publish</th>
        <th nowrap="true">updateddate <br/>(if state = A, M or H)</th>
        <th nowrap="true">updateddate <br/>@last publish</th>
        <%//th>asset version</th%>
        <%//th>last asset version</th%>
        <th nowrap="true">locked <br/>(being modified)</th>
    </tr>

    <ics:listloop listname="apps">
    <tr>
        <td align="right"><ics:listget listname="apps" fieldname="#curRow"/></td>
        <td><ics:listget listname="apps" fieldname="id"/></td>
        <td><ics:listget listname="apps" fieldname="targetid"/></td>
        <td><ics:listget listname="apps" fieldname="state"/></td>
        <td><ics:listget listname="apps" fieldname="tstate"/></td>
        <td><ics:listget listname="apps" fieldname="reason"/></td>
        <td><ics:listget listname="apps" fieldname="treason"/></td>
        <td><ics:listget listname="apps" fieldname="voided"/></td>
        <td><ics:listget listname="apps" fieldname="lastassetvoided"/></td>
        <td nowrap="true"><ics:listget listname="apps" fieldname="assetdate"/></td>
        <td nowrap="true"><ics:listget listname="apps" fieldname="lastassetdate"/></td>
        <td><ics:listget listname="apps" fieldname="locked"/></td>
    </tr>
    </ics:listloop>
</table>
Legend:<br/>
<li>state (fundamental): C=changed, A=approved, M=maybe, H=held<br/>
<li>tstate (template): C=changed, A=approved, M=maybe, H=held<br/>
<li>reason (fundamental/state=held): C=child, N=child never, P=parent<br/>
<li>reason (fundamental/state=maybe): U=undetermined, X=undetermined child, Z=undetermined parent<br/>
<li>treason (template/tstate=held): C=child, N=child never, P=parent<br/>
<li>treason (template/tstate=maybe): U=undetermined, X=undetermined child, Z=undetermined parent<br/>
<br/>

<%// ********************* RENDER SUMMARY ********************* %>
<ics:sql sql='<%= ics.ResolveVariables("SELECT targetid, ownerid, count(id) as num FROM ApprovedAssetDeps WHERE ownerid IN (SELECT id FROM ApprovedAssets WHERE assetid =Variables.assetid) GROUP BY targetid,ownerid ORDER BY targetid") %>' table="ApprovedAssetDeps" listname="deptotals"/>
Errno: <b><ics:geterrno/></b>, Targets: <b><ics:listget listname="deptotals" fieldname="#numRows"/></b>
<table class="altClass">
    <tr>
        <th>#</th>
        <th>Targetid</th>
        <th>Ownerid</th>
        <th>TotalDeps</th>
    <tr>
    <ics:listloop listname="deptotals">
    <tr>
        <td align="right"><ics:listget listname="deptotals" fieldname="#curRow"/></td>
        <td><ics:listget listname="deptotals" fieldname="targetid"/></td>
        <td><ics:listget listname="deptotals" fieldname="ownerid" /></td>
        <td><ics:listget listname="deptotals" fieldname="num" /></td>
    </tr>
    </ics:listloop>
</table>
<hr/>

<%// ********************* RENDER BROKEN RELATIONSHIPS ********************* %>
<ics:sql sql='<%= ics.ResolveVariables("SELECT * FROM ApprovedAssetDeps WHERE EXISTS (SELECT 1 FROM ApprovedAssets WHERE assetid = Variables.assetid AND ApprovedAssetDeps.ownerid = ApprovedAssets.assetid AND ApprovedAssetDeps.targetid != ApprovedAssets.targetid)") %>' table="ApprovedAssetDeps" listname="brokenrefs"/>
DEBUG: SQL errno = <ics:geterrno/>
<% if (ics.GetErrno() ==0) { %>
    <h4>Broken Refs found for this asset</h4>
    <table class="altClass">
        <tr><th colspan="9">ApprovedAssetDeps (broken refs)</th></tr>
        <tr>
            <th>#</th>
            <th>id</th>
            <th>targetid</th>
            <th>ownerid</th>
            <th>assettype</th>
            <th>assetid</th>
            <th>assetdeptype</th>
            <th>currentDep</th>
            <th>depmode</th>
            <th>lastpub</th>
            <th nowrap="true">assetdate <br/>(only if exact)</th>
            <%//th>assetversion</th%>
        </tr>
        <ics:listloop listname="brokenrefs">
        <tr align="center">
            <td><ics:listget listname="brokenrefs" fieldname="#curRow"/></td>
            <td><ics:listget listname="brokenrefs" fieldname="id"  /></td>
            <td><ics:listget listname="brokenrefs" fieldname="targetid"  /></td>
            <td>
                <ics:listget listname="brokenrefs" fieldname="ownerid" output="ownerid" />
                <ics:clearerrno/>
                <ics:sql sql='<%= ics.ResolveVariables("SELECT assetid FROM ApprovedAssets WHERE id=Variables.ownerid")  %>'  table="ApprovedAssets" listname="owner"/>
                <a href='ContentServer?pagename=Support/TCPI/AP/ShowHeld&assetid=<ics:listget listname="owner" fieldname="assetid" />'><ics:getvar name="ownerid"  /></a>
            </td>
            <td><ics:listget listname="brokenrefs" fieldname="assettype" /></td>
            <td><ics:listget listname="brokenrefs" fieldname="assetid" /></td>
            <td><ics:listget listname="brokenrefs" fieldname="assetdeptype" /></td>
            <td><ics:listget listname="brokenrefs" fieldname="currentdep" /></td>
            <td><ics:listget listname="brokenrefs" fieldname="depmode" /></td>
            <td><ics:listget listname="brokenrefs" fieldname="lastpub"  /></td>
            <td><ics:listget listname="brokenrefs" fieldname="assetdate" /></td>
        </tr>
        </ics:listloop>
    </table>
    Legend:<br/>
    <li>depmode: F=fundamental, T=template, R=reference<br/>
    <li>currentdep: F=dep changed or not calculated yet due to edit/change in asset, T=dep exists as of last publish<br/>
    <li>assetdeptype: E=exists, V=exact, G=greater<br/>
    <li>lastpub (dep existed @ last pub): T=true, F=false<br/>
<% } else { %>
    <h4>No broken relationships found in ApprovedAssetDeps</h4>
<% } %>
<br/>

<%// ********************* RENDER APPROVEDASSETDEP CHILDREN TABLE RECORDS ********************* %>
<h4>List of all Child Dependents (per target)</h4>
<ics:listloop listname="deptotals">
    <ics:listget listname="deptotals" fieldname="targetid" output="targetid" />
    <ics:sql sql='<%= ics.ResolveVariables("SELECT name as value FROM PubTarget WHERE id=Variables.targetid")  %>' table="PubTarget" listname="PubTargetName"/>
    <ics:sql sql='<%= ics.ResolveVariables("SELECT * FROM ApprovedAssetDeps WHERE ownerid IN (SELECT id FROM ApprovedAssets WHERE assetid=Variables.assetid) AND targetid=Variables.targetid ORDER BY assettype, assetid")  %>' table="ApprovedAssetDeps" listname="deps"/>
    DEBUG: SQL errno = <ics:geterrno/>
        <% if (ics.GetErrno()==0) { %>
        <h5>Listing not more than 100 records</h5>
    <table class="altClass">
        <tr><th colspan="12">ApprovedAssetDeps - Child Dependencies for <font color="black"><ics:listget listname="PubTargetName" fieldname="value" /></font></th></tr>
        <tr>
            <th>#</th>
            <th>id</th>
            <th>ownerid</th>
            <th>assettype</th>
            <th>assetid</th>
            <th>assetdeptype</th>
            <th>currentDep</th>
            <th>depmode</th>
            <th>lastpub</th>
            <th nowrap="true">assetdate <br/>(only if exact)</th>
            <th>Child Status</th>
            <th>Child state/tstate</th>
        </tr>
        <ics:listloop listname="deps" maxrows="100">
        <tr>
            <td align="right"><ics:listget listname="deps" fieldname="#curRow"/></td>
            <td><ics:listget listname="deps" fieldname="id"  /></td>
            <td><ics:listget listname="deps" fieldname="ownerid"  /></td>
            <td><ics:listget listname="deps" fieldname="assettype"  /></td>
            <td>
                <ics:listget listname="deps" fieldname="assetid" output="assetid2" />
                <ics:clearerrno/>
                <ics:sql sql='<%= ics.ResolveVariables("SELECT assetid, assettype FROM ApprovedAssets WHERE assetid=Variables.assetid2") %>' table="ApprovedAssets" listname="child"/>
                        <% if (ics.GetErrno()==0) { %>
                            <a href='ContentServer?pagename=Support/TCPI/AP/ShowHeld&assetid=<ics:listget listname="deps" fieldname="assetid" />'><ics:getvar name="assetid2"  /></a>
                        <% } else { %>
                            <font color="red">no assetid = <ics:getvar name="assetid2"  /> in ApprovedAssets (i.e. needs to be approved)</font>
                <% } %>
            </td>
            <td><ics:listget listname="deps" fieldname="assetdeptype"  /></td>
            <td><ics:listget listname="deps" fieldname="currentdep"  /></td>
            <td><ics:listget listname="deps" fieldname="depmode"  /></td>
            <td><ics:listget listname="deps" fieldname="lastpub"  /></td>
            <td nowrap="true"><ics:listget listname="deps" fieldname="assetdate" /></td>
                        <td>
                            <ics:clearerrno/>
                            <ics:sql sql='<%= ics.ResolveVariables("SELECT id,status,updateddate,updatedby FROM deps.assettype WHERE id=deps.assetid") %>' table='<%= ics.ResolveVariables("deps.assettype") %>' listname="assets"/>
                            <% if (ics.GetErrno()==0) { %>
                            <table cellspacing="1px" bgcolor="#CCFF99">
                                <tr><td width="10%"><ics:listget listname="assets" fieldname="status"/></td>
                                <td><ics:listget listname="assets" fieldname="updatedby"/></td></tr>
                                <tr><td colspan="2" nowrap="true"><ics:listget listname="assets" fieldname="updateddate"/></td></tr>
                            </table>
                            <% } else { %>
                            <table cellspacing="1px" bgcolor="#CCFF99">
                                <tr><td><font color="red">Missing</font></td></tr>
                            </table>
                            <% } %>
                        </td>
                        <ics:clearerrno/>
                        <ics:sql sql='<%= ics.ResolveVariables("SELECT state, tstate FROM ApprovedAssets WHERE assetid=deps.assetid AND targetid=deps.targetid ORDER BY targetid") %>' table="ApprovedAssets" listname="deps2"/>
                        <% if (ics.GetErrno()==0) { %>
                        <ics:listloop listname="deps2">
                            <td>
                                     <ics:listget listname="deps2" fieldname="state" output="Cstate"/>
                                     <ics:listget listname="deps2" fieldname="tstate" output="Ctstate"/>
                                     <% if ( ("C".equals(ics.GetVar("Cstate"))) && ("A".equals(ics.GetVar("Ctstate"))) ) { %>
                                              <font color="red"><ics:getvar name="Cstate"/>/<ics:getvar name="Ctstate"/></font>
                                     <% } else { %>
                                              <ics:getvar name="Cstate"/>/<ics:getvar name="Ctstate"/>
                                     <% } %>
                            </td>
                        </ics:listloop>
                        <% } else { %>
                            <td>error number: <ics:geterrno/></td>
                        <% } %>
         </tr>
         </ics:listloop>
    </table>
    Legend:<br/>
    <li>depmode: F=fundamental, T=template, R=reference<br/>
    <li>currentdep: F=dep changed or not calculated yet due to edit/change in asset, T=dep exists as of last publish<br/>
    <li>assetdeptype: E=exists, V=exact, G=greater<br/>
    <li>lastpub (dep existed @ last pub): T=true, F=false<br/>
    <% } %>
</ics:listloop>
<br/>

<%-- ********************* RENDER APPROVEDASSETDEP PARENT TABLE RECORDS ********************* --%>

<ics:clearerrno/>
<ics:sql sql='<%= ics.ResolveVariables("SELECT * FROM ApprovedAssetDeps WHERE assetid=Variables.assetid ORDER BY ownerid, assetdeptype")  %>'  table="ApprovedAssetDeps" listname="deps3"/>
<h4>Approved Parent Dependencies for this asset (all targets)</h4>
DEBUG: SQL errno = <ics:geterrno/>
<h5>Listing not more than 100 records</h5>
<table class="altClass">
    <tr><th colspan="11">ApprovedAssetDeps - Parents of Current Asset</th></tr>
    <tr>
        <th>#</th>
        <th>id</th>
        <th>targetid</th>
        <th>ownerid (assettype)</th>
        <th>assetdeptype</th>
        <th>currentdep</th>
        <th>depmode</th>
        <th>lastpub</th>
        <th nowrap="true">assetdate <br/>(only if exact)</th>
        <th>Parent Status</th>
        <th nowrap="true">Parent tstate <br/>per destination</th>
    </tr>

    <ics:listloop listname="deps3" maxrows="100">
    <tr align="center">
        <td><ics:listget listname="deps3" fieldname="#curRow"/></td>
        <td><ics:listget listname="deps3" fieldname="id"  /></td>
        <td><ics:listget listname="deps3" fieldname="targetid"  /></td>
        <td><ics:listget listname="deps3" fieldname="ownerid" output="ownerid" />
            <ics:clearerrno/>
            <ics:sql sql='<%= ics.ResolveVariables("SELECT assetid, assettype FROM ApprovedAssets WHERE id=Variables.ownerid") %>' table="ApprovedAssets" listname="owner"/>
            <% if (ics.GetErrno()==0) { %>
                <a href='ContentServer?pagename=Support/TCPI/AP/ShowHeld&assetid=<ics:listget listname="owner" fieldname="assetid" />'><ics:getvar name="ownerid"  /></a>
                (<ics:listget listname="owner" fieldname="assettype" />)
            <% } else { %>
                    <font color="red">Broken Parent Ref (i.e. no id=<ics:getvar name="ownerid"  />)</font>
            <% } %>
        </td>
        <td><ics:listget listname="deps3" fieldname="assetdeptype" /></td>
        <td><ics:listget listname="deps3" fieldname="currentdep" /></td>
        <td><ics:listget listname="deps3" fieldname="depmode" /></td>
        <td><ics:listget listname="deps3" fieldname="lastpub"  /></td>
        <td nowrap="true"><ics:listget listname="deps3" fieldname="assetdate" /></td>
        <td>
        <ics:clearerrno/>
        <ics:sql sql='<%= ics.ResolveVariables("SELECT id,status,updateddate,updatedby FROM deps3.assettype WHERE id=deps3.assetid") %>' table='<%= ics.ResolveVariables("deps3.assettype") %>' listname="assets"/>
        <% if (ics.GetErrno() ==0) { %>
            <table cellspacing="1px" bgcolor="#CCFF99">
                <tr><td width="10%"><ics:listget listname="assets" fieldname="status"/></td>
                <td><ics:listget listname="assets" fieldname="updatedby"/></td></tr>
                <tr><td colspan="2" nowrap="true"><ics:listget listname="assets" fieldname="updateddate"/></td></tr>
            </table>
        <% } else { %>
            <table cellspacing="1px" bgcolor="#CCFF99">
                <tr><td><font color="red">Missing</font></td></tr>
            </table>
        <% } %>
        </td>
        <td>
        <ics:clearerrno/>
        <ics:sql sql='<%= ics.ResolveVariables("SELECT targetid, tstate FROM ApprovedAssets WHERE assetid = deps3.assetid ORDER BY targetid") %>' table="ApprovedAssets" listname="deps4"/>
        <table cellspacing="1px" bgcolor="#CCFF99">
        <ics:listloop listname="deps4">
            <tr><td nowrap="true"><ics:listget listname="deps4" fieldname="targetid"/></td>
            <td><ics:listget listname="deps4" fieldname="tstate"/></td></tr>
        </ics:listloop>
        </table>
        </td>
    </tr>
    </ics:listloop>
</table>
Legend:<br/>
<ol>
<li>depmode: F=fundamental, T=template, R=reference</li>
<li>currentdep: F=dep changed or not calculated yet due to edit/change in asset, T=dep exists as of last publish</li>
<li>assetdeptype: E=exists, V=exact, G=greater</li>
<li>lastpub (dep existed @ last pub): T=true, F=false</li>
</ol>
<ics:sql sql='<%= ics.ResolveVariables("SELECT pubkeyid, assettype, assetid, assetdate FROM PublishedAssets WHERE assetid=Variables.assetid") %>' table="PublishedAssets" listname="publishedassets"/>
<%
if (ics.GetErrno()!=-101) {
    %>Errno: <b><ics:geterrno/></b>, PubKeys for this PublishedAsset (via PublishedAssets) : <b><ics:listget listname="publishedassets" fieldname="#numRows"/></b>
      <table class="altClass">
            <tr>
                <th>Nr</th>
                <th>Pubkeyid</th>
                <th>Targetid</th>
                <th>Newkey</th>
                <th>Localkey</th>
                <th>Permanent</th>
                <th>Assetdate</th>
            </tr>
            <ics:listloop listname="publishedassets">
            <tr>
                <td align="right"><ics:listget listname="publishedassets" fieldname="#curRow"/></td>
                <ics:sql sql='<%= ics.ResolveVariables("SELECT * FROM PubKeyTable WHERE id=publishedassets.pubkeyid") %>' table="PubKeyTable" listname="keys"/>
                <td><ics:listget listname="publishedassets" fieldname="pubkeyid" /></td>
                <td><ics:listget listname="keys" fieldname="targetid" /></td>
                <td><ics:listget listname="keys" fieldname="newkey" /></td>
                <td><ics:listget listname="keys" fieldname="localkey" /></td>
                <td><ics:listget listname="keys" fieldname="ispermanent" /></td>
                <td><ics:listget listname="publishedassets" fieldname="assetdate" /></td>
            </tr>
            </ics:listloop>
        </table><%
  } else {
     %><font color="red">No PublishedAssets to Display</font> <br/><%
  }





} else {
    %><satellite:form satellite="false" id="tableform" method="POST">
    <input type="hidden" name="pagename" value='<%=ics.GetVar("pagename") %>'/>
    <b>Any Assetid: </b><input type="text" name="assetid" value=""/>&nbsp;<input type="Submit" name="showheld" value="ShowHeld"><br/>
    </satellite:form><%
}
%></cs:ftcs>
