package agilesitesng.services;

import static agilesitesng.services.Utils.*;

import java.util.Arrays;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import COM.FutureTense.Interfaces.ICS;

import com.fatwire.assetapi.data.AttributeData;
import com.fatwire.assetapi.data.MutableAssetData;

public class Template extends Asset {

	public final static char UNSPECIFIED = '\0';
	public final static char INTERNAL = 'b';
	public final static char STREAMED = 'r';
	public final static char EXTERNAL = 'x';
	public final static char LAYOUT = 'l';

	// private final static Log log = new Log(Template.class);

	private String rootelement;
	private String fileelement;
	private String folderelement;

	private String cscache;
	private String sscache;
	private char ttype;
	private String forSubtype;
    private String body;

    // todo read default cache criteria
	private List<String> cacheCriteria =
            Utils.listString("c", "cid", "context",
			"p", "rendermode", "site", /* "sitepfx",*/ "ft_ss");

	/**
	 * Create a template with given subtype, name, and top element, applying to
	 * given subtypes.
	 * 
	 * Description defaults to the name, cache defaults to false/false
	 *
	 */
	public Template(ICS ics) {
		super("Template", ics);
		//this.clazz = elementClass.getCanonicalName();

		this.ttype = ics.GetVar("ttype").charAt(0);
        String forSubtype = ics.GetVar("forSubtype");
		if (forSubtype == null || forSubtype.trim().length() == 0)
			this.forSubtype = "*";
		else
			this.forSubtype = forSubtype;
        this.cscache = ics.GetVar("cscache");
        this.sscache = ics.GetVar("sscache");
        this.body = ics.GetVar("body");
        List<String> criteria = Arrays.asList(Utils.splitOnPipe(ics.GetVar("cachecriteria")));
        this.cacheCriteria.addAll(criteria);
	}

	//@Override
	public void init(String site) {
		//super.init(site);
		if (subtype == null || subtype.trim().length() == 0) {
			subtype = "";
			rootelement = "/" + name;
			folderelement = "Typeless";
		} else {
			subtype = subtype.trim();
			rootelement = subtype + "/" + name;
			folderelement = subtype;
		}
		fileelement = name + /* "_" + clazz + */ ".jsp";
	}

	//@Override
	List<String> getAttributes() {
		return Utils.listString("name", "description", "category",
				"rootelement", "element", "ttype", "pagecriteria", "acl",
				"applicablesubtypes", "Thumbnail");
	}

	private String template(String clazz, int poll) {
		//return Utils.getResource("/Streamer.jsp").replaceAll("%CLASS%", clazz).replaceAll("%POLL%", ""+poll);
        return null;
	}

	@Override
	public void setData(MutableAssetData data) {
		//final String body = template(clazz, mypoll);
		final AttributeData blob = attrBlob("url", folderelement, fileelement,
                body);

		HashMap mapElement = new HashMap<String, Object>();

		mapElement.put("elementname", attrString("elementname", rootelement));
		mapElement.put("description", attrString("description", rootelement));
		mapElement.put("resdetails1",
				attrString("resdetails1", "tid=" + data.getAssetId().getId()));
		mapElement.put(
				"resdetails2",
				attrString("resdetails2",
						"agilesites=" + System.currentTimeMillis()));
		mapElement.put("csstatus", attrString("csstatus", "live"));
		mapElement.put("cscacheinfo", attrString("cscacheinfo", cscache));
		mapElement.put("sscacheinfo", attrString("sscacheinfo", sscache));
		mapElement.put("url", blob);

		HashMap mapSiteEntry = new HashMap<String, Object>();
		mapSiteEntry.put("pagename", attrString("pagename", rootelement));
		mapSiteEntry.put(
				"defaultarguments", //
				attrArray(
						"defaultarguments", //
						attrStructKV("site", site),
						attrStructKV("rendermode", "live")));
		mapElement.put(
				"siteentry",
				attrArray("siteentry",
						attrStruct("Structure siteentry", mapSiteEntry)));

		data.getAttributeData("category").setData("banr");

		data.getAttributeData("rootelement").setData(rootelement);

		data.getAttributeData("element").setData(
				Utils.list(attrStruct("Structure Element", mapElement)));

		// default page criteria
		Collections.sort(cacheCriteria);
		data.getAttributeData("pagecriteria").setDataAsList(cacheCriteria);

		data.getAttributeData("acl").setDataAsList(Utils.listString(""));

		data.getAttributeData("ttype").setData(
				ttype == UNSPECIFIED ? null : "" + ttype);

		data.getAttributeData("applicablesubtypes").setData(forSubtype);
	}
}
