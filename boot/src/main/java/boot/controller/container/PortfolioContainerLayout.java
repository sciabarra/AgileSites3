package boot.controller.container;

import agilesites.annotations.Controller;
import agilesites.annotations.Groovy;
import agilesites.annotations.Template;
import agilesites.api.Picker;
import agilesitesng.api.ASContentController;
import boot.model.container.PortfolioContainer;
import boot.model.container.PortfolioContainerHelper;
import boot.model.page.Home;
import boot.model.page.HomeHelper;
import com.fatwire.assetapi.fragment.EditableTemplateFragment;

import java.util.List;
import java.util.Map;

/**
 * Created by jelerak on 03/12/15.
 */
@Controller
public class PortfolioContainerLayout extends ASContentController<PortfolioContainer> {

    @Template(from = "boot/index.html", forType = "BootContainer", forSubtype = "PortfolioContainer", layout = true, pick = "#portfolio-container")
    public String portfolioContainerLayout(Picker p, PortfolioContainerHelper helper) {
        p.replace("#portfolio-header", helper.editHeading());
        p.single(".portfolio_item");
        p.replaceWith(".portfolio_item", helper.editFragmentLoop("projectDetailFragments"));
        return p.outerHtml();
    }

    public void doWork(Map models) {
        super.doWork(models);
        @Groovy("def container = this.load()")
        PortfolioContainer container = this.load();


        int existingProjectsSize = container.projectPortfolio.length;
        List<EditableTemplateFragment> projectList = newFragmentList();

        for (int i = 0; i < existingProjectsSize; i++) {
            EditableTemplateFragment projectEmptySlotFragment = newEditableTemplateFragment()
                    .useTemplate("projectSummary")
                    .forAsset(container.projectPortfolio[i].getAssetId())
                    .editField("projectPortfolio", i)
                    .setSlotname("Project Portfolio Detail")
                    .setEmptyText("Drop Project");
            projectList.add(projectEmptySlotFragment);
        }
        models.put("projectDetailFragments", projectList);

    }

}
