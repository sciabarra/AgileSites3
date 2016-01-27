package agilesitesng.api;

import com.fatwire.assetapi.data.BaseController;
import java.util.Map;

/**
 * Created by jelerak on 19/10/2015.
 */
public class ASContentController<T extends ASAsset> extends BaseController {

//+ def load() {
    protected T load() {//-
//+     ContentFactory cf = new ContentFactory(ics);
        ContentFactory<T> cf = new ContentFactory<T>(ics);//-
        return cf.load(getAssetId());
    }

    @Override
    protected void doWork(Map models) {
//+     def asset = load()
        T asset = load();//-
        System.out.println(String.format("putting asset: %s in page model with name: %s ", asset, getAssetName(asset)));
        models.put(getAssetName(asset), asset);
    }

//+ protected String getAssetName(Object assetType)
    protected String getAssetName(T assetType)//-
    {
        return assetType.getClass().getSimpleName();
    }
}
