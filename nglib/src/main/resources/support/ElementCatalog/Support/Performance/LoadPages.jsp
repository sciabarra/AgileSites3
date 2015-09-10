<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"%><%@ taglib
	prefix="asset" uri="futuretense_cs/asset.tld"%><%@ taglib
	prefix="assetset" uri="futuretense_cs/assetset.tld"%><%@ taglib
	prefix="commercecontext" uri="futuretense_cs/commercecontext.tld"%><%@ taglib
	prefix="ics" uri="futuretense_cs/ics.tld"%><%@ taglib
	prefix="listobject" uri="futuretense_cs/listobject.tld"%><%@ taglib
	prefix="render" uri="futuretense_cs/render.tld"%><%@ taglib
	prefix="searchstate" uri="futuretense_cs/searchstate.tld"%><%@ taglib
	prefix="siteplan" uri="futuretense_cs/siteplan.tld"%><%@ taglib
	prefix="satellite" uri="futuretense_cs/satellite.tld"%><%@ page
	import="COM.FutureTense.Interfaces.*,COM.FutureTense.Util.ftMessage,com.fatwire.assetapi.data.*,com.fatwire.assetapi.*,COM.FutureTense.Util.ftErrors,COM.FutureTense.Util.*"%><cs:ftcs>
	<%--

INPUT

OUTPUT

--%>
	<%-- Record dependencies for the SiteEntry and the CSElement --%>
	<ics:if condition='<%=ics.GetVar("seid") != null%>'>
		<ics:then>
			<render:logdep cid='<%=ics.GetVar("seid")%>' c="SiteEntry" />
		</ics:then>
	</ics:if>
	<ics:if condition='<%=ics.GetVar("eid") != null%>'>
		<ics:then>
			<render:logdep cid='<%=ics.GetVar("eid")%>' c="CSElement" />
		</ics:then>
	</ics:if>

	<h3>LoadPages</h3>
	<p />
This tool lets you load many copies of a cacheable page into the cache by specifying a url to call, a parameter name that the script will vary at each call, and numeric start/end values. <p/>
For example, to call the Support Tools standard 'lorem' test, using the "cb" param to cache 10 different copies: <p />

<ul>
<li/> - http://<i>host:port/cs</i>/ContentServer?pagename=Support/Performance/Standard/lorem
<li/> - cb
<li/> - 1
<li/> - 10
</ul>

	<%
		String pageToLoad = "";
			String paramToVary = "";
			long start = 1;
			long end = 10;

			if (ics.GetVar("pageToLoad") != null)
				pageToLoad = ics.GetVar("pageToLoad");
			if (ics.GetVar("paramToVary") != null)
				paramToVary = ics.GetVar("paramToVary");
			if (ics.GetVar("start") != null)
				start = Long.parseLong(ics.GetVar("start"));
			if (ics.GetVar("end") != null)
				end = Long.parseLong(ics.GetVar("end"));
	%>
	<satellite:form satellite="false" name="loadpagesform" method="POST">
		<input type='hidden' name='pagename'
			value='<%=ics.GetVar("pagename")%>' />
URL of page to load: <textarea name='pageToLoad' rows='3' cols='80' /><%=pageToLoad%></textarea>
		<p />
Parameter to vary: <input type='text' name='paramToVary'
			value='<%=paramToVary%>' size='40' />
		<p />
Param start value: <input type='text' name='start' value='<%=start%>' />
		<p />
Param end value: <input type='text' name='end' value='<%=end%>' />
		<p />
		<input type="submit" value="Go" name="button">

	</satellite:form>

	<%
		if ("".compareTo(pageToLoad.toString()) != 0) {
				for (long i = start; i < end; i++) {
					char sep = '&';
					if (pageToLoad.indexOf('?') == -1)
						sep = '?';
					String url = pageToLoad + sep + paramToVary + "=" + i;
					String r = Utilities.readURL(url);
					String msg = "Reading " + url + " (" + r.length()
							+ " chars)";
					out.println(msg + "<br/>");
					ics.LogMsg(msg);
				}
			}
	%>

</cs:ftcs>
