package starter.element;

import static wcs.Api.*;
import wcs.api.Env;
import wcs.api.Asset;
import wcs.java.Element;
import wcs.java.Picker;
import agilesites.annotations.CSElement;
import agilesites.annotations.SiteEntry;

@CSElement
@SiteEntry(wrapper = true)
public class StWrapper extends Element {
    @Override
    public String apply(Env e)
    {
        Picker html = Picker.load("/starter/template.html");

        // change relative references to absolute
        html.prefixAttrs("link[rel=stylesheet]", "href", "/cs/starter/");
        html.prefixAttrs("script[id=js-import]", "src", "/cs/starter/");
        html.replace("#js-base", "var base='/cs/starter/'");

        // handle errors
        if (e.isVar("error"))
            return html.replace("#content",
                    e.call("StError", arg("error", e.getString("error"))))
                    .outerHtml();

        Asset a = e.getAsset();
        if (a == null)
            return html.replace("#content",
                    e.call("StError", arg("error", "Asset not found")))
                    .outerHtml();

        // render the asset using his default template
        html.replace("title", a.getName());
        html.attr("meta[name=description]", "content", a.getDescription());
        html.replace("#content", a.call(a.getTemplate()));

        return html.outerHtml();
    }
}
