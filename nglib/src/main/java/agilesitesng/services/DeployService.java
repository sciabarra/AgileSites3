package agilesitesng.services;

import COM.FutureTense.Interfaces.ICS;
import com.fatwire.assetapi.data.AssetDataManager;
import com.fatwire.system.Session;
import com.fatwire.system.SessionFactory;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class DeployService implements Service {

    @Override
    public String exec(HttpServletRequest req, ICS ics, HttpServletResponse res) throws Exception {

        String what = ics.GetVar("value");
        if (what == null)
            return "Deploy: what?";

        Asset a = null;
        if (what.equals("Controller")) {
            // return Utils.dumpVars(ics);
            a = new Controller(ics);
        } else if (what.equals("CSElement")) {
            return Utils.dumpVars(ics);
            //a = new CSElement(ics);
        } else if (what.equals("Template")) {
            return Utils.dumpVars(ics);
            //a = new Template(ics);
        } else if (what.equals("SiteEntry")) {
            return Utils.dumpVars(ics);
            //a = new SiteEntry(ics);
        } else if (what.equals("AttributeEditor")) {
            a = new AttributeEditor(ics);
        } else if (what.equals("Attribute")) {
            a = new Attribute(ics);
        }

        if (ics.GetVar("debug") != null)
            System.out.println("DEBUG: a=" + a.toString()
                    + "\nvars:" + Utils.dumpVars(ics));

        if (a == null)
            return "Deploy: what is " + what + " ?";
        else {
            System.out.println("deploying "+a.toString());
        }

        //return a.deploy(ics.GetVar("site"), )
        Session session = SessionFactory.newSession(ics.GetVar("username"), ics.GetVar("password"));
        AssetDataManager adm = (AssetDataManager) session.getManager(AssetDataManager.class
                .getName());
        try {
            return a.deploy(ics.GetVar("site"), adm, ics);
        } catch(Exception ex) {
            return ex.getMessage();
        }
    }
}