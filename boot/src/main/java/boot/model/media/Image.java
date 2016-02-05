package boot.model.media;

import agilesites.annotations.*;
import agilesitesng.api.BlobAttribute;

@NewStartMenu("New Image")
@FindStartMenu("Find Image")
@ContentDefinition(flexAttribute = "BootAttribute",
        flexContent = "BootContentDefinition",
        flexParent = "BootParentDefinition")
public class Image extends boot.model.BootImage {

    @Attribute(value = "Image", editor = "BootUploaderEditor")
    private BlobAttribute defaultImage;

    @Attribute("Alt Text Image")
    @Required
    private String altTextImageString;

}
