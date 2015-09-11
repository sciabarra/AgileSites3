package agilesitesng.services;

import COM.FutureTense.Interfaces.ICS;
import agilesites.api.DateformatTag;
import agilesites.api.IcsTag;
import agilesites.api.Log;
import com.fatwire.assetapi.common.AssetAccessException;
import com.fatwire.assetapi.common.AssetNotExistException;
import com.fatwire.assetapi.data.AssetData;
import com.fatwire.assetapi.data.AssetDataManager;
import com.fatwire.assetapi.data.AssetId;
import com.fatwire.assetapi.data.MutableAssetData;
import com.fatwire.services.beans.AssetIdImpl;

import java.util.*;

/**
 * Main asset abstraction. You get an asset from an Env then use this class to
 * generate code.
 *
 * @author msciab
 */
public abstract class Asset {

    //private static Log log = Log.getLog(Asset.class);

    protected String c;
    protected long cid;
    protected String site;
    protected String subtype;
    protected String name;
    protected String description;
    protected String filename;
    protected String path;
    protected String template;
    protected Date startDate;
    protected Date endDate;

    /**
     * Create an asset with a given type, subtype and name.
     */
    public Asset(String c, ICS ics) {
        this.c = c;
        this.cid = Utils.parseLongOrZero(ics.GetVar("cid"));
        this.site = ics.GetVar("site");
        this.name = ics.GetVar("name");
        this.description = Utils.nnOr(ics.GetVar("description"), this.name);
        this.subtype = Utils.nnOr(subtype, "");
        this.filename = ics.GetVar("filename");
        this.path = ics.GetVar("path");
        this.template = ics.GetVar("template");
        this.startDate = Utils.toDate(ics.GetVar("startdate"));
        this.endDate = Utils.toDate(ics.GetVar("enddate"));
    }

    private boolean assetExist(AssetDataManager adm, AssetId aid)
            throws AssetAccessException {
        List<AssetId> ls = new ArrayList<AssetId>();
        ls.add(aid);
        try {
            return adm.read(ls).iterator().hasNext();
        } catch (AssetNotExistException ex) {
            return false;
        }
    }

    public String deploy(String sitename, AssetDataManager adm, ICS ics) {

        // initialize the env for an update call
        // ics.SetVar("site", sitename) // ambiguous for groovy!
        IcsTag.setvar().name("site").value(sitename);
        ics.SetSSVar("pubid", Utils.siteid(ics, sitename));
        DateformatTag.create().name("_FormatDate_").run(ics);

        StringBuilder sb = new StringBuilder();
        sb.append("ASSET ").append(c).append(" ").append(name);
        try {
            AssetId aid = new AssetIdImpl(c, cid);
            MutableAssetData ad;
            boolean update;
            if (assetExist(adm, aid)) {
                Iterator<MutableAssetData> iad = adm.readForUpdate(
                        Arrays.asList(aid)).iterator();
                ad = iad.next();
                update = true;
            } else {
                ad = adm.newAssetData(c, "");
                ad.setAssetId(aid);
                update = false;
            }

            ad.getAttributeData("Publist").setDataAsList(Arrays.asList(sitename));
            ad.getAttributeData("name").setData(name);
            ad.getAttributeData("description").setData(description);
            ad.getAttributeData("subtype").setData(subtype);
            if (filename != null)
                ad.getAttributeData("filename").setData(filename);
            if (path != null)
                ad.getAttributeData("path").setData(path);
            if (template != null)
                ad.getAttributeData("template").setData(template);
            if (startDate != null)
                ad.getAttributeData("startdate").setData(startDate);
            if (endDate != null)
                ad.getAttributeData("enddate").setData(endDate);

                /*
                clearing the data in Attributes in ad to insert a fresh definitions defined in the definitions. So that the removed/unspecified attributes will be moved out from the definition.
				The below check is made by :bharath
				*/
            if (ad.getAttributeData("Attributes") != null) {
                ad.getAttributeData("Attributes").setData(null);
            }

            setData(ad);

            List<AssetData> la = new LinkedList<AssetData>();
            la.add(ad);

            // insert/update
            if (update) {
                sb.append(" UPDATE: ");
                adm.update(la);
                sb.append(" OK\n");
            } else {
                sb.append(" INSERT: ");
                adm.insert(la);
                sb.append(" OK\n");
            }
            // post process
            if (this instanceof HasPostProcess)
                sb.append(((HasPostProcess) this).postProcess(ics));

        } catch (Exception e) {
            e.printStackTrace();
            sb.append(" ERR ").append(e.getMessage()).append("\n");
        }
        return sb.toString();
    }


    public String toString() {
        return c+":"+name+"#"+cid+"@"+site;
    }

    /**
     * Print it
     */
    public String dump() {
        StringBuilder sb = new StringBuilder();
        sb.append("name=").append(name);
        sb.append("\ndescription=").append(description);
        sb.append("\nsite=").append(site);
        sb.append("\ncid=").append(cid);
        sb.append("\nc=").append(c);
        if (subtype != null)
            sb.append("\nsubtype=").append(subtype);
        //sb.append("\nsite=").append(site);
        if (template != null)
            sb.append("\ntemplate=").append(template);
        if (startDate != null)
            sb.append("\nstartDate=").append(
                    startDate == null ? "" : startDate.toString());
        if (endDate != null)
            sb.append("\nendDate=").append(
                    endDate == null ? "" : endDate.toString());
        if (path != null)
            sb.append("\npath=").append(path);
        if (filename != null)
            sb.append("\nfilename=").append(filename);
        return sb.toString();
    }

    /**
     * Set specific asset data for this asset
     *
     * @return
     */
    abstract public void setData(MutableAssetData data);


}
