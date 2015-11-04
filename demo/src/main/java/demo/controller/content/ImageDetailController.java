package demo.controller.content;

import agilesites.annotations.Controller;
import agilesitesng.api.ASContentController;
import com.fatwire.assetapi.fragment.EditableTemplateFragment;
import demo.model.dmcontent.DmArticle;
import demo.model.dmcontent.DmImage;

import java.util.Map;

/**
 * Created by msciab on 09/09/15.
 */
@Controller
public class ImageDetailController extends ASContentController<DmImage> {

    public void preProcess() {
    }

    public void doWork(Map models) {
        super.doWork(models);
        DmImage image = load();
        models.put("image", image);
    }

}
