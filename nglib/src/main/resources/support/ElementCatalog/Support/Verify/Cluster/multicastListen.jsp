<%@ page import="java.util.zip.GZIPInputStream" %>
<%@ page import="java.io.*" %>
<%@ page import="java.net.SocketException" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.text.DateFormat" %>
<%@ page import="java.util.Date" %>
<%!

private final int DEFAULT_DURATION = 5;
private boolean timedOut = false;
private DateFormat df = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss.SSS");

private byte[] unGZip(byte[] data) {

    byte[] ret = new byte[0];

    try {
        GZIPInputStream gzis = new GZIPInputStream(new ByteArrayInputStream(data));
        ByteArrayOutputStream baos = new ByteArrayOutputStream(data.length);

        byte[] buffer = new byte[1500];

        int read = 0;

        while(read != -1) {
            read = gzis.read(buffer, 0, 1500);
            
            if (read != -1) {
                baos.write(buffer, 0, read);
            }
        }

        ret = baos.toByteArray();
        
        gzis.close();
        baos.close();
        
        return ret;
    }
    catch (Exception e) {

        e.printStackTrace();

    }

    return null;
}

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

private class SocketDuration implements Runnable {

    private MulticastSocket ms;
    private int duration;

    public SocketDuration (MulticastSocket ms, int duration) {
        this.duration = duration;
        this.ms = ms;
    }

    public void run() {
        try {
            Thread.sleep(duration * 1000);
            ms.close();
            timedOut = true;
        }
        catch (Exception e) {
            //do nothing
        }
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

    String listenDuration_s = ics.GetVar("listen_duration");

    int listenDuration = -1;

    try {
        InetAddress localhost = InetAddress.getLocalHost();
        String hostname = localhost.getHostName();
        String ip = localhost.getHostAddress();

        out.println("This server's hostname: " + hostname + " (" + ip + ")");
    }
    catch (Exception e) {
        out.println("Error obtaining this server's hostname and/or ip!");
        out.println(stacktraceToString(e, out));
    }

    try {
        listenDuration = Integer.parseInt(listenDuration_s);
    }
    catch (Exception e) {
        out.println("Error parsing listen_duration! setting listen duration to default value of '" + DEFAULT_DURATION + "'");
        listenDuration = DEFAULT_DURATION;
    }

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
            out.println("Exception caught:");
            out.println(stacktraceToString(e, out));
        }

        if (group == null || port == -1 || ttl == -1) {
            out.println("Incorrect parameter values!");
        }
        else {
            MulticastSocket ms = new MulticastSocket(port);
            ms.setTimeToLive(ttl);
            ms.joinGroup(group);

            out.println("Sucessfully joined multicast group '" + group_s + ":" + port_s + "' with TTL=" + ttl_s + "!");

            byte[] buffer = new byte[10*1024];
            DatagramPacket data = new DatagramPacket(buffer, buffer.length);
            long start = System.currentTimeMillis();

            HashMap<String,Integer> ipList = new HashMap<String,Integer>();
            HashMap<String,ArrayList<String>> knownPackets = new HashMap<String,ArrayList<String>>();

            try {
                Thread t = new Thread(new SocketDuration(ms, listenDuration));
                t.start();

                while ((start + (listenDuration * 1000)) > System.currentTimeMillis()) {
                    ms.receive(data);
                    String fromIp = data.getAddress().getHostAddress();
        		
                    if (!ipList.containsKey(fromIp)) {
                        ipList.put(fromIp, new Integer(1));
                    }
                    else {
                        ipList.put(fromIp, new Integer(ipList.get(fromIp).intValue() + 1));
                    }
        		
                    String packetData = new String(buffer, 0, data.getLength());
                    String packet_s = "";

                    //Check if this is EhCache Heartbeat packet
                    byte[] payload = unGZip(buffer);
                    if (payload != null) {
                        packet_s = "[" + df.format(new Date()) + "] - " + (new String(payload).trim());
                    }
                    //Check if this packet was sent by Support Tools
                    else if (packetData != null && packetData.startsWith("FROM_SUPPORT_TOOLS-")) {
                        packet_s = "[" + df.format(new Date()) + "] - From Support Tools: '" + packetData.substring(19) + "'";
                    }
                    else {
                        packet_s = "[" + df.format(new Date()) + "] - " + "CAS or unknown packet";
                    }

                    if (knownPackets.get(fromIp) != null) {
                        ArrayList<String> al = knownPackets.get(fromIp);
                        al.add(packet_s);
                        knownPackets.put(fromIp, al);
                    }
                    else {
                        ArrayList<String> al = new ArrayList<String>();
                        al.add(packet_s);
                        knownPackets.put(fromIp, al);
                    }
                }
            }
            catch (SocketException se) {
                if (!timedOut)
                    out.println(stacktraceToString(se, out));
            }
            catch (Exception e) {
                out.println(stacktraceToString(e, out));
            }
            finally {

                if (ipList.size() > 0) {
                    out.println("Received response(s) from:");
                    for (String key : ipList.keySet()) {
                        out.println(key + " - " + ipList.get(key) + " time(s).");
                        if (knownPackets.get(key) != null) {
                            ArrayList<String> rmi = knownPackets.get(key);
                            for (String url : rmi) {
                                out.println("    " + url);
                            }
                        }
                    }
                }
                else {
                    out.println("Received no packets!");
                }
                try {
                    ms.close();
                }
                catch (Exception ex) {
                    out.println(stacktraceToString(ex, out));
                }
            }
        }
    }

%>

</cs:ftcs>


