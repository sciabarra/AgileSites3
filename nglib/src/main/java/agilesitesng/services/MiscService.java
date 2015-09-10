package agilesitesng.services;

import COM.FutureTense.Interfaces.ICS;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Created by msciab on 30/08/15.
 */
public class MiscService implements Service {
    @Override
    public String exec(HttpServletRequest req, ICS ics, HttpServletResponse res) throws Exception {
        if(ics.GetVar("op").equals("echo")) {
            return ics.GetVar("value");
        } else {
            return "nothing to echo";
        }
    }
}
