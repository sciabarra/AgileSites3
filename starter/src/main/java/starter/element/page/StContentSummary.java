package starter.element.page;

import agilesites.annotations.Template;
import wcs.api.Asset;
import wcs.api.Env;
import wcs.api.Log;
import wcs.java.Element;
import wcs.java.Picker;

@Template(forType = "Page")
public class StContentSummary extends Element {

    final static Log log = Log.getLog(StContentSummary.class);

    @Override
    public String apply(Env e) {
        if (log.debug())
            log.debug("Demo StContentSummary");

        Asset a = e.getAsset();
        Picker html = Picker.load("/starter/template.html", "#related");
        html.replace("#related-title", a.getString("stTitle"));
        html.replace("#related-body", a.getString("stSummary"));
        html.removeAttrs("*[id^=related]", "id");
        return html.outerHtml();
    }

}
