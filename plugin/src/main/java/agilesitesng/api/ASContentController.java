package agilesitesng.api;

import agilesites.annotations.Controller;
import com.fatwire.assetapi.data.BaseController;

import java.util.Map;

/**
 * Created by jelerak on 19/10/2015.
 */
public class ASContentController<T extends ASAsset> extends BaseController {

    protected T load() {
        ContentFactory<T> cf = new ContentFactory<T>(ics);
        return cf.load(getAssetId());
    }

    @Override
    protected void doWork(Map models) {
        T asset = load();
        models.put(getAssetName(asset), asset);
    }

    protected String getAssetName(T assetType) {
        return assetType.getClass().getSimpleName();
    }
}
