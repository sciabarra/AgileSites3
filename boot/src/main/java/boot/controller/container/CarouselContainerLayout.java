package boot.controller.container;

import agilesites.annotations.Controller;
import agilesites.annotations.Groovy;
import agilesites.annotations.Template;
import agilesites.api.Picker;
import agilesitesng.api.ASContentController;
import boot.model.container.CarouselContainer;
import boot.model.container.CarouselContainerHelper;
import boot.model.container.PortfolioContainer;
import boot.model.page.HomeHelper;
import com.fatwire.assetapi.fragment.EditableTemplateFragment;

import java.util.List;
import java.util.Map;

/**
 * Created by msciab on 03/12/15.
 */
@Controller
public class CarouselContainerLayout extends ASContentController<CarouselContainer> {

    @Template(from = "boot/index.html", forType = "BootContainer", forSubtype = "CarouselContainer", layout = true, pick = "#myCarousel")
    public String carouselContainerLayout(Picker p, CarouselContainerHelper helper) {
        return p.outerHtml();
    }

    public void doWork(Map models) {
        super.doWork(models);
        @Groovy("def container = this.load()")
        CarouselContainer container = this.load();


        int existingProjectsSize = container.carouselItems.length;
        List<EditableTemplateFragment> carouselList = newFragmentList();

        for (int i = 0; i < existingProjectsSize; i++) {
            EditableTemplateFragment projectEmptySlotFragment = newEditableTemplateFragment()
                    //.addLegalTypes("Project")
                    .useTemplate("projectSummary")
                    .forAsset(container.carouselItems[i].getAssetId())
                    .editField("projectPortfolio", i)
                    .setSlotname("Project Portfolio Detail")
                    .setEmptyText("Drop Project");
            carouselList.add(projectEmptySlotFragment);
        }
        models.put("projectDetailFragments", carouselList);

    }

}
