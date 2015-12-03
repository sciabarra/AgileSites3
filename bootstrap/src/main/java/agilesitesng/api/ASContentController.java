package agilesitesng.api;

import COM.FutureTense.Interfaces.ICS;
import com.fatwire.assetapi.data.BaseController;

/**
 * Created by jelerak on 19/10/2015.
 */
public class ASContentController<T extends ASAsset> extends BaseController {

    protected T load() {
        ContentFactory<T> cf = new ContentFactory<T>(ics);
        return cf.load(getAssetId());
    }

}
