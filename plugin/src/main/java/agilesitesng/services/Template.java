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

    private String rootElement;
    private String fileElement;
    private String folderElement;

    private char tType;
    private String csCache;
    private String ssCache;
    private String forSubtype;
    private String body;

    // todo read default cache criteria
    private List<String> cacheCriteria =
            Utils.listString("ab", "c", "cid", "context",
                    "d", "deviceid", "p", "rendermode",
                    "site", "sitepfx", "ft_ss");

    /**
     * Create a template with given subtype, name, and top element, applying to
     * given subtypes.
     * <p/>
     * Description defaults to the name, cache defaults to false/false
     */
    public Template(ICS ics) {
        super("Template", ics);

        // file & folder from type
        if (subtype == null || subtype.trim().length() == 0) {
            subtype = "";
            rootElement = "/" + name;
            folderElement = "Typeless";
        } else {
            subtype = subtype.trim();
            rootElement = subtype + "/" + name;
            folderElement = subtype;
        }
        fileElement = name + ".jsp";
        this.body = ics.GetVar("body");

        // template types
        this.tType = ics.GetVar("ttype").charAt(0);
        String forSubtype = ics.GetVar("forSubtype");
        if (forSubtype == null || forSubtype.trim().length() == 0)
            this.forSubtype = "*";
        else
            this.forSubtype = forSubtype;

        // cache & criteria
        this.csCache = ics.GetVar("cscache");
        this.ssCache = ics.GetVar("sscache");
        if (!isEmpty(ics.GetVar("criteria")))
            cacheCriteria = Arrays.asList(Utils.splitOnComma(ics.GetVar("criteria")));
        if (!isEmpty(ics.GetVar("extraCriteria")))
            this.cacheCriteria.addAll(Arrays.asList(Utils.splitOnComma(ics.GetVar("extraCriteria"))));
    }

    //@Override
    List<String> getAttributes() {
        return Utils.listString("name", "description", "category",
                "rootelement", "element", "ttype", "pagecriteria", "acl",
                "applicablesubtypes", "Thumbnail");
    }

    @Override
    public void setData(MutableAssetData data) {
        final AttributeData blob =
                attrBlob("url", folderElement, fileElement, body);

        HashMap mapElement = new HashMap<String, Object>();

        mapElement.put("elementname",
                attrString("elementname", rootElement));
        mapElement.put("description",
                attrString("description", rootElement));
        mapElement.put("resdetails1",
                attrString("resdetails1", "tid=" + data.getAssetId().getId()));

        mapElement.put(
                "resdetails2",
                attrString("resdetails2",
                        "agilesites=" + System.currentTimeMillis()));
        mapElement.put("csstatus",
                attrString("csstatus", "live"));
        mapElement.put("cscacheinfo",
                attrString("cscacheinfo", csCache));
        mapElement.put("sscacheinfo",
                attrString("sscacheinfo", ssCache));


        mapElement.put("url", blob);

        HashMap mapSiteEntry = new HashMap<String, Object>();
        mapSiteEntry.put("pagename", attrString("pagename", rootElement));
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

        data.getAttributeData("rootelement").setData(rootElement);

        data.getAttributeData("element").setData(
                Utils.list(attrStruct("Structure Element", mapElement)));

        // default page criteria
        Collections.sort(cacheCriteria);
        data.getAttributeData("pagecriteria").setDataAsList(cacheCriteria);

        data.getAttributeData("acl").setDataAsList(Utils.listString(""));

        data.getAttributeData("ttype").setData(
                tType == UNSPECIFIED ? null : "" + tType);

        data.getAttributeData("applicablesubtypes").setData(forSubtype);
    }
}
