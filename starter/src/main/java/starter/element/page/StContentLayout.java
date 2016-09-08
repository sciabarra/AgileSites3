package starter.element.page;

import wcs.api.Asset;
import wcs.api.Log;
import wcs.java.Element;
import wcs.api.Env;
import agilesites.annotations.Template;
import wcs.java.Picker;

import static wcs.Api.arg;

@Template(forType = "Page", layout=true, extraCriteria = "test", csCache="true,~0", ssCache="true,~0")
public class StContentLayout extends Element {

    Log log = Log.getLog(StContentLayout.class);

    @Override
    public String apply(Env e) {
        if (log.debug())
            log.debug("Demo ContentLayout");

        Asset a = e.getAsset();
        Picker html = Picker.load("/starter/template.html", "#content");

        html.prefixAttrs("img", "src", "/cs/starter/");

        html.replace("#title", a.editString("stTitle"));
        html.replace("#subtitle", a.editString("stSubtitle"));
        html.replace("#summary", a.editString("stSummary"));
        html.replace("#detail", a.editText("stDetail", ""));

        html.replace("#teaser-title1", a.editString("stTeaserTitle", 1,
                "{noValueIndicator: \"Enter Teaser Title\"}"));
        html.replace("#teaser-body1", a.editString("stTeaserText", 1,
                "{noValueIndicator: \"Enter Teaser Text\"}"));
        html.replace("#teaser-title2", a.editString("stTeaserTitle", 2,
                "{noValueIndicator: \"Enter Teaser\"}"));
        html.replace("#teaser-body2", a.editString("stTeaserText", 2,
                "{noValueIndicator: \"Enter Teaser Text\"}"));

        html.remove("div.related");
        html.append("#related-container",
                a.slotList("stRelated", 3, "Page", "StContentSeeAlso"));
        html.append("#related-container", a.slotEmpty("stRelated", "Page",
                "StContentSeeAlso", "Drag a Page here. Save to add more."));

        String image = a.getBlobUrl("stImage");
        if (image == null)
            html.remove("#image-main");
        else
            html.attr("#image-main", "src", image);

        html.replace("#seealso1", a.slot("stSeeAlso", 1, "Page",
                "StContentSummary", "Drag a Page Here"));
        html.replace("#seealso2", a.slot("stSeeAlso", 2, "Page",
                "StContentSeeAlso", "Drag a Page Here"));
        html.replace("#seealso3", a.slot("stSeeAlso", 3, "Page",
                "StContentSeeAlso", "Drag a Page Here"));

        html.replace("#topmenu", e.call("StTopMenu"));
        html.replace(
                "#breadcrump",
                e.call("StBreadcrump", arg("c", a.getC()),
                        arg("cid", a.getCid().toString())));
        html.replace("#tree", e.call("StTree"));


        return html/*.dump(log)*/.html();
    }

}
