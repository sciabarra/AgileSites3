package demo.model.page;

import agilesites.annotations.*;
import agilesites.api.AgileAsset;
import demo.model.DmContent;
import demo.model.Page;
import demo.model.dmcontent.DmArticle;
import demo.model.dmcontent.DmImage;

@FindStartMenu("Find HomePage")
@NewStartMenu("New HomePage")
@ContentDefinition(flexAttribute = "PageAttribute",
        flexContent = "PageDefinition")
public class DmHome extends Page {

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
    private AssetAttribute<Page<DmSection>>[] sections;


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

    public AssetAttribute<Page<DmSection>>[] getSections() {
        return sections;
    }
}
