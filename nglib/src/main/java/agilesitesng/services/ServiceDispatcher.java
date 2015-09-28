package agilesitesng.services;

import COM.FutureTense.Interfaces.ICS;
import agilesites.api.UserTag;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class ServiceDispatcher {

    public ServiceDispatcher() {
    }

    Service getService(String name) throws Exception {
        if (name.equals("siteid"))
            return new SiteService();
        if (name.equals("site"))
            return new SiteService();
        if (name.equals("flexFamily"))
            return new FlexFamilyService();
        if (name.equals("startmenu"))
            return new StartMenuService();
        if (name.equals("login"))
            return new LoginService();
        if (name.equals("authkey"))
            return new LoginService();
        if (name.equals("scatter"))
            return new ScatterGatherService();
        if (name.equals("gather"))
            return new ScatterGatherService();
        if (name.equals("dump"))
            return new ScatterGatherService();
        if (name.equals("echo"))
            return new MiscService();
        if (name.equals("sql"))
            return new SqlService();
        if (name.equals("deploy"))
            return new DeployService();

        throw new Exception("unknown service " + name);
    }

    private String dumpCookie(Cookie[] cookies) {
        StringBuilder sb = new StringBuilder(" cookies=");
        for (Cookie c : cookies) {
            sb.append(c.getName()).append("=").append(c.getValue()).append(";");
        }
        return sb.toString();
    }

    private void login(ICS ics) {
        String username = ics.GetVar("username");
        String password = ics.GetVar("password");
        if (username != null && password != null) {
            UserTag.login().username(username).password(password).run(ics);
        }
    }

    public String exec(HttpServletRequest req, ICS ics, HttpServletResponse res) throws Exception {
        String op = ics.GetVar("op");
        login(ics);
        Service svc = getService(op);
        System.out.println("*** " + svc.getClass() + dumpCookie(req.getCookies()));
        return svc.exec(req, ics, res);

    }

}
