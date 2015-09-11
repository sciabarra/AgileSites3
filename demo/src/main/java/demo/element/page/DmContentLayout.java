package demo.element.page;

import agilesites.annotations.Template;
import agilesites.api.*;
import demo.model.Page;
import demo.model.page.DmSection;

import static agilesites.api.Api.*;

@Template(layout = true)
public class DmContentLayout implements TypedElement<DmSection> {

    Log log = Log.getLog(DmContentLayout.class);



    @Override
    public String apply(DmSection a, Env e) {

        Picker html = Picker.load("/blueprint/template.html", "#content");

        html.prefixAttrs("img", "src", "/cs/blueprint/");

        html.replace("#title", a.getTitle()); //todo edit
        html.replace("#subtitle", a.getSubtitle()); //todo edit
        html.replace("#summary", a.getSummary());// todo edit
        html.replace("#detail", a.getDetail()); // todo edit


        html.replace("#teaser-title1", a.getTeaserTitle(0));
        html.replace("#teaser-title2", a.getTeaserTitle(1));
        html.replace("#teaser-title3", a.getTeaserTitle(2));

        html.replace("#teaser-body1", a.getTeaserText(0));
        html.replace("#teaser-body2", a.getTeaserTitle(1));
        html.replace("#teaser-body3", a.getTeaserTitle(2));

        /*
        html.replace("#teaser-title1", a.editString("TeaserTitle", 1,
				"{noValueIndicator: \"Enter Teaser Title\"}"));
		html.replace("#teaser-body1", a.editString("TeaserText", 1,
				"{noValueIndicator: \"Enter Teaser Text\"}"));
		html.replace("#teaser-title2", a.editString("TeaserTitle", 2,
				"{noValueIndicator: \"Enter Teaser\"}"));
		html.replace("#teaser-body2", a.editString("TeaserText", 2,
				"{noValueIndicator: \"Enter Teaser Text\"}"));
		*/

        html.remove("div.related");
        html.append("#related-container",
                a.slotList("Related", "Page", "Summary"));
        html.append("#related-container", a.slotEmpty("Related", "Page",
                "Summary", "Drag a Page here. Save to add more."));

        String image = a.getImage().url();
        if (image == null)
            html.remove("#image-main");
        else
            html.attr("#image-main", "src", image);

        html.replace("#seealso1", a.slot("SeeAlso", 1, "Page",
                "ContentSeeAlso", "Drag a Page Here"));
        html.replace("#seealso2", a.slot("SeeAlso", 2, "Page",
                "ContentSeeAlso", "Drag a Page Here"));
        html.replace("#seealso3", a.slot("SeeAlso", 3, "Page",
                "ContentSeeAlso", "Drag a Page Here"));

        html.replace("#topmenu", e.call("Topmenu"));
        html.replace(
                "#breadcrump",
                e.call("Breadcrump", arg("c", a.getC()),
                        arg("cid", a.getCid().toString())));
        html.replace("#tree", e.call("Tree"));

        return html.dump(log).html();

    }

}
