package agilesites.annotations;

//FIXME temporary solution to deploy lib classes as controllers

@Controller
public class AssetAttribute<T> {

    T attributeAssetType;

    public AssetAttribute(T attributeAssetType) {
        this.attributeAssetType = attributeAssetType;
    }

    public T get() {
        return attributeAssetType;
    }

}
