<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ page import="COM.FutureTense.Interfaces.ICS,COM.FutureTense.Util.ftMessage,java.util.*"
%><%@ page import="COM.FutureTense.Interfaces.*"
%><%@ page import="COM.FutureTense.Cache.CacheHelper,com.fatwire.cs.core.db.*"
%><%!

private static final String PAGE_MARKER="com.fatwire.satellite.page";
private static final String PAGE_MARKER_START="<" + PAGE_MARKER +" ";
private static final String PAGE_MARKER_END="/" + PAGE_MARKER +">";

private static final String BLOB_MARKER="com.fatwire.satellite.blob";
private static final String BLOB_MARKER_START="<" + BLOB_MARKER +" ";
private static final String BLOB_MARKER_END="/" + BLOB_MARKER +">";

private static String[] listMarkers(String body){
    //in jdk 1.4 we would do Sting.split("<page.*/page>");
    //here we have the joy to implement this ourselves.

    int tStart = 0;
    int tEnd = 0;
    java.util.List<String> list = new java.util.ArrayList<String>();
    while ((tStart= body.indexOf(PAGE_MARKER_START,tEnd)) != -1){
        if ((tEnd = body.indexOf(PAGE_MARKER_END,tStart)) > -1){
            list.add(body.substring(tStart+PAGE_MARKER_START.length(),tEnd));
        }
    }
    tStart = 0;
    tEnd = 0;

    while ((tStart= body.indexOf(BLOB_MARKER_START,tEnd)) != -1){
        if ((tEnd = body.indexOf(BLOB_MARKER_END,tStart)) > -1){
            list.add(body.substring(tStart+BLOB_MARKER_START.length(),tEnd));
        }
    }

    return (String[])list.toArray(new String[0]);
}
private  static String[] orderPageCriteria(List pca) {

    TreeSet<String> pc = new TreeSet<String>();
    for (Object c : pca) {
        if (!CacheHelper.ssCookie.equals(c))
            pc.add(c.toString());
    }
    String[] mPC = pc.toArray(new String[pc.size() + 1]);
    // add sscookie to end
    mPC[mPC.length - 1] = CacheHelper.ssCookie;
    return mPC;
}

private static String getCacheKey(ICS ics, Map<String, String> inputArgs,
        boolean clientIsSS) {
    String sResult;
    String pagename = inputArgs.get(ftMessage.PageName);
    COM.FutureTense.ContentServer.PageData pd = ics.getPageData(pagename);
    Map<String, String> defaultArguments = pd.getDefaultArguments();

    String[] pageCriteria = orderPageCriteria(pd.getPageCriteria());
    // Build up the criteria for the page's evaluation
    StringBuilder cacheKey = new StringBuilder(ftMessage.PageName);
    cacheKey.append('=').append(pagename);
    for (String sName : pageCriteria) {
        String sValue;
        if (CacheHelper.isSSMarker(sName)) {
            sValue = clientIsSS ? ftMessage.truestr : ftMessage.falsestr;
        } else {
            Object oValue = inputArgs == null ? null : inputArgs.get(sName);
            sValue = oValue == null ? defaultArguments.get(sName) : oValue
                    .toString(); // value may be FTVAL or String
        }
        if (sValue != null && sValue.length() > 0) {
            cacheKey.append('&').append(sName).append('=').append(sValue);
        }
    }

    sResult = cacheKey.toString();

    return sResult;
}

private static Map<String,String> mapFromTag(String s) {
    Map<String,String> vl = new HashMap<String,String>();

    int size = s.length();
    int start = 0;
    boolean b = true;
    while (b) {
        int j;
        int i = s.indexOf('=', start); // end of word
        if (i < 0)
            break; // done!

        String key = s.substring(start, i).trim();
        i = s.indexOf('"', i); // value begin
        j = s.indexOf('"', i + 1); // end

        String value = s.substring(i + 1, j);
        value = com.fatwire.cs.core.uri.Util.decodeUTF8(value);
        vl.put(key, value);

        // To next word start.
        start = j;
        while (true) {
            if (start < size) {
                if (!Character.isWhitespace(s.charAt(start)))
                    start++;
                else
                    break;
            } else
                break;
        }

        if (start >= size)
            b = false;
    }

    return vl;
}
%><cs:ftcs><%
String pageBody = ics.GetVar("pagebody");
String[] markers= listMarkers(pageBody);
if (markers.length !=0) {
    %><p><b>Inner pagelets found!</b></p><%
    PreparedStmt stmt = new PreparedStmt("SELECT id from SystemPageCache where qryhash= ?", Collections
            .singletonList("SystemPageCache"));
    stmt.setElement(0, "SystemPageCache", "qryhash");

    for (int i=0; i<markers.length;i++){
        Map<String,String> map = mapFromTag(markers[i]);
        String pn = map.get(ftMessage.PageName);
        if (ics.isCacheable(pn)){
            String key = getCacheKey(ics,map,true);
            String md5 =  org.apache.commons.codec.digest.DigestUtils.md5Hex(key);
            StatementParam param = stmt.newParam();
            param.setString(0, md5);
            IList result = ics.SQL(stmt, param, true);
            if (null != result && result.hasData()) // has data
            {
                result.moveTo(1);
                String id = result.getValue("id");
                %><%= Integer.toString(i+1) %>: <a style="color:black" href='ContentServer?pagename=Support/CacheManager/listItemsByPage&pid=<%= id %>'><%= markers[i] %></a><br/><%
            }else {
                %><%= Integer.toString(i+1) %>: (not in cache) <%= markers[i] %><br/><%
            }
        } else {
            %><%= Integer.toString(i+1) %>: (uncacheable) <%= markers[i] %><br/><%
        }
    }
}
%></cs:ftcs>
