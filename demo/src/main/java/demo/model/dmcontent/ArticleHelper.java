package demo.model.dmcontent;

import demo.model.DmContent;

public class ArticleHelper extends DmContent {

    public String getTitle(String assetName) {
        return editString(assetName, "title");
    }

    public String getSubtitle(String assetName) {
        return editText(assetName, "subtitle");
    }

    public String getArticleType(String assetName) {
        return editString(assetName, "articleType");
    }

    public String getStartDate(String assetName, String format) {
        return editDate(assetName, "startDate", format);
    }
}
