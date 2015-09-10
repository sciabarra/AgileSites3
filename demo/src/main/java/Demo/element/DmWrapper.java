package demo.element;
import agilesites.annotations.CSElement;
import agilesites.annotations.SiteEntry;
import agilesites.api.*;
import static agilesites.api.Api.*;

@CSElement
@SiteEntry(wrapper=true)
public class DmWrapper implements Element {

	private final static Log log = Log.getLog(DmWrapper.class);

	@Override
	public String apply(Env e) {
		if (log.debug())
			log.trace("Demo Wrapper");

		Picker html = Picker.load("/blueprint/template.html");

		// change relative references to absolute
		html.prefixAttrs("link[rel=stylesheet]", "href", "/cs/blueprint/");
		html.prefixAttrs("script[id=js-import]", "src", "/cs/blueprint/");
		html.replace("#js-base", "var base='/cs/blueprint/'");

		// handle errors
		if (e.isVar("error"))
			return html.replace("#content",
					e.call("Error", arg("error", e.getString("error"))))
					.outerHtml();

		Asset a = e.getAsset();
		if (a == null)
			return html.replace("#content",
					e.call("Error", arg("error", "Asset not found")))
					.outerHtml();

		// render the asset using his default template
		html.replace("title", a.getName());
		html.attr("meta[name=description]", "content", a.getDescription());
		html.replace("#content", a.call(a.getTemplate()));

		return html.outerHtml();
	}
}
