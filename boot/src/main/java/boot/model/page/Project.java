package boot.model.page;

import agilesites.annotations.Attribute;
import agilesites.annotations.ContentDefinition;
import agilesites.annotations.FindStartMenu;
import agilesites.annotations.NewStartMenu;
import agilesitesng.api.AssetAttribute;
import boot.model.BootContent;
import boot.model.BootImage;
import boot.model.Page;
import boot.model.media.Image;

@NewStartMenu("Page: Project")
@FindStartMenu("Page: Project")
@ContentDefinition(flexContent = "PageDefinition", flexAttribute = "PageAttribute")
public class Project extends Page {

    @Attribute(value = "Title")
    public String title;

    @Attribute(value = "Description", editor = "BootRichTextEditor")
    public String projectDescription;

    @Attribute(value = "Details", editor = "BootRichTextEditor")
    public String details;

    @Attribute(value = "Main Project Image")
    public AssetAttribute<BootImage<Image>> smallProjectImage;

    @Attribute(value = "Main Project Image")
    public AssetAttribute<BootImage<Image>> portfolioImages[];

    @Attribute(value = "Related Projects")
    public AssetAttribute<Page<Project>> relatedProjects[];

}
