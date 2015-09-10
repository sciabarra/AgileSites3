package demo.model.dmcontent;

import agilesites.annotations.*;
import demo.model.DmContent;

@MultipleStartMenu(items = {
        @NewStartMenu(value = "News Article", args = "path:news"),
        @NewStartMenu(value = "Blog Article", args = "path:blog")
})
@FindStartMenu("Find Article")
@ContentDefinition
@Parent("DmFolder")
public class DmArticle extends DmContent {

    @Attribute()
    private String title;

    @Attribute(editor = "DmRichTextEditor")
    private String subtitle;

    @Attribute
    private String summary;

    @Attribute(editor = "DmRichTextEditor")
    private String detail;

    @Attribute()
    @AssetSubtypes(values = "DmImage")
    private AssetAttribute<DmContent>[] images;

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

    public AssetAttribute<DmContent>[] getImages() {
        return images;
    }

    public void setImages(AssetAttribute<DmContent>[] images) {
        this.images = images;
    }
}
