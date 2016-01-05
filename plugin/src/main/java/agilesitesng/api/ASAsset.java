package agilesitesng.api;

import agilesites.annotations.Controller;
import com.fasterxml.jackson.core.JsonFactory;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

import java.io.IOException;
import java.util.Map;

/**
 * Created by jelerak on 20/10/2015.
 */
public class ASAsset {

    public Map<String, String>[] getAttributes() {
        try {
            JsonFactory factory = new JsonFactory();
            ObjectMapper mapper = new ObjectMapper(factory);
            TypeReference<Map<String, String>[]> typeRef = new TypeReference<Map<String, String>[]>() {
            };
            return mapper.readValue(readAttributes(), typeRef);
        } catch (IOException e) {
            e.printStackTrace();
            return null;
        }
    }

    protected String readAttributes() {
        return null;
    }

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
