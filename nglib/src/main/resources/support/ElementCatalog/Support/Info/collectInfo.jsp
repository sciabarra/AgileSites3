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
  String sFormat = ics.GetProperty(ftMessage.propDBConnPicture);
  if (!Utilities.goodString(sFormat))
  {
   sFormat = "jdbc/$dsn";
  }
  String connectString = Utilities.replaceAll(sFormat, ftMessage.connpicturesub, ics.GetProperty("cs.dsn"));
  ServletContext context = getServletConfig().getServletContext() ; //getServletConfig().


 try
 {
  out.print("<h2><center>Product Versions</center></h2>");
  new VersionView(out).printVersions();
  out.print("<br/><h2><center>Environment and settings</center></h2>");
  View view = new View(out);
  view.printTableOpen();

  view.printDBInfo(connectString);
  view.printVMInfo();
  view.printSystemProperties();
  view.printInitParameters(context);
  view.printContextAttributes(context);
  view.printSessionInfo(request, session);
  view.printRequestDetails(config,request, response);
  view.printRequestAttributes(request);

  //view.printRequestParameters(request);

  view.printRequestCookies( request);
  view.printRequestHeaders(request);
  //view.printCurrentThreadGroup();
  //view.printAllThreads();
  view.printClassFolder();
  view.printAddresses();
  view.printLicense();
  view.printServletRequestPropertyFile();
  view.printAllIniPropFiles(Utilities.osSafeSpec(context.getInitParameter("inipath")));
  view.printAllIniPropFiles(Utilities.osSafeSpec(context.getRealPath("/WEB-INF/classes")));
  view.printXmlFiles(Utilities.osSafeSpec(context.getRealPath("/WEB-INF/classes")));    
  view.printWebXml(context);
  view.printWebInfLib(context);
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
static class IniFileFilter implements java.io.FileFilter {
    public boolean accept(File f) {
        if(f != null) {
            if(f.isDirectory()) {
                return false;
            }
            String extension = getExtension(f);
            if(extension != null && ("ini".equals(extension) || "properties".equals(extension))) {
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
    void printInitParameters(ServletContext context ) throws IOException
    {
        printTableSectionTitle("Context init parameters");
        java.util.Enumeration enum1 = context.getInitParameterNames();
        while (enum1.hasMoreElements()) {
            String key = (String)enum1.nextElement();
            String value = (String) context.getInitParameter(key);
            printTableRow( key, value);
        }
    }
    void printContextAttributes(ServletContext context ) throws IOException
    {
        printTableSectionTitle("Context attributes");
        java.util.Enumeration enum2 = context.getAttributeNames();
        try {
            while (enum2.hasMoreElements())
            {
                String key = (String) enum2.nextElement();
                Object value = (Object) context.getAttribute(key);
                printTableRow( key, value.toString());
            }
        } catch (Exception e) {
            //do something...
        }
    }
    void printRequestAttributes(ServletRequest request) throws IOException
    {
        printTableSectionTitle("Request attributes");
        java.util.Enumeration e = request.getAttributeNames();
        while (e.hasMoreElements()) {
            String key = (String)e.nextElement();
            Object value =  request.getAttribute(key);
            if (value==null) {
                value="NULL";
            }
            printTableRow( key, value.toString());
        }
    }

    void printSystemProperties() throws IOException
    {
    String[] importantPropNames={"java.runtime.name",
    "java.runtime.version",
    "java.specification.name",
    "java.specification.vendor",
    "java.specification.version",
    "java.vendor",
    "java.vendor.url",
    "java.vendor.url.bug",
    "java.version",
    "java.vm.info",
    "java.vm.name",
    "java.vm.specification.name",
    "java.vm.specification.vendor",
    "java.vm.specification.version",
    "java.vm.vendor",
    "java.vm.version",
    "os.arch",
    "os.name",
    "os.version",
    "file.encoding",
    "java.class.path",
    "java.class.version",
    "java.endorsed.dirs",
    "java.ext.dirs",
    "java.home",
    "java.io.tmpdir",
    "java.library.path",
    "java.naming.factory.initial",
    "java.naming.factory.url.pkgs",
    "java.util.logging.manager",
    "javax.management.builder.initial",
    "org.xml.sax.driver",
    "sun.arch.data.model",
    "sun.boot.class.path",
    "sun.boot.library.path",
    "sun.cpu.endian",
    "sun.cpu.isalist",
    "sun.desktop",
    "sun.io.unicode.encoding",
    "sun.java.launcher",
    "sun.jnu.encoding",
    "sun.management.compiler",
    "sun.os.patch.level",
    "user.country",
    "user.dir",
    "user.home",
    "user.language",
    "user.name",
    "user.timezone",
    "user.variant",
    "cs.LicenseFile",
    "cs.installDir"};


        printTableSectionTitle("<a name=\"SystemP\"></a>System Properties");
        Properties pSystem = System.getProperties();
        java.util.Set en_pNames = new java.util.TreeMap(pSystem).keySet();

        for (int i=0; i< importantPropNames.length;i++){
            String sPropertyValue = pSystem.getProperty(importantPropNames[i]) ;
            printTableRow( importantPropNames[i], sPropertyValue);
            en_pNames.remove(importantPropNames[i]);

        }

        for (java.util.Iterator itor = en_pNames.iterator();itor.hasNext();)
        {
            String sPropertyName = (String) itor.next();
            String sPropertyValue = pSystem.getProperty(sPropertyName) ;
            printTableRow( sPropertyName, sPropertyValue);
        }
    }
    void printRequestDetails( ServletConfig config, javax.servlet.http.HttpServletRequest request, javax.servlet.http.HttpServletResponse response) throws IOException
    {
        printTableSectionTitle("Servlet Information");
        //printTableRow( "Current URL",   HttpUtils.getRequestURL(request).toString());
        //printTableRow( "Query String",   request.getQueryString());

        printTableRow( "WebServer Name",   request.getServerName());
        printTableRow( "WebServer Port",   "" + request.getServerPort());
        printTableRow( "WebServer Info",   config.getServletContext().getServerInfo());
        printTableRow( "WebServer Remote Addr",  request.getRemoteAddr());
        printTableRow( "WebServer Remote Host",  request.getRemoteHost());
        printTableRow( "Default Response Buffer",  "" + response.getBufferSize());
        printTableRow( "Character Encoding",  request.getCharacterEncoding());
        printTableRow( "Request Locale",   request.getLocale().toString());

        printTableRow( "Servlet Name",   config.getServletName());
        printTableRow( "Protocol",    request.getProtocol().trim());
        printTableRow( "Scheme",    request.getScheme());
        printTableRow( "Content Length",   "" + request.getContentLength());
        printTableRow( "Content Type",   request.getContentType());
        printTableRow( "Request Is Secure",  "" + request.isSecure());
        printTableRow( "Auth Type",   request.getAuthType());
        printTableRow( "HTTP Method",   request.getMethod());
        printTableRow( "Remote User",   request.getRemoteUser());
        printTableRow( "Request URI",   request.getRequestURI());
        printTableRow( "Context Path",  request.getContextPath());
        printTableRow( "Servlet Path",   request.getServletPath());
        printTableRow( "Path Info",   request.getPathInfo());
        printTableRow( "Path Trans",   request.getPathTranslated());
    }
    void printRequestParameters( javax.servlet.http.HttpServletRequest request) throws IOException
    {
        printTableSectionTitle("Parameter names in this request");
        StringBuffer sbOut = new StringBuffer();
        java.util.Enumeration e2 = request.getParameterNames();
        while (e2.hasMoreElements())
        {
            String key = (String)e2.nextElement();
            String[] values = request.getParameterValues(key);
            for(int i = 0; i < values.length; i++)
            {
                sbOut.append(values[i] + " ");
            }
            printTableRow( key, sbOut.toString());
        }
    }
    void printRequestCookies( javax.servlet.http.HttpServletRequest request) throws IOException
    {
        printTableSectionTitle("Cookies in this request");
        Cookie[] cookies = request.getCookies();
        if(null!=cookies)
        {
            for (int i = 0; i < cookies.length; i++)
            {
              Cookie cookie = cookies[i];
              printTableRow( cookie.getName(), cookie.getValue());
            }
        }
    }
    void printSessionInfo( javax.servlet.http.HttpServletRequest request, javax.servlet.http.HttpSession session) throws IOException
    {
        SimpleDateFormat sdf = new SimpleDateFormat( "yyyy-MM-dd HH:mm:ss.sss zzz" );
        printTableSectionTitle("Session information in this request");
        printTableRow( "Requested Session Id",     "" + request.getRequestedSessionId());
        printTableRow( "Current Session Id",     "" + session.getId());
        printTableRow( "Session Created Time",     "" + sdf.format(new java.util.Date((session.getCreationTime()))));
        printTableRow( "Session Last Accessed Time",   "" + sdf.format(new java.util.Date((session.getLastAccessedTime()))));
        printTableRow( "Session Max Inactive Interval Seconds",  "" + session.getMaxInactiveInterval());
        /*
        printTableSectionTitle("Session scoped attributes");
        java.util.Enumeration names = session.getAttributeNames();
        while (names.hasMoreElements())
        {
            String name = (String) names.nextElement();
            printTableRow( name, session.getAttribute(name).toString());
        }
        */
    }
    void printRequestHeaders( javax.servlet.http.HttpServletRequest request) throws IOException
    {
        printTableSectionTitle("<a name=\"RequestH\"></a>Request headers");
        java.util.Enumeration e1 = request.getHeaderNames();
        while (e1.hasMoreElements())
        {
            String key = (String)e1.nextElement();
            String value = request.getHeader(key);
            printTableRow( key, value);
        }
    }
    void printDBMetaData(Connection connection) throws Exception
    {
         DatabaseMetaData dmd  =  connection.getMetaData();
         printTableRow( "JDBC Driver URL", dmd.getURL());
         printTableRow( "JDBC Driver Info", dmd.getDriverName() + " " + dmd.getDriverVersion());
         printTableRow( "Database Server Information", dmd.getDatabaseProductName() + " "+ dmd.getDatabaseProductVersion());
         //printTableRow( "DriverMajorVersion", Integer.toString(dmd.getDriverMajorVersion()));
         //printTableRow( "DriverMinorVersion", Integer.toString(dmd.getDriverMinorVersion()));
         //printTableRow( "DriverName", dmd.getDriverName());
         //printTableRow( "DriverVersion", dmd.getDriverVersion() );


         //printTableRow( "Database Product Name", dmd.getDatabaseProductName());
         //printTableRow( "Database Product Version", dmd.getDatabaseProductVersion());
         //printTableRow( "DatabaseMajorVersion", Integer.toString(dmd.getDatabaseMajorVersion()));
         //printTableRow( "DatabaseMinorVersion", Integer.toString(dmd.getDatabaseMinorVersion()));
         int transactionLevel=dmd.getDefaultTransactionIsolation();
         String level="Unknown";
         if (transactionLevel == Connection.TRANSACTION_NONE){
            level="TRANSACTION_NONE";
         }else if (transactionLevel == Connection.TRANSACTION_READ_COMMITTED){
            level="TRANSACTION_READ_COMMITTED";
         }else if (transactionLevel == Connection.TRANSACTION_READ_UNCOMMITTED){
            level="TRANSACTION_READ_UNCOMMITTED";
         }else if (transactionLevel == Connection.TRANSACTION_REPEATABLE_READ){
            level="TRANSACTION_REPEATABLE_READ";
         }else if (transactionLevel == Connection.TRANSACTION_SERIALIZABLE){
            level="TRANSACTION_SERIALIZABLE";
         }
         printTableRow( "Default Transaction Isolation", level);
         printTableRow( "JDBC Version", Integer.toString(dmd.getJDBCMajorVersion()) + "." + Integer.toString(dmd.getJDBCMinorVersion()));

    }
    void printVMInfo() throws IOException
    {
        printTableSectionTitle("Java VM Information");
        Runtime rt = Runtime.getRuntime();
        NumberFormat formatter = NumberFormat.getNumberInstance(Locale.US);
        printTableRow( "Max Memory", formatter.format( rt.maxMemory()) + " bytes");
        printTableRow( "Total Memory", formatter.format(rt.totalMemory()) + " bytes");
        printTableRow( "Free Memory", formatter.format( rt.freeMemory()) + " bytes");
        printTableRow( "Number of Processors", Integer.toString(rt.availableProcessors()));
        for (java.lang.management.MemoryPoolMXBean mx : java.lang.management.ManagementFactory.getMemoryPoolMXBeans()) {
        	printTableRow(mx.getName(), formatter.format(mx.getUsage().getMax()) + " bytes");
        }
    }
    
    void printCurrentDate() throws IOException
    {
        SimpleDateFormat sdf = new SimpleDateFormat( "yyyy-MM-dd HH:mm:ss.sss zzz" );
        printTableSectionTitle("Current Date");
        printTableRow( "Date", sdf.format(new java.util.Date()));
    }

    void printAddresses() throws IOException
    {
        printTableSectionTitle("AppServer DNS Names and IP Addresses");

        InetAddress local = InetAddress.getLocalHost();
        InetAddress [] localList = local.getAllByName(local.getHostName());

        for (int i=0; i<localList.length; i++)
        {
            String sHostName = ((InetAddress) localList[i]).getHostName();
            String sHostIP = ((InetAddress) localList[i]).toString();
            printTableRow( sHostName , sHostIP);
        }
    }
    void printClassFolder() throws IOException
    {
        printTableSectionTitle("ContentServer deployment folder");
        Class csClass = COM.FutureTense.Servlet.SContentServer.class;
        printTableRow( "SContentServer loaded from" ,  csClass.getResource("SContentServer.class").toString());
    }
    void printCurrentThreadGroup() throws IOException
    {
        printTableSectionTitle("<a name=\"Threads\"></a>Threads in the current thread group");

        Thread current  = Thread.currentThread();
        printTableRow( "Current Thread" , current.toString());
        ThreadGroup tgCurrent  = current.getThreadGroup();
        // double the current active count to be very safe
        int sizeEstimate = tgCurrent.activeCount() * 2;
        Thread[] threadList = new Thread[sizeEstimate];
        int size = tgCurrent.enumerate(threadList);
        for ( int i = 0; i < size; i++ )
        {
         printTableRow( "Thread" + i , threadList[i].toString());
        }
    }
    void printAllThreads() throws IOException
    {
        printTableSectionTitle("All the threads in the java VM");
        ThreadGroup group =     Thread.currentThread().getThreadGroup();
        ThreadGroup rootGroup = null;

        // traverse the tree to the root group
        while ( group != null )
        {
            rootGroup = group;
            group = group.getParent();
        }

        // double the current active count to be very safe
        int sizeEstimate = rootGroup.activeCount() * 2;
        Thread[] threadList1 = new Thread[sizeEstimate];

        int size = rootGroup.enumerate(threadList1);

        for ( int i = 0; i < size; i++ )
        {
            printTableRow( "Thread" + i , threadList1[i].toString());
        }
    }

    void printDBInfo(String connectString) throws Exception
    {
        printTableSectionTitle("Database Information");
        Connection connection = null;
        InitialContext ic = new InitialContext();

        try
        {
            DataSource ds   =  (DataSource) ic.lookup(connectString);
            printTableRow( "JNDI DataSource connection string", connectString);
            connection   =  ds.getConnection();
            printDBMetaData(connection);

        }
        catch (Exception ex)
        {
            printTableRow( "Failed to connect with cs.dsn", ex.toString());
        }finally {
            if (connection !=null){
                 connection.close();
            }
        }

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

    void printLicense() throws IOException {
        printTableSectionTitle("License");
        String licFile = System.getProperty("cs.LicenseFile");
        if (Utilities.goodString(licFile)){

            String license =Utilities.readFile(licFile);
            printTableRowSpan2("license", encodeString(license));

        }
    }

    void printServletRequestPropertyFile() throws IOException{
        Properties srProps = getResourceAsProperties("ServletRequest.properties");
        if (srProps ==null) return;

        printTableSectionTitle("<a name=\"ServletRequestProps\"></a>ServletRequest.properties");
        java.util.Set en_pNames = new java.util.TreeMap(srProps).keySet();


        for (java.util.Iterator itor = en_pNames.iterator();itor.hasNext();)
        {
            String sPropertyName = (String) itor.next();
            String sPropertyValue = srProps.getProperty(sPropertyName) ;
            printTableRow( sPropertyName, sPropertyValue);
        }

    }


    void printWebXml(javax.servlet.ServletContext context) throws IOException{
       String webXmlPath = context.getRealPath("/WEB-INF/web.xml");
       printFile(new File(webXmlPath));
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
    
    
    void printXmlFiles(String path) throws IOException{
    	File[] xmlfiles = new File(path).listFiles(new xmlFileFilter());
        java.util.Arrays.sort(xmlfiles);
        for (int i=0;i<xmlfiles.length; i++){
            printFile(xmlfiles[i]);
        }
    }
    
    
    void printFile(File file) throws IOException{
        printTableSectionTitle(file.getName());
        String contents = Utilities.readFile(file.getPath());
        printTableRowSpan2( file.getName(), "<code>"+encodeString(contents) +"</code>");
     }
    
    
    void printWebInfLib(javax.servlet.ServletContext context) throws IOException{
       String path = context.getRealPath("/WEB-INF/lib/");

        printTableSectionTitle("WEB-INF/lib directory");
        NumberFormat formatter = NumberFormat.getNumberInstance(Locale.US);
        if (Utilities.goodString(path) && new File(path).isDirectory()){
            File[] files = new File(path).listFiles();
            final java.text.Collator usCollator = java.text.Collator.getInstance(Locale.US);
            java.util.Comparator<File> comp = new java.util.Comparator<File>(){
                 public int compare(File o1, File o2){
                     return usCollator.compare(o1.getName(),o2.getName());
                 }

                 public boolean equals(Object obj) {return obj==this;}


            };
            java.util.Arrays.sort(files, comp);
            for (File f:files){
                if (f.isFile()){
                    printTableRow( f.getName(), formatter.format(f.length()));
                }
            }
        }


    }

    void printAllIniPropFiles(String path) throws IOException {

        File[] files = new File(path).listFiles(new IniFileFilter());
        java.util.Arrays.sort(files);
        for (int i=0;i<files.length; i++){
            printPropertyFile(files[i]);
        }
    }

    void printPropertyFile(File f) throws IOException {
        Properties props = new Properties();
        props.load(new FileInputStream(f));
        Set keySet = new TreeSet(props.keySet());

        printTableSectionTitle("ini/prop file: "+ f.getName());

        for (java.util.Iterator itor = keySet.iterator();itor.hasNext();) {
            String sPropertyName = (String) itor.next();
            String sPropertyValue = props.getProperty(sPropertyName) ;
            printTableRow( sPropertyName, sPropertyValue);
        }

    }

}
/**
 * Method to load a java.util.Properties object as a resource
 * accessible to the current classloader for this thread.  The
 * property file is read with each invocation of this method.
 *
 * @param name fully qualified name of properties file located
 *             in the classpath (ex. futuretense.properties)
 * @return newly loaded Properties object or null on failure.
 */
private static Properties getResourceAsProperties(final String name)
{
    Properties result = null;
    /*
     * Get an input stream on a resource in the current classpath.
     * Check security first just in case.
     */
    InputStream is = (InputStream) AccessController.doPrivileged(new PrivilegedAction()
    {
        public Object run()
        {
            ClassLoader threadCL = Thread.currentThread().getContextClassLoader();
            return threadCL.getResourceAsStream(name);
        }
    });
    if (is != null)
    {
        try
        {
            result = new Properties();
            result.load(is);
        }
        catch (IOException e)
        {
            result = null;
        }
        try
        {
            is.close();
        }
        catch (IOException e)
        {
            //huh
        }
    }
    return result;
}
private static final List<ProductInfo> productInfo = new LinkedList<ProductInfo>();;
static class VersionView{

    private final static String PRODUCT_NOT_FOUND = "<span class=\"notfound\">JAR NOT INSTALLED/LOADED</span>";

    //*********************************************************************************
    //
    //  PRODUCT INFORMATION
    //
    //*********************************************************************************

    private JspWriter out;

    public VersionView(JspWriter out)  throws Exception{
        this.out=out;
        init();
    }

    void printVersions() throws IOException{
        out.print("<table class=\"altClass\">");

        out.print("<tr class=\"sectionTitle\">");

        out.print("<td>Product Name</td>");

        out.print("<td>Jar File</td>");

        out.print("<td>Class Name</td>");

        out.print("<td>Version</td>");

        out.print("</tr>");

        for (final ProductInfo product : productInfo) {

            out.print("<tr>");

            out.print("<td>");
            out.print(product.getProductName() == null ? "&nbsp;" : product
                    .getProductName());
            out.print("</td>");

            out.print("<td>");
            out.print(product.getProductJar());
            out.print("</td>");

            out.print("<td>");
            out.print(product.getProductVersionInfoClass());
            out.print("</td>");

            out.print("<td>");
            out
                    .print((product.getProductVersion() == null ? PRODUCT_NOT_FOUND
                            : product.getProductVersion()));
            out.print("</td>");

            out.println("</tr>");
        }

        out.print("</table>");
    }
    private void init() throws Exception {
        if (!productInfo.isEmpty()) return;

productInfo.add(new ProductInfo("ContentServer","cs.jar","COM.FutureTense.Util.FBuild"));
productInfo.add(new ProductInfo("cs-core.jar","com.fatwire.cs.core.util.FBuild"));


productInfo.add(new ProductInfo("Satellite","sseed.jar","com.fatwire.sseed.util.FBuild"));
productInfo.add(new ProductInfo("sserve.jar","com.fatwire.sserve.util.FBuild"));
productInfo.add(new ProductInfo("Tools","systemtoolsclient.jar","com.fatwire.sysinfo.util.FBuild"));

productInfo.add(new ProductInfo("directory.jar","com.fatwire.directory.util.FBuild"));
productInfo.add(new ProductInfo("ftcsntsecurity.jar","COM.fatwire.ftcsntsecurity.util.FBuild"));
productInfo.add(new ProductInfo("ics.jar","com.fatwire.ics.util.FBuild"));
productInfo.add(new ProductInfo("logging.jar","com.fatwire.logging.util.FBuild"));


productInfo.add(new ProductInfo("CS-Direct","alloyui.jar","com.fatwire.cs.ui.util.FBuild"));
productInfo.add(new ProductInfo("analyticscs.jar","com.fatwire.analytics.tools.util.FBuild"));
productInfo.add(new ProductInfo("assetapi.jar","com.fatwire.assetapi.util.FBuild"));
productInfo.add(new ProductInfo("assetapi-impl.jar","com.fatwire.assetapi.util.FBuild"));
productInfo.add(new ProductInfo("assetframework.jar","com.openmarket.assetframework.util.FBuild"));
productInfo.add(new ProductInfo("assetmaker.jar","com.openmarket.assetmaker.util.FBuild"));
productInfo.add(new ProductInfo("basic.jar","com.openmarket.basic.util.FBuild"));
productInfo.add(new ProductInfo("batch.jar","com.fatwire.batch.util.FBuild"));
productInfo.add(new ProductInfo("catalog.jar","com.openmarket.catalog.util.FBuild"));
productInfo.add(new ProductInfo("commercedata.jar","com.openmarket.commercedata.util.FBuild"));
productInfo.add(new ProductInfo("cscommerce.jar","com.openmarket.cscommerce.util.FBuild"));
productInfo.add(new ProductInfo("cs-portlet.jar","com.fatwire.cs.portlet.util.FBuild"));
productInfo.add(new ProductInfo("firstsite-filter.jar","com.fatwire.firstsite.filter.util.FBuild"));
productInfo.add(new ProductInfo("firstsite-uri.jar","com.fatwire.firstsite.uri.util.FBuild"));
productInfo.add(new ProductInfo("flame.jar","com.fatwire.flame.util.FBuild"));
productInfo.add(new ProductInfo("framework.jar","com.openmarket.framework.util.FBuild"));
productInfo.add(new ProductInfo("gator.jar","com.openmarket.gator.util.FBuild"));
productInfo.add(new ProductInfo("gatorbulk.jar","com.openmarket.gatorbulk.util.FBuild"));
productInfo.add(new ProductInfo("icutilities.jar","com.fatwire.icutilities.util.FBuild"));
productInfo.add(new ProductInfo("lucene-search.jar","com.fatwire.search.lucene.util.FBuild"));
productInfo.add(new ProductInfo("rules.jar","com.openmarket.rules.util.FBuild"));
productInfo.add(new ProductInfo("sampleasset.jar","com.openmarket.sampleasset.util.FBuild"));
productInfo.add(new ProductInfo("spark.jar","com.fatwire.spark.util.FBuild"));
productInfo.add(new ProductInfo("sparksample.jar","com.fatwire.sparksample.util.FBuild"));

productInfo.add(new ProductInfo("transformer.jar","com.fatwire.transformer.util.FBuild"));
productInfo.add(new ProductInfo("visitor.jar","com.openmarket.visitor.util.FBuild"));

productInfo.add(new ProductInfo("wl6special.jar","com.fatwire.wl6special.util.FBuild"));

productInfo.add(new ProductInfo("xcelerate.jar","com.openmarket.xcelerate.util.FBuild"));

productInfo.add(new ProductInfo("xmles.jar","com.fatwire.xmles.util.FBuild"));

    }
}


private static class ProductInfo {
    private String productName;

    private String productJar;

    private String productVersionInfoClass;

    private String productVersion;

    /**
     * @param productName
     * @param productJar
     * @param productVersionInfoClass
     */
    public ProductInfo(final String productName, final String productJar,
            final String productVersionInfoClass) {
        super();
        this.productName = productName;
        this.productJar = productJar;
        this.productVersionInfoClass = productVersionInfoClass;
        try {
            collectVersion();
        } catch(ClassNotFoundException e){
            //ignore
        } catch(NoClassDefFoundError e){
            //ignore
        } catch(Exception e){
            e.printStackTrace();
        }
    }

    /**
     * @param productJar
     * @param productVersionInfoClass
     */
    public ProductInfo(final String productJar,
            final String productVersionInfoClass) {
        this("", productJar, productVersionInfoClass);
    }

    private void collectVersion() throws Exception{

        String version = null;

        final Class<?> clazz = Class
                .forName(getProductVersionInfoClass());
        if (BuildBase.class.isAssignableFrom(clazz)) {
            final Object o = clazz.newInstance();
            if (o instanceof BuildBase) {
                final BuildBase bb = (BuildBase) o;
                String v = bb.version();
                String[] x= v.split("\n");
                if (x.length >1){
                    version = x[x.length-1];
                }else {
                    version=v;
                }


            }
        }else {
            version= clazz +" is not a buildbase";
        }
        productVersion = version;

    }

    /**
     * @return the productJar
     */
    public String getProductJar() {
        return productJar;
    }

    /**
     * @return the productName
     */
    public String getProductName() {
        return productName;
    }

    /**
     * @return the productVersion
     */
    public String getProductVersion() {
        return productVersion;
    }

    /**
     * @return the productVersionInfoClass
     */
    public String getProductVersionInfoClass() {
        return productVersionInfoClass;
    }

}
%>
