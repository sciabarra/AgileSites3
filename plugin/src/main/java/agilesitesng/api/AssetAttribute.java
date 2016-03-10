package agilesitesng.api;

import com.fatwire.assetapi.data.AssetId;
import com.openmarket.xcelerate.asset.AssetIdImpl;

//+public class AssetAttribute
public class AssetAttribute<T extends ASAsset> //-
{

//+ def attributeAssetType;
    T attributeAssetType;//-

    String name;
    String c;
    long cid;
    String url;

//+ public AssetAttribute(Object attributeAssetType)
    public AssetAttribute(T attributeAssetType)//-
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

    //+ def getValue()
    public T getValue() //-
    {
        if (attributeAssetType == null) {

//+         ContentFactory cf = new ContentFactory();
            ContentFactory<T> cf = new ContentFactory<T>();//-
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
