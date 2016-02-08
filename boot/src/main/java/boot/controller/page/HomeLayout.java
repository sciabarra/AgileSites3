package boot.controller.page;

import agilesites.annotations.Controller;
import agilesites.annotations.Groovy;
import agilesites.annotations.Template;
import agilesites.api.Picker;
import agilesitesng.api.ASContentController;
import boot.model.page.Home;
import boot.model.page.HomeHelper;
import com.fatwire.assetapi.fragment.EditableTemplateFragment;

import java.util.List;
import java.util.Map;

/**
 * Created by msciab on 03/12/15.
 */
@Controller
public class HomeLayout extends ASContentController<Home> {

    @Template(from = "boot/index.html", forType = "Page", forSubtype = "Home", layout = true, pick = "body")
    public String homeLayout(Picker p, HomeHelper helper) {
        p.replace("#home-title", helper.editBootTitle());
        p.replace("#home-subtitle", helper.editBootSubtitle());
        p.replaceWith("header", helper.editFragmentOrElse("carouselContainerFragment", "<div><h2>Nun c'e' trippa pe' gatti</h2></div>"));
        p.replaceWith("#portfolio-container", helper.editFragmentOrElse("portfolioContainerFragment", "<div><h2>Nun c'e' trippa pe' gatti</h2></div>"));
        return p.outerHtml();
    }

    public void doWork(Map models) {
        super.doWork(models);
        @Groovy("def home = this.load()")
        Home home = this.load();


        if (home.portfolioContainer != null) {
            EditableTemplateFragment portfolioContainerFragment = newEditableTemplateFragment()
                    .useTemplate("portfolioContainerLayout")
                    .forAsset(home.portfolioContainer.getAssetId())
                    .editField("portfolioContainer")
                    .setSlotname("Project Portfolio Container")
                    .setEmptyText("Drop Portfolio Container");
            models.put("portfolioContainerFragment", portfolioContainerFragment);
        }

        if (home.carouselContainer != null) {
            EditableTemplateFragment carouselContainerFragment = newEditableTemplateFragment()
                    .useTemplate("carouselContainerLayout")
                    .forAsset(home.carouselContainer.getAssetId())
                    .editField("carouselContainer")
                    .setSlotname("Carousel Container")
                    .setEmptyText("Drop Carousel Container");
            models.put("carouselContainerFragment", carouselContainerFragment);
        }
    }

}
