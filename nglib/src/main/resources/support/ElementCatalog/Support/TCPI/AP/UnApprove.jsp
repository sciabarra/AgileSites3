<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld"
%><%@ taglib prefix="deliverytype" uri="futuretense_cs/deliverytype.tld"
%><%@ page import="COM.FutureTense.Interfaces.FTValList" 
%><%@ page import="COM.FutureTense.Interfaces.ICS" 
%><%@ page import="COM.FutureTense.Interfaces.IList" 
%><%@ page import="COM.FutureTense.Interfaces.Utilities" 
%><%@ page import="COM.FutureTense.Util.ftErrors" 
%><%@ page import="COM.FutureTense.Util.ftMessage"
%><%@ page import="java.net.*"
%><cs:ftcs>
<script language="JavaScript">
function checkall ( checkbox_obj ) {

    var obj = document.forms[1].elements[0];
    var formCnt = obj.form.elements.length;

    for (i=0; i<formCnt; i++) {
      if (obj.form.elements[i].name == "remPub")  {
           obj.form.elements[i].checked= checkbox_obj.checked;
      }
    }
}

<%-- function for checking if the asset selected is a deletion --%>
function checkVoided() {

  var obj = document.forms[0].elements[0];
  var formCnt = obj.form.elements.length;
  var cont = true;
  var deletions = "";
  var countDel=0;
  //loops for all checkboxes with id set to "VO"
  for (i=0; i<formCnt; i++) {

    if (obj.form.elements[i].name == "remPub")  {
      if (obj.form.elements[i].checked && obj.form.elements[i].className == "VO"){
          deletions = deletions + obj.form.elements[i].value + "\n";
          countDel++;
      }
    }
  }

  if (deletions != "")
      cont = (prompt("WARNING!\n\nThe following assets are asset deletions:\n\n" + (countDel < 25 ? deletions :"\n\nToo many assets (" + countDel + "), not shown here\n\n") + "\nYou will only be able to publish this deletion again if you approve these assets via the Bulk Approve function.\nAssets that are unapproved are written to the log file.\n\nPlease type in \"YES\" if you are absolutely sure you would like to proceed with this:") == "YES");
  return cont;

}

</script>
<h3>Remove Assets from Publish Queue</h3>

<%-- Setting up variables --%>
<%
//Publish Queue Query
String thesql = "SELECT DISTINCT PublishedAssets.assetid AS assetid, PublishedAssets.assettype AS assettype, ApprovedAssets.tstate AS tstate FROM PubKeyTable,PublishedAssets,ApprovedAssets WHERE PubKeyTable.id=PublishedAssets.pubkeyid AND PubKeyTable.targetid=Variables.targetid AND ApprovedAssets.assetid=PublishedAssets.assetid AND ApprovedAssets.targetid=Variables.targetid AND EXISTS (SELECT 'x' FROM ApprovedAssets t0 WHERE PublishedAssets.assetid=t0.assetid AND t0.targetid=Variables.targetid AND (PublishedAssets.assetversion!=t0.assetversion OR PublishedAssets.assetdate<t0.assetdate)) AND EXISTS (SELECT 'x' FROM ApprovedAssets t1 WHERE PubKeyTable.assetid=t1.assetid AND t1.targetid=Variables.targetid AND t1.tstate='A' AND t1.locked='F') UNION SELECT t2.assetid AS assetid, t2.assettype AS assettype, t2.tstate AS tstate FROM PubKeyTable,ApprovedAssets t2 WHERE newkey!='D' AND t2.targetid=Variables.targetid AND (t2.tstate='A' OR t2.tstate='H') AND t2.locked='F' AND PubKeyTable.assetid=t2.assetid AND PubKeyTable.targetid=Variables.targetid  ORDER BY assetid";

//Request objects
String thisPage = ics.GetVar("pagename");
String removePub = ics.GetVar("remPub");
String startIndex = ics.GetVar("startIndex");
String removeAll = ics.GetVar("removeAll");
String checkAllHeld = ics.GetVar("checkAllHeld");
String checkAllApproved = ics.GetVar("checkAllApproved");

//check if we should add all assets to remove them
if (removeAll != null && removeAll.equals("true")) {
	removePub = "";
	%><ics:sql sql='<%= ics.ResolveVariables(thesql) %>' table='PubKeyTable' listname='tlist'/>
      <ics:listloop listname="tlist">
        <ics:listget listname="tlist" fieldname="assetid" output="assetID" />
        <ics:listget listname="tlist" fieldname="assettype" output="assetType" />
        <% 	removePub += (removePub.equals("") ? "" : ";")
        						+ ics.GetVar("assetType") + ":"
        						+ ics.GetVar("assetID"); %>
      </ics:listloop>
     <%
}

