<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// Support/Info/connectToLDAP
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
<%@ page import="javax.naming.Context" %>
<%@ page import="javax.naming.NamingException" %>
<%@ page import="javax.naming.NamingEnumeration" %>
<%@ page import="javax.naming.NameClassPair" %>
<%@ page import="javax.naming.directory.*" %>
<%@ page import="java.util.Hashtable" %>
<%@ page import="java.util.*" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="netscape.ldap.*" %>

<cs:ftcs>
       
<%! LDAPConnection ld = null; %>
<%! int searchScope = 1; %>
<%! String filter   = "Objectclass=*"; %>
<%! String entryDN        = ""; %>
<%! String sBaseURL = ""; %>
<%! String 	sHost 	= ""; %>
<%! int 	intPort 	= 389; %>
<%! String 	sDN	= ""; %>
<%! String 	sPass	= ""; %>
<%! String 	Sitesbase	= ""; %>
<%! String 	Peoplebase	= ""; %>
<%! String 	Groupsbase	= ""; %>
<%! String 	peopleparent	= ""; %>
<%! String[] ATTRS    = {"cn"};  %>

<%
sDN	= ics.GetProperty("jndi.login","dir.ini",true);
String peopleparent = ics.GetProperty("peopleparent","dir.ini",true);
String groupparent = ics.GetProperty("groupparent","dir.ini",true);
sPass = request.getParameter("jndi.password");
// This is a hack
try {
 	Peoplebase=peopleparent.substring(peopleparent.indexOf("dc"));
}
catch (StringIndexOutOfBoundsException ex){
	Peoplebase=peopleparent.substring(peopleparent.indexOf("DC"));
}

try {
 	Groupsbase=groupparent.substring(groupparent.indexOf("dc"));
}
catch (StringIndexOutOfBoundsException ex)
{
	Groupsbase=groupparent.substring(groupparent.indexOf("DC"));
}

try {
 	Sitesbase=groupparent.substring(groupparent.indexOf("dc"));
}
catch (StringIndexOutOfBoundsException ex)
{
	Sitesbase=groupparent.substring(groupparent.indexOf("DC"));
}
sBaseURL 	= ics.GetProperty("jndi.baseURL","dir.ini",true);
sHost 		= sBaseURL.substring(sBaseURL.lastIndexOf("/")+1,sBaseURL.lastIndexOf(":"));
intPort 	= Integer.parseInt(sBaseURL.substring(sBaseURL.lastIndexOf(":")+1));
searchScope 	= LDAPConnection.SCOPE_BASE;
if((null==sPass)||(sPass.equals("")))
{
	out.print("<b>Please add \"&jndi.password=your_password\" to this URL and try again where your_password is the password for --> " + sDN + "</b>");
}
else
{
	printTableOpen(out);
	ld=connect(3,sHost,intPort,sDN,sPass,out);
	if (null==ld)
	{
		printTableSectionTitle(out, "LDAP Connection failed - Please check to see if LDAP is configured correctly in the ini files");
	}
	else
	{
		printMetaData(ld,out);
		performSearch(out );
		performSearch(out,Peoplebase );
		disconnect(ld,out);
	}
	printTableClose(out);

}
%>

<%! 
public LDAPConnection connect(int intVersion, String sHost, int intPort, String sDN, String sPass, JspWriter out ) throws Exception
{
	LDAPConnection ld1 =null;
	printTableSectionTitle(out, "Connecting to LDAP");
	try
	{
		ld1 = new LDAPConnection();
		printTableRow(out, "Connecting with " , "LDAP v3 , Host=" +  sHost + " Port=" + intPort + " DN=" + sDN + " Pass" );	
		ld1.connect(intVersion, sHost , intPort, sDN, sPass);
		printTableRow(out, "Connection Successful", "");
	}
	catch(Exception e){
		System.out.println("Connection failed");
		//e.printStackTrace(new PrintWriter(out));
		return null;
	}
	return ld1;
}

public void performSearch(JspWriter out, String sBase) 
{
        try 
        {
            LDAPSearchResults res = ld.search(sBase, ld.SCOPE_SUB, filter, ATTRS, false);
   	    printTableSectionTitle(out, "Printing LDAP entries from the server for " + sBase );
            while (res.hasMoreElements()) 
            {
                try 
                {
                    LDAPEntry entry = res.next();
                    printEntry(entry, out);
                } 
                catch (Exception e) 
                {
                    System.out.println("Exception in LDAPEntry : " + e.toString());
                    continue;
                }
            }
        } 
        catch (Exception e) 
        {
            System.out.println("Exception in LDAPSearchResults : " +e.toString());
        }
}


