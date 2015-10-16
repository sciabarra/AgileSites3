package demo.element;

import agilesites.annotations.Controller;
import demo.model.dmcontent.DmArticle;

import java.util.Map;

/**
 * Created by msciab on 09/09/15.
 */
@Controller
public class HelloWorld {

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
/*
        DmArticle dm = Factory.load(DmArticle.class, c, cid)
        models.put("dm", dm);
*/
    }
}
