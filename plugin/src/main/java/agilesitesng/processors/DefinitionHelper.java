package agilesitesng.processors;

/**
 * Created by jelerak on 07/12/2015.
 */
public class DefinitionHelper {

    protected String getUrl(String assetName) {
        return String.format("${%s._link_}", assetName);
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
