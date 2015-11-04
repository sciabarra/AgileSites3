package demo.controller.content;

import agilesites.annotations.Controller;
import agilesitesng.api.ASContentController;
import com.fatwire.assetapi.fragment.EditableTemplateFragment;
import demo.model.dmcontent.DmArticle;

import java.util.Map;

/**
 * Created by msciab on 09/09/15.
 */
@Controller
public class ArticleDetailController extends ASContentController<DmArticle> {

    public void preProcess() {
/*
         Picker html = Picker.load("/blueprint/template.html", "#related");
         html.replace("#related-title", getString("a.Title"));
         html.replace("#related-body",  getString("a.Summary"));
         html.removeAttrs("*[id^=related]", "id");
         return html.html();
*/
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

/*
        EditableTemplateFragment<?> textBlockDetailFragment = newEditableTemplateFragment()
                .useTemplate("Text Block Detail")
                .setEmptyText("[ Drop Text Block]");
*/
    }

}
