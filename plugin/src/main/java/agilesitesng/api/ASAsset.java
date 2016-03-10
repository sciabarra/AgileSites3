package agilesitesng.api;

import com.fasterxml.jackson.core.JsonFactory;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fatwire.assetapi.data.BaseController;
import java.io.IOException;
import java.util.Arrays;
import java.util.Date;
import java.util.List;
import java.util.Map;

/**
 * Created by jelerak on 20/10/2015.
 */
public class ASAsset extends BaseController {

    protected String assettype;
    protected String id;
    protected String site;
    protected String subtype;
    protected String name;
    protected String url;
    protected String description;
    protected String template;

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

    public String getAssettype() {
        return assettype;
    }

    public void setAssettype(String assettype) {
        this.assettype = assettype;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getSite() {
        return site;
    }

    public void setSite(String site) {
        this.site = site;
    }

    public String getSubtype() {
        return subtype;
    }

    public void setSubtype(String subtype) {
        this.subtype = subtype;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getTemplate() {
        return template;
    }

    public void setTemplate(String template) {
        this.template = template;
    }

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }
}
