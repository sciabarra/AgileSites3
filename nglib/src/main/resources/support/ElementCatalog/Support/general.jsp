<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld"
%><%!
private String csEnv="var csEnv ={";

public void jspInit(){
    String csVersion="unknown";
    try {
        final COM.FutureTense.Util.FBuild bb = new COM.FutureTense.Util.FBuild();
        String v = bb.version();
        String[] x= v.split("[\r\n]");
        if (x.length >1){
            csVersion = x[x.length-1];
        }else {
            csVersion=v;
        }
    } catch(Throwable t){
    }
    try {
        csEnv +="cs_version:'"+csVersion +"',";

        for (String s : new String[]{ "java.runtime.version","java.version","java.vm.version","os.arch","os.name","os.version"}){
            csEnv += s.replace(".","_") +":'"+ System.getProperty(s) +"',";
        }
        Runtime rt = Runtime.getRuntime();
        csEnv +="os_proc: "+ Integer.toString(rt.availableProcessors()) +",";
        csEnv += "ws_info:'"+ getServletConfig().getServletContext().getServerInfo() +"'};";
    } catch(Throwable t){
        csEnv="var csEnv ={};";
    }


}
%><cs:ftcs><%
ics.SetVar("st_version","4.1");
%><satellite:link pagename='Support/css' satellite="true" outstring="cssURL" ><satellite:argument name="v" value='<%= ics.isCacheable("Support/css")?"40": Long.toString(System.currentTimeMillis()) %>'/></satellite:link><%
%><head><script type="text/javascript">var began_loading = new Date().getTime();</script>
<title>WebCenter Sites:: <ics:getvar name="pagename"/></title>
<meta http-equiv="Pragma" content="no-cache"/><%
%><link rel="stylesheet" href='<%=ics.GetVar("cssURL")%>' type="text/css" media="screen"/>
<script type="text/javascript"><%=csEnv %>

function addEvent(obj, evType, fn){
 if (obj.addEventListener){
   obj.addEventListener(evType, fn, false);
   return true;
 } else if (obj.attachEvent){
   var r = obj.attachEvent("on"+evType, fn);
   return r;
 } else {
   return false;
 }
}
String.prototype.evalJSON = function () {
	return eval('(' + this + ')');
}

Element.prototype.update = function(obj) {
	this.innerHTML = obj;
}

function $(idValue) {
	return document.getElementById(idValue);
}

var Ajax = {
	Request: function(servlet, params) {
        
		var ajaxRequest;
                    
		var async = params.asynchronous;
                    
		if (async == null)
			async = true;
                    
		if (window.XMLHttpRequest)
			ajaxRequest = new XMLHttpRequest();
		else
			ajaxRequest = new ActiveXObject("Microsoft.XMLHTTP");
                    
		ajaxRequest.onreadystatechange = function() {
			if (ajaxRequest.readyState == 4) {
				if (ajaxRequest.status == 200) {
					params.onSuccess(ajaxRequest);
				}
				else {
					params.onFailure();
				}
			}
		}
		    
		var url = servlet;
		var delim = "?";
		urlParams = params.parameters;

		for (var key in urlParams) {
			url += delim + key + "=" + urlParams[key];
			delim = "&";
		}
		    
		ajaxRequest.open(params.method, url, async);
			ajaxRequest.send();
		}
};
</script>
</head>
<% ics.RemoveVar("referURL");ics.RemoveVar("cssURL");%></cs:ftcs>
