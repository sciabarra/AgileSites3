<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld"
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld"
%><%@ page import="COM.FutureTense.Interfaces.*,
                   java.util.StringTokenizer"
%><cs:ftcs>
<script type="text/javascript" src="ContentServer?pagename=Support/Assets/checkAssetsScript"></script>
<link rel="stylesheet" type="text/css" href="ContentServer?pagename=Support/Assets/checkAssetsCSS" />
<h3 id="title">Check Assets</h3>
<%
String theTypes = ics.GetVar("types");
StringBuffer errstr = new StringBuffer(128);

if (theTypes == null) { %>

  <satellite:form satellite="false" method="POST">
    <input type="hidden" name="pagename" value='<%= ics.GetVar("pagename") %>'/>
    <input type="Submit" value="Submit"/>
    <table class="altClass" style="width:50%">
      <tr><th><input type="checkbox" style="border: 0" onclick="checkall();" id="cAll"/></th><th colspan="2">Asset Type</th></tr>

    <%
        IList typeList = ics.SQL("AssetType", "SELECT assettype, description FROM AssetType ORDER BY description", null, -1, true, errstr);

        if (typeList !=null && typeList.numRows() > 0) {
          do {
            String tempValue = typeList.getValue("assettype");
            out.print("<tr><td><input type=\"checkbox\" name=\"types\" value=\"" + tempValue + "\"/></td><td>" + tempValue + "</td><td>" + typeList.getValue("description") + "</td></tr>");

          }
          while (typeList.moveToRow(IList.next, 0));
        }
    %>

    </table>
    <input type="Submit" value="Submit"/>
  </satellite:form>

<% } else { %>

  <satellite:form satellite="false" method="POST" onsubmit="submitExportPage('table_data', 'export_data')">
    <input type="hidden" name="pagename" value="Support/Assets/checkAssetsExport"/>
    <input id="table_data" type="hidden" name="table_data" value=""/>
    <input type="submit" value="Export Page"/>
  </satellite:form>

  <div id="export_data">
  Show: <input type="checkbox" id="good-check" name="good" checked="true" onclick="setViewType('good', (this.checked) ? '' : 'none')"/><label class="good" for="good-check"> valid</label>&nbsp;&nbsp;
  <input type="checkbox" id="bad-check" name="bad" checked="true" onclick="setViewType('bad', (this.checked) ? '' : 'none')"/><label class="bad" for="bad-check"> invalid</label><br/>

  (<a href="javascript:void(0)" onclick='expandAll(this, document.getElementById("results", ""))' title="unhide">expand all</a>)(<a href="javascript:void(0)" onclick='rescanAll()'>rescan all</a>)
  <table id="results" style="width:50%">

<%
  StringTokenizer typeToken = new StringTokenizer(theTypes, ";");

  while (typeToken.hasMoreTokens()) {
    String currTable = typeToken.nextToken(); %>

    <tr id='<%= currTable %>' name="unknown">
      <td style="width:18px; vertical-align: top;"><div class="nodeLink" style="display: none" name="togglehide" onclick='toggleHide(this, null);' id='<%= currTable + "-results-a" %>'>+</div></td>
      <td>
        <span id='<%= currTable + "-atype" %>' class="atype"><%= currTable %></span><span title='<%= currTable %>' name="result-label"></span>
        <div id='<%= currTable + "-results" %>' style="display: none">
          <span id='<%= currTable + "-dbcheck" %>' style="display: none"></span>
          <span id='<%= currTable + "-noasset" %>' style="display: none">no assets found</span>
          <div id='<%= currTable + "-results-table" %>'>
          <table style="border: 0">
            <tr id='<%= currTable + "-wrong-tr" %>' style="display: none">
            <td style="width:18px; border:0;text-align: left; vertical-align: top;"><div class="nodeLink" name="togglehide" href="javascript:void(0);" onclick='toggleHide(this, null);' id='<%= currTable + "-wrong-a" %>'>+</div></td>
            <td style="border:0;text-align: left">
            <div class="bad">Invalid Asset(s) - <span id='<%= currTable + "-numwrong"%>'></span></div>
            <div id='<%= currTable + "-wrong" %>' style="display: none"></div>
          </td>
        </tr>
            <tr id='<%= currTable + "-correct-tr" %>' style="display: none">
            <td style="width:18px; border:0;text-align: left; vertical-align: top;"><div class="nodeLink" name="togglehide" href="javascript:void(0);" onclick='toggleHide(this, null);' id='<%= currTable + "-correct-a" %>'>+</div></td>
            <td style="border:0;text-align: left">
            <div class="good">Valid Asset(s) - <span id='<%= currTable + "-numcorrect"%>'></span></div>
            <div id='<%= currTable + "-correct" %>' style="display: none"></div>
          </td>
        </tr>
          </table>
          </div>
        </div>
      </td>
      <td style="text-align: right; vertical-align: top;"><span id='<%= currTable + "-exp-link" %>' style="display: none">(<a name="expand_table" href="javascript:void(0)" onclick='<%= "expandAll(this, document.getElementById(\"results\"), \"" + currTable + "\" );" %>' title="unhide">expand</a>)</span></td>
    </tr>

  <% } %>
  </table>
  </div>
<% } %>
<script type="text/javascript">onLoad();</script>
</cs:ftcs>