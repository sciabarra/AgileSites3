package demo.controller.content;

import agilesites.annotations.Controller;
import agilesites.annotations.Template;
import agilesites.api.Picker;
import agilesitesng.api.ASContentController;
import com.fatwire.assetapi.fragment.EditableTemplateFragment;
import demo.model.dmcontent.DmArticle;
import demo.model.dmcontent.ArticleHelper;

import java.util.Map;

/**
 * Created by jelerak on 09/09/15.
 */
@Controller
public class ArticleDetailController extends ASContentController<DmArticle> {

    @Template(from = "article-detail.html", pick = "#body")
    public String preProcess(Picker html) {
        ArticleHelper article = new ArticleHelper();
        html.replace("#article-title", article.getTitle("dm"));
        html.replace("#article-subtitle", article.getSubtitle("dm"));
        html.replace("#article-start_date", article.getStartDate("dm", "mm/dd/yyyy"));
        return html.html();
    }

    public void doWork(Map models) {
        super.doWork(models);
        DmArticle article = load();
        models.put("dm", article);
        EditableTemplateFragment<?> articleImageDetailFragment = newEditableTemplateFragment()
                .useTemplate("ImageDetail")
                .setEmptyText("[ Drop Image ]")
                .forAsset(article.image.getAssetId())
                .editField(article.image.getName());
        models.put("articleImageDetailFragment", articleImageDetailFragment);

        EditableTemplateFragment<?> textBlockDetailFragment = newEditableTemplateFragment()
                .useTemplate("Text Block Detail")
                .setEmptyText("[ Drop Text Block]");
    }

}
