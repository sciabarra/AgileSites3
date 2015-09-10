<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// Support/Audit/Default/storageCheck
//
// For pre 1.6 JDK's there was no way to get the available disk size.  Some code was taken from the following URL:
// http://forum.java.sun.com/thread.jspa?threadID=193735&messageID=634286
//
// Once Content Server is certified for JDK 1.6, this tool should be reimplemented to use the new File API, which has method calls to get free space.
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
<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>

<%!
/*
Determines what OS the app server is running on.  Currently, only Windows and Linux are supported for this tool.
*/
public static String getFreeSpace(String path) throws Exception {
    if (System.getProperty("os.name").startsWith("Windows")) {
        return getFreeSpaceOnWindows(path);
    }
    if (System.getProperty("os.name").startsWith("Linux")) {
        return getFreeSpaceOnLinux(path);
    }
    throw new UnsupportedOperationException("The method getFreeSpace(String path) has not been implemented for this operating system.");
}

/*
Gets the amount of free space on windows.  It creates a batch file which is runs the 'dir' process for a given directory.  The output then parsed.
*/
private static String getFreeSpaceOnWindows(String path) throws Exception {
    long bytesFree = -1;

    File script = new File(System.getProperty("java.io.tmpdir"),"script.bat");

    PrintWriter writer = new PrintWriter(new FileWriter(script, false));
    writer.println("dir \"" + path + "\"");
    writer.close();

    // get the output from running the .bat file
    Process p = Runtime.getRuntime().exec(script.getAbsolutePath());
    //p.waitFor();
    InputStream reader = new BufferedInputStream(p.getInputStream());
    StringBuffer buffer = new StringBuffer();
    for (; ; ) {
        int c = reader.read();
        if (c == -1){

            break;
        }
        buffer.append( (char) c);
    }
    String outputText = buffer.toString();
    reader.close();

    // parse the output text for the bytes free info
    StringTokenizer tokenizer = new StringTokenizer(outputText, "\n");
    while (tokenizer.hasMoreTokens()) {
        String line = tokenizer.nextToken().trim();
        // see if line contains the bytes free information
        if (line.endsWith("bytes free")) {
            tokenizer = new StringTokenizer(line, " ");
            tokenizer.nextToken();
            tokenizer.nextToken();
            bytesFree = Long.parseLong(tokenizer.nextToken().replaceAll(",", ""));
        }
    }
    delete();
    String value=Long.toString(bytesFree);
    return value;

}

/*
Gets the amount of free space on Linux.  It creates a batch file which is runs the 'df' process for a given directory.  The output then parsed.
*/
private static String getFreeSpaceOnLinux(String path) throws Exception {
    Process p = Runtime.getRuntime().exec("df -k " + path);
    p.waitFor();
    InputStream reader = new BufferedInputStream(p.getInputStream());
    StringBuffer buffer = new StringBuffer();

    for (; ; ) {
        int c = reader.read();
        if (c == -1){
            break;
        }
        buffer.append( (char) c);
    }
    String outputText = buffer.toString();
    reader.close();

System.out.println(outputText);
    //take off the top line as we do not need it
    String[] tokenizer = outputText.split("\n");
    String token=tokenizer[0];
    String line2 = tokenizer.length>1? tokenizer[tokenizer.length-1]:"";

    // parse the output text for the bytes free info
    String[] tokenizer2 = line2.split(" ");
    //The amount of free space is the 4th variable
    return tokenizer2.length > 3 ? tokenizer2[3]:"0";

}

//used for Windows.  This deletes the batch file from the io.tmpdir
private static boolean delete() {
    File script = new File(System.getProperty("java.io.tmpdir"),"script.bat");
    if (script.delete()==true)
        return true;
    else
        return false;
}
%>
<cs:ftcs>
    <%
    String inipath = Utilities.osSafeSpec(getServletConfig().getServletContext().getInitParameter("inipath"))+"/";   //ft.ini path
    String tmpdir=System.getProperty("java.io.tmpdir");
    String s1, s2, s3;

    String basefolder = ics.ResolveVariables("CS.CatalogDir.ElementCatalog");

    if (System.getProperty("os.name").startsWith("Windows") || System.getProperty("os.name").startsWith("Linux") ) {
        long toMegs=1048576;

        long num1=new File(tmpdir).getFreeSpace()/toMegs;  //space free for temp dir
        long num2=new File(inipath).getFreeSpace()/toMegs;  //space free for install dir
        long num3=new File(basefolder).getFreeSpace()/toMegs;  //space free for shared file sys dir

        s1="There is " + num1 + " MB free";
        s2="There is " + num2 + " MB free";
        s3="There is " + num3 + " MB free";
    } else {
        s1 = "getFreeSpace not implemented for this OS";
        s2 = "getFreeSpace not implemented for this OS";
        s3 = "getFreeSpace not implemented for this OS";
    }
    %>
    <table class="altClass">
        <tr>
            <th>Storage</th>
            <th>Directory</th>
            <th>Space</th>
        </tr>
        <tr>
            <td>WebCenter Sites Install Directory</td>
            <td><%= inipath %></td>
            <td><%= s1 %></td>
        </tr>
        <tr>
            <td>Java temp Directory</td>
            <td><%= tmpdir %></td>
            <td><%= s2 %></td>
        </tr>
        <tr>
            <td>Shared file system</td>
            <td><%= basefolder %></td>
            <td><%= s3 %></td>
        </tr>
    </table>
</cs:ftcs>
