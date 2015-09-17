package agilesitesng.services;

import COM.FutureTense.Interfaces.ICS;
import agilesites.api.DateformatTag;
import agilesites.api.IcsTag;
import com.fatwire.assetapi.common.AssetAccessException;
import com.fatwire.assetapi.common.AssetNotExistException;
import com.fatwire.assetapi.data.AssetData;
import com.fatwire.assetapi.data.AssetDataManager;
import com.fatwire.assetapi.data.AssetId;
import com.fatwire.assetapi.data.MutableAssetData;
import com.fatwire.services.beans.AssetIdImpl;
import com.openmarket.basic.interfaces.AssetException;
import com.openmarket.xcelerate.common.RoleList;
import com.openmarket.xcelerate.common.SiteList;
import com.openmarket.xcelerate.interfaces.*;
import com.openmarket.xcelerate.startmenu.InputArgList;

import java.util.*;

/**
 * Main asset abstraction. You get an asset from an Env then use this class to
 * generate code.
 *
 * @author msciab
 */
public class StartMenu {

    //private static Log log = Log.getLog(Asset.class);

    protected long id;
    protected String site;
    protected String name;
    protected String description;
    protected String menuType;
    protected String assetType;
    protected String assetSubtype;
    protected String[] arguments;

    /**
     * Create an asset with a given type, subtype and name.
     */
    public StartMenu(ICS ics) {
        this.id = Utils.parseLongOrZero(ics.GetVar("id"));
        this.site = ics.GetVar("site");
        this.name = ics.GetVar("name");
        this.description = Utils.nnOr(ics.GetVar("description"), this.name);
        this.menuType = Utils.nnOr(menuType, "");
        this.assetType = ics.GetVar("assetType");
        this.assetSubtype = ics.GetVar("assetSubtype");
        this.arguments = Utils.splitOnPipe("args");
    }


    public String build(AssetDataManager adm, ICS ics) {
        ISiteList siteList  =new SiteList();
        siteList.addSite(Long.parseLong(ics.GetSSVar("pubid")));
        IRoleList roleList = new RoleList();
        roleList.addRole("");
        StringBuilder sb = new StringBuilder();
        String prefix = site + "_";
        sb.append("START MENU " + description);
        try {

            IStartMenu menu = StartMenuFactory.make(ics);
            // finds an existing startMenuItem or returns a new one
            IStartMenuItem startMenuItem = menu.getMenuItemName(name,menuType);
            if (startMenuItem.getID() == null) {
                sb.append(" INSERT: ");
            }
            else {
                sb.append(" UPDATE: ");
            }
            startMenuItem.setName(name);
            startMenuItem.setDescription(description);
            startMenuItem.setItemType(menuType);
            startMenuItem.setAssetType(assetType);
            if (!assetSubtype.startsWith(prefix) && assetSubtype.length() > 0)
                assetSubtype = prefix + assetSubtype;

            startMenuItem.setAssetSubtype(assetSubtype);
            startMenuItem.setLegalSites(siteList);
            startMenuItem.setLegalRoles(roleList);

            IArgumentList argumentList = startMenuItem.getArguments();
            if (argumentList.get("subtype") == null) {
                argumentList.set("subtype", assetSubtype);
            }
            if (arguments != null) {
                for (String argument : arguments) {
                    String[] nameValue = argument.split(":");
                    IArgument arg = argumentList.get(nameValue[0]);
                    if (arg != null)
                        argumentList.delete(nameValue[0]);
                    argumentList.set(nameValue[0],nameValue[1]);
                }
            }
            IInputArgList inputArgList = new InputArgList();
            inputArgList.add("subtype",false);
            inputArgList.add("Group_%", false);
            startMenuItem.setLegalArguments(inputArgList);
            menu.setMenuItem(startMenuItem);
            sb.append(" OK\n");
        } catch (AssetException e) {
            e.printStackTrace();
            sb.append(" ERR " + e.getMessage() + "\n");
        }
        return sb.toString();
    }

}
