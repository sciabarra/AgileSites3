package boot.controller;

import agilesites.annotations.CSElement;
import agilesites.annotations.Controller;
import agilesites.api.Picker;
import com.fatwire.assetapi.data.BaseController;

import java.util.Map;

/**
 * Created by msciab on 03/12/15.
 */
@Controller
public class BootWrapper extends BaseController {

    @CSElement(from="boot/index.html", pick="#bs-example-navbar-collapse-1")
    public String bootWrapper(Picker p) {
        return p.html();
    }

    public void doWork(Map map) {
        map.put("a", "hello");
    }
}
