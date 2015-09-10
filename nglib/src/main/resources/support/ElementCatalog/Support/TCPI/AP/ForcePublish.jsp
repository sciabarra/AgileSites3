<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld"
%><%@ taglib prefix="deliverytype" uri="futuretense_cs/deliverytype.tld"
%><%@ taglib prefix="string" uri="futuretense_cs/string.tld"
%><%
//
// Support/TCPI/AP/ForcePublish
//
// INPUT
//
// OUTPUT
//
%><cs:ftcs><h3>Force Publish to a Destination</h3>

<ics:if condition='<%= ics.GetVar("forcepub")!=null && ics.GetVar("id") != null %>'>
<ics:then>

    <ics:selectto table="PubTarget" listname="pubTgts" what="id,name,type" where="id" />
    <% String sql = "UPDATE PublishedAssets SET assetdate = {ts '" + new java.sql.Timestamp(0).toString() + "'} WHERE EXISTS (SELECT 1 from PubkeyTable where id = PublishedAssets.pubkeyid and targetid = "+ics.GetVar("id")+")"; %>
    <ics:sql sql='<%= sql%>' listname="pktuplist" table="PubKeyTable,PublishedAssets"/>
    <% if (ics.GetErrno() == 0 || ics.GetErrno() == -502){
        %>Marked all previously published assets as publishable for destination <string:stream list="pubTgts" column="name"/><br/><%
    }else {
        %>Error updating PublishedAssets table. Errno: <ics:geterrno/> for destination <string:stream list="pubTgts" column="name"/><br/><%
    }
    %>
    <ics:flushcatalog catalog="PubKeyTable"/>
    <ics:flushcatalog catalog="PublishedAssets"/>
    <ics:flushcatalog catalog="ApprovedAssets"/>
</ics:then>
</ics:if>
<ics:clearerrno/>
<ics:selectto table="PubTarget" listname="pubTgts" what="id,name,type"/>
<ics:if condition='<%= ics.GetErrno()==0%>'>
<ics:then>
<satellite:form satellite="false" id="tableform" method="POST">
    <input type="hidden" name="pagename" value='<%=ics.GetVar("pagename") %>'/>
    <b>Select a Publish Destination:</b>
    <select name="id">
    <ics:listloop listname="pubTgts">
        <deliverytype:load name="dtype" objectid='<%= ics.ResolveVariables("pubTgts.type")%>'/>
        <deliverytype:get name="dtype" field="name" output="dname"/>
        <option value='<ics:resolvevariables name="pubTgts.id"/>'><ics:resolvevariables name="pubTgts.name"/> (<ics:getvar name="dname"/>)</option>
    </ics:listloop>
    </select>
    <input type="Submit" name="forcepub" value="RePublish"><br/>
    </satellite:form>
    </ics:then>
<ics:else>
    No Destinations Available
</ics:else>
</ics:if>
</cs:ftcs>