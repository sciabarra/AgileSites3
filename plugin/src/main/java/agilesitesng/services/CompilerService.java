package agilesitesng.services;

import COM.FutureTense.Common.ControllerProcessorImpl;
import COM.FutureTense.Interfaces.ControllerProcessor;
import COM.FutureTense.Interfaces.ICS;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Created by msciab on 18/01/16.
 */
public class CompilerService implements Service {
    @Override
    public String exec(HttpServletRequest req, ICS ics, HttpServletResponse res) throws Exception {
        ControllerProcessor cp = new ControllerProcessorImpl();
        cp.compileAll(null);
        return cp.getControllerStatuses().toString();
    }
}
