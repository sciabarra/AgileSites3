package agilesitesng.api;

import COM.FutureTense.Interfaces.ICS;
import com.fatwire.assetapi.data.AssetId;
import com.fatwire.assetapi.data.BaseController;
import com.fatwire.assetapi.data.BlobObject;
import com.fatwire.assetapi.data.search.SearchException;
import com.fatwire.services.beans.AssetIdImpl;
import org.apache.commons.beanutils.PropertyUtils;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * Created by jelerak on 15/10/2015.
 */
public class ContentFactory<T extends ASAsset> extends BaseController {


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

    public T load(AssetId assetId) {
        T t = null;
        try {
            Map assetMap = newAssetReader()
                    .forAsset(assetId)
                    .selectAll(true)
                    .selectImmediateOnlyParents(true)
                    .includeLinks(true)
                    .includeLinksForBlobs(true)
                    .read();
            String assetSubtype = (String) assetMap.get("subtype");
            String assetClass = getAssetClass((String) assetMap.get("name"), assetSubtype);
            t = (T) Class.forName(assetClass, true, this.getClass().getClassLoader()).newInstance();
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
            assetClass = (String)assetMap.get("path");
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
            }
            else {
                List<AssetAttribute> assetList = new ArrayList<AssetAttribute>();
                if (value instanceof List) {
                    List<AssetId> list = (List<AssetId>) value;
                    for (AssetId id : list) {
                       assetList.add(new AssetAttribute(id.getType(), id.getId()));
                    }
                    return assetList.toArray(new AssetAttribute[0]);
                }
            }
        } else if ("blob".equals(attributeType)) {
            if (!isMultiple) {
                if (value instanceof BlobObject) {
                    return new BlobAttribute((String) assetmap.get(attributeName + "_bloblink_"));
                }
            }
            else {
                List<BlobAttribute> assetList = new ArrayList<BlobAttribute>();
                if (value instanceof List) {
                    List list = (List) value;
                    for (int i = 0; i < list.size(); i++) {
                        assetList.add(new BlobAttribute((String) assetmap.get(attributeName + "_" + i + "_bloblink_")));
                    }
                    return assetList.toArray(new BlobAttribute[0]);
                }
            }
        }
        return value;

    }

}
