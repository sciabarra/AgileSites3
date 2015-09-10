<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="asset" uri="futuretense_cs/asset.tld"
%><%@ page import="COM.FutureTense.Interfaces.*,
                   COM.FutureTense.Util.ftMessage,
                   COM.FutureTense.Util.ftErrors,
                   java.util.*,
                   java.io.*"
%><cs:ftcs><?xml version="1.0" encoding="UTF-8"?>
<%!
public final String AMASSET_STR = "AMAsset";
public final String COMPLEXASSET_STR = "ComplexAsset";
public final String CSELEMENT_STR = "CSElement";
public final String TEMPLATE_STR = "Template";
public final String SITEENTRY_STR = "SiteEntry";
private int numerr, numright, numwrong;
private String ecDefDir = "", mbDefDir = "";

  private String getAssetType(ICS ics, String tableName, StringBuffer errstr) throws NoSuchFieldException {
    String result = "";
    IList atype = ics.SQL("AssetType", "SELECT logic FROM AssetType WHERE assettype='" + tableName + "'", null, -1, true, errstr);

    if (atype.numRows() > 0) {
      String theLogic = atype.getValue("logic");
      if (theLogic.endsWith(AMASSET_STR))
        result = AMASSET_STR;
      else if (theLogic.endsWith(COMPLEXASSET_STR))
        result = COMPLEXASSET_STR;
    }

    return result;
  }

  private String checkBasicDBLength(ICS ics, String tableName, StringBuffer errstr) throws NoSuchFieldException {

    String result = "";

    IList catDef = ics.CatalogDef(tableName, null, errstr);

    Map<String,String> field_length = new HashMap<String,String>();

    if (catDef.numRows() > 0) {
      do {
        field_length.put((catDef.getValue("COLNAME")).toLowerCase(), catDef.getValue("COLSIZE"));
      }
      while (catDef.moveToRow(IList.next, 0));
    }

    String propList = com.openmarket.assetmaker.asset.AMAsset.GenPropertyList(ics, com.openmarket.assetmaker.asset.AMAsset.LoadDescriptorFile(ics, tableName), "storage");

    StringTokenizer propToken = new StringTokenizer(propList, ",");

    while (propToken.hasMoreTokens()) {

      String currProp = (propToken.nextToken()).toLowerCase();

      int dbSize = Integer.parseInt("" + field_length.get(currProp.toLowerCase()));

      int adfSize = 0;
      String adfSizeString = ics.GetVar("assetmaker/property/" + currProp + "/storage/length");

      if (adfSizeString != null) {
        adfSize = Integer.parseInt(adfSizeString);

        if (adfSize != dbSize) {
          result += "<br/>" + currProp + " - ADF size: " + adfSize + ", DB size: " + dbSize;
          numerr++;
        }
      }
    }
    return result;

  }

  private String checkFlexDBLength(ICS ics, String tableName, StringBuffer errstr) throws NoSuchFieldException {

    if (ics.GetCatalogType(tableName + "_Mungo") == ICS.NoSuchCatalog) {
      return "";
    }

    final int STRINGVALUE_INT = 0, INTVALUE_INT = 1, FLOATVALUE_INT = 2, TEXTVALUE_INT = 3;
    final String[] COLUMNS = {"stringvalue", "intvalue", "floatvalue", "textvalue"};

    String result = "";
    String badproperties = "";

    IList catDef = ics.CatalogDef(tableName + "_Mungo", null, errstr);

    Map<String,String> field_length = new HashMap<String,String>();

    if (catDef.numRows() > 0) {
      do {
        field_length.put((catDef.getValue("COLNAME")).toLowerCase(), catDef.getValue("COLSIZE"));
      }
      while (catDef.moveToRow(IList.next, 0));
    }

    int dbSize = 0, iniSize = 0;
    String currCol;

    for (int i = 0; i < COLUMNS.length; i++) {
      currCol = COLUMNS[i];

      dbSize = Integer.parseInt("" + field_length.get(currCol));

      String propname = "", propvalue = "";
      boolean badprop = false;

      switch (i) {


      case STRINGVALUE_INT:
          propname = "cc.queryablemaxvarcharlength";
          propvalue = ics.GetProperty(propname);

          if (!Utilities.goodString(propvalue)) {
            badprop = true;
          }
          else {
            try {
              iniSize = Integer.parseInt(propvalue);
            }
            catch (NumberFormatException e) {
              badprop = true;
            }
          }

          break;


        case INTVALUE_INT:
          propname = "cc.integer";
          propvalue = ics.GetProperty(propname);

          if (!Utilities.goodString(propvalue)) {
            badprop = true;
          }
          else {
            try {
              if (propvalue.indexOf("(") != -1 && propvalue.indexOf(")") != -1) {
                iniSize = Integer.parseInt(propvalue.substring(propvalue.indexOf("(") + 1, propvalue.indexOf(")")));
              }
              else { //no size defined in ini file, assume match
                iniSize = dbSize;
              }
            }
            catch (NumberFormatException e) {
              badprop = (ics.GetProperty("cs.dbtype").equalsIgnoreCase("Oracle"));

              if (!badprop)
                iniSize = dbSize;
            }
            catch (StringIndexOutOfBoundsException e) {
              badprop = (ics.GetProperty("cs.dbtype").equalsIgnoreCase("Oracle"));

              if (!badprop)
                iniSize = dbSize;

            }
          }

          break;


        case FLOATVALUE_INT:
          propname = "cc.double";
          propvalue = ics.GetProperty(propname);

          if (!Utilities.goodString(propvalue)) {
            badprop = true;
          }
          else {
            iniSize = dbSize;
            try {
              if (propvalue.indexOf("(") !=-1 && propvalue.indexOf(",") != -1) {
                iniSize = Integer.parseInt(propvalue.substring(propvalue.indexOf("(") + 1, propvalue.indexOf(",")));
              }
              else if (propvalue.indexOf("(") != -1 && propvalue.indexOf(")") != -1) {
                iniSize = Integer.parseInt(propvalue.substring(propvalue.indexOf("(") + 1, propvalue.indexOf(")")));
              }
              else { //no size defined in ini file, assume match
                iniSize = dbSize;
              }
            }
            catch (Exception e) {
              badprop = (!ics.GetProperty("cs.dbtype").equalsIgnoreCase("DB2"));
              if (!badprop)
                iniSize = dbSize;
            }
          }

          break;


        case TEXTVALUE_INT:
          propname = "cc.bigtext";
          propvalue = ics.GetProperty(propname);

          if (!Utilities.goodString(propvalue)) {
            badprop = true;
          }
          else {
            try {
              if (propvalue.indexOf("(") != -1 && propvalue.indexOf(")") != -1) {
                iniSize = Integer.parseInt(propvalue.substring(propvalue.indexOf("(") + 1, propvalue.indexOf(")")));
              }
              else { //no size defined in ini file, assume match
                iniSize = dbSize;
              }
            }
            catch (NumberFormatException e) {
              badprop = (ics.GetProperty("cs.dbtype").equalsIgnoreCase("Oracle"));

              if (!badprop)
                iniSize = dbSize;
            }
            catch (StringIndexOutOfBoundsException e) {
              badprop = (!propvalue.equalsIgnoreCase("CLOB") && ics.GetProperty("cs.dbtype").equalsIgnoreCase("Oracle"));

              if (!badprop)
                iniSize = dbSize;
            }
          }

          break;

      }

      if (badprop) {
        badproperties += (badproperties.equals("")) ? propname : ", " + propname;
        numerr++;
      }
      else if (dbSize != iniSize) {
        result += "<br/>" + currCol + " - INI size (" + propname + "): " + iniSize + ", DB size: " + dbSize;
        numerr++;
      }
    }

    return (badproperties.equals("")) ? result : result + "<br/>invalid property values in futuretense.ini: " + badproperties;
  }

  private String getDefDir (String tblName, ICS ics) {

        try {
          String thedefdir = "" + ics.ResolveVariables("CS.CatalogDir." + tblName);

          if (!thedefdir.equals("")) {
            thedefdir = Utilities.osSafeSpec(thedefdir);
            thedefdir = new java.io.File(thedefdir).getCanonicalPath();
            if (thedefdir.charAt(thedefdir.length()-1) != java.io.File.separatorChar)
              thedefdir = thedefdir.concat(java.io.File.separator);

            return thedefdir;
          }
        }
        catch (IOException e) {
          e.printStackTrace();
        }

        return "";
      }

      private boolean isUpload (String fieldName) {
        return (((fieldName.startsWith("url") || fieldName.endsWith("_file")) && !fieldName.equals("url")) && !(fieldName.endsWith("_folder") || fieldName.equals("urlspec")));
      }

      private boolean isItself (String fieldName) {
        return ((fieldName.lastIndexOf(":") == fieldName.indexOf(":") || fieldName.matches("tempasset:[\\d]*:(.*)")) || fieldName.contains(":element:"));
      }

      private String htmlEncode (String unencoded) {

        String result;
        result = unencoded.replaceAll("&", "&amp;");
        result = result.replaceAll(">", "&gt;");
        result = result.replaceAll("<", "&lt;");

        return result;
      }

      private boolean checkFile (ICS ics, String defdir, String fileVar, JspWriter out) {

        String checkString = "";
        String folderVar = "";

        if (fileVar.endsWith("_file")) {

          folderVar = fileVar.substring(0, fileVar.length() - 5) + "_folder";

          if (ics.GetVar(folderVar) != null) {
            checkString = ics.GetVar(folderVar) + File.separator + ics.GetVar(fileVar);
          }
          else
            checkString = ics.GetVar(fileVar);
        }

        return Utilities.fileExists(defdir + checkString) || Utilities.fileExists(ecDefDir + checkString) || Utilities.fileExists(mbDefDir + checkString);
      }

      private String stripSuffix( String theVar ) {

        String result = theVar;

        if (theVar.endsWith("_file") || theVar.endsWith("_folder")) {
          result = theVar.substring(0, theVar.lastIndexOf('_'));
        }

        return result;
    }
%><%--

MAIN LOGIC

--%><%

  String currTable = ics.GetVar("assettype");

  if (currTable ==null || (ics.GetCatalogType(currTable) == ICS.NoSuchCatalog)) {
    out.println("<result numerr='1'>");
    out.println("  <dbmismatch>no such table found!</dbmismatch>");
    out.println("  <invalid num='0'></invalid>");
    out.println("  <valid num='0'></valid>");
    out.println("</result>");
  }
  else {

StringBuffer errstr = new StringBuffer(128);

String wrong, correct, dbmismatch, assetType;
mbDefDir = getDefDir("MungoBlobs", ics);
ecDefDir = getDefDir("ElementCatalog", ics);

  numerr = 0;
  numright = 0;
  numwrong = 0;
  wrong = "";
  correct = "";
  dbmismatch = "";
  assetType = getAssetType(ics, currTable, errstr);

  //If this is a basic asset created from asset maker, check to see if column type and size matches on the DB and the ADF file
  if (assetType.equals(AMASSET_STR)) {

    String mismatchCheck = checkBasicDBLength(ics, currTable, errstr);

    if (mismatchCheck.equals(""))
      dbmismatch = "<p>Column length in ADF correctly matches length in DB</p>";
    else
      dbmismatch = "<p>The following DB column(s) do not match values in ADF: <span class=\"bad\">" + mismatchCheck + "</span></p>";
  }
  //If this is a flex asset, we need to check values in futuretense.ini and compare it to the _MUNGO table
  else if (assetType.equals(COMPLEXASSET_STR)) {
    String mismatchCheck = checkFlexDBLength(ics, currTable, errstr);

    if (mismatchCheck.equals(""))
      dbmismatch = "Column length in futuretense.ini correctly matches length in DB</p>";
    else
      dbmismatch = "<p>The following DB columns do no match values in the futuretense.ini file: <span class=\"bad\">" + mismatchCheck + "</span></p>";
  }

  //Loop through each non-voided row in this asset table

  IList assetRows = ics.SQL(currTable, "SELECT * FROM " + currTable + " WHERE status != 'VO'", null, -1, true, errstr);

  if (assetRows.numRows() > 0) {
    do {

      int temperrno;
      boolean thisError = false;
      String currId = assetRows.getValue("id");

      String results = "<p><b>" + currId + "</b><br/>";


      //run asset:load on this asset id
      ics.ClearErrno();

      %><asset:load name="tempAsset" type='<%= currTable %>' objectid='<%= currId %>' /><%

      temperrno = ics.GetErrno();

      results += "&lt;asset:load&gt; call error number = <span class=\"";
      if (temperrno != 0) {
        results += "bad\">" + temperrno + "</span> (please check log files for additional details)<br/>";
        thisError = true;
      }
      else {
        results += "good\">" + temperrno + "</span><br/>";



        //run asset:scatter on this asset id if asset:load was successful
        ics.ClearErrno();
        %><asset:scatter name="tempAsset" prefix="tempasset" /><%

        temperrno = ics.GetErrno();
        results += "&lt;asset:scatter&gt; call error number = <span class=\"";

        if (temperrno != 0) {
          results += "bad\">" + temperrno + "</span><br/>";
          thisError = true;
        }
        else
          results += "good\">" + temperrno + "</span><br/>";



        //If this is a page asset, check SitePlanTree

        if (currTable.equalsIgnoreCase("Page")) {
          boolean passCheck = true;
          results += "SitePlanTree check: ";

          ics.ClearErrno();
          try {
            %><asset:getsitenode name="tempAsset" output="tempasset:sitenodetest"/><%
          }
          catch (Exception e) {
            passCheck = false;
          }

          int errorNumber = ics.GetErrno();
          if (errorNumber < 0)
            passCheck = false;

          if (!passCheck) {
            results += "<span class=\"bad\">SitePlanTree entry missing!</span><br/>";
            thisError = true;
          }
          else {
            results += "<span class=\"good\">pass</span><br/>";
          }
        }




      //If this is a Template, CSElement, or SiteEntry, check if the rootelement/pagename points to an existing ElementCatalog

      if (currTable.equalsIgnoreCase(TEMPLATE_STR) || currTable.equalsIgnoreCase(CSELEMENT_STR)) {
        String root = assetRows.getValue("rootelement");

        results += "valid rootelement (" + root + "): <span class=\"";

        if (ics.IsElement(root)) {
          results += "good\">yes</span><br/>";
        }
        else {
          results += "bad\">no</span><br/>";
          thisError = true;
        }
      }
      else if (currTable.equalsIgnoreCase(SITEENTRY_STR)) {
        String pname = assetRows.getValue("pagename");

        results += "valid pagename (" + pname + "): <span class=\"";

        IList sitecatalog = ics.SQL("SiteCatalog", "SELECT pagename FROM SiteCatalog WHERE pagename='" + pname + "'", null, -1, true, errstr);

        if (sitecatalog.numRows() > 0) {
          results += "good\">yes</span><br/>valid CSElement id (" + assetRows.getValue("cselement_id") + "): <span class=\"";

      IList cselement = ics.SQL("CSElement", "SELECT id FROM CSElement WHERE id='" + assetRows.getValue("cselement_id") + "'", null, -1, true, errstr);

      if (cselement.numRows() > 0) {
        results += "good\">yes</span><br/>";
      }
      else {
        results += "bad\">no</span><br/>";
            thisError = true;
          }
        }
        else {
          results += "bad\">no</span><br/>";
          thisError = true;
        }
      }

      //Checks this table to see if there are any url fields that reference an invalid file

      String badurl = "";
      String tempVars = "";


      Enumeration vars = ics.GetVars();

      while (vars.hasMoreElements()) {
        String currVar = "" + vars.nextElement();
        if (currVar.startsWith("tempasset")) {
          tempVars += (tempVars.length() > 0) ? "," + currVar : currVar;

          String strippedVar = currVar.substring(currVar.lastIndexOf(":") + 1);

          if (isUpload(strippedVar) && isItself(currVar)) {
            String thedefdir = getDefDir(currTable, ics);

            if (!thedefdir.equals("")) {
              boolean isNull = (ics.GetVar(currVar) == null) || (("" + ics.GetVar(currVar)).equals("")) || (("" + ics.GetVar(currVar)).equals("null"));
              boolean bcheckFile = checkFile(ics, thedefdir, currVar, out);

              if (!isNull &&
                  !bcheckFile &&
                  !(assetType.equals(COMPLEXASSET_STR) && Utilities.fileExists(mbDefDir + ics.GetVar(currVar)))
                 ) {

                String strippedString = stripSuffix(strippedVar);
                badurl += (badurl.length() == 0) ? strippedString : ", " + strippedString;

                if (strippedString.equals("url") && (currTable.equalsIgnoreCase("CSElement") || currTable.equalsIgnoreCase("Template"))) {
                  badurl += " (ElementCatalog)";
                }

                thisError = true;

              }
            }
          }
        }
      }
      results += "Referenced file is missing in the following attribute or database column: ";
      results += (badurl.length() == 0) ? "<span class=\"good\">none</span>" : "<span class=\"bad\">" + badurl + "</span>";


      //Remove temp variables from hash

      StringTokenizer removeToken = new StringTokenizer(tempVars, ",");

      while (removeToken.hasMoreTokens()) {
        ics.RemoveVar(removeToken.nextToken());
      }

      }

      //Finalize and sort the valid and invalid assets

      results += "</p>";

      if (thisError) {
        wrong += (wrong.equals("")) ? results : "\n" + results;;
        numerr ++;
        numwrong ++;
      }
      else {
        correct += (correct.equals("")) ? results : "\n" + results;
        numright ++;
      }
    }
    while (assetRows.moveToRow(IList.next, 0));
  }
  %><%--

  RESULT XML

  --%><result numerr='<%= numerr %>'>
  <dbmismatch><%= htmlEncode(dbmismatch) %></dbmismatch>
  <invalid num='<%= "" + numwrong %>'><%= htmlEncode(wrong) %></invalid>
  <valid num='<%= "" + numright %>'><%= htmlEncode(correct) %></valid>
</result><%
}

%></cs:ftcs>