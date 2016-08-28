package agilesitesng.services;

import COM.FutureTense.Interfaces.ICS;
import agilesites.api.Api;
import agilesites.api.PublicationTag;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Created by msciab on 10/08/15.
 */
public class SiteService implements Service {


    private String site(ICS ics) {
        try {
            String user = ics.GetVar("username");
            String pass = ics.GetVar("password");
            SiteInit init = new SiteInit(ics,user,pass);
            return init.init(ics.GetVar("name"), Long.parseLong(ics.GetVar("id")), Utils.splitOnPipe(ics.GetVar("enabledTypes")));
        } catch (Exception e) {
            return "error "+e.getMessage();
        }
    }

    private String delete(ICS ics) {
        try {
            String user = ics.GetVar("username");
            String pass = ics.GetVar("password");
            SiteInit init = new SiteInit(ics,user,pass);
            return init.delete(ics.GetVar("value"));
        } catch (Exception e) {
            return "error "+e.getMessage();
        }
    }

    @Override
    public String exec(HttpServletRequest req, ICS ics, HttpServletResponse res) {
        String op = ics.GetVar("op");
        if (op.equals("siteid"))
            return Utils.siteid(ics, ics.GetVar("value"));
        if (op.equals("site"))
            return site(ics);
        if (op.equals("sitedelete")) {
            return delete(ics);
        }
        return "???";
    }
}
