package agilesitesng.services;

import COM.FutureTense.Interfaces.ICS;
import com.fatwire.assetapi.data.MutableAssetData;

import java.util.Arrays;
import java.util.List;

public class SitePlan extends Asset {

    // private String element;
    private String rank;
    private String code;

    /**
     * Create a site entry, specifying if it is a wrapper and the element it
     * actually calls (otherwise it is automatically calculated from the name)
     */
    public SitePlan(ICS ics) {
        super("SitePlan", ics);
        this.rank = ics.GetVar("rank");
        this.code = ics.GetVar("code");
    }

    public List<String> getAttributes() {
        return Utils.listString("name", "description", "SPTRank", "SPTNCode");
    }

    @Override
    public void setData(MutableAssetData data) {
        data.getAttributeData("SPTRank").setData(rank);
        data.getAttributeData("SPTNCode").setData(code);
    }
}
