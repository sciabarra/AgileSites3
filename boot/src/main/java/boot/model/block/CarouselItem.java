package boot.model.block;

import agilesites.annotations.Attribute;
import agilesites.annotations.ContentDefinition;
import agilesites.annotations.FindStartMenu;
import agilesites.annotations.NewStartMenu;
import agilesitesng.api.AssetAttribute;
import agilesitesng.api.BlobAttribute;
import boot.model.BootImage;
import boot.model.media.Image;

@NewStartMenu("New Carousel Item")
@FindStartMenu("Find Carousel Item")
@ContentDefinition(flexAttribute = "BootAttribute",
        flexContent = "BootContentDefinition",
        flexParent = "BootParentDefinition")
public class CarouselItem extends boot.model.BootContent {

    @Attribute(value = "Caption")
    public String caption;

    @Attribute(value = "Background Image")
    public BlobAttribute backgroundImage;

    @Attribute(value = "Text")
    public String text;

}
