<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld"
%><%//
// Support/TCPI/PubKeys/UpdateBatchUI
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
%><cs:ftcs>
<ics:callelement element="Support/general"/>
<div id="content">
<ics:callelement element="Support/Topnav"/>
<h3>Move Files in PubKeyTable</h3>
<ics:callelement element="Support/TCPI/PubKeys/UpdateBatch">
  <ics:argument name="delete" value="true" />
  <ics:argument name="limit" value="500" />
</ics:callelement>
<ics:clearerrno />
<ics:sql sql="SELECT count(id) as num FROM PubKeyTable WHERE urlkey NOT LIKE('%/%')" table="PubKeyTable" listname="pubkeys"/>
<ics:resolvevariables name="pubkeys.num"/> pubkeys can be moved. <br/><a href='ContentServer?pagename=<ics:getvar name="pagename"/>&delete=true&limit=<ics:getvar name="limit"/>'>Click here to move <ics:getvar name="limit"/> pubkey urlkey fields.</a><br/>
<ics:clearerrno />
<ics:callelement element="Support/Footer"/>
</div>
</cs:ftcs>