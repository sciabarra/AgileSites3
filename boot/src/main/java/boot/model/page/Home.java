package boot.model.page;

import agilesites.annotations.Attribute;
import agilesites.annotations.ContentDefinition;
import agilesites.annotations.FindStartMenu;
import agilesites.annotations.NewStartMenu;
import agilesitesng.api.AssetAttribute;
import boot.model.BootContainer;
import boot.model.Page;
import boot.model.container.CarouselContainer;
import boot.model.container.MarketingContainer;
import boot.model.container.PortfolioContainer;

/**
 * Created by jelerak on 03/12/15.
 */
@FindStartMenu("Page: Home" )
@NewStartMenu("Page: Home")
@ContentDefinition(flexContent = "PageDefinition", flexAttribute = "PageAttribute")
public class Home extends Page {

    @Attribute
    public String title;

    @Attribute
    public String subtitle;

    @Attribute
    public AssetAttribute<BootContainer<CarouselContainer>> carouselContainer;

    @Attribute
    public AssetAttribute<BootContainer<MarketingContainer>> marketingContainer;

    @Attribute
    public AssetAttribute<BootContainer<PortfolioContainer>> portfolioContainer;
}
