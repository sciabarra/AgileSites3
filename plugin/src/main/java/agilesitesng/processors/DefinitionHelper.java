package agilesitesng.processors;

import agilesites.api.Arg;

/**
 * Created by jelerak on 07/12/2015.
 */
public class DefinitionHelper {

    public String getArgument(String name) {
        return "<%=ics.GetVar(\""+name+"\")%>";
    }

    public String getArgumentOrElse(String name, String alt) {
        return "<%=ics.GetVar(\""+name+"\") != null?ics.GetVar(\""+name+"\"):\""+alt+"\"%>";
    }

    public String getUrl(String assetName) {
        return String.format("${%s.url}", assetName);
    }

    public String getBlobUrl(String assetName, String value) {
        return String.format("${%s.%s.url}", assetName, value);
    }

    public String editFragment(String fragmentName, Arg... arg) {
        return String.format("<fragment:include name=\"%s\"/>", fragmentName);
    }

    public String editFragmentIfPresent(String fragmentName, Arg... arg) {

        return String.format("<c:if test=\"${%s != null}\"><fragment:include name=\"%s\"/></c:if>", fragmentName, fragmentName);
    }

    public String editFragmentOrElse(String fragmentName, String alt, Arg... arg) {

        return String.format(
                "<c:choose>" +
                "    <c:when test=\"${%s != null}\">" +
                "        <fragment:include name=\"%s\"/>" +
                "    </c:when>" +
                "    <c:otherwise>" +
                "        %s" +
                "    </c:otherwise>" +
                "</c:choose>", fragmentName, fragmentName, alt);
    }

    public String editFragmentLoop(String fragmentName, Arg... arg) {
        return String.format("" +
                "<c:if test=\"${%s.size() gt 0}\">" +
                "   <c:forEach begin=\"0\" end=\"${%s.size()-1}\" var=\"fragmentIndex\">" +
                "       <fragment:include name=\"%s\" index=\"${fragmentIndex}\"/>\n" +
                "   </c:forEach>" +
                "</c:if>", fragmentName, fragmentName,fragmentName);
    }

    public String editFragmentLoop(String fragmentName, int startIndex,  Arg... arg) {
        return String.format("" +
                "<c:if test=\"${%s.size() gt 0}\">" +
                "   <c:forEach begin=\"%n\" end=\"${%s.size()-1}\" var=\"fragmentIndex\">" +
                "       <fragment:include name=\"%s\" index=\"${fragmentIndex}\"/>\n" +
                "   </c:forEach>" +
                "</c:if>", fragmentName, fragmentName,fragmentName);
    }

    public String editFragmentLoopOrElse(String fragmentName, String alt, Arg... arg) {
        return String.format("" +
                "<c:choose>" +
                "   <c:when test=\"${%s.size() gt 0}\">" +
                "       <c:forEach begin=\"0\" end=\"${%s.size()-1}\" var=\"fragmentIndex\">" +
                "           <fragment:include name=\"%s\" index=\"${fragmentIndex}\"/>\n" +
                "       </c:forEach>" +
                "   </c:when>" +
                "    <c:otherwise>" +
                "        %s" +
                "    </c:otherwise>" +
                "</c:choose>", fragmentName, fragmentName, fragmentName, alt);
    }
    protected String getAsset(String assetName, String value) {
        return String.format("${%s.%s}", assetName, value);
    }

    protected String getString(String assetName, String value) {
        return String.format("${%s.%s}", assetName, value);
    }

    protected String getDate(String assetName,String value, String format) {
        return  String.format("<fmt:formatDate pattern='%s' value='%s' />", format, getString(assetName, value));
    }

    protected String editString(String assetName, String value) {
        return editString(assetName,value,"");
    }

    protected String editString(String assetName, String value, String text) {
        return String.format("<insite:edit field=\"%s\" value=\"${%s.%s}\" params=\"{noValueIndicator: '[ %s ]'}\" />", value, assetName, value, text);
    }

    protected String editDate(String assetName, String value, String format) {
        return editDate(assetName,value,format, "");
    }

    protected String editDate(String assetName, String value, String format, String text) {
        String formatDate = String.format("<fmt:formatDate pattern=\"%s\" value=\"%s\"'  var=\"%s_formatted\"/>", format, getString(assetName, value), value);
        return formatDate + String.format(" <insite:edit field=\"%s\" value=\"${%s_formatted}\" params=\"{noValueIndicator: '[ %s ]'}\" />", value, value, text);
    }

}
