<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld"
%><%//
// Support/CacheManager/ShowDuplicate
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
%><%@ page import="java.util.*"
%><%!
static class PageInfo {
    int count = 0;
    String pagename;
    List<String[]> qrystr = new LinkedList<String[]>();
    PageInfo(String s) {
        pagename=s;;
    }
}

static Comparator<PageInfo> pageInfoComparator = new  Comparator<PageInfo>() {
    public int compare(PageInfo pi1,PageInfo pi2) {
      return pi1.count < pi2.count ? -1 : (pi1.count == pi2.count ? 0 : 1);
   }
};

private LinkedHashMap sortMapByValue(HashMap tosort, boolean asc) {
    List mapKeys = new ArrayList(tosort.keySet());
    List mapValues = new ArrayList(tosort.values());

    Collections.sort(mapValues, pageInfoComparator);
    Collections.sort(mapKeys);

    if (!asc)
    Collections.reverse(mapValues);

    LinkedHashMap sorted = new LinkedHashMap();
    Iterator valueIt = mapValues.iterator();
    while (valueIt.hasNext()) {
        Object val = valueIt.next();
        Iterator keyIt = mapKeys.iterator();
        while (keyIt.hasNext()) {
            Object key = keyIt.next();
            if (tosort.get(key).toString().equals(val.toString())) {
                tosort.remove(key);
                mapKeys.remove(key);
                sorted.put(key, val);
                break;
            }
        }
    }
    return sorted;
}

private String parseQuery(String qry) {
    Map<String,String> conqry = new HashMap<String,String>();
    conqry.put("pagename", "--");
    conqry.put("c", "--");
    conqry.put("cid", "--");
    conqry.put("p", "--");
    conqry.put("context", "--");
    conqry.put("rendermode", "--");
    conqry.put("ft_ss", "--");
    conqry.put("other", "--");
    conqry.put("seid", "--");
    conqry.put("site", "--");
    conqry.put("siteid", "--");


    String[] parsed = qry.split("&");
    for (int j=0; j<parsed.length; j++) {
        String[] cparse = parsed[j].split("=");
        if (cparse.length >1){
            if (cparse[0].equals("pagename") || cparse[0].equals("c") || cparse[0].equals("cid") || cparse[0].equals("p") || cparse[0].equals("context") || cparse[0].equals("rendermode") || cparse[0].equals("ft_ss") || cparse[0].equals("seid") || cparse[0].equals("site") || cparse[0].equals("siteid"))
              conqry.put(cparse[0], cparse[1]);
            else {
              String op = conqry.get("other");
              if(op!="--")
                conqry.put("other", op+"&"+cparse[0]+"="+cparse[1]);
              else
                conqry.put("other", cparse[0]+"="+cparse[1]);
            }
        }
    }

    String qrystring = "";
    qrystring += "<td width=\"25%\" nowrap=\"true\">"+conqry.get("pagename")+"</td>";
    qrystring += "<td width=\"5%\" nowrap=\"true\">"+conqry.get("c")+"</td>";
    qrystring += "<td width=\"5%\" nowrap=\"true\">"+conqry.get("cid")+"</td>";
    qrystring += "<td width=\"5%\" nowrap=\"true\">"+conqry.get("p")+"</td>";
    qrystring += "<td width=\"5%\" nowrap=\"true\">"+conqry.get("context")+"</td>";
    qrystring += "<td width=\"5%\" nowrap=\"true\">"+conqry.get("rendermode")+"</td>";
    qrystring += "<td width=\"5%\" nowrap=\"true\">"+conqry.get("ft_ss")+"</td>";
    qrystring += "<td width=\"15%\" nowrap=\"true\">"+conqry.get("other")+"</td>";
    qrystring += "<td width=\"5%\" nowrap=\"true\">"+conqry.get("seid")+"</td>";
    qrystring += "<td width=\"5%\" nowrap=\"true\">"+conqry.get("site")+"</td>";
    qrystring += "<td width=\"5%\" nowrap=\"true\">"+conqry.get("siteid")+"</td>";
    conqry.clear();

    return qrystring;
}

