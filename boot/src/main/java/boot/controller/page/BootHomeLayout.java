package boot.controller.page;

import agilesites.annotations.Controller;
import agilesites.annotations.Template;
import agilesites.api.Picker;
import agilesitesng.api.ASContentController;
import boot.model.page.BootHome;

/**
 * Created by msciab on 03/12/15.
 */
@Controller
public class BootHomeLayout extends ASContentController<BootHome> {

/*
    @Template(from="demo.html", layout=true, pick = "body")
    public String bootHomeLayout(Picker p, BootHomeHelper helper) {
        p.replace("#title", helper.editBootTitle());
        p.replace("#date", helper.editBootDate("dd/mm/yyyy"));
        return p.html();
    }
*/

}
