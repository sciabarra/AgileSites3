package agilesitesng.services;

import COM.FutureTense.Interfaces.FTValList;
import COM.FutureTense.Interfaces.ICS;
import COM.FutureTense.Interfaces.Utilities;
import agilesites.api.Log;
import com.fatwire.assetapi.common.AssetAccessException;
import com.fatwire.assetapi.def.AssetTypeDef;
import com.fatwire.assetapi.def.AssetTypeDefManager;
import com.fatwire.assetapi.def.AssetTypeDefManagerImpl;
import com.fatwire.system.Session;
import com.fatwire.system.SessionFactory;
import com.openmarket.assetframework.assettypemanager.AssetTypeManager;
import com.openmarket.basic.interfaces.AssetException;
import com.openmarket.gator.fatypemanager.FlexAssetTypeManager;
import com.openmarket.gator.fatypemanager.FlexGroupTypeManager;
import com.openmarket.xcelerate.commands.AssetDispatcher;

/**
 * Created by jelerak on 08/09/15.
 */
public class FlexFamilyInit {

    final static Log log = Log.getLog(FlexFamilyInit.class);

    private ICS ics;
    private Session ses;

    public FlexFamilyInit(ICS ics) {
        this.ics = ics;
        String username = ics.GetVar("username");
        String password = ics.GetVar("password");
        ses = SessionFactory.newSession(username, password);
    }


    public String init(String attribute, String parentDef, String contentDef, String parent, String content, String filter, String[] additionalTypes, String[] additionalParents) {

        StringBuilder sb = new StringBuilder();
        try {
            sb.append("Flex family (").append(attribute).append(" ")
                    .append(content).append(" ")
                    .append(parent).append(" ")
                    .append(contentDef).append(" ")
                    .append(parentDef).append(" ")
                    .append(filter).append(")");
            sb.append(createFlexFamily(attribute, parentDef, contentDef, parent, content, filter)).append("\n");
            for (String additionalParent : additionalParents) {
                sb.append(addFlexParent(additionalParent, additionalParent, additionalParent, parentDef, attribute, filter));
            }
            for (String additionalType : additionalTypes) {
                String[] assetType = Utils.splitOn(additionalType,"~");
                if (assetType.length >= 2) {
                    String name = assetType[0];
                    sb.append(addFlexType(name, name, name, contentDef, assetType[1], attribute, filter));
                }
            }
        } catch (Exception e) {
            log.error(e,"could not create flex family");
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

    private String addFlexType(String name, String description, String pluralForm, String contentDef, String parentDef, String attributeType, String filterType) {

        AssetTypeDef definition = null;
        try {
            AssetTypeDefManager atdm = new AssetTypeDefManagerImpl(ics);
            definition = atdm.findByName(name, null);
        } catch (AssetAccessException e) {
            //e.printStackTrace();
        }
        if (definition == null) {
            try {
                FTValList values = new FTValList();
                values.setValString("request_internal", "true");
                values.setValString("assetname", name);
                values.setValString("AssetDescription", description);
                values.setValString("AssetPlural",pluralForm);
                values.setValString("AssetChild", "T");
                values.setValString("assetlogic", "com.openmarket.assetframework.complexasset.ComplexAsset");
                ics.CallElement("OpenMarket/Gator/FlexibleAssets/AssetMaker/addAssetType", values);

                AssetTypeManager atm = new AssetTypeManager(ics);
                atm.setAsset(name, "com.openmarket.gator.flexassets.FlexAssetManager", "Catalog");

                values = new FTValList();
                values.setValString("request_internal", "true");
                values.setValString("elementtype", "FlexAssets");
                values.setValString("AssetType", name);
                ics.CallElement("OpenMarket/Gator/FlexibleAssets/AssetMaker/addElements", values);

                values = new FTValList();
                values.setValString("request_internal", "true");
                values.setValString("sqltype", "FlexAssets");
                values.setValString("AssetType", name);
                ics.CallElement("OpenMarket/Gator/FlexibleAssets/AssetMaker/addSQL", values);


                FlexAssetTypeManager fatm = new FlexAssetTypeManager(ics);
                fatm.add(name, parentDef, contentDef, attributeType, filterType);

                String defdirBase = ics.GetProperty("xcelerate.defaultbase","futuretense_xcel.ini", true);
                values = new FTValList();
                values.setValString("TYPE", name);
                values.setValString("ACL", "Browser,SiteGod,xceleditor,xceladmin");
                values.setValString("DIR", Utilities.fileName(defdirBase, name));
                AssetDispatcher.Install(ics, values);

            } catch (AssetException e) {
                e.printStackTrace();
                return (" Error: " + e.getMessage());
            }
            return " Created" ;
        } else {
            // TODO
            return " Updated";
        }
    }

    private String addFlexParent(String name, String description, String pluralForm, String parentDef, String attributeType, String filterType) {
        AssetTypeDef definition = null;
        AssetTypeDefManager atdm = new AssetTypeDefManagerImpl(ics);
        try {
            definition = atdm.findByName(name, null);
        } catch (AssetAccessException e) {
            //e.printStackTrace();
        }
        if (definition == null) {
            try {
                FTValList values = new FTValList();
                values.setValString("request_internal", "true");
                values.setValString("assetname", name);
                values.setValString("AssetDescription", description);
                values.setValString("AssetPlural",pluralForm);
                values.setValString("AssetChild", "T");
                values.setValString("assetlogic", "com.openmarket.assetframework.complexasset.ComplexAsset");
                ics.CallElement("OpenMarket/Gator/FlexibleAssets/AssetMaker/addAssetType", values);

                AssetTypeManager atm = new AssetTypeManager(ics);
                atm.setAsset(name, "com.openmarket.gator.flexgroups.FlexGroupManager", "Catalog");

                values = new FTValList();
                values.setValString("request_internal", "true");
                values.setValString("elementtype", "FlexGroups");
                values.setValString("AssetType", name);
                ics.CallElement("OpenMarket/Gator/FlexibleAssets/AssetMaker/addElements", values);

                values = new FTValList();
                values.setValString("request_internal", "true");
                values.setValString("sqltype", "FlexGroups");
                values.setValString("AssetType", name);
                ics.CallElement("OpenMarket/Gator/FlexibleAssets/AssetMaker/addSQL", values);

                FlexGroupTypeManager fgtm = new FlexGroupTypeManager(ics);
                fgtm.add(name, parentDef, attributeType, filterType);

                String defdirBase = ics.GetProperty("xcelerate.defaultbase","futuretense_xcel.ini", true);
                values = new FTValList();
                values.setValString("TYPE", name);
                values.setValString("ACL", "Browser,SiteGod,xceleditor,xceladmin");
                values.setValString("DIR", Utilities.fileName(defdirBase, name));
                AssetDispatcher.Install(ics, values);


            } catch (AssetException e) {
                e.printStackTrace();
                return (" Error: " + e.getMessage());
            }
            return " Created" ;
        } else {
            // TODO
            return " Updated";
        }
    }


}

