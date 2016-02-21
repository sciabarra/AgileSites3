package agilesitesng.services;
/**
 * Do not remove 1-/1+ comments - they distinguish 11g from 12c code
 */
import COM.FutureTense.Common.ControllerProcessorImpl;//1-
import COM.FutureTense.Interfaces.ControllerProcessor;//1-
import COM.FutureTense.Interfaces.ICS;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Created by msciab on 18/01/16.
 */
public class CompilerService implements Service {
    @Override
    public String exec(HttpServletRequest req, ICS ics, HttpServletResponse res) throws Exception {
        ControllerProcessor cp = new ControllerProcessorImpl();//1-
        cp.compileAll(null);//1-
        return cp.getControllerStatuses().toString();//1-
//1+  return "no compiler support in 11g";
    }
}
