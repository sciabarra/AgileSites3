package agilesitesng.services;

import COM.FutureTense.Interfaces.ICS;
import agilesites.api.AssetTag;
import com.fatwire.assetapi.data.AssetData;
import com.fatwire.assetapi.data.AssetDataManager;
import com.fatwire.assetapi.data.MutableAssetData;
import com.openmarket.xcelerate.asset.AssetIdImpl;
import agilesites.api.Api;

// the attribute
public class Attribute extends Asset implements HasPostProcess {

    private String type;
    private String valuestyle;
    private String embedtype;
    private String depexist;
    private String assettypename;
    private String[] assetsubtypename;
    private long attributetype = -1;


    // mul: S/O/N
    // dependencyExist: E/X
    // embedded: H/U
    public Attribute(ICS ics) throws Exception {
        super(ics.GetVar("c"), ics);
        this.type = ics.GetVar("type");
        this.valuestyle = Utils.oneOf(ics.GetVar("mul"), "SON");
        this.depexist = Utils.bool(ics.GetVar("existDep")) ? "E" : "X";
        this.embedtype = Utils.bool(ics.GetVar("notEmbedded")) ? "H" : "U";
        this.attributetype = Utils.parseLongOrZero(ics.GetVar("attributetype"));
        this.assettypename = ics.GetVar("assettypename");
        this.assetsubtypename = Utils.splitOnPipe(ics.GetVar("assetsubtypename"));
    }


    @Override
    public void setData(MutableAssetData ad) {
        ad.getAttributeData("type").setData(type);
        ad.getAttributeData("valuestyle").setData(valuestyle);
        ad.getAttributeData("embedtype").setData(embedtype);
        ad.getAttributeData("deptype").setData(depexist);
        ad.getAttributeData("editing").setData("L");
        ad.getAttributeData("storage").setData("L");
        if (attributetype > 0)
            ad.getAttributeData("attributetype").setData(
                    new AssetIdImpl("AttrTypes", attributetype));
        if (assettypename != null && assettypename.length() > 0)
            ad.getAttributeData("assettypename").setData(assettypename);
        // post process will fix attribute subtypes
    }

    @Override
    public String postProcess(ICS ics) {
        if (assetsubtypename == null || assetsubtypename.length == 0)
            return "";

        String tmp = Api.tmp();
        AssetTag.load().type(c).objectid("" + cid).name(tmp).editable("true")
                .run(ics);
        // AssetTag.get().name(tmp).field(arg0)
        AssetTag.scatter().name(tmp).prefix(tmp).fieldlist("*").run(ics);
        StringBuilder sb = new StringBuilder("SUBTYPE ");
        /*
         * Enumeration<?> en = ics.GetVars(); while (en.hasMoreElements()) {
		 * String v = en.nextElement().toString(); if (v.startsWith(tmp))
		 * sb.append(v).append("=").append(ics.GetVar(v)).append("\n"); }
		 */
        ics.SetVar(tmp + ":assetsubtypename:Total",
                assetsubtypename == null ? "0" : "" + assetsubtypename.length);
        int i = 0;
        for (String s : assetsubtypename) {
            ics.SetVar(tmp + ":assetsubtypename:" + i, s);
            sb.append(s).append(" ");
            i++;
        }
        sb.append("\n");
        AssetTag.gather().name(tmp).prefix(tmp).fieldlist("*").run(ics);
        AssetTag.save().name(tmp).run(ics);
        return sb.toString();
    }
}
