package boot.controller.container;

import agilesites.annotations.Controller;
import agilesites.annotations.Groovy;
import agilesites.annotations.Template;
import agilesites.api.Picker;
import agilesitesng.api.ASContentController;
import boot.model.container.MarketingContainer;
import boot.model.container.PortfolioContainer;
import boot.model.container.PortfolioContainerHelper;
import com.fatwire.assetapi.fragment.EditableTemplateFragment;

import java.util.List;
import java.util.Map;

/**
 * Created by jelerak on 03/12/15.
 */
@Controller
public class MarketingContainerLayout extends ASContentController<MarketingContainer> {

    @Template(from = "boot/index.html", forType = "BootContainer", forSubtype = "MarketingContainer", layout = true, pick = "#marketing-container")
    public String marketingContainerLayout(Picker p, PortfolioContainerHelper helper) {
        p.replace("#marketing-header", helper.editHeading());
        p.single(".marketing-block");
        p.replaceWith(".marketing-block", helper.editFragmentLoop("marketingBlockFragments"));
        return p.outerHtml();
    }

    public void doWork(Map models) {
        super.doWork(models);
        @Groovy("def container = this.load()")
        MarketingContainer container = this.load();


        int itemsSize = container.marketingItems.length;
        List<EditableTemplateFragment> blockList = newFragmentList();

        for (int i = 0; i < itemsSize; i++) {
            EditableTemplateFragment marketingItemEmptySlotFragment = newEditableTemplateFragment()
                    .useTemplate("marketingBlockLayout")
                    .forAsset(container.marketingItems[i].getAssetId())
                    .editField("marketingItems", i)
                    .setSlotname("Marketing Block layout")
                    .setEmptyText("Drop Marketing Block");
            blockList.add(marketingItemEmptySlotFragment);
        }
        models.put("marketingBlockFragments", blockList);

    }

}
