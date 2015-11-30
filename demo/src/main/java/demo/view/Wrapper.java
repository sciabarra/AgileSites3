package demo.view;

import agilesites.annotations.CSElement;
import agilesites.api.Picker;

public class Wrapper  {

	@CSElement(from="/blueprint/template.html")
	public String apply(Picker html) {

		System.out.println("salve, sono il wrapper");
		/*

		// change relative references to absolute
		html.prefixAttrs("link[rel=stylesheet]", "href", "/cs/blueprint/");
		html.prefixAttrs("script[id=js-import]", "src", "/cs/blueprint/");
		html.replace("#js-base", "var base='/cs/blueprint/'");

		// render the asset using his default template
		html.replace("title", "${a.Title}");
		html.attr("meta[name=description]", "content", "${a.description");
		html.replace("#content", "<p>insert a call here</p>");

		return html.outerHtml();
		*/
		return "Wrapper";
	}
}
