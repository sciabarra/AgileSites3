package agilesites.annotations;

/**
 * Created by msciab on 11/08/15.
 */
public class AssetAttribute<T> {

    T attributeAssetType;

    public AssetAttribute(T attributeAssetType) {
        this.attributeAssetType = attributeAssetType;
    }

    public T get() {
        return attributeAssetType;
    }

}
