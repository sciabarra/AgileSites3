<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="object" uri="futuretense_cs/object.tld" %>
<%//
// Support/Verify/i18n/encoding
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
<%@ page import="java.lang.*" %>
<%@ page import="java.util.*" %>
<cs:ftcs>
<ics:callelement element="Support/general"/>
<div id="content">
<ics:callelement element="Support/Topnav"/>
<center><h3>Unicode Form Post</h3></center>
<%
IList meta = ics.CatalogDef("jsp01",null,new StringBuffer());
if (ics.GetErrno()==-104){
	%><h3>Creating table jsp01!</h3><br>
	<ics:clearerrno />
	<ics:catalogmanager> 
		<ics:argument name="ftcmd" value="createtable" /> 
		<ics:argument name="tablename" value="jsp01" /> 
		<ics:argument name="systable" value="obj"/> 
		<ics:argument name="uploadDir" value="" /> 
		<ics:argument name="aclList" value="SiteGod" /> 
		<ics:argument name="colname0" value="name" /> 
		<ics:argument name="colvalue0" value="VARCHAR(255)"/> 
	</ics:catalogmanager> 
	<ics:if condition='<%=ics.GetErrno() != 0%>'>
		<ics:then>
		Table creation failed with: <ics:geterrno /><br>
		</ics:then>
		<ics:else>
		Table creation succuessful<br>
		</ics:else>
	</ics:if>
<%
}
%>
<ics:clearerrno />
	<ics:if condition='<%=ics.GetVar("name") != null%>'>
		<ics:then>
		    <ics:getvar name="name"/><br>
			<object:create name='obj01' classname='com.openmarket.framework.objects.AbstractObject' arg1='jsp01'/>
			object:create errno: <ics:geterrno/><br />
			<object:set name='obj01' field='name' value='<%=ics.GetVar("name")%>'/>
			object:set errno: <ics:geterrno/><br />
			<object:save name='obj01'/>
			object:save errno: <ics:geterrno/><br />
			<object:scatter name='obj01' prefix='obj01'/>
			object:scatter errno: <ics:geterrno/><br />
			<object:load name='obj02' classname='com.openmarket.framework.objects.AbstractObject' arg1='jsp01' objectid='<%=ics.GetVar("obj01:id")%>'/>
			object:load errno: <ics:geterrno/><br />
			<object:scatter name='obj02' prefix='obj02'/>
			object:scatter errno: <ics:geterrno/><br />
			name: <ics:getvar name='obj02:name'/><br />
		</ics:then>
	</ics:if>
	username: <ics:getssvar name="username"/><br />
<%
	out.println("request.getCharacterEncoding(): " + request.getCharacterEncoding() + "<br />");
	out.println("request.getContentType(): " + request.getContentType() + "<br />");
	out.println("request.getLocale(): " + request.getLocale() + "<br />");
	out.println("file.encoding: " + System.getProperty("file.encoding") + "<br />");
	out.println("default locale:  "+Locale.getDefault()+" <br/>");
	out.println("xcel charset: " +ics.GetProperty("xcelerate.charset","futuretense_xcel.ini",true)+ "<br />");
	out.println("cs.contenttype: " +ics.GetProperty("cs.contenttype")+ "<br />");
	String		sResume = "res\u00FCm\u00E9";
	String		sGreek = "\u03A0\u039A\u03A6";
	String		sLatinA = "\u0100\u0110\u0120";
	String		sShiftJIS = "my\u5192\u967A";
	String 		sMixed = sResume+sLatinA;
	String		sArabic = "\u0632\u0637";
	//String		sArabic = "\u0641";

	String		bigMix = sResume + " lat1 "+ sGreek + " greek "+ sLatinA + " latA "+ sArabic +" arabic " + sShiftJIS + " jp";
	ics.SetVar("resume_string", sResume);           
	ics.SetVar("greek_string", sGreek);
	ics.SetVar("latina_string", sLatinA);
	ics.SetVar("shiftjis_string", sShiftJIS);
	if (ics.GetVar("name") == null)
		//ics.SetVar("name", sResume);
		ics.SetVar("name", bigMix);
%>

<br>
<ics:getvar name="name" /><br>

	<form action="ContentServer" method='get'>
		<input type='hidden' name='pagename' value='<%=ics.GetVar("pagename")%>'/> 
		<input type='hidden' name='cmd' value='<%=ics.GetVar("cmd")%>'/> 
		<input type='hidden' name='_charset_'/>
		<input type='text' name="name" value='<%=ics.GetVar("name")%>' size='48' />
		<input type='submit'/>
	</form>
	<hr />

	<satellite:form satellite="false" method='post' enctype='application/x-www-form-urlencoded'>
		<input type='hidden' name='pagename' value='<%=ics.GetVar("pagename")%>'/> 
		<input type='hidden' name='cmd' value='<%=ics.GetVar("cmd")%>'/> 
		<input type='hidden' name='_charset_'/>
		<input type='text' name="name" value='<%=ics.GetVar("name")%>' size='48' />
		<input type='submit'/>
	</satellite:form>
	<hr />

	<satellite:form satellite="false" method='post' enctype='multipart/form-data'>
		<input type='hidden' name='pagename' value='<%=ics.GetVar("pagename")%>'/> 
		<input type='hidden' name='cmd' value='<%=ics.GetVar("cmd")%>'/> 
		<input type='hidden' name='_charset_'/>
		<input type='text' name="name" value='<%=ics.GetVar("name")%>' size='48' />		
		<input type='submit'/>
	</satellite:form>
	<hr />
<ics:callelement element="Support/Footer"/>
</div>        
</cs:ftcs>
