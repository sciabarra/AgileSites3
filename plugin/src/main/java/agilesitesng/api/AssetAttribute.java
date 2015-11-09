package agilesitesng.api;

public class AssetAttribute<T extends ASAsset> {

    T attributeAssetType;
    String c;
    long cid;

    public AssetAttribute(T attributeAssetType) {
        this.attributeAssetType = attributeAssetType;
    }

    public AssetAttribute(String c, long cid) {
        this.c = c;
        this.cid = cid;
    }


    public T at() {
        return attributeAssetType;
    }

}
