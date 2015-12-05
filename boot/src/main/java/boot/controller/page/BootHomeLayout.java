package boot.controller.page;

import agilesites.annotations.Controller;
import agilesites.annotations.Template;
import agilesites.api.Picker;
import agilesitesng.api.ASContentController;
import boot.model.page.BootHome;

import java.util.Map;

/**
 * Created by msciab on 03/12/15.
 */
@Controller
public class BootHomeLayout extends ASContentController<BootHome> {

    @Template(from="demo.html", layout=true)
    String bootHomeLayout(Picker p) {
        p.replace("#title", "${home.bootTitle}");
        return p.html();
    }

    @Override
    protected void doWork(Map models) {
        BootHome home = load();
        models.put("home", home);
    }
}
