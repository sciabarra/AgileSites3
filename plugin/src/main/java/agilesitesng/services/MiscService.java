package agilesitesng.services;

import COM.FutureTense.Interfaces.ICS;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Created by msciab on 30/08/15.
 */
public class MiscService implements Service {

    public String hello(ICS ics) {
        return "hello #2";
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
