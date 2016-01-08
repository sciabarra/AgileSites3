package agilesitesng.services;

import COM.FutureTense.Interfaces.ICS;
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
        this.menuType = ics.GetVar("menuType");
        this.assetType = ics.GetVar("assetType");
        this.assetSubtype = Utils.nnOr(ics.GetVar("assetSubtype"),"");
        this.arguments = Utils.splitOnPipe(ics.GetVar("args"));
    }

    public StartMenu(String name, String site, String menuType, String assetType) {
        this.site = site;
        this.name = name;
        this.description = name;
        this.menuType = menuType;
        this.assetType = assetType;
        this.assetSubtype = "";
        this.arguments = new String[0];
    }

    public String build(ICS ics) {
        ISiteList siteList  =new SiteList();
        siteList.addSite(Long.valueOf(Utils.siteid(ics, site)));
        IRoleList roleList = new RoleList();
        roleList.addRole("");
        StringBuilder sb = new StringBuilder();
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
            startMenuItem.setAssetSubtype(assetSubtype);
            startMenuItem.setLegalSites(siteList);
            startMenuItem.setLegalRoles(roleList);
            IInputArgList inputArgList = new InputArgList();
            IArgumentList argumentList = startMenuItem.getArguments();
            if (argumentList.get("subtype") == null) {
                argumentList.set("subtype", assetSubtype);
                inputArgList.add("subtype",true);
            }
            else {
                inputArgList.add("subtype",false);
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
            inputArgList.add("Group_%", false);
            startMenuItem.setLegalArguments(inputArgList);
            menu.setMenuItem(startMenuItem);
            sb.append(" OK\n");
        } catch (AssetException e) {
            e.printStackTrace();
            sb.append(" ERR ").append(e.getMessage()).append("\n");
        }
        return sb.toString();
    }

}
