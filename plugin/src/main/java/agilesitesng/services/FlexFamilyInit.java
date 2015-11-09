package agilesitesng.services;

import COM.FutureTense.Interfaces.FTValList;
import COM.FutureTense.Interfaces.ICS;
import COM.FutureTense.Interfaces.Utilities;
import agilesites.api.Log;
import com.fatwire.assetapi.common.AssetAccessException;
import com.fatwire.assetapi.def.AssetTypeDef;
import com.fatwire.assetapi.def.AssetTypeDefManager;
import com.fatwire.assetapi.def.AssetTypeDefManagerImpl;
import com.fatwire.assetapi.def.FlexAssetFamilyInfo;
import com.fatwire.assetapi.site.SiteManager;
import com.fatwire.system.Session;
import com.fatwire.system.SessionFactory;
import com.openmarket.assetframework.assettypemanager.AssetTypeManager;
import com.openmarket.basic.interfaces.AssetException;
import com.openmarket.gator.fatypemanager.FlexAssetTypeManager;
import com.openmarket.gator.fatypemanager.FlexGroupTypeManager;
import com.openmarket.xcelerate.commands.AssetDispatcher;

import java.util.LinkedList;
import java.util.List;

/**
 * Created by jelerak on 08/09/15.
 */
public class FlexFamilyInit {

    final static Log log = Log.getLog(FlexFamilyInit.class);

    private ICS ics;
    private Session ses;

    public FlexFamilyInit(ICS ics, String username, String password) {
        this.ics = ics;
        ses = SessionFactory.newSession(username, password);
    }


    public String init(String attribute, String parentDef,String contentDef, String parent, String content, String filter) {

        StringBuilder sb = new StringBuilder();
        try {
            sb.append("Flex family (").append(attribute).append(" ")
                    .append(content).append(" ")
                    .append(parent).append(" ")
                    .append(contentDef).append(" ")
                    .append(parentDef).append(" ")
                    .append(filter).append(")");
            sb.append(createFlexFamily(attribute, parentDef, contentDef, parent, content, filter)).append("\n");
        } catch (Exception e) {
            e.printStackTrace();
            sb.append(" ERR ").append(e.getMessage()).append("\n");
        }

        return sb.toString();

    }

    public String createFlexFamily(String attribute, String parentDef,String contentDef, String parent, String content, String filter) throws AssetAccessException {

        FTValList values = new FTValList();
        values.setValString("request_internal", "true");
        values.setValString("Attr", attribute);
        values.setValString("DescAttr", attribute);
        values.setValString("PluralAttr",attribute);
        values.setValString("Filt", filter);
        values.setValString("DescFilt", filter);
        values.setValString("PluralFilt", filter);
        values.setValString("Prod", content);
        values.setValString("DescProd", content);
        values.setValString("PluralProd", content);
        values.setValString("Group", parent);
        values.setValString("DescGroup", parent);
        values.setValString("PluralGroup", parent);
        values.setValString("PT", contentDef);
        values.setValString("DescPT", contentDef);
        values.setValString("PluralPT", contentDef);
        values.setValString("PGT", parentDef);
        values.setValString("DescPGT", parentDef);
        values.setValString("PluralPGT", parentDef);

        String defdirBase = ics.GetProperty("xcelerate.defaultbase","futuretense_xcel.ini", true);
        values.setValString("defdirBase", defdirBase);

        ics.CallElement("OpenMarket/Gator/FlexibleAssets/AssetMaker/makeasset",values);
        return " Created" ;
    }
}

