package demo.element.page;

import agilesites.api.*;

public class DmContentSeeAlso implements Element {

	final static Log log = Log.getLog(DmContentSeeAlso.class);

	/*
	public static AssetSetup setup() {

		return new Template("Page", "ContentSeeAlso", Template.INTERNAL,
				"Content", ContentSeeAlso.class) //
				.cache("false", "false") // change caching here
                .cacheCriteria("d")
				.description("Template ContentSeeAlso for type Page subtype Content");
	}*/

	@Override
	public String apply(Env e) {
		if (log.debug())
			log.debug("Demo ContentSeeAlso");

		Picker html = Picker.load("/blueprint/template.html", "#seealso1");
		Asset a = e.getAsset();
		html.replace("#seealso-title1", a.getString("Title"));
		html.replace("#seealso-text1", a.getString("Summary"));
		html.attr("#seealso-link1", "href", a.getUrl());
		html.removeAttrs("*[id^=seealso]", "id");
		return html.html();
	}

}
