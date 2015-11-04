package demo.model.page;

import agilesites.annotations.*;
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
    private agilesitesng.api.BlobAttribute image;

    @Attribute
    private String[] teaserTitle;

    @Attribute
    private String[] teaserText;

    @Attribute(description = "related pages")
    @AssetSubtypes(values = {"DmSection", "DmHome"})
    private agilesitesng.api.AssetAttribute<Page> related[];

    @Attribute(description = "similar pages")
    private agilesitesng.api.AssetAttribute<Page<DmSection>> seeAlso[];

    @Attribute
    private agilesitesng.api.AssetAttribute<DmContent<DmArticle>> head;

    @Attribute
    private agilesitesng.api.AssetAttribute<DmContent<DmArticle>> content[];

}
