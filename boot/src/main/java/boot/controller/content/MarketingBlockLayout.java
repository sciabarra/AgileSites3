package boot.controller.content;

import agilesites.annotations.Controller;
import agilesites.annotations.Template;
import agilesites.api.Picker;
import agilesitesng.api.ASContentController;
import boot.model.block.CarouselItem;
import boot.model.block.CarouselItemHelper;
import boot.model.block.MarketingBlockHelper;

import java.util.Map;

/**
 * Created by jelerak on 02/02/2016.
 */
@Controller
public class MarketingBlockLayout extends ASContentController<CarouselItem> {

    @Template(from = "boot/index.html", layout = true, forType = "BootContent", forSubtype = "MarketingBlock", pick = "#marketing-block")
    public String marketingBlockLayout(Picker p, MarketingBlockHelper helper) {
        p.replace("#marketing-title", helper.editTitle());
        p.replace("#marketing-description", helper.editBlockDescription());
        //p.replace(".wcs-cta-text", helper.editCtaText());
        p.addClass(".fa-fw", helper.getIconClass());
        return p.outerHtml();
    }

    public void doWork(Map models) {
        super.doWork(models);
    }
}
