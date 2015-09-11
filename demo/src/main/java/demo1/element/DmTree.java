package demo.element;

import agilesites.annotations.CSElement;
import agilesites.api.*;
import static agilesites.api.Api.*;

@CSElement
public class DmTree implements Element {

	final static Log log = Log.getLog(DmTree.class);
	private SitePlan sp;
	private Env e;


	/**
	 * Recursive visit of the site plan to build the tree
	 * 
	 * @param parent
	 * @param result
	 */
	private void visit(Id parent, StringBuilder result) {
		sp.goTo(parent);
		for (Id id : sp.children()) {
			Asset a = e.getAsset(id);
			String node = String.format(//
					"d.add(%d, %d, '%s', '%s');\n", //
					id.cid, parent.cid, a.getName(), a.getUrl());
			result.append(node);
			visit(id, result);
		}
	}

	@Override
	public String apply(Env e) {
		if (log.debug())
			log.debug("Demo Tree");

		this.e = e;
		this.sp = e.getSitePlan();

		// get model and view
		Picker html = Picker.load("/blueprint/template.html", "#tree");

		// navigate the siteplan
		Id parent = sp.current();
		StringBuilder result = new StringBuilder("d.add(" + parent.cid
				+ ", -1,'" + e.getSite() + "');");
		visit(parent, result);

		html.replace("#tree-body", result.toString());
		return html/* .dump(log) */.html();
	}
}
