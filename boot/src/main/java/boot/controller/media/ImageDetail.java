package boot.controller.media;

import agilesites.annotations.Controller;
import agilesites.annotations.Template;
import agilesites.api.Picker;
import agilesitesng.api.ASContentController;
import boot.model.media.Image;
import boot.model.media.ImageHelper;

import java.util.Map;

/**
 * Created by jelerak on 02/02/2016.
 */
@Controller
public class ImageDetail extends ASContentController<Image> {

    @Template(from = "boot/index.html", layout = true, forType = "BootImage", forSubtype = "Image", pick = "#image-detail")
    public String imageDetail(Picker p, ImageHelper helper) {
        p.attr("img", "src", helper.getDefaultImage());
        p.attr("img", "alt", helper.getAltTextImageString());
        return p.outerHtml();
    }

    public void doWork(Map models) {
        super.doWork(models);
    }

}