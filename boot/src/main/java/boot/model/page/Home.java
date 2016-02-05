package boot.model.page;

import agilesites.annotations.Attribute;
import agilesites.annotations.ContentDefinition;
import agilesites.annotations.FindStartMenu;
import agilesites.annotations.NewStartMenu;
import agilesitesng.api.AssetAttribute;
import boot.model.BootContainer;
import boot.model.BootContent;
import boot.model.BootImage;
import boot.model.Page;
import boot.model.block.Project;
import boot.model.container.CarouselContainer;
import boot.model.container.PortfolioContainer;
import boot.model.media.Image;

import java.util.Date;

/**
 * Created by jelerak on 03/12/15.
 */
@FindStartMenu("Find HomePage")
@NewStartMenu("New HomePage")
@ContentDefinition(flexContent = "PageDefinition", flexAttribute = "PageAttribute")
public class Home extends Page {

    @Attribute
    public String bootTitle;

    @Attribute
    public String bootSubtitle;

    @Attribute
    public AssetAttribute<BootContainer<CarouselContainer>> carouselContainer;

    @Attribute
    public AssetAttribute<BootContainer<PortfolioContainer>> portfolioContainer;
}
