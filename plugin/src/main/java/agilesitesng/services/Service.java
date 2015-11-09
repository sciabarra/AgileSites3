package agilesitesng.services;

import COM.FutureTense.Interfaces.ICS;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Created by msciab on 10/08/15.
 */
public interface Service {
    public String exec(HttpServletRequest req, ICS ics, HttpServletResponse res) throws Exception;
}
