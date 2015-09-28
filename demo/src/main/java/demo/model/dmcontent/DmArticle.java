package demo.model.dmcontent;

import agilesites.annotations.*;
import agilesites.api.AgileAsset;
import demo.model.DmContent;

@MultipleStartMenu(items = {
        @NewStartMenu(value = "News Article", args = "path:news"),
        @NewStartMenu(value = "Blog Article", args = "path:blog")
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

    @Attribute
    private String summary;

    @Attribute(editor = "DmRichTextEditor")
    private String detail;

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

    public String getSummary() {
        return summary;
    }

    public void setSummary(String summary) {
        this.summary = summary;
    }

    public String getDetail() {
        return detail;
    }

    public void setDetail(String detail) {
        this.detail = detail;
    }

    public AssetAttribute<DmContent<DmImage>> getImage() {
        return image;
    }

    public void setImage(AssetAttribute<DmContent<DmImage>> image) {
        this.image = image;
    }
}
