package demo.model.dmcontent;

import agilesites.annotations.*;
import agilesites.api.AgileAsset;
import demo.model.DmContent;

@NewStartMenu("New Image")
@FindStartMenu("Find Image")
@ContentDefinition(flexAttribute = "DemoAttribute",
        flexContent = "DemoContentDefinition",
        flexParent = "DemoParentDefinition")
@Parents("DmGallery")
public class DmImage extends DmContent {

    @Attribute(value = "Large Image", editor = "DmUploaderEditor" )
    private BlobAttribute largeImage;

    @Attribute(value = "Medium Image", editor = "DmUploaderEditor")
    private BlobAttribute mediumImage;

    @Attribute(value = "Small Image", editor = "DmUploaderEditor")
    private BlobAttribute smallImage;

    @Attribute("Alt Text Image")
    @Required
    private String altTextImageString;

    public BlobAttribute getLargeImage() {
        return largeImage;
    }

    public BlobAttribute getMediumImage() {
        return mediumImage;
    }

    public BlobAttribute getSmallImage() {
        return smallImage;
    }

    public String getAltTextImageString() {
        return altTextImageString;
    }
}
