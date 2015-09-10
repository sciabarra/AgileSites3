<%@ page import="java.io.*" %>
<%@ page import="java.net.SocketException" %>
<%!

private String stacktraceToString(Exception e, JspWriter out) {
    try {
        Writer w = new StringWriter();
        PrintWriter pw = new PrintWriter(w);
        e.printStackTrace(pw);
        return w.toString();
    }
    catch (Exception ex) {
        e.printStackTrace();
        ex.printStackTrace();
        return "";
    }
}
%>
<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>

<%@ page import="COM.FutureTense.Interfaces.FTValList" %>
<%@ page import="COM.FutureTense.Interfaces.ICS" %>
<%@ page import="COM.FutureTense.Interfaces.IList" %>
<%@ page import="COM.FutureTense.Interfaces.Utilities" %>
<%@ page import="COM.FutureTense.Util.ftErrors" %>
<%@ page import="COM.FutureTense.Util.ftMessage"%>
<%@ page import="java.net.DatagramPacket" %>
<%@ page import="java.net.InetAddress" %>
<%@ page import="java.net.MulticastSocket" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.HashMap" %>
<cs:ftcs>

<%
    String group_s = ics.GetVar("group");
    String port_s = ics.GetVar("port");
    String ttl_s = ics.GetVar("ttl");

    String sendMsg = ics.GetVar("send_msg");
    String sendMsgFormatted = "FROM_SUPPORT_TOOLS-" + sendMsg;

    if (port_s == null || ttl_s == null || group_s == null)
        out.println("ERROR: Missing parameters!");
    else {

        int port = -1;
        int ttl = -1;
        InetAddress group = null;

        try {
            group = InetAddress.getByName(group_s);
            port = Integer.parseInt(port_s);
            ttl = Integer.parseInt(ttl_s);
        }
        catch (Exception e) {
            out.println("ERROR: " + stacktraceToString(e, out));
        }

        if (group == null || port == -1 || ttl == -1) {
            out.println("ERROR: Incorrect parameter values!");
        }
        else {
            MulticastSocket ms = new MulticastSocket(port);
            ms.setTimeToLive(ttl);
            ms.joinGroup(group);

            DatagramPacket data = new DatagramPacket(sendMsgFormatted.getBytes(), sendMsgFormatted.length(), group, port);

            try {
                ms.send(data);
                out.println("SUCCESS");
                ms.close();
            }
            catch (Exception e) {
                out.println("ERROR: " + stacktraceToString(e, out));
            }
            finally {
                try {
                    ms.close();
                }
                catch (Exception ex) {
                }
            }
        }
    }

%>

</cs:ftcs>



