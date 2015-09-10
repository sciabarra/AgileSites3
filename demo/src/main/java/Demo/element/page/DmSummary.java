package demo.element.page;

import agilesites.api.*;

public class DmSummary implements Element {

	final static Log log = Log.getLog(DmSummary.class);

	/*
	public static AssetSetup setup() {
		return new Template("Page", "Summary", Template.INTERNAL, // change
				"Content", Summary.class) //
				.cache("false", "false") // change caching here
                .cacheCriteria("d")
				.description("Template Summary for type Page ");
	}*/

	@Override
	public String apply(Env e) {
		if (log.debug())
			log.debug("Demo ContentSeeAlso");

		Asset a = e.getAsset();
		Picker html = Picker.load("/blueprint/template.html", "#related");
		html.replace("#related-title", a.getString("Title"));
		html.replace("#related-body", a.getString("Summary"));
		html.removeAttrs("*[id^=related]", "id");
		return html.outerHtml();
	}

}
