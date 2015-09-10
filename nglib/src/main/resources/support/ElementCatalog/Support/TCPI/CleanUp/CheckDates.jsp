<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld"
%><%//
// Support/TCPI/CleanUp/CheckDates
//
// INPUT
//
// OUTPUT
//
%><cs:ftcs><h3>Validate Dates in ApprovedAssets and ApprovedAssetDeps Tables</h3><%

String assetType = ics.GetVar("assettype");
if(assetType==null || assetType.trim().equals("")) { 
	String sql = "SELECT pt.id as targetid, pt.name as name, aa.assettype as assettype, count(distinct aa.assetid) as num, count(*) as num2 "+
    "FROM ApprovedAssets aa, ApprovedAssetDeps aad, PubTarget pt "+
    "WHERE aad.targetid = pt.id "+
    "AND aad.currentdep = 'T' "+
    "AND aad.depmode in ('T', 'R') "+
    "AND aad.assetdeptype in ('V', 'G') "+
    "AND aa.assetid = aad.assetid "+
    "AND aa.targetid = aad.targetid "+
    "AND aa.tstate = 'H' "+
    "AND aa.treason = 'P' "+
    "AND ((aad.assetdeptype = 'V' AND aad.assetdate <> aa.assetdate) "+
    "OR (aad.assetdeptype = 'G' AND aad.assetdate > aa.assetdate) ) "+
    "GROUP BY pt.name, pt.id, aa.assettype";
	ics.ClearErrno();
%><ics:sql sql="<%= sql %>"  table="ApprovedAssets,ApprovedAssetDeps,PubTarget" listname="aList" />
    <% if (ics.GetErrno() == -101) {  %>
        No Disagreeing Dates Found.<br/>
    <% } else if (ics.GetErrno() == 0) { %>
      <table class="altClass">
        <tr>
          <th>Target</th>
          <th>AssetType</th>
          <th>Number of Assets with <br/>Disagreeing Asset Dates</th>
          <th>Number of Disagreeing Records</th>
        </tr>
        <ics:listloop listname="aList">
        <tr>
          <td><ics:listget listname="aList" fieldname="name"/></td>
          <td><a href='ContentServer?pagename=<ics:getvar name="pagename"/>&targetid=<ics:listget listname="aList" fieldname="targetid"/>&assettype=<ics:listget listname="aList" fieldname="assettype"/>'><ics:listget listname="aList" fieldname="assettype"/></a></td>
          <td><ics:listget listname="aList" fieldname="num"/></td>
          <td><ics:listget listname="aList" fieldname="num2"/></td>
        </tr>
        </ics:listloop>
      </table><%
     } 
 } else { 
     boolean fix = "true".equals(ics.GetVar("fix")); 
     String sql = ics.ResolveVariables("SELECT aa.id as aaid, aad.id as aadid, aad.ownerid as ownerid, aa.assetid as assetid, aa.assetdate as assetdate, aad.assetdate as assetdepdate "+
             "FROM ApprovedAssets aa, ApprovedAssetDeps aad "+
             "WHERE aad.targetid = Variables.targetid "+
             "AND aad.assettype = \'Variables.assettype\' "+
             "AND aad.currentdep = \'T\' "+
             "AND aad.depmode in (\'T\', \'R\') "+
             "AND aad.assetdeptype in (\'V\', \'G\') "+
             "AND aa.assetid = aad.assetid "+
             "AND aa.targetid = aad.targetid "+
             "AND aa.tstate = \'H\' "+
             "AND aa.treason = \'P\' "+
             "AND ((aad.assetdeptype = \'V\' AND aad.assetdate <> aa.assetdate) "+
             "OR (aad.assetdeptype = \'G\' AND aad.assetdate > aa.assetdate)) "+
             "ORDER BY aa.assetid");
     ics.ClearErrno();
    %><ics:sql sql='<%= sql %>' table="ApprovedAssets,ApprovedAssetDeps" listname="aList" /><%
    if (ics.GetErrno() == -101) { 
    	%>No Disagreeing Dates Found.<br/><%
    } else if (ics.GetErrno() == 0) { 
    	%><table class="altClass">
            <tr>
              <th>AssetType</th>
              <th>AssetID</th>
              <th>ApprovedAssets.assetdate</th>
              <th>ApprovedAssetDeps.assetdate</th>
              <th><%= assetType %>.updateddate</th>
              <th>Parent</th>
            </tr>
            <ics:listloop listname="aList">
            <tr>
              <td><%= assetType %></td>
              <td><ics:listget listname="aList" fieldname="assetid"/></td>
              <td><ics:listget listname="aList" fieldname="assetdate"/></td>
              <td>
                <% if(fix) { %>
                    <ics:sql sql='<%= ics.ResolveVariables("UPDATE ApprovedAssetDeps aad SET assetdate = (SELECT assetdate FROM ApprovedAssets aa WHERE aa.id = aList.aaid) WHERE aad.id = aList.aadid") %>'
                             table="ApprovedAssetDeps,ApprovedAssets"
                             listname="aFix"/>
                    <% if(ics.GetErrno() != -502) { %>
                        Error: <ics:geterrno/>
                    <% } else { %>
                        <font color="red"><ics:listget listname="aList" fieldname="assetdate"/></font>
                    <% } %>
                    <ics:clearerrno/><br>
                <% } else { %>
                    <ics:listget listname="aList" fieldname="assetdepdate"/>
                <% } %>
              </td>
              <td>
                <% if(fix) { %>
                    <ics:sql sql='<%= ics.ResolveVariables("UPDATE Variables.assettype tab SET updateddate = (SELECT assetdate FROM ApprovedAssets aa WHERE aa.id = aList.aaid) WHERE tab.id = aList.assetid") %>'
                             table="ApprovedAssetDeps,ApprovedAssets"
                             listname="aFix"/>
                    <% if(ics.GetErrno() != -502) { %>
                        Asset Error: <ics:geterrno/>
                    <% } else { %>
                        <font color="red"><ics:listget listname="aList" fieldname="assetdate"/></font>
                    <% } %>
                        <ics:clearerrno/>
                <% } else { %>
                    <ics:sql sql='<%= ics.ResolveVariables("SELECT updateddate FROM Variables.assettype WHERE id = aList.assetid") %>'
                             table="ApprovedAssets"
                             listname="anAsset" />
                    <ics:listget listname="anAsset" fieldname="updateddate"/>
                <% } %>
              </td>
              <td>
                <ics:sql sql='<%= ics.ResolveVariables("SELECT assetid, assettype, assetdate FROM ApprovedAssets WHERE id = aList.ownerid") %>'
                         table="ApprovedAssets"
                         listname="aParent" />
                <ics:listget listname="aParent" fieldname="assettype"/>:<ics:listget listname="aParent" fieldname="assetid"/>
                (<ics:listget listname="aParent" fieldname="assetdate"/>)
              </td>
            </tr>
            </ics:listloop>
      </table>
      <% if(fix) {
    	  ics.FlushCatalog("ApprovedAssetDeps");
    	  ics.FlushCatalog("ApprovedAssets");
    	  ics.FlushCatalog(ics.ResolveVariables("Variables.assettype"));
      }
      %><a href='ContentServer?pagename=<ics:getvar name="pagename"/>'>Back to list</a><%
      if(!fix) { 
      	%><br><a href='ContentServer?pagename=<ics:getvar name="pagename"/>&targetid=<ics:getvar name="targetid"/>&assettype=<ics:getvar name="assettype"/>&fix=true'>Fix these</a><%
      } 
     } 
 } 
 %></cs:ftcs>