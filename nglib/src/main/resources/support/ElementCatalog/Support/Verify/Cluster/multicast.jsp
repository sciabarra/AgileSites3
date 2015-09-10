<%@ page import="java.io.*" %>
<%@ page import="javax.xml.parsers.*" %>
<%@ page import="org.w3c.dom.*" %>
<%@ page import="java.util.*" %>
<%!

private JspWriter out = null;

private final int DEFAULT_DURATION = 5;

private final HashMap<String,String> DEFAULT_MULTICAST_ADDRESS = new HashMap<String,String>();

private Document parseXML(InputStream is) {

    try {
        DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
        DocumentBuilder db = dbf.newDocumentBuilder();

        return db.parse(is);
    }
    catch (Exception e) {
        stacktraceToString(e, out);
        return null;
    }
}

private class EhCacheXML implements ReadDoc {

    public HashMap<String,String> readDoc(Document d) {

        NodeList nList = d.getElementsByTagName("cacheManagerPeerProviderFactory");
    
        HashMap<String,String> ret = null;

        if (nList.getLength() > 0) {
            Element e = (Element)(nList.item(0));

            String[] props = e.getAttribute("properties").split(",");

            ret = new HashMap<String,String>();

            for (String s : props) {
                String[] avs = s.trim().split("=");
                ret.put(avs[0], avs[1]);
            }
        }

        return ret;
    }
}

private class JbossXML implements ReadDoc {

    public HashMap<String,String> readDoc(Document d) {

        NodeList nList = d.getElementsByTagName("UDP");

        HashMap<String,String> ret = null;

        if (nList.getLength() > 0) {
            Element e = (Element)(nList.item(0));

            ret = new HashMap<String,String>();

            ret.put("multicastGroupAddress", e.getAttribute("mcast_addr"));
            ret.put("multicastGroupPort", e.getAttribute("mcast_port"));
            ret.put("timeToLive", e.getAttribute("ip_ttl"));
        }

        return ret;
    }
}

private void stacktraceToString(Exception e, JspWriter out) {
    try {
        Writer w = new StringWriter();
        PrintWriter pw = new PrintWriter(w);
        e.printStackTrace(pw);
        out.println("\n<!-- EXCEPTION CAUGHT:\n" + w.toString() + "\n--!>");
    }
    catch (Exception ex) {
        e.printStackTrace();
        ex.printStackTrace();
    }
}

private interface ReadDoc {

    HashMap<String,String> readDoc(Document d);

}
%><%
        DEFAULT_MULTICAST_ADDRESS.put("cs-cache.xml", "230.0.0.0:4444");
        DEFAULT_MULTICAST_ADDRESS.put("ss-cache.xml", "230.0.0.0:4844");
        DEFAULT_MULTICAST_ADDRESS.put("linked-cache.xml", "230.0.0.0:4445");
        DEFAULT_MULTICAST_ADDRESS.put("cas-cache.xml", "230.0.0.0:4666");
        DEFAULT_MULTICAST_ADDRESS.put("jbossTicketCacheReplicationConfig.xml", "239.255.0.0:48866");
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

<cs:ftcs>
<satellite:link pagename='Support/prototype' satellite="true" outstring="prototypeURL" ><satellite:argument name="v" value="1.6.1"/></satellite:link>
<script type="text/javascript" src='<%=ics.GetVar("prototypeURL")%>'></script>
<script type="text/javascript">
    var all_multicast = new Array();

    function listen( output_element, mcGrpAddr, mcGrpPort, ttl) {
        
        $(output_element).innerHTML = "listening...";

        disableListenButtons(true);

        new Ajax.Request('ContentServer', {
          method: 'get',
          parameters: {pagename:'Support/Verify/Cluster/multicastListen',group: mcGrpAddr, port: mcGrpPort, ttl: ttl, listen_duration: $('listen_duration').value},
          onSuccess: function(response){
                var result = response.responseText;
                $('output_area').value = result.trim();
                $(output_element).innerHTML = "";
                disableListenButtons(false);
              },
          onFailure: function(){
                $('output_area').value = "Error Encountered! Please check logs for details.";
                $(output_element).innerHTML = "";
                disableListenButtons(false);
              }
        });
        
        var duration = parseInt($('listen_duration').value);

        $('output_area').value = "listening - " + duration + " seconds remaining...";

        countdown(duration, output_element);

    }

    function send(output_element, mcGrpAddr, mcGrpPort, ttl, send_msg) {
      new Ajax.Request('ContentServer', {
          method: 'get',
          parameters: {pagename:'Support/Verify/Cluster/multicastSend',group: mcGrpAddr, port: mcGrpPort, ttl: ttl, send_msg: send_msg},
          onSuccess: function(response){
                  if (response.responseText.trim().indexOf("ERROR:") == -1) {
                      $(output_element).innerHTML = "packet sent!";
                  }
                  else {
                      $(output_element).innerHTML = "<font color='red'>error encountered!</font>";
                  }
                  setTimeout("$('" + output_element + "').innerHTML = ''", 800);
              },
          onFailure: function(){
                  output_element.innerHTML = "<font color='red'>error encountered!</font>";
                  setTimeout("$('" + output_element + "').innerHTML = ''", 800);
              }
        });

    }

    function countdown( duration, eid) {
        if (duration != -1 && $(eid).innerHTML != "") {
            $('output_area').value = "listening - " + duration + " seconds remaining.";
            setTimeout("countdown(" + (duration - 1) + ", '" + eid + "');", 1000);
        }
        else if (duration == -1 && $(eid).innerHTML != "") {
            $(eid).innerHTML = "Processing...";
        }
    }
    function disableListenButtons( disable ) {
        var inputs = $('listener').getElementsByTagName("input");
        
        for (i = 0; i < inputs.length; i++) {
            if (inputs[i].type == "button" && inputs[i].value == "listen")
                inputs[i].disabled = disable;
        }

    }

    function calculateUniqueness() {

        var table_rows = $('listener').getElementsByTagName("tr");
        var multicast = {};

        for (var i = 0; i < table_rows.length; i++) {
            var mcast_split = (table_rows[i].id).split(":");
            if (mcast_split.length > 2) {
                multicast[mcast_split[mcast_split.length - 3]] = mcast_split[mcast_split.length - 2] + ":" + mcast_split[mcast_split.length - 1];
            }
        }

        var nonunique = new Array();

        for (var m in multicast) {
            for (var n in multicast) {
                if ((m != n) && (multicast[m] == multicast[n])) {
                    nonunique.push(m);
                }
            }
        }

        for (var m in nonunique) {
            alert(nonunique[m] + "_unique");
            $(nonunique[m] + "_unique").innerHTML = "<font color='red'>false</font>";
        }
    }

</script>
<%

this.out = out;

HashMap<String,ReadDoc> xmlFiles = new HashMap<String,ReadDoc>();

xmlFiles.put("cs-cache.xml", new EhCacheXML());
xmlFiles.put("ss-cache.xml", new EhCacheXML());
xmlFiles.put("linked-cache.xml", new EhCacheXML());
xmlFiles.put("cas-cache.xml", new EhCacheXML());
xmlFiles.put("jbossTicketCacheReplicationConfig.xml", new JbossXML());

boolean assetCacheEnabled = false;

%>
<p>
---------------------<br/>
SYSTEM SETTINGS<br/>
---------------------<br/>
<br/>
System Property:<br/>
cs.useEhcache = <%= System.getProperty("cs.useEhcache") %><br/>
<br/>
futuretense.ini:<br/>
rsCacheOverInCache = <%= "true".equals(ics.GetProperty("rsCacheOverInCache")) %><br/>
<br/>
futuretense_xcel.ini:<br/>
wem.enabled = <%= ics.GetProperty("wem.enabled", "futuretense_xcel.ini", true) %><br/>
<br/>
<%

try {

    InputStream is = getClass().getResourceAsStream("/cs-cache.xml");
    Document doc = parseXML(is);

    NodeList nl = doc.getElementsByTagName("cache");
    for (int i = 0; i < nl.getLength(); i++) {
        Element e = (Element)nl.item(i);
        String name = e.getAttribute("name");
        if ((name != null) && name.startsWith("AssetCache")) {
            assetCacheEnabled = true;
        }
    }
}
catch (Exception e) {

    stacktraceToString(e, out);

}

%>
AssetCache enabled = <%= assetCacheEnabled %><br/>
</p>
<%
String listenDuration = ics.GetVar("listen_duration");
if (listenDuration == null)
    listenDuration = "" + DEFAULT_DURATION;
%><br/>
--------------------------------<br/>
MULTICAST TOOL SETTINGS<br/>
--------------------------------<br/>
<br/>
<label for="listen_duration">Listen Duration (in seconds): </label><input type="text" name="listen_duration" id="listen_duration" value='<%= listenDuration %>'></input><br/>
<label for="send_msg">Send Message: </label><input type="text" name="send_msg" id="send_msg" value='ping from Support Tools!'></input><br/>
<br/>
<div id="listener">
<table style='table-layout:fixed; width: 50%'>
    <tr><th style="width: 50%">File</th><th style="text-align: center">Found</th><th style="text-align: center">Default</th><th style="text-align: center">Unique</th><th style="text-align: center"></th><th style="text-align: center"></th><th style="text-align: center"></th></tr>