private void reportExcess(PageInfo pd, JspWriter writer) throws java.io.IOException {
    writer.print("<td>Found "+pd.count+" identical pages: <br/>"+"<a href='ContentServer?pagename=Support/CacheManager/listPagename&pname="+pd.pagename+"&mode=detail'>"+pd.pagename+"</a></td>");
    writer.print("<td style=\"padding:0px\"><table style=\"background-color:#CCFF99\" cellspacing=\"1px\" width=\"100%\"  class=\"altClass\">");
    writer.print("<tr><th>pageid</th><th>pagename</th><th>c</th><th>cid</th><th>p</th><th>context</th><th>rendermode</th><th>ft_ss</th><th>other params</th><th>seid</th><th>site</th><th>siteid</th>");

    for (String[] s: pd.qrystr) {
        writer.print("<tr><td width=\"10%\"><a href=\"ContentServer?pagename=Support/CacheManager/listItemsByPage&pid="+s[0]+"\" onmouseover=\"div_show(this,'"+s[0]+"')\" onmouseout=\"div_hide()\">"+s[0]+"</a></td>");
        writer.print(parseQuery(s[1])+"</tr>");
    }
    writer.print("</table></td>");
}

private void findDups(ICS ics, String pagename, JspWriter out) throws Exception {
    StringBuffer errstr = new StringBuffer();
    String query = "select id, pagename, urlqry, urlpage from SystemPageCache "+ (pagename!=null? "where pagename='" +pagename+"'" :"") +"order by pagename";
    IList results = ics.SQL("SystemPageCache", query, null, -1, true, errstr);
    int rows = results.numRows();

    out.print("...Total "+rows+" Cached Pages for '"+pagename+"' ");

    java.security.MessageDigest md = java.security.MessageDigest.getInstance("MD5");

    Map<String,PageInfo> counter = new HashMap<String,PageInfo>();
    for (int i = 1; i <= rows; i++) {
        results.moveTo(i);
        byte[] pagebody = results.getFileData("urlpage");
        md.update(pagebody);
        byte[] digest = md.digest();

        String pgbody = new String(org.apache.commons.codec.binary.Hex.encodeHex(digest));

        PageInfo pi = counter.get(pgbody);

        if (pi == null) {
            pi = new PageInfo(results.getValue("pagename"));
            counter.put(pgbody,pi);
        }
        pi.count++;
        pi.qrystr.add(new String[]{results.getValue("id"),results.getFileString("urlqry")});
    }

    List<PageInfo> list = new ArrayList<PageInfo>();

    for (PageInfo info: counter.values()){
        if (info.count>1){
            list.add(info);
        }
    }
    if (list.isEmpty()){
        out.print("No duplicates found...........<br/>");
    }else {
        out.print("...........");
        Collections.sort(list, pageInfoComparator);
        out.print("<table>");
        out.print("<tr><th>DuplicatePages</th><th>PageID - QueryDetails</th></tr>");
        for (PageInfo pi:list) {
            out.print("<tr>");
            reportExcess(pi,out);
            out.print("</tr>");
        }
        out.print("</table>");
    }
    counter.clear();

}

%><cs:ftcs><%
if (ics.GetVar("pname")!=null){
    StringBuffer errstr = new StringBuffer();
    String query = "select pagename from SiteCatalog order by lower(pagename)";
    IList results = ics.SQL("SiteCatalog", query, null, -1, true, errstr);
    int rows = results.numRows();
    int x=0;
    for (int i = 1; i <= rows; i++) {
        results.moveTo(i);
        String pagename = results.getValue("pagename");
        if (ics.isCacheable(pagename)){ //assuming ss and cscacheinfo are both set the same
            String[] criteria = ics.pageCriteriaKeys(pagename);
            if (criteria.length > 0){
                if (pagename.equals(ics.GetVar("pname"))){
                    findDups(ics,pagename,out);
                }
            }
        }
    }
}
%></cs:ftcs>