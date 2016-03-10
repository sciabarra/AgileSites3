package boot.controller.content;

import agilesites.annotations.Controller;
import agilesites.annotations.Template;
import agilesites.api.Picker;
import agilesitesng.api.ASContentController;
import boot.model.block.CarouselItem;
import boot.model.block.CarouselItemHelper;

import java.util.Map;

/**
 * Created by jelerak on 02/02/2016.
 */
@Controller
public class CarouselItemLayout extends ASContentController<CarouselItem> {

    @Template(from = "boot/index.html", layout = true, forType = "BootContent", forSubtype = "CarouselItem", pick = "#carousel-item", extraCriteria = "active")
    public String carouselItemLayout(Picker p, CarouselItemHelper helper) {
        p.replace("#carousel-item-caption", helper.editCaption());
        p.removeClass(".item", "active");
        p.addClass(".item", helper.getArgumentOrElse("active", ""));
        return p.outerHtml();
    }

    public void doWork(Map models) {
        super.doWork(models);
    }
}
