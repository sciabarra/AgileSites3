package wcs.java;

import wcs.api.Arg;
import wcs.api.Call;
import wcs.api.Env;
import wcs.api.Id;
import wcs.api.Log;
import wcs.api.URL;
import wcs.java.util.Util;
import COM.FutureTense.Interfaces.ICS;

import java.util.List;
import java.util.StringTokenizer;

import static wcs.Api.arg;

/**
 * The router - implement the abstract methods to provide url->asset and
 * asset->burl conversions.
 * 
 * @author msciab
 * 
 */
abstract public class Router implements wcs.api.Router {

	private static Log log = Log.getLog(Router.class);
	private ICS i;
	private Env e;
	private String site;
	
	@Override
	public void init(String site) {
		this.site = site;
	}
	
	public String getSite() {
		return site;
	}

	@Override
	public Call route(ICS ics, String _path, String _query) {
		if (log.debug())
			log.debug("site=" + site + " path=" + _path + " query=" + _query);
		this.i = ics;
		this.e = new wcs.java.Env(i);
		this.site = ics.GetVar("site");
		if (_query == null || _query.trim().length() == 0)
			_query = "";
		else
			_query = "?" + _query;
		return route(e, URL.parse(_path, _query));
	}

	/**
	 * Create a call to an element
	 * 
	 * @param name
	 * @param args
	 * @return
	 */
	public Call call(String name, Arg... args) {
		Call call = new Call("ICS:CALLELEMENT", args);
		call.addArg("site", site);
		call.addArg("element", name);
		log.trace("call returns %s", call.toString());
		return call;
	}

	/**
	 * Default implementation of router.
	 *
	 * Route by name and calls the given wrapper.
	 *
	 *  http://yoursite.com
	 *   looks for a page names Home
	 *
	 *  http://yoursite.com/Welcome
	 *    looks for a page named Welcome
	 *
	 *  http://yoursite/Article/About
	 *    looks for an Article named About
	 *
	 *  If not found calls the wrapper with error set
	 *  Otherwise you have c/cid set.
	 *
	 * @param wrapper
	 * @param e
	 * @param url
     * @return
     */
	public Call defaultRoute(String wrapper, Env e, URL url) {
		// split the token
		String c = null;
		String name = null;

		StringTokenizer st = url.getPathTokens();
		switch (st.countTokens()) {
			case 0: // example: http://yoursite.com
				// look for the home page
				c = "Page";
				name = "Home";
				break;

			case 1: // example: http://yoursite.com/Welcome
				// look for a named page
				c = "Page";
				name = st.nextToken();
				break;

			case 2: // example: http://yoursite/Article/About
				// the following assume all the asset types
				// have the same prefix as the site name
				c = st.nextToken();
				name = st.nextToken();
				break;

			// unknown path
			default: // example: http://yoursite/service/action/parameter"
				c = null;
				break;
		}

		// path not split in pieces
		if (c == null || name == null) {
			if (log.debug())
				log.debug("path not found");
			return call(wrapper, arg("error", "Path not found: " + url.getPath()));
		}

		// resolve the name to an id
		List<Id> list = e.find(c, arg("name", name));
		if (list.size() > 0) {
			// found
			if (log.debug())
				log.debug("calling Wrapper c=%s cid=%s", list.get(0).c,
						list.get(0).cid.toString());
			return call(wrapper, //
					arg("c", list.get(0).c), //
					arg("cid", list.get(0).cid.toString()));
		} else {
			// not found
			String error = "Asset not found: type:" + c + " name:" + name;
			return call(wrapper, arg("error", error));
		}
	}

	/**
	 * Encode a link of a given asset using its name.
	 *
	 * @param e
	 * @param id
	 * @param args
     * @return
     */
	public String defaultLink(Env e, Id id, Arg[] args) {
		String name = e.getAsset(id).getName();
		if (id.c.equals("Page"))
			// home page
			if (name.equals("Home"))
				return "";
			else
				return "/" + name;
		else
			// return type/name
			return "/" + id.c + "/" + name;
	}

	/**
	 * Route an asset
	 * 
	 * @param env
	 * @param url
	 * @return
	 */
	abstract public Call route(Env env, URL url);

	/**
	 * Link an asset
	 * 
	 * @param env
	 * @param id
	 * @return
	 */
	abstract public String link(Env env, Id id, Arg... args);
}
