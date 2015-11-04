package demo.controller.content;

import agilesites.annotations.Controller;
import agilesitesng.api.ASContentController;
import demo.model.dmcontent.DmImage;
import demo.model.dmcontent.DmTextBlock;

import java.util.Map;

/**
 * Created by msciab on 09/09/15.
 */
@Controller
public class TextBlockController extends ASContentController<DmTextBlock> {

    public void preProcess() {
    }

    public void doWork(Map models) {
        super.doWork(models);
        DmTextBlock block = load();
        models.put("textBlock", block);
    }

}
