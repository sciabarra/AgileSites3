package demo.model.dmcontent;

import agilesites.annotations.*;
import agilesitesng.api.AssetAttribute;
import demo.model.DmContent;

import java.util.Date;

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

    @Attribute
    @Required
    public String title;

    @Attribute(editor = "DmRichTextEditor")
    public String subtitle;

    @Attribute(editor = "ArticleTypeSelector")
    public String articleType;

    @Attribute
    public Date startDate;

    @Attribute
    public agilesitesng.api.AssetAttribute<DmContent<DmImage>> image;

    @Attribute
    public agilesitesng.api.AssetAttribute<DmContent<DmTextBlock>> blocks[];

}
