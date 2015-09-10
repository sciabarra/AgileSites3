package agilesitesng.services;

import java.util.Arrays;
import java.util.List;

import COM.FutureTense.Interfaces.ICS;
import com.fatwire.assetapi.data.MutableAssetData;

public class SiteEntry extends Asset {

    // private String element;
    private String elementname;
    private boolean wrapper;
    private List<String> cacheCriteria =
            Utils.listString("c", "cid", "context",
                    "p", "rendermode", "site", /* "sitepfx",*/ "ft_ss");

    /**
     * Create a site entry, specifying if it is a wrapper and the element it
     * actually calls (otherwise it is automatically calculated from the name)
     */
    public SiteEntry(ICS ics) {
        super("SiteEntry", ics);
        this.elementname = ics.GetVar("elementname");
        this.wrapper = Utils.bool(ics.GetVar("wrapper"));
        List<String> criteria = Arrays.asList(Utils.splitOnPipe(ics.GetVar("cachecriteria")));
        this.cacheCriteria.addAll(criteria);
    }

    public List<String> getAttributes() {
        return Utils.listString("name", "description", "category", "pagename",
                "cs_wrapper", "cselement_id", "acl", "cscacheinfo",
                "sscacheinfo", "csstatus", "defaultarguments", "pagecriteria",
                "rootelement", "pageletonly");
    }

    @Override
    public void setData(MutableAssetData data) {
        String elementname = //
                (this.elementname == null) ? (site + "/" + name) : this.elementname;

        // root element
        data.getAttributeData("category").setData("");
        data.getAttributeData("pagename").setData(name);
        data.getAttributeData("rootelement").setData(elementname);
        data.getAttributeData("cs_wrapper").setData(wrapper ? "y" : "n");

        // data.getAttributeData("cselement_id").setData(
        // "CSElement:" + csElementId);

        data.getAttributeData("acl").setData("");
        data.getAttributeData("cscacheinfo").setData("false");
        data.getAttributeData("sscacheinfo").setData("false");
        data.getAttributeData("csstatus").setData("live");
        data.getAttributeData("pageletonly").setData("false");

        data.getAttributeData("pagecriteria").setDataAsList(
                cacheCriteria);

        data.getAttributeData("defaultarguments").setDataAsList(
                Utils.list(
                        Utils.attrStructKV("seid", "" + data.getAssetId().getId()), //
                        Utils.attrStructKV("site", site),
                        Utils.attrStructKV("rendermode", "live")));
    }
}
