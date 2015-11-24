package agilesitesng.services;

import COM.FutureTense.Interfaces.ICS;
import agilesites.api.Log;
import agilesites.api.UserTag;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Created by msciab on 10/08/15.
 */
public class LoginService implements Service {

    Log log = Log.getLog(LoginService.class);

    @Override
    public String exec(HttpServletRequest req, ICS ics, HttpServletResponse res) throws Exception {
        String op = ics.GetVar("op");
        if (op == null)
            throw new Exception("no op");
        // login service
        if (op.equals("login")) {
            String username = ics.GetVar("username");
            String password = ics.GetVar("password");
            //if (username == null || password == null)
            //    throw new Exception("username or password required");

            if (username == null || password == null)
                throw new Exception("login: no username or password");

            ics.ClearErrno();
            UserTag.login().username(username).password(password).run(ics);
            return "" + ics.GetErrno()+"\n";
        }
        // authkey service
        if (op.equals("authkey")) {
            return ics.GetSSVar("_authkey_") + "\n";
        }
        throw new Exception("unknown op: " + op);
    }
}
