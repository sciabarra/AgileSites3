<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"%>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"%>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld"%>
<%//
// Support/CacheManager/dumpStatusCodes
//
// INPUT
//
// OUTPUT
//
%>
<%@ page import="COM.FutureTense.Interfaces.FTValList"%>
<%@ page import="COM.FutureTense.Interfaces.ICS"%>
<%@ page import="COM.FutureTense.Interfaces.IList"%>
<%@ page import="COM.FutureTense.Interfaces.Utilities"%>
<%@ page import="COM.FutureTense.Util.ftErrors"%>
<%@ page import="COM.FutureTense.Util.ftMessage"%>
<%@ page import="COM.FutureTense.Util.ftStatusCode"%>
<cs:ftcs>
<satellite:tag>
    <satellite:parameter name='type' value='open'/>
</satellite:tag>
<%
ftStatusCode sc = (ftStatusCode) ics.GetObj("cmStatusCode");
StringBuffer bf = new StringBuffer();
bf.append("<table class=\"altClass\">");

do {
	int errno = sc.getErrorID();
    //
    // deal with empty status codes - should we return successful status codes?
    //
	if (errno >= 999990){
		bf.append("<tr><td colspan=\"2\"><b>Success</b></td></tr>");
	} else {
		bf.append("<tr><td width=\"10%\"><b>Command</b></td>");
		bf.append("<td>" + sc.getCommand() + "</td></tr>");
		if (errno == 1){
			bf.append("<tr><td width=\"10%\"><b>Reason</b></td>");
			bf.append("<td>" + sc.getReason() + "</td></tr>");
		} else {
			bf.append("<tr><td width=\"10%\"><b>Result</b></td>");
			bf.append("<td>" + sc.getStrResult() + "</td></tr>");

			bf.append("<tr><td width=\"10%\"><b>Errno</b></td>");
			bf.append("<td>" + sc.getErrorID() + "</td></tr>");

			bf.append("<tr><td width=\"10%\"><b>Reason</b></td>");
			bf.append("<td>" + sc.getReason() + "</td></tr>");
		}
		//bf.append("<tr><td width=\"10%\"><b>Params</b></td>");
		//bf.append("<td>" + sc.getParams() + "</td></tr>");
	}
	bf.append("<tr><td colspan=\"2\">&nbsp;</td></tr>");
} while (sc.setNextError());

bf.append("</table>");
%>
<%= bf.toString()%>
<satellite:tag>
	<satellite:parameter name='type' value='close'/>
</satellite:tag>
</cs:ftcs>
