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
import com.fatwire.assetapi.data.AssetId;
import com.openmarket.xcelerate.asset.AssetIdImpl;
import COM.FutureTense.Interfaces.ICS;
import agilesites.annotations.Groovy;
import com.fatwire.assetapi.data.BlobObject;
import org.apache.commons.beanutils.PropertyUtils;
import java.util.ArrayList;


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


/**
 * Created by jelerak on 19/10/2015.
 */
public class ASContentController<T extends ASAsset> extends BaseController {

    ContentFactory<T> cf;
 def load() {



     ContentFactory cf = new ContentFactory(ics);







        return cf.load(getAssetId());
    }








    @Override
    protected void doWork(Map models) {
     def asset = load()



        System.out.println(String.format("putting asset: %s in page model with name: %s ", asset, getAssetName(asset)));
        models.put(getAssetName(asset), asset);
    }

 protected String getAssetName(Object assetType)



    {
        return assetType.getClass().getSimpleName();
    }
}


public class AssetAttribute



{

 def attributeAssetType;




    String name;
    String c;
    long cid;
    String url;

 public AssetAttribute(Object attributeAssetType)



    {
        this.attributeAssetType = attributeAssetType;
    }

    public AssetAttribute(String c, long cid) {
        this(c, cid, null);
    }

    public AssetAttribute(String c, long cid, String name) {
        this(c,cid, name, null);
    }

    public AssetAttribute(String c, long cid, String name,  String url) {
        this.name = name;
        this.c = c;
        this.cid = cid;
        this.url = url;
    }

 def getValue()



    {
        if (attributeAssetType == null) {

         ContentFactory cf = new ContentFactory();



            attributeAssetType = cf.load(new AssetIdImpl(c,cid));
        }
        return attributeAssetType;
    }

    public AssetId getAssetId() {
        return new AssetIdImpl(c,cid);
    }

    public String getName() {
        return name;
    }

    public String getUrl() {
        return url;
    }
}

public class BlobAttribute {

    public BlobAttribute(String url) {
        this.url = url;
    }

    public BlobAttribute(String url, String name) {
        this.url = url;
        this.name = name;
    }

    public String url;

    private String name;

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url=url;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }
}




/**
 * Created by jelerak on 15/10/2015.
 */

public class ContentFactory extends BaseController



{

    private static final ThreadLocal<ICS> context = new ThreadLocal<ICS>();

    public ContentFactory(ICS ics) {
        super();
        if (context.get() == null) {
            context.set(ics);
        }
        setICS(ics);
    }


    public ContentFactory() {
        super();
        setICS(context.get());
    }

 def load(AssetId assetId)



    {
     def t = null;



        try {
            Map assetMap = newAssetReader()
                    .forAsset(assetId)
                    .selectAll(true)
                    .selectImmediateOnlyParents(true)
                    .includeLinks(true)
                    .includeLinksForBlobs(true)
                    .includeFeatures(true)
                    .read();

            String assetSubtype = (String) assetMap.get("subtype");
            String assetClassName = getAssetClass((String) assetMap.get("name"), assetSubtype);

            Class clazz = this.getClass().getClassLoader().loadClass(assetClassName);

         t = clazz.newInstance();



            t.setId((String)assetMap.get("id"));
            t.setName((String)assetMap.get("name"));
            t.setDescription((String)assetMap.get("description"));
            t.setSubtype(assetSubtype);
            t.setTemplate((String)assetMap.get("template"));
            t.setUrl((String)assetMap.get("_link_"));

            for (Map<String, String> attribute : t.getAttributes()) {
                String attributeName = attribute.get("name");
                if (assetMap.get(attributeName) != null) {
                    Object o = convertAttribute(attribute, assetMap);
                    PropertyUtils.setSimpleProperty(t, attributeName, o);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return t;
    }

    private String getAssetClass(String assetName, String assetSubtype) throws Exception {
        List<Map<String, String>> results = newSearcher().from("WCS_Controller").selectAll().searchFor(assetSubtype);
        String assetClass = assetName;
        if (results.size() > 0) {
            AssetId assetId = new AssetIdImpl(results.get(0).get("AssetType"), new Long(results.get(0).get("id")));
            Map assetMap = newAssetReader()
                    .forAsset(assetId)
                    .selectAll(true)
                    .read();
            assetClass = (String) assetMap.get("path");
        }
        return assetClass;
    }

    private Object convertAttribute(Map<String, String> attribute, Map assetmap) {
        String attributeName = attribute.get("name");
        String attributeType = attribute.get("type");
        boolean isMultiple = "O".equals(attribute.get("mul"));
        Object value = assetmap.get(attributeName);
        if ("asset".equals(attributeType)) {
            if (!isMultiple) {
                if (value instanceof AssetId) {
                    AssetId id = (AssetId) value;
                    return new AssetAttribute(id.getType(), id.getId(), attributeName);
                }
            } else {
                List<AssetAttribute> assetList = new ArrayList<AssetAttribute>();
                if (value instanceof List) {
                    List<AssetId> list = (List<AssetId>) value;
                    for (AssetId id : list) {
                        assetList.add(new AssetAttribute(id.getType(), id.getId()));
                    }
                    return assetList.toArray(new AssetAttribute[assetList.size()]);
                }
            }
        } else if ("blob".equals(attributeType)) {
            if (!isMultiple) {
                if (value instanceof BlobObject) {
                    return new BlobAttribute((String) assetmap.get(attributeName + "_bloblink_"));
                }
            } else {
                List<BlobAttribute> assetList = new ArrayList<BlobAttribute>();
                if (value instanceof List) {
                    List list = (List) value;
                    for (int i = 0; i < list.size(); i++) {
                        assetList.add(new BlobAttribute((String) assetmap.get(attributeName + "_" + i + "_bloblink_")));
                    }
                    return assetList.toArray(new BlobAttribute[assetList.size()]);
                }
            }
        }
        return value;

    }

}
public class Version { public String toString() { return "Concat of package agilesitesng.api; 3.0.0-SNAPSHOT built on Wed Mar 09 10:30:12 GMT 2016"; } }
        