package boot.model.block;

import agilesites.annotations.*;
import agilesitesng.api.AssetAttribute;
import agilesitesng.api.BlobAttribute;
import boot.model.BootImage;
import boot.model.media.Image;

@NewStartMenu("New Project")
@FindStartMenu("Find Project")
@ContentDefinition(flexAttribute = "BootAttribute",
        flexContent = "BootContentDefinition",
        flexParent = "BootParentDefinition")
public class Project extends boot.model.BootContent {

    @Attribute(value = "Title")
    public String title;

    @Attribute(value = "Subtitle")
    public String subtitle;

    @Attribute(value = "Description", editor = "BootRichTextEditor")
    public String description;

    @Attribute(value = "Main Project Image")
    public AssetAttribute<BootImage<Image>> smallProjectImage;

    @Attribute(value = "Main Project Image")
    public AssetAttribute<BootImage<Image>> portfolioImages[];


}
