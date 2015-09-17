package agilesitesng.services;

import COM.FutureTense.Interfaces.ICS;
import com.fatwire.assetapi.data.AssetDataManager;
import com.fatwire.system.Session;
import com.fatwire.system.SessionFactory;
import com.openmarket.basic.interfaces.AssetException;
import com.openmarket.xcelerate.common.RoleList;
import com.openmarket.xcelerate.common.SiteList;
import com.openmarket.xcelerate.interfaces.*;
import com.openmarket.xcelerate.startmenu.InputArgList;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Created by jelerak on 08/09/15.
 */
public class StartMenuService implements Service {

    @Override
    public String exec(HttpServletRequest req, ICS ics, HttpServletResponse res) {
        StartMenu s = new StartMenu(ics);
        Session session = SessionFactory.newSession(ics.GetVar("username"), ics.GetVar("password"));
        AssetDataManager adm = (AssetDataManager) session.getManager(AssetDataManager.class
                .getName());
        try {
            return s.build(adm, ics);
        } catch(Exception ex) {
            return ex.getMessage();
        }
    }
}
