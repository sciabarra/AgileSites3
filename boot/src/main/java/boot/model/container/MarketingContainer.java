package boot.model.container;

import agilesites.annotations.Attribute;
import agilesites.annotations.ContentDefinition;
import agilesites.annotations.FindStartMenu;
import agilesites.annotations.NewStartMenu;
import agilesitesng.api.AssetAttribute;
import boot.model.BootContainer;
import boot.model.BootContent;
import boot.model.block.CarouselItem;
import boot.model.block.MarketingBlock;

/**
 * Created by jelerak on 04/02/2016.
 */
@NewStartMenu("Container: Marketing")
@FindStartMenu("Container: Marketing")
@ContentDefinition(flexAttribute = "BootAttribute",
        flexContent = "BootContentDefinition",
        flexParent = "BootParentDefinition")
public class MarketingContainer extends BootContainer {

    @Attribute
    public String heading;

    @Attribute
    public AssetAttribute<BootContent<MarketingBlock>> marketingItems[];

}
