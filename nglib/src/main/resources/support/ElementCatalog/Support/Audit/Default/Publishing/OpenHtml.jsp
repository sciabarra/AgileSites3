<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld"
%><%
	//
	// Support/Audit/Default/openHTML
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
%><%@ page import="java.io.*"
%><cs:ftcs><%
	String spath = ics.GetVar("var");
		String workfolder = ics.GetProperty("request.folder",
				"batch.ini", true);
		String filepath = workfolder + spath + "Output.html";

		BufferedReader in = new BufferedReader(new FileReader(filepath));

		String line = null;
		try {
			while ((line = in.readLine()) != null) {
				out.println(line);
			}
		} catch (IOException e) {
			out.println("Error reading HTML file");
		}
		in.close();
%></cs:ftcs>