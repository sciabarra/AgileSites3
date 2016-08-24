package starter.model.page;

import agilesites.annotations.*;
import starter.model.Page;

@FindStartMenu("Find Content Page")
@NewStartMenu("New Content Page")
@ContentDefinition(
        flexAttribute = "PageAttribute",
        flexContent = "PageDefinition")
public class StContent extends Page {

        @Attribute(description = "Title")
        @Required
        private String stTitle;

        @Attribute(description="Subtitle", editor = "stRichTextEditor")
        private String stSubtitle;

        @Attribute(description= "Summary")
        private String stSummary;

        @Attribute(description="Detail", editor = "stRichTextEditor")
        private String stDetail;

        @Attribute(description="Image")
        private agilesitesng.api.BlobAttribute stImage;

        @Attribute(description="Teaser Title")
        private String[] stTeaserTitle;

        @Attribute(description="Teaser Text")
        private String[] stTeaserText;

        @Attribute(description = "related pages")
        @AssetSubtypes(values = {"StContent"})
        private agilesitesng.api.AssetAttribute<Page> stRelated[];

        @Attribute(description = "similar pages")
        private agilesitesng.api.AssetAttribute<Page<Page>> stSeeAlso[];
    }
