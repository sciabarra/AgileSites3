<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="asset" uri="futuretense_cs/asset.tld"
%><%@ taglib prefix="time" uri="futuretense_cs/time.tld"
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld"
%><%@ taglib prefix="string" uri="futuretense_cs/string.tld"
%><%//
// Support/Assets/BulkSaveAssets
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
<cs:ftcs>
<h3>Saving assets</h3>
    <satellite:form satellite="false" enctype="multipart/form-data" method="POST">
        <h3>Asset Query</h3>
        <input type='hidden' name='pagename' value='<%=ics.GetVar("pagename")%>'/>
        Enter SQL: should return assettype and assetid as columnnames <input maxLength="204800" size="112" name="sql" value='<string:stream variable="sql"/>'/><br/>
        limit: <input maxLength="5" size="5" name="limit" value='<%= ics.GetVar("limit") !=null? ics.GetVar("limit"):"10"%>'/><br/>
        Operation:
    <select name="cmd">
        <option value="load" <%= "load".equals(ics.GetVar("cmd")) ? "selected=\"selected\"":""%>>Load Only</option>
        <option value="save" <%= "save".equals(ics.GetVar("cmd")) ? "selected=\"selected\"":""%>>Save</option>
        <option value="void" <%= "void".equals(ics.GetVar("cmd")) ? "selected=\"selected\"":""%>>Void</option>
    </select><br/>
    <input type="submit" value="Execute" name="button"><br/>
</satellite:form>
<ics:if condition='<%= ics.GetVar("sql") != null %>'>
<ics:then>
    Executing query: <string:stream variable="sql"/><br/>
    <ics:sql sql='<%= ics.GetVar("sql") %>' table="ApprovedAssets" listname="assets" limit='<%= ics.GetVar("limit") !=null? ics.GetVar("limit"):"1"%>'/>
    <%
    if (ics.GetErrno() ==0){
    try { %>
        <ics:listloop listname="assets">
            <%if (ics.ResolveVariables("assets.assettype") !=null && ics.ResolveVariables("assets.assetid") !=null){ %>
                <time:set name="loadTime"/>
                <ics:clearerrno/>
            <asset:load name="asset" type='<%= ics.ResolveVariables("assets.assettype") %>' objectid='<%= ics.ResolveVariables("assets.assetid") %>' editable="true" option="editable"/>
            <%
            if (ics.GetErrno() < 0) {
                throw new Exception("Error loading asset with id " + ics.ResolveVariables("assets.assetid") );
            }
            %>
            <time:get name="loadTime" output="loadElapsed"/>
            <ics:if condition='<%= "void".equals(ics.GetVar("cmd")) %>'>
            <ics:then>
                    <time:set name="saveTime"/>
                <asset:void name="asset" />
                <%
                    if (ics.GetErrno() < 0) {
                        throw new Exception("Error on Void " + ics.GetVar("assetid"));
                    }
                %>
                <time:get name="saveTime" output="saveElapsed"/>
            </ics:then>
            </ics:if>
            <ics:if condition='<%= "save".equals(ics.GetVar("cmd")) %>'>
            <ics:then>
                <time:set name="saveTime"/>
                <asset:save name="asset"/><%
                if (ics.GetErrno() < 0) {
                    throw new Exception("Error on Save " + ics.GetVar("assetid"));
                }
                %>
                <time:get name="saveTime" output="saveElapsed"/>
            </ics:then>
            </ics:if>

            <asset:get name="asset" field="id" output="mainAssetID"/>
            <asset:get name="asset" field="updateddate" output="mainAssetUpdateddate"/>
            asset of type <%= ics.ResolveVariables("assets.assettype") %> with id: <ics:getvar name="mainAssetID"/>, updated at <ics:getvar name="mainAssetUpdateddate"/>. Loading took <ics:getvar name="loadElapsed"/> ms
            <ics:if condition='<%= "void".equals(ics.GetVar("cmd")) %>'>
            <ics:then>
                and voiding took <ics:getvar name="saveElapsed"/> ms
            </ics:then>
            </ics:if>

            <ics:if condition='<%= "save".equals(ics.GetVar("cmd")) %>'>
            <ics:then>
                and saving took <ics:getvar name="saveElapsed"/> ms
            </ics:then>
            </ics:if>
            .<br/>
            <%
            if (ics.GetErrno() != 0) {
                throw new Exception("Error " + ics.GetErrno() + " on Get");
            }
        }
        %>
        </ics:listloop>
        <ics:clearerrno/>
        <%
        } //end try
        catch (Exception e) {
            out.println("<error>" + e.toString() + "</error>");
        }
        ics.GetList("assets").flush();
    } else { %>Error: <ics:geterrno/><br/><%
    }
    %>
</ics:then>
</ics:if>
</cs:ftcs>