public void performSearch(JspWriter out) throws Exception
{
        printTableSectionTitle(out, "Root DSE information");

	try 
	{
	   int root_scope = LDAPv2.SCOPE_BASE;
	   String filter = "(objectclass=*)";
	   String base = "";
	   LDAPSearchResults res = ld.search( base, root_scope, filter, null, false );
	   while ( res.hasMoreElements() ) 
	   {
	      LDAPEntry findEntry = (LDAPEntry)res.nextElement();
	      LDAPAttributeSet findAttrs = findEntry.getAttributeSet();
	      Enumeration enumAttrs = findAttrs.getAttributes();
	      while ( enumAttrs.hasMoreElements() ) 
	      {
		 LDAPAttribute anAttr = (LDAPAttribute)enumAttrs.nextElement();
		 String attrName = anAttr.getName();
		 Enumeration enumVals = anAttr.getStringValues();
		 if ( enumVals == null ) 
		 {
		    printTableRow(out,  attrName , "No values found.");
		    continue;
		 }
		 while ( enumVals.hasMoreElements() ) 
		 {
		    String aVal = ( String )enumVals.nextElement();
		    printTableRow(out,  attrName , aVal);
		 }
	      }
	   }
	}
	catch( LDAPException e ) {
	   System.out.println( "Error: " + e.toString() );
	}
}	

public void disconnect(LDAPConnection ld, JspWriter out)
{
        if ( (ld != null) && ld.isConnected() ) 
        {
            try 
            {
                ld.disconnect();
	         printTableSectionTitle(out, "Disconnecting... ");
            } 
            catch (Exception e) 
            {
                System.out.println("Exception in disconnect : " + e.toString());
            }
        }
}


public void printEntry(LDAPEntry entry, JspWriter out) throws Exception
{
	printTableRow(out,  "" ,"<br/>");
	printTableRow(out,  "DN" , entry.getDN());
        LDAPAttributeSet entryAttrs 	= entry.getAttributeSet();
        Enumeration attrEnum 		= entryAttrs.getAttributes();
        while ( (attrEnum != null) && (attrEnum.hasMoreElements()) )
        {
            LDAPAttribute attr = (LDAPAttribute) attrEnum.nextElement();
            if (attr == null) 
            {
		printTableRow(out,  attr.getName() , " attribute is null");
                continue;
            }

            Enumeration enumValues = attr.getStringValues();
            boolean hasValues = false;
            while ( (enumValues != null) && (enumValues.hasMoreElements()) ) 
            {
                String value = (String) enumValues.nextElement();
		printTableRow(out,  attr.getName() ,   value );
                hasValues = true;
            }
            if (!hasValues) 
            {
		printTableRow(out, attr.getName() , "has no values");
            }
        }
    }
    
public void printMetaData(LDAPConnection conn, JspWriter out) throws Exception
{
	printTableSectionTitle(out, "Connection Metadata");
	printTableRow(out,  "Host" ,conn.getHost());
	printTableRow(out,  "Port" ,conn.getPort() + "");
	printTableRow(out,  "DN" ,conn.getAuthenticationDN());
	//printTableRow(out,  "Auth Method" ,conn.getAuthenticationMethod());
	//printTableRow(out,  "Maximum connection wait time" ,conn.getConnectTimeout());


}

private static void printTableOpen(JspWriter out) throws Exception
{
	out.print("<table border=\"1\" cellpadding=\"1\" cellspacing=\"1\" style=\"border-collapse: collapse\" bordercolor=\"#111111\" width=\"500\">");
}   

private static void printTableClose(JspWriter out) throws Exception
{
	out.print("</table>");	
}   

private static void printTableSectionTitle(JspWriter out, String sValue) throws Exception
{
	out.print("<tr>");	
	out.print("<td width=\"500\" colspan=\"2\"><font color=\"#003399\" face=\"Verdana\"><b>");
	out.print(sValue);
	out.print("</b></font></td>");
	out.print("</tr>");
}   

private static void printTableRow(JspWriter out, String sName, String sValue) throws Exception
{
	out.print("<tr>");
		out.print("<td width=\"200\" bgcolor=\"#E9E9E9\" align=\"left\" class=\"key\">");
				out.print(sName);
		out.print("</td>");
		out.print("<td width=\"300\" bgcolor=\"#E9E9E9\" align=\"left\" class=\"value\">");
				out.print(sValue);
		out.print("</td>");
	out.print("</tr>");
}
%>    

</cs:ftcs>
