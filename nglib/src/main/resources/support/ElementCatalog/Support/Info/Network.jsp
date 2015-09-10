<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld"
%><%@ taglib prefix="user" uri="futuretense_cs/user.tld"
%><%@ page import="COM.FutureTense.Interfaces.FTValList"
%><%@ page import="COM.FutureTense.Interfaces.ICS"
%><%@ page import="COM.FutureTense.Interfaces.IList"
%><%@ page import="COM.FutureTense.Interfaces.Utilities"
%><%@ page import="COM.FutureTense.Util.ftErrors"
%><%@ page import="COM.FutureTense.Util.ftMessage"
%><%@ page import="javax.naming.*"
%><%@ page import="java.sql.*"
%><%@ page import="java.util.*"
%><%@ page import="java.text.*"
%><%@ page import="javax.sql.*"
%><%@ page import="java.net.*"
%><%@ page import="java.io.*"
%><%@ page import="java.security.*"
%><%@ page import="javax.servlet.*"
%><%@ page import="javax.servlet.http.*"
%><%@ page import="com.fatwire.cs.core.util.BuildBase"
%><cs:ftcs>
<%

  ServletContext context = getServletConfig().getServletContext() ; //getServletConfig().


 try
 {
  out.print("<br/><h2><center>Network</center></h2>");
  View view = new View(out);
  view.printTableOpen();
  view.printMulticastGroups();
  view.printNetworkInterfaces();
  view.printHostsFile();
  view.printTableClose();
 }
 catch (Exception ex)
 {
     out.println(ex.toString());
     ex.printStackTrace();
 }

%>
</cs:ftcs>
<%!

private static boolean isWindows() {
	String os = System.getProperty("os.name", "unknown");
	if (os.contains("Windows")) {
		return true;
	}
	return false;
}


static class View {

    final JspWriter out;
    boolean tBodyOpen=false;
    View(JspWriter out){
        this.out=out;
    }
    void printTableOpen() throws IOException
    {
     out.print("<table class=\"altClass\">");
    }
    void printTableClose() throws IOException
    {
    if (tBodyOpen){
     out.print("</tbody>");
    }

     out.print("</table>");
    }
    void printTableSectionTitle(String sValue) throws IOException
    {
    if (tBodyOpen){
     out.print("</tbody>");
    }
    tBodyOpen=true;
     out.print("<tbody>");
     out.print("<tr>");
     out.print ("<th colspan=\"2\">");
     out.print(sValue);
     out.print("</th>");
     out.print("</tr>");
    }

    void printTableRow(String sName, String sValue) throws IOException
    {
        out.print("<tr>");
        out.print("<td>");
        out.print(sName);
        out.print("</td>");
        out.print("<td>");
        out.print(sValue);
        out.print("</td>");
        out.print("</tr>");
    }
    void printTableRowSpan2(String sName, String sValue) throws IOException
    {
        out.print("<tr>");
        out.print("<td colspan=\"2\">");
        out.print(sValue);
        out.print("</td>");
        out.print("</tr>");
    }

    String addNewline(String abc) {
        if (abc!=null) {
            if(abc.indexOf(' ')!=-1)
                return abc;
            else {
                int len = abc.length();
                if (len < 75)
                    return abc;

                StringBuffer newstr = new StringBuffer(len+(len/75));
                for(int i=0, j=0; i < len; i++) {
                    newstr.append(abc.charAt(i));
                    j++;
                    if(j ==75) {
                        newstr.append('\n');
                        j=0;
                    }
                }
                return newstr.toString();
            }
        }
        return "null";
    }
    

    
    private static final String AMPPOUND = "&#";
    private static final String SEMI = ";";

    public static String encodeString(String input)
    {
        StringBuffer sb = new StringBuffer();
        int i = 0;
        while (i < input.length())
        {
            char x = input.charAt(i);
            // NOTE WELL: Unicode characters (above 80h) are OK!!!
            if (x != '<' && x != '>' && x != '&' && x != '"' && x != '\'' && x >= ' ')
                sb.append(x);
            else
            {
                sb.append(AMPPOUND);
                sb.append(Integer.toString((int) x));
                sb.append(SEMI);
            }
            i++;
        }
        return sb.toString();
    }


    
    
    class xmlFileFilter implements java.io.FileFilter {
        public boolean accept(File f) {
            if(f != null) {
                if(f.isDirectory()) {
                    return false;
                }
                String extension = getExtension(f);
                if(extension != null && ("xml".equals(extension))) {
                    return true;
                }
            }
            return false;
        }

        private String getExtension(File f) {
            if(f != null) {
                String filename = f.getName();
                int i = filename.lastIndexOf('.');
                if(i>0 && i<filename.length()-1) {
                    return filename.substring(i+1).toLowerCase();
                };
            }
            return null;
        }
    }
    
    
    void printFile(File file) throws IOException{
        printTableSectionTitle(file.getName());
        String contents = Utilities.readFile(file.getPath());
        printTableRowSpan2( file.getName(), "<code>"+encodeString(contents) +"</code>");
     }
    
    
    void printMulticastGroups() throws IOException {
		printTableSectionTitle("Multicast Groups");
		String cmdout = runCommand(isWindows() ? "netsh interface ip show joins" : "netstat -gn");
		printTableRowSpan2("Multicast Groups", "<code>"+encodeString(cmdout) +"</code>");
    }
    
    
    void printNetworkInterfaces() throws IOException {
		printTableSectionTitle("Network Interfaces");
		String cmdout = runCommand(isWindows() ? "ipconfig /all" : "ifconfig -a");
		printTableRowSpan2("Network Interfaces", "<code>"+encodeString(cmdout) +"</code>");
   }
    
    
    void printHostsFile() throws IOException {
    	printFile(new File(isWindows() ? System.getenv("SystemRoot") + "\\system32\\drivers\\etc\\hosts" : "/etc/hosts"));
      }
    
    
    String runCommand(String cmd) {
    	String cmdout = "";
        try {
                String line;
                java.lang.Process p = Runtime.getRuntime().exec(cmd);
                BufferedReader input = new BufferedReader(new InputStreamReader(p.getInputStream()));
                while ((line = input.readLine()) != null) {
                	cmdout = cmdout + " \n" + line;
                }
                input.close();
        } catch (Exception err) {
            cmdout = "Exception running '" + cmd + "' " + err.getMessage();
        }
        return cmdout;
    }

}
%>