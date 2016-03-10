package boot.model.page;

import agilesites.annotations.Attribute;
import agilesites.annotations.ContentDefinition;
import agilesites.annotations.FindStartMenu;
import agilesites.annotations.NewStartMenu;
import agilesitesng.api.AssetAttribute;
import agilesitesng.api.BlobAttribute;
import boot.model.BootContainer;
import boot.model.BootContent;
import boot.model.Page;
import boot.model.block.EmployeeBlock;
import boot.model.container.CarouselContainer;
import boot.model.container.MarketingContainer;
import boot.model.container.PortfolioContainer;

/**
 * Created by jelerak on 03/12/15.
 */
@FindStartMenu("Page: About")
@NewStartMenu("Page: About")
@ContentDefinition(flexContent = "PageDefinition", flexAttribute = "PageAttribute")
public class About extends Page {

    @Attribute
    public String title;

    @Attribute
    public String subtitle;

    @Attribute
    public String heading;

    @Attribute
    public String aboutDescription;

    @Attribute(value = "Image")
    public BlobAttribute image;

    @Attribute
    public AssetAttribute<BootContent<EmployeeBlock>> employees[];
}
