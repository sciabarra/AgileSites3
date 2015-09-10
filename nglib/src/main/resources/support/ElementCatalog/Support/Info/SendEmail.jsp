<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld"
%><%@ page import="COM.FutureTense.Interfaces.FTValList"
%><%@ page import="COM.FutureTense.Interfaces.ICS"
%><%@ page import="java.io.*"
%><cs:ftcs><%

String[] propNames = {"cs.emailhost", "cs.emailaccount", "cs.emailpassword", "cs.emailreturnto", "cs.emailauthenticator", "cs.emailcharset", "cs.emailcontenttype"};

for (String p : propNames) {

    %><ics:getproperty name='<%= p %>' file="futuretense.ini" output='<%= p %>'/><%
    %><%= p %>=<%= ics.GetVar(p) %><br/><%

}
%>
<br/>
mail.jar: <%

boolean jarexists = true;

try {

    Class.forName("javax.mail.Transport");
    out.print("exists");

}
catch (ClassNotFoundException e) {

    out.print("does not exist");
    jarexists = false;

}
%><br/>
activation.jar: <%
try {

    Class.forName("javax.activation.MimeType");
    out.print("exists");

}
catch (ClassNotFoundException e) {

    out.print("does not exist");
    jarexists = false;

}
%><br/>
<br/>

<satellite:form satellite="false" id="tableform" method="POST">
    <input type="hidden" name="pagename" value='<%= ics.GetVar("pagename") %>'/>
    <label for="emailaddress">To:<br/></label><input id="emailaddress" type="text" name="emailaddress" /><br/>
    <br/>
    <label for="emailsubject">Subject:<br/></label><input id="emailsubject" type="text" name="emailsubject" size="40" value="WebCenter Sites Support Tools - E-Mail Test" /><br/>
    <br/>
    <label for="emailbody">Body:<br/></label><textarea id="emailbody" name="emailbody" cols="30" rows="8">Do not reply. This is a test.</textarea><br/>
    <br/>
    <input type="submit" value="Send"/>
</satellite:form>

<%

if (ics.GetVar("emailaddress") != null) {

    boolean err = false;
    int namepwCheck = 0;

    for (String p : propNames) {


        if ((ics.GetVar(p) == null || ics.GetVar(p).trim().equals("")) && (p.equals("cs.emailhost") || p.equals("cs.emailreturnto"))) {

            %><%= p %> is empty!<br/><br/><%
            err = true;

        }

        if (p.equals("cs.emailaccount") || p.equals("cs.emailpassword")) {
            namepwCheck += (ics.GetVar(p) == null || ics.GetVar(p).trim().equals("")) ? 0 : 1;
        }
    }

    if (!jarexists) {

        out.print("missing jar file!<br/>");
        err = true;
    }

    if (namepwCheck == 1) {
        %>Missing cs.emailccount or cs.emailpassword. Either both needs to be set to a value, or both of them left blank.<br/><br/><%
        err = true;
    }

    if (!err) {

        ics.ClearErrno();

        FTValList args = new FTValList();
        String output = null;

        args.setValString("TO", ics.GetVar("emailaddress"));
        args.setValString("SUBJECT", ics.GetVar("emailsubject"));
        args.setValString("BODY", ics.GetVar("emailbody"));

        output = ics.runTag("MAIL.SEND", args);

        int errnum = ics.GetErrno();

        %>&lt;MAIL.SEND&gt; errno: <%= errnum %><br/><%

        if (errnum != 0) {
            %>Please log file for details on the error.<%
        }
    }
}

%></cs:ftcs>