if (ics.GetVar("targetid") == null) {
	ics.ClearErrno();
	ics.SelectTo("PubTarget", "id,name,type", null, null, -1,"pubTgts", true, new StringBuffer());
    if (ics.GetErrno()==0){
    %><b>Select a Publish Destination:</b>
    <ul class="subnav">
    <ics:listloop listname="pubTgts">
        <deliverytype:load name="dtype" objectid='<%= ics.ResolveVariables("pubTgts.type")%>'/>
        <deliverytype:get name="dtype" field="name" output="dname"/>
        <li>
        <a href='ContentServer?pagename=<%=thisPage%>&targetid=<ics:resolvevariables name="pubTgts.id"/>'>
        <ics:resolvevariables name="pubTgts.name"/> (<ics:getvar name="dname"/>)</a>
        </li>
    </ics:listloop>
    </ul><% 
   } else { 
    %>No Destinations Available<%
	}
} else if (ics.GetVar("targetid") != null) {
	ics.ClearErrno();
	 //If assets have been selected, remove these from this target's publish queue 
   	if (removePub != null && !removePub.equals("")) {
      	String[] tz = removePub.split(";");
		int counter = 1000;
		for (String token : tz) {
			String[] parts = token.split(":");
			String atype = parts[0];
			String uid = parts[1];
			String status = parts[2];
			counter++;
			ics.LogMsg("UnApproving " + status + " " + atype + "-" + uid);
			//Inserts a row into the ApprovalQueue table for the particular asset to be removed
			FTValList list = new FTValList();
            list.setValString("ftcmd","addrow");
            list.setValString("tablename","ApprovalQueue");
            list.setValString("cs_ordinal",Integer.toString(counter) );
            list.setValString("cs_assettype", atype);
            list.setValString("cs_assetid", uid);
            list.setValString("cs_optype","C");
            list.setValString("cs_voided","F");
            list.setValString("cs_target", ics.GetVar("targetid"));
		    ics.CatalogManager(list);
      	}
        //Trigger the removal of the asset in the ApprovalQueue 
      	FTValList args = new FTValList();
		String output = null;
		args.setValString("TARGET", ics.GetVar("targetid"));
		args.setValString("VARNAME", "heldAssetsCount");

		output = ics.runTag("APPROVEDASSETS.COUNTHELDASSETS",
				args);
		ics.LogMsg("APPROVEDASSETS.COUNTHELDASSETS returned " + output);
		ics.LogMsg("errno is " + ics.GetErrno());
		
		ics.ClearErrno();
   	}
    %>
    <%-- Displays all assets currently in the publish queue --%>
    <ics:setvar name="id" value='<%= ics.GetVar("targetid") %>'/>
    <ics:selectto table="PubTarget" listname="pubTgts" what="id,name,type" where="id" />
    <ics:if condition='<%= ics.GetErrno()==0%>'>
    <ics:then>
        <deliverytype:load name="dtype" objectid='<%= ics.ResolveVariables("pubTgts.type")%>'/>
        <deliverytype:get name="dtype" field="name" output="dname"/>
      <h3><%=ics.ResolveVariables("pubTgts.name (Variables.dname)")%></h3><br/>
    </ics:then>
    </ics:if>
    <%
   	ics.FlushCatalog("ApprovalQueue");
	ics.FlushCatalog("PubKeyTable");
	ics.FlushCatalog("PublishedAssets");
	ics.FlushCatalog("ApprovedAssets");
	ics.SQL("PubKeyTable", ics.ResolveVariables(thesql), "tlist",  -1,  true, new StringBuffer());
   	int held = 0, appr = 0;
	int currentNum = (startIndex == null || startIndex
			.equals("")) ? 1 : Integer.parseInt(startIndex);
	int totalNum = ics.GetList("tlist").numRows();
	int maxNum = Integer.parseInt(ics.GetVar("limit"));
	if (maxNum <1) maxNum=1;

	%>
         <a href='ContentServer?pagename=<%=thisPage%>'>Back to site selection</a><br/>
         
<satellite:form satellite="false" id="tableform1" method="POST" >
    <input type="hidden" name="pagename" value='<%=thisPage %>'/>
    <input type="hidden" name="targetid" value='<%=ics.GetVar("targetid")%>'/>
    <input type="hidden" name="limit" value='<%=Integer.toString(maxNum)%>'/>

    Advanced Settings:<br/>
    <input type="checkbox" name="checkAllHeld" <%= "on".equals(checkAllHeld) ? "checked=\"checked\"": "" %> /> Check all held<br/>
    <input type="checkbox" name="checkAllApproved" <%= "on".equals(checkAllApproved) ? "checked=\"checked\"": "" %> /> Check all approved<br/>
    <input type="submit"/>
</satellite:form>

<satellite:form satellite="false" id="tableform2" method="POST" >
    <input type="hidden" name="pagename" value='<%=thisPage %>'/>
    <input type="hidden" name="targetid" value='<%=ics.GetVar("targetid")%>'/>
    <input type="hidden" name="limit" value='<%=Integer.toString(maxNum)%>'/>
         <br/>
    <input type="hidden" name="checkAllHeld" value='<%= checkAllHeld %>'/>
    <input type="hidden" name="checkAllApproved" value='<%= checkAllApproved %>'/>

    Total number of assets ready for publish: <%= Integer.toString(totalNum) %>. 
    List <% for (int l = 25 ; l <= totalNum*2; ){ %> <a href='ContentServer?pagename=<%=thisPage%>&targetid=<%=ics.GetVar("targetid")%>&limit=<%= Integer.toString(l) %>'><%= Integer.toString(l) %></a><% l=l*2; }%> assets<br/> 
    <table class="altClass" style="width:50%">
        <tr><th>Remove <input type="checkbox" onclick="return checkall(this)"/></th><th>State</th><th>Status</th><th>Asset ID</th><th>Asset Type</th><th>Asset Name</th><th>Asset Description</th></tr>

        <ics:listloop listname="tlist" startrow='<%= "" + currentNum %>' maxrows='<%= "" + maxNum %>'>
          <ics:listget listname="tlist" fieldname="assetid" output="assetID" />
          <ics:listget listname="tlist" fieldname="assettype" output="assetType" />
          <ics:listget listname="tlist" fieldname="tstate" output="state" />

          <%-- get asset's name and description --%>
          <ics:sql sql='<%= ics.ResolveVariables("SELECT name, description, status FROM Variables.assetType WHERE id=Variables.assetID") %>' table='<%= ics.GetVar("assetType") %>' listname="anamelist" />

          <ics:listget listname="anamelist" fieldname="status" output="assetStatus" />
          <ics:listget listname="anamelist" fieldname="name" output="assetName" />
          <ics:listget listname="anamelist" fieldname="description" output="assetDesc" />

          <%-- counts the number of held assets and approved assets --%>
          <%
          	if ("H".equals(ics.GetVar("state")))
				held++;
			else
				appr++;
          %>

          <tr>
<%
  String checked = "";

  if ("on".equals(checkAllHeld)) {
    checked =  ics.GetVar("state").equals("H") ? "checked=\"checked\"" : checked;
  }

  if ("on".equals(checkAllApproved)) {
    checked =  ics.GetVar("state").equals("A") ? "checked=\"checked\"" : checked;
  }


%>
            <td><input type="checkbox" name="remPub" value='<%=ics.GetVar("assetType") + ":"
								+ ics.GetVar("assetID") + ":"
								+ ics.GetVar("assetStatus")%>' class='<ics:getvar name="assetStatus" />' <%= checked %> /></td>
<%--
<%="VO".equals(ics.GetVar("assetStatus"))
								|| ics.GetVar("state").equals("H") ? ""
								: "checked=\"checked\""%>
--%>
            <td><%=ics.GetVar("state")%></td>
            <td><%=ics.GetVar("assetStatus")%></td>
            <td><%=ics.GetVar("assetID")%></td>
            <td><%=ics.GetVar("assetType")%></td>
            <td><%=ics.GetVar("assetName")%></td>
            <td><%=ics.GetVar("assetDesc")%></td>
          </tr>
        </ics:listloop>
    </table><br/>
    <%
    	int cursorNum = 1;
		int pageNum = 1;
		String navBar = "";

		do {

			String navLink = (currentNum == cursorNum) ? ("" + pageNum)
					: ("<a href=\"ContentServer?pagename="
							+ thisPage + "&targetid="
							+ ics.GetVar("targetid")
							+ "&limit=" + maxNum 
							+ "&startIndex=" + cursorNum
							+ "&checkAllHeld=" + checkAllHeld
							+ "&checkAllApproved=" + checkAllApproved + "\">"
							+ pageNum + "</a>");

			if (pageNum == 1)
				navBar += navLink;
			else
				navBar += "|" + navLink;

			cursorNum += maxNum;
			pageNum++;
		} while (cursorNum <= totalNum);
    %>
    <%=navBar.equals("1") ? "" : navBar%>
    <br/>
    Number of held assets: <%=held%>, number of approved assets: <%=appr%><br/>
    <input type="submit" value="Unapprove selected assets"/>
    </satellite:form><%
}%></cs:ftcs>
