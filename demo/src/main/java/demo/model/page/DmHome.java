package demo.model.page;

import agilesites.annotations.*;
import demo.model.Page;

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
    private agilesitesng.api.AssetAttribute<Page<DmSection>>[] sections;
}
