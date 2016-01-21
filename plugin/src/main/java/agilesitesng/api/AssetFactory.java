package agilesitesng.api;

/**
 * Created by jelerak on 19/01/2016.
 */
public abstract class AssetFactory<T> {

    protected abstract T getAssetClass(String name);

}
