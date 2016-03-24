package agilesitesng.services;

import java.util.Map;

/**
 * Created by jelerak on 18/03/2016.
 */
public class JsonResponse {
    String exportPath;
    String exportFilename;
    Map<String, String> values;

    public JsonResponse(String path, String filename) {
        this.exportPath = path;
        this.exportFilename = filename;
    }

    public void setValues(Map<String, String> values) {
        this.values = values;
    }

    public String getPath() {
        return exportPath;
    }

    public String getFilename() {
        return exportFilename;
    }

    public Map<String, String> getValues() {
        return values;
    }
}
