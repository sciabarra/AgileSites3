package agilesitesng.services;

import COM.FutureTense.Interfaces.ICS;
import agilesites.api.IcsTag;
import agilesites.api.Log;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Created by msciab on 30/08/15.
 */
public class MiscService implements Service {

    final static long loadTime = System.currentTimeMillis();

    final static Log log = Log.getLog(MiscService.class);

    public String hello(ICS ics) {
        String msg = "hello, "+loadTime;
        log.debug(msg);
        //System.out.println("hello");
        return msg;
    }

    public String echo(ICS ics) {
        return ics.GetVar("value");
    }

    // reversing
    public String reverse(ICS ics) {
        try {
            return new StringBuffer(ics.GetVar("value")).reverse().toString();
        } catch (Exception ex) {
            return "no args";
        }
    }


    @Override
    public String exec(HttpServletRequest req, ICS ics, HttpServletResponse res) throws Exception {
        if (ics.GetVar("op").equals("echo")) {
            return echo(ics);
        } else if (ics.GetVar("op").equals("reverse")) {
            return reverse(ics);
        } else if (ics.GetVar("op").equals("hello")) {
            return hello(ics);
        } else {
            return "nothing to echo";
        }
    }
}
