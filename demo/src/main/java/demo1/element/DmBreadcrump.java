package demo.element;

import static java.lang.String.format;

import agilesites.annotations.CSElement;
import agilesites.api.*;
import static agilesites.api.Api.*;

@CSElement
public class DmBreadcrump implements Element {

	final static Log log = Log.getLog(DmBreadcrump.class);

	@Override
	public String apply(Env e) {

		if (log.debug())
			log.debug("Demo Breadcrump");

		Picker html = Picker.load("/blueprint/template.html", "#breadcrump");
		StringBuilder sb = new StringBuilder();
		String sep = "&nbsp;&raquo;&nbsp;";

		Asset a = e.getAsset();
		if (log.trace())
			log.trace("id=" + a.getId());
		SitePlan sp = e.getSitePlan().goTo(a.getId());

		Id[] path = sp.path();
		if (log.trace())
			log.trace("path len=%d", path.length);
		for (int i = path.length - 1; i >= 0; i--) {
			Id id = path[i];
			if (log.trace())
				log.trace("id: %s", id);
			if (!id.c.equals("Publication")) {
				String name = e.getAsset(id).getName();
				sb.append(format("<a href='%s'>%s</a>%s", e.getUrl(id), name,
						sep));
			}
		}
		sb.append("<b>").append(a.getName()).append("</b>");
		return html.replace("#breadcrump", sb.toString()).dump(log).html();
	}
}
