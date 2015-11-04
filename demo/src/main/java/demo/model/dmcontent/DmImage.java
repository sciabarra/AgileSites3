package demo.model.dmcontent;

import agilesites.annotations.*;
import agilesitesng.api.BlobAttribute;
import demo.model.DmContent;

@NewStartMenu("New Image")
@FindStartMenu("Find Image")
@ContentDefinition(flexAttribute = "DemoAttribute",
        flexContent = "DemoContentDefinition",
        flexParent = "DemoParentDefinition")
@Parents("DmGallery")
public class DmImage extends DmContent {

    @Attribute(value = "Large Image", editor = "DmUploaderEditor" )
    private agilesitesng.api.BlobAttribute largeImage;

    @Attribute(value = "Medium Image", editor = "DmUploaderEditor")
    private agilesitesng.api.BlobAttribute mediumImage;

    @Attribute(value = "Small Image", editor = "DmUploaderEditor")
    private agilesitesng.api.BlobAttribute smallImage;

    @Attribute("Alt Text Image")
    @Required
    private String altTextImageString;

}
