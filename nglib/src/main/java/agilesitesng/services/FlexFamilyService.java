package agilesitesng.services;

import COM.FutureTense.Interfaces.ICS;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Created by jelerak on 08/09/15.
 */
public class FlexFamilyService implements Service {


    private String flexFamily(ICS ics) {
        try {
            FlexFamilyInit init = new FlexFamilyInit(ics,"fwadmin","xceladmin");
            return init.init(
                    ics.GetVar("flexAttribute"),
                    ics.GetVar("flexParentDef"),
                    ics.GetVar("flexContentDef"),
                    ics.GetVar("flexParent"),
                    ics.GetVar("flexContent"),
                    ics.GetVar("flexFilter")
            );
        } catch (Exception e) {
            return "error";
        }
    }

    @Override
    public String exec(HttpServletRequest req, ICS ics, HttpServletResponse res) {
        return flexFamily(ics);
    }
}
