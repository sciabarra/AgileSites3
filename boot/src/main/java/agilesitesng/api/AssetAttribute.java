package agilesitesng.api;

import com.fatwire.assetapi.data.AssetId;
import com.fatwire.services.beans.AssetIdImpl;

public class AssetAttribute<T extends ASAsset> {

    T attributeAssetType;
    String name;
    String c;
    long cid;

    public AssetAttribute(T attributeAssetType) {
        this.attributeAssetType = attributeAssetType;
    }

    public AssetAttribute(String c, long cid) {
        this.c = c;
        this.cid = cid;
    }

    public AssetAttribute(String c, long cid, String name) {
        this.c = c;
        this.cid = cid;
        this.name = name;
    }

    public T getValue() {
        if (attributeAssetType == null) {
            ContentFactory<T> cf = new ContentFactory<T>();
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

}
