package ngdemo.element.page;

import agilesites.annotations.Controller;
import agilesites.annotations.Template;
import agilesites.api.HTML;
import ngdemo.model.page.NgPageHome;

import java.util.Map;

/**
 * Created by msciab on 12/09/15.
 */
@Controller
public class NgPageHomeLayout extends NgPageHome {

    @Template("demo/index.html")
    public static String ngPageHomeLayout(HTML doc) {
        //doc.$(".navbar").first();
        return doc.html();
    }

    public Map doWork() {
        Map map = map();
        return map;
    }
}
