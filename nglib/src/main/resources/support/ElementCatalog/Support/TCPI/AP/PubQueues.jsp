<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld"
%><%//
// Support/TCPI/AP/PubQueues
//
// INPUT
//
// OUTPUT
//
%><%@ page import="COM.FutureTense.Interfaces.ICS"
%><%!
static String sqlA="SELECT count(id) as num FROM ApprovedAssets WHERE assettype='assettypes.assettype' AND targetid=targets.id AND tstate='A'";
static String sqlH="SELECT count(id) as num FROM ApprovedAssets WHERE assettype='assettypes.assettype' AND targetid=targets.id AND tstate='H'";
static String sqlC="SELECT count(id) as num FROM ApprovedAssets WHERE assettype='assettypes.assettype' AND targetid=targets.id AND tstate='C'";
static String sqlT="SELECT count(id) as num FROM ApprovedAssets WHERE assettype='assettypes.assettype' AND targetid=targets.id";

static String sqlAA="SELECT count(id) as num FROM ApprovedAssets WHERE assettype='assettypes.assettype' AND tstate='A'";
static String sqlHA="SELECT count(id) as num FROM ApprovedAssets WHERE assettype='assettypes.assettype' AND tstate='H'";
static String sqlCA="SELECT count(id) as num FROM ApprovedAssets WHERE assettype='assettypes.assettype' AND tstate='C'";
static String sqlTA="SELECT count(id) as num FROM ApprovedAssets WHERE assettype='assettypes.assettype'";

static String sqlAT="SELECT count(id) as num FROM ApprovedAssets WHERE targetid=targets.id AND tstate='A'";
static String sqlHT="SELECT count(id) as num FROM ApprovedAssets WHERE targetid=targets.id AND tstate='H'";
static String sqlCT="SELECT count(id) as num FROM ApprovedAssets WHERE targetid=targets.id AND tstate='C'";
static String sqlTT="SELECT count(id) as num FROM ApprovedAssets WHERE targetid=targets.id";

static String sqlATA="SELECT count(id) as num FROM ApprovedAssets WHERE tstate='A'";
static String sqlHTA="SELECT count(id) as num FROM ApprovedAssets WHERE tstate='H'";
static String sqlCTA="SELECT count(id) as num FROM ApprovedAssets WHERE tstate='C'";
static String sqlTTA="SELECT count(id) as num FROM ApprovedAssets";
%>
<cs:ftcs>
<center><h3>Overview of ApprovedAssets</h3></center>
<% if ("true".equals(ics.GetVar("detail")) ){
%><ics:callelement element="Support/TCPI/AP/PubDestTotalsDetail"/><%
} else {
%><ics:callelement element="Support/TCPI/AP/PubDestTotals"/><%
}
%>
</cs:ftcs>
