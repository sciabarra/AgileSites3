package demo.view.page;

import agilesites.annotations.Template;
import agilesites.api.Picker;

public class ContentLayout  {


	@Template(from="/blueprint/template.html", pick="#content")
	public String apply(Picker html) {

		html.prefixAttrs("img", "src", "/cs/blueprint/");

		html.replace("#title", "${a.Title}");
		html.replace("#subtitle", "${a.Subtitle}");
		html.replace("#summary", "${a.Summary}");
		html.replace("#detail", "${a.Detail}");

		/* TODO
		html.replace("#teaser-title1", a.editString("TeaserTitle", 1,
				"{noValueIndicator: \"Enter Teaser Title\"}"));
		html.replace("#teaser-body1", a.editString("TeaserText", 1,
				"{noValueIndicator: \"Enter Teaser Text\"}"));
		html.replace("#teaser-title2", a.editString("TeaserTitle", 2,
				"{noValueIndicator: \"Enter Teaser\"}"));
		html.replace("#teaser-body2", a.editString("TeaserText", 2,
				"{noValueIndicator: \"Enter Teaser Text\"}"));

		html.remove("div.related");
		html.append("#related-container",
				a.slotList("Related", "Page", "Summary"));
		html.append("#related-container", a.slotEmpty("Related", "Page",
				"Summary", "Drag a Page here. Save to add more."));

		String image = a.getBlobUrl("Image");
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

		*/
		return html.html();
	}
}