<%

for (String key : xmlFiles.keySet()) {
    InputStream is = getClass().getResourceAsStream("/" + key);
    String listenButton = "";
    String sendButton = "";
    if (is != null) {
        ReadDoc rd = xmlFiles.get(key);
        Document doc = parseXML(is);

        HashMap<String,String> mcInfo = rd.readDoc(doc);
        boolean defaultSettings = DEFAULT_MULTICAST_ADDRESS.get(key).equals(mcInfo.get("multicastGroupAddress") + ":" + mcInfo.get("multicastGroupPort"));
        String def_str = defaultSettings ? "<font color='red'>true</font>" : "false";

        listenButton = "<input type=\"button\" value=\"listen\" onclick=\"listen('" + key.replaceAll("\\.", "_") + "_listenstatus', '" + mcInfo.get("multicastGroupAddress") + "','" + mcInfo.get("multicastGroupPort") + "','" + mcInfo.get("timeToLive") + "');\" />";
        sendButton = "<input type=\"button\" value=\"send\" onclick=\"send('" + key.replaceAll("\\.", "_") + "_sendstatus', '" + mcInfo.get("multicastGroupAddress") + "','" + mcInfo.get("multicastGroupPort") + "','" + mcInfo.get("timeToLive") + "', $('send_msg').value);\" />";
%>
    <tr id='<%= key.replaceAll("\\.", "_") + ":" + mcInfo.get("multicastGroupAddress") + ":" + mcInfo.get("multicastGroupPort") %>'><td><%= key %></td><td style="text-align: center"><%= is != null %></td><td style="text-align: center"><%= def_str %></td><td id='<%= key.replaceAll("\\.", "_") + "_unique" %>' style="text-align: center">true</td><td style="text-align: center"><%= listenButton %> <%= sendButton %></td><td id='<%= key.replaceAll("\\.", "_") %>_listenstatus' style="text-align: center"></td><td id='<%= key.replaceAll("\\.", "_") %>_sendstatus' style="text-align: center"></td></tr>
<%
    }
}
%>
</table>
<br/>
Custom:<br/>
<label for="c_group">Group Address: </label><input type="text" name="c_group" id="c_group"></input><br/>
<label for="c_port">Port: </label><input type="text" name="c_port" id="c_port"></input><br/>
<label for="c_ttl">TimeToLive: </label><input type="text" name="c_ttl" id="c_ttl"></input><br/>
<input type="button" value="listen" id="c_listen" onclick="listen('c_status', $('c_group').value, $('c_port').value, $('c_ttl').value);"/>
<input type="button" value="send" id="c_send" onclick="send('c_status', $('c_group').value, $('c_port').value, $('c_ttl').value, $('send_msg').value);"/><span id="c_status"></span><br/>
</div>
<br/>
output:<br/>
<textarea id="output_area" name="output_area" disabled="true" cols="100" rows="20"></textarea>
<br/>
<p>
----------------<br/>
DESCRIPTION<br/>
----------------<br/>
<ul style="list-style-type:square;">
<li>If 'cs.useEhcache' is true, 'cs-cache.xml' and 'ss-cache.xml' are used.</li>
<li>If 'rsCacheOverInCache' is true, 'linked-cache.xml' is used.</li>
<li>If 'wem.enabled' is true, 'cas-cache.xml' and 'jbossTicketCacheReplicationConfig.xml' are used.</li>
<li>If AssetCache is enabled, 'cs-cache.xml' is used.</li>
<li>This tool will check to see if all of the above-mentioned files are in the classpath. If any of these files are not found, please check your configuration.</li>
<li>This tool will check to see if the group address and port are defaults. Although functionally it will be fine, it is recommended to change them to a different value to prevent new installs from conflicting with this cluster.</li>
<li>This tool will check whether all multicast group addresses and ports are unique to each other.</li>
<li>Listen on a multicast group to make sure this server can receive packets from all other servers that belong to this cluster. Also, make sure servers that does not belong to this cluster is not listed.</li>
<li>When listening on EhCache multicast (files that ends with '-cache.xml'), make sure the broadcasted IP is a valid network IP of the server. 127.0.0.1 is not a valid network IP.</li>
<li>You can manually send a packet to the multicast group to test if other servers can see this. Other servers can see the sent packet if they are listening on the same multicast group via this tool.</li>
</ul><br/>
Explanation of TTL values:<br/>
0 = restricted to the same host.<br/>
1 = Restricted to the same subnet.<br/>
32 = Restricted to the same site.<br/>
64 = Restricted to the same region.<br/>
128 = Restricted to the same continent.<br/>
255 = Unrestricted.<br/>
</p>

<script>
calculateUniqueness();
</script>
</cs:ftcs>

