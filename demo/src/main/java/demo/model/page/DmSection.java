package demo.model.page;

import agilesites.annotations.*;
import agilesites.api.AgileAsset;
import demo.model.DmContent;
import demo.model.Page;
import demo.model.dmcontent.DmArticle;

@FindStartMenu("Find Content Page")
@NewStartMenu("New Content Page")
@ContentDefinition(flexAttribute = "PageAttribute",
        flexContent = "PageDefinition")
public class DmSection extends Page {

    @Attribute
    @Required
    private String title;

    @Attribute(editor = "DmRichTextEditor")
    private String subtitle;

    @Attribute
    private String summary;

    @Attribute(editor = "DmRichTextEditor")
    private String detail;

    @Attribute
    private BlobAttribute image;

    @Attribute
    private String[] teaserTitle;

    @Attribute
    private String[] teaserText;

    @Attribute(description = "related pages")
    @AssetSubtypes(values = {"DmSection", "DmHome"})
    private AssetAttribute<Page>[] related;

    @Attribute(description = "similar pages")
    private AssetAttribute<Page<DmSection>>[] seeAlso;

    @Attribute
    private AssetAttribute<DmContent<DmArticle>> head;

    @Attribute
    private AssetAttribute<DmContent<DmArticle>>[] content;

    public String getTitle() {
        return title;
    }

    public String getSubtitle() {
        return subtitle;
    }

    public String getSummary() {
        return summary;
    }

    public String getDetail() {
        return detail;
    }

    public BlobAttribute getImage() {
        return image;
    }

    public String[] getTeaserTitle() {
        return teaserTitle;
    }

    public String[] getTeaserText() {
        return teaserText;
    }

    public String getTeaserTitle(int n) {
        if (n < teaserTitle.length) return "";
        return teaserTitle[n];
    }


    public String getTeaserText(int n) {
        if (n < teaserText.length) return "";
        return teaserTitle[n];
    }

    public AssetAttribute<Page>[] getRelated() {
        return related;
    }

    public AssetAttribute<Page<DmSection>>[] getSeeAlso() {
        return seeAlso;
    }

    public AssetAttribute<DmContent<DmArticle>> getHead() {
        return head;
    }

    public AssetAttribute<DmContent<DmArticle>>[] getContent() {
        return content;
    }
}
