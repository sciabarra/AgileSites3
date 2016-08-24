package starter;

import wcs.api.*;

/**
 * Simple router invoking the tester only
 * 
 * @author msciab
 * 
 */
public class Router extends wcs.java.Router {

	@Override
	public Call route(Env env, URL url) {
		return defaultRoute("StWrapper", env, url);
	}

	/**
	 * Create a link with just the page name
	 * 
	 * Special case: the home page, normalized to just the void string
	 */
	@Override
	public String link(Env e, Id id, Arg... args) {
		return defaultLink(e, id, args);
	}
}
