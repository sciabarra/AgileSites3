<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// Support/Verify/xml/export
//
// INPUT
//
// OUTPUT
//%>
<%@ page import="COM.FutureTense.Interfaces.ICS, COM.FutureTense.Interfaces.IList" %>
<%!
    static final String[] esc = {"&amp;","&lt;", "&gt;","&quot;"};
        
    String escape(String s){
	if(s==null) return "";
        StringBuffer t = new StringBuffer(s.length());
        char c = (char)-1;
        for (int j = 0; j<s.length(); j++) {
            //System.out.println(j + "=" + s.charAt(j));
            c = s.charAt(j);
            switch (c){
                case '&':
                    t.append(esc[0]);
                    break;
                case '<':
                    t.append(esc[1]);
                    break;
                case '>':
                    t.append(esc[2]);
                    break;
                case '\"':
                    t.append(esc[3]);
                    break;
                default:
                    t.append(c);
                    break;
            }
        }
        return t.toString();
    }

%><cs:ftcs><?xml version="1.0" encoding="UTF-8"?>
<schema>
<%
String tbl = ics.GetVar("tbl");
String query = ics.GetVar("query");

if (tbl==null || tbl.length()==0) tbl="SystemInfo";

if (query==null) query="SELECT * FROM " + tbl;

%><table name="<%= tbl %>"><%
StringBuffer err = new StringBuffer();
IList schema = ics.SQL(tbl,query, null,20,true,err);
if(ics.GetErrno() == 0 && schema != null && schema.hasData()){
	int cols= schema.numColumns();
	int rows= schema.numRows();
	String[] colNames= new String[cols];
	for (int i=0; i< cols;i++){
		colNames[i]= schema.getColumnName(i);
	}
	for (int j=1; j<=rows;j++){
		schema.moveTo(j);
		%><row><%
		for (int i=0; i< cols;i++){
			boolean upload = colNames[i].startsWith("url");
			%><column name='<%= colNames[i] %>' urlcolumn='<%= upload %>'> 
					<colvalue><%= escape(schema.getValue(colNames[i])) %></colvalue><%
				if (upload && !"".equals(schema.getValue(colNames[i]) )) {
					%><urldata><%= escape(schema.getFileString(colNames[i])) %></urldata><%
				} 
			%></column><%
		}
		%></row><%
		
	}
} else {
	%>No data found!<%= ics.GetErrno() %><%= err.toString() %><%
	ics.ClearErrno();
	//ics.FlushStream();

}
%>
</table>
</schema>
</cs:ftcs>
