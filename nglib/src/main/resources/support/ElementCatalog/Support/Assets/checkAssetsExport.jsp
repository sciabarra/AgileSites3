<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ page import="COM.FutureTense.Interfaces.*,
                   COM.FutureTense.Util.ftMessage,
                   COM.FutureTense.Util.ftErrors"
%><cs:ftcs><%-- checkAssetsExport

INPUT

OUTPUT

--%><%

  String theData = ics.GetVar("passed_data");
  
  if (theData == null) {
    theData = ics.GetVar("table_data");
    if (theData != null && !theData.equals("")) {
      ics.StreamHeader("Content-Disposition", "attachment; filename=\"checkAssets.html\"");
      %><ics:callelement element="checkAssetsExport">
        <ics:argument name="passed_data" value='<%= theData %>'/>
      </ics:callelement><%
    }
    else
      out.println("no data found!");
  }
  else if (!theData.equals("")) {
    %><head>
      <script language="Javascript" type="text/javascript">
        <ics:callelement element="checkAssetsScript"/>
      </script>
      <style type="text/css">
        <ics:callelement element="checkAssetsCSS"/>
      </style>
    </head>
    <body>
      <center><h3 id="title">Check Assets</h3></center>
      <table style="width: 50%">
         <%= theData %>
      </table>
    </body><%
  }
  else {
    out.println("no data found");
  }
%>


</cs:ftcs>