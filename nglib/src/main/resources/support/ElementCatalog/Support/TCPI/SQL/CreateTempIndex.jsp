<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" 
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" 
%><%//
// Support/TCPI/SQL/CreateIndex
//
// INPUT
// tablename, columns, pctfree
//
// OUTPUT
//
%><%@ page import="COM.FutureTense.Interfaces.ICS,COM.FutureTense.Interfaces.IList,COM.FutureTense.Interfaces.Utilities" 
%><%!
private String getTableSpace(ICS ics, String tableName){
	IList list = ics.SQL("SystemInfo","select tablespace_name AS tablespace from user_indexes where table_name='" + tableName + "' AND uniqueness='NONUNIQUE'","TableSpace",1,true,new StringBuffer());

	if(ics.GetErrno() == -101) {
		ics.ClearErrno();
		list = ics.SQL("SystemInfo","select tablespace_name AS tablespace from user_indexes where table_name='" + tableName + "'", "TableSpace", 1,true,new StringBuffer());
		if(ics.GetErrno() == -101) {
			ics.ClearErrno();
			list = ics.SQL("SystemInfo","select tablespace_name AS tablespace from user_tables where table_name='" + tableName + "'", "TableSpace", 1,true,new StringBuffer());
		}
	}
	return ics.ResolveVariables("TableSpace.tablespace");
}
%>
<cs:ftcs>
<%
String bitMap = "";

if (!Utilities.goodString(ics.GetVar("pctfree")))	{	ics.SetVar("pctfree", "0"); }
if ("true".equals(ics.GetVar("bitmap")))	{	bitMap = "BITMAP ";}
String indexName = "I_FW_INDT_" + ics.genID(true) ;
%>
prompt CREATE INDEX <%= indexName %> ON <ics:getvar name="tablename"/>

select 'current time is ' || to_char(sysdate,'YYYY-MM-DD HH24:MI:SS') as cur from dual;
timing start create_index

CREATE <%= bitMap %>INDEX <%= indexName %>
	ON <ics:getvar name="tablename"/> (<ics:getvar name="columns"/>)
	TABLESPACE <%= getTableSpace(ics,ics.GetVar("tablename")) %>
	NOLOGGING
	PCTFREE <ics:getvar name="pctfree"/>;
ALTER INDEX <%= indexName %> LOGGING;

timing stop
</cs:ftcs>
