package starter.element.page;

import agilesites.annotations.Template;
import wcs.api.Asset;
import wcs.api.Env;
import wcs.api.Log;
import wcs.java.Element;
import wcs.java.Picker;

@Template(forType = "Page")
public class StContentSeeAlso extends Element {

    final static Log log = Log.getLog(StContentSeeAlso.class);

    @Override
    public String apply(Env e) {
        if (log.debug())
            log.debug("Demo ContentSeeAlso");

        Picker html = Picker.load("/starter/template.html", "#seealso1");
        Asset a = e.getAsset();
        html.replace("#seealso-title1", a.getString("stTitle"));
        html.replace("#seealso-text1", a.getString("stSummary"));
        html.attr("#seealso-link1", "href", a.getUrl());
        html.removeAttrs("*[id^=seealso]", "id");
        return html.html();
    }
}
