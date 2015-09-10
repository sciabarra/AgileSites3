package demo.model.page;

import agilesites.annotations.*;
import demo.model.Page;

@FindStartMenu("Find HomePage")
@StartMenu("New HomePage")
@ContentDefinition
public class DmHome extends Page {

    @Attribute()
    private String title;

    @Attribute(editor = "DmRichTextEditor")
    private String subtitle;

    @Attribute
    private String summary;

    @Attribute(editor = "DmRichTextEditor")
    private String detail;

    @Attribute
    @AssetSubtypes(values = "DmSection")
    private AssetAttribute<Page>[] sections;


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

}
