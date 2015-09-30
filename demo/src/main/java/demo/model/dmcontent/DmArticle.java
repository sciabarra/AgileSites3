package demo.model.dmcontent;

import agilesites.annotations.*;
import agilesites.api.AgileAsset;
import demo.model.DmContent;

@MultipleStartMenu(items = {
        @NewStartMenu(value = "News Article", args = "articleType(S):news"),
        @NewStartMenu(value = "Blog Article", args = "articleType(S):blog")
})
@FindStartMenu("Find Article")
@ContentDefinition(flexAttribute = "DemoAttribute",
        flexContent = "DemoContentDefinition",
        flexParent = "DemoParentDefinition")
@Parents({"DmFolder","DmGallery"})
public class DmArticle extends DmContent {

    @Attribute()
    @Required
    private String title;

    @Attribute(editor = "DmRichTextEditor")
    private String subtitle;

    @Attribute(editor = "ArticleTypeSelector")
    private String articleType;

    @Attribute
    private AssetAttribute<DmContent<DmImage>> image;

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getSubtitle() {
        return subtitle;
    }

    public void setSubtitle(String subtitle) {
        this.subtitle = subtitle;
    }

    public AssetAttribute<DmContent<DmImage>> getImage() {
        return image;
    }

    public void setImage(AssetAttribute<DmContent<DmImage>> image) {
        this.image = image;
    }
}
