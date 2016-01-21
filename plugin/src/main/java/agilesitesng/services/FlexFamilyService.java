package agilesitesng.services;

import COM.FutureTense.Interfaces.FTValList;
import COM.FutureTense.Interfaces.ICS;
import COM.FutureTense.Interfaces.Utilities;
import agilesites.api.Log;
import com.fatwire.assetapi.common.AssetAccessException;
import com.fatwire.assetapi.def.AssetTypeDef;
import com.fatwire.assetapi.def.AssetTypeDefManager;
import com.fatwire.assetapi.def.AssetTypeDefManagerImpl;
import com.openmarket.assetframework.assettypemanager.AssetTypeManager;
import com.openmarket.basic.interfaces.AssetException;
import com.openmarket.gator.fatypemanager.FlexAssetTypeManager;
import com.openmarket.gator.fatypemanager.FlexGroupTypeManager;
import com.openmarket.xcelerate.commands.AssetDispatcher;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Created by jelerak on 08/09/15.
 */
public class FlexFamilyService implements Service {

    final static Log log = Log.getLog(FlexFamilyInit.class);

    private String flexFamily(ICS ics) {
        try {
            FlexFamilyInit init = new FlexFamilyInit(ics);
            return init.init(
                    ics.GetVar("flexAttribute"),
                    ics.GetVar("flexParentDef"),
                    ics.GetVar("flexContentDef"),
                    ics.GetVar("flexParent"),
                    ics.GetVar("flexContent"),
                    ics.GetVar("flexFilter"),
                    Utils.splitOnPipe(ics.GetVar("aditionalTypes")),
                    Utils.splitOnPipe(ics.GetVar("additionalParents"))
            );
        } catch (Exception e) {
            log.error(e, "could not initialize flex family");
            return e.getMessage();
        }
    }

    @Override
    public String exec(HttpServletRequest req, ICS ics, HttpServletResponse res) {
        return flexFamily(ics);
    }
}
