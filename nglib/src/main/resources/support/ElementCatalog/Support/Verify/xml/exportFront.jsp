<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" 
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" 
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" 
%><%//
// Support/Verify/xml/exportFront
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
<ics:callelement element="Support/general"/>
<div id="content">
<ics:callelement element="Support/Topnav"/>
<center><h3>Export TableData to XML Format</h3></center>
<satellite:form satellite="false" method="POST">
  <table class="altClass">
    <tr>
      <td style="text-align:right"><b>TableName: </b></td>
      <td><select size="1" name="tbl">
<%
StringBuffer err = new StringBuffer();
IList schema = ics.SQL("SystemInfo","SELECT tblname FROM SystemInfo WHERE tblname NOT IN ('SystemAssets') AND tblname NOT LIKE ('tt%') ORDER by LOWER(tblname)" , null,-1,true,err);
if(ics.GetErrno() == 0 && schema != null && schema.hasData()){
	int rows= schema.numRows();
	for (int i=1; i<= rows;i++){
		schema.moveTo(i);
		%><option><%= schema.getValue("tblname") %></option><%
	}
}
%>
      </select></td>
    </tr>
    <tr>
      <td style="text-align:right"><b>Query: </b></td>
      <td><textarea rows="8" name="query" cols="40"></textarea></td>
    </tr>
  </table>
  <p><input type="submit" value="Submit">&nbsp;<input type="reset" value="Reset"></p>
  <input type="hidden" name="pagename" value="Support/Verify/xml/export">
</satellite:form>
<ics:callelement element="Support/Footer"/>
</div>
</cs:ftcs>
