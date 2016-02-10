package boot.model.block;

import agilesites.annotations.Attribute;
import agilesites.annotations.ContentDefinition;
import agilesites.annotations.FindStartMenu;
import agilesites.annotations.NewStartMenu;

@NewStartMenu("Block: Marketing")
@FindStartMenu("Block: Marketing")
@ContentDefinition(flexAttribute = "BootAttribute",
        flexContent = "BootContentDefinition",
        flexParent = "BootParentDefinition")
public class MarketingBlock extends boot.model.BootContent {

    @Attribute(value = "Title")
    public String title;

    @Attribute(value = "Description", editor = "BootRichTextEditor")
    public String description;

    @Attribute(value = "Icon class")
    public String iconClass;

}
