<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// Support/Audit/Default/ElementCheck
//
// INPUT
//
// OUTPUT
//%>
<%@ page import="COM.FutureTense.Interfaces.FTValList" %>
<%@ page import="COM.FutureTense.Interfaces.ICS" %>
<%@ page import="COM.FutureTense.Interfaces.IList" %>
<%@ page import="COM.FutureTense.Interfaces.Utilities" %>
<%@ page import="COM.FutureTense.Util.ftErrors" %>
<%@ page import="COM.FutureTense.Util.ftMessage"%>
<%@ page import="java.util.*"%>
<%@ page import="java.io.*"%>
<cs:ftcs>
<h3><center>Lists Elements and Checks all URL columns Exist on Disk</center></h3>
<%!
   private void fileRollup(JspWriter out, String urlfile, String path) throws IOException{
      try {
          String filename = Utilities.fileFromSpec(urlfile);
          String xfile = null;
          if (filename.lastIndexOf(",") > 0)
              xfile = filename.substring(0,filename.lastIndexOf(","));
          else
              xfile = filename.substring(0,filename.lastIndexOf("."));

          String dirname = urlfile.substring(0,urlfile.lastIndexOf(filename));
          String oldpath = path+dirname+filename;

          File dirfiles = new File(path+dirname);
          String[] files = dirfiles.list();

          if (files.length > 0)
             out.print("<font color=\"orange\">File Rollups: </font>");
          for (int j=0; j<files.length; j++) {
              String yfile = null;
              if (Utilities.isFolder(path+dirname+files[j])!=0) {
                  if (files[j].lastIndexOf(",") < 0)
                      yfile = files[j].substring(0,files[j].lastIndexOf("."));
                  else
                      yfile = files[j].substring(0,files[j].lastIndexOf(","));

                  if (xfile.equalsIgnoreCase(yfile)) {
                      String newpath = path+dirname+files[j];
                      out.print("<font color=\"orange\">"+files[j]+"</font>");
                      out.print("&nbsp;<a href=\"ContentServer?pagename=Support/Audit/DispatcherFront&cmd=ElementCheck&filespec="+newpath+"&filepath="+oldpath+"&useme=yes\">UseMe</a><br/>");
                  }
              }
          }
      } catch (Exception e) {
          out.print(e);
      }
   }
%>

<%
    String query = "SELECT url, elementname FROM ElementCatalog ORDER BY elementname";
    String defquery = "SELECT defdir FROM SystemInfo WHERE tblname='ElementCatalog'";
    String table = "ElementCatalog";
    String listname = null;
    String defdir=null;
    IList resultList;
    StringBuffer errstr = new StringBuffer();

    ics.ClearErrno();
    defdir = ics.ResolveVariables("CS.CatalogDir.ElementCatalog");
    if("yes".equals(ics.GetVar("useme"))) {
        String content = Utilities.readFile(ics.GetVar("filespec"));
        Utilities.writeFile(ics.GetVar("filepath"), content);
    }

    if("yes".equals(ics.GetVar("createme"))) {
        String content = "";
        Utilities.writeFile(ics.GetVar("filepath"), content);
    }

    ics.ClearErrno();
    int count=0;
    resultList = ics.SQL(table, query, listname, -1, true, errstr);
    if (ics.GetErrno()==0 && resultList.hasData()){
        int numrows = resultList.numRows();
        out.print("Total Number of Elements: <b>"+numrows+"</b>");
        out.print("<table class=\"altClass\">");
        out.print("<tr><th width=\"40%\" align=\"left\">Element Name</th><th>UrlFile?</th></tr>");
        for (int i=1; i<=numrows; i++) {
            resultList.moveTo(i);
            if (!Utilities.fileExists(defdir + resultList.getValue("url"))) {
                count++;
                out.print("<tr><td>");
                out.print(resultList.getValue("elementname"));
                out.print("</td>");
                out.print("<td>");
                out.print("<font color=\"red\"><b>File NOT FOUND</b></font><br/>");
                fileRollup(out, resultList.getValue("url"), defdir);
                out.print("</td></tr>");
            }
        }
        out.print("</table>");
        if(count==0){
            out.print("<p style=\"font-size:large\">All ElementCatalog rows are in sync with the file system.</p>");
        }
    }
%>
</cs:ftcs>