package agilesitesng.services;

import COM.FutureTense.Interfaces.ICS;
import agilesites.api.Api;
import agilesites.api.AssetTag;
import com.fatwire.assetapi.data.AssetData;
import com.fatwire.assetapi.data.AssetDataManager;
import com.fatwire.assetapi.data.AssetId;
import com.fatwire.system.Session;
import com.fatwire.system.SessionFactory;
import com.openmarket.xcelerate.asset.AssetIdImpl;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.*;

/**
 * Created by msciab on 23/08/15.
 */
public class ScatterGatherService implements Service {

    public String gather(HttpServletRequest req, ICS ics, HttpServletResponse res) throws Exception {

        String c = ics.GetVar("c");
        String site = ics.GetVar("site");
        String siteid = Utils.siteid(ics, site);

        //return "c="+c+"\nsite="+site+"\n"+Utils.dumpVarsByPrefix(ics, "a:");

        String id = ics.GetVar("a:id");
        String obj = Api.tmp();
        System.out.println("loading " + id);
        AssetTag.load().name(obj).type(c).objectid(id).site(site).editable("true").run(ics);
        if (ics.GetObj(obj) == null) {
            System.out.println("creating " + id);
            AssetTag.create().type(c).name(obj).run(ics);
            AssetTag.set().name(obj).field("id").value(id).run(ics);
            AssetTag.addsite().name(obj).pubid(siteid).run(ics);
            AssetTag.save().name(obj).flush("true").run(ics);
        }
        ics.ClearErrno();
        AssetTag.gather().name(obj).prefix("a").run(ics);
        AssetTag.addsite().name(obj).pubid(siteid).run(ics);
        AssetTag.save().name(obj).run(ics);
        return "gather " + c + ":" + id + "@" + site + " is " + ics.GetErrno() + " sessid=" + req.getSession().getId();

    }

    public String scatter(HttpServletRequest req, ICS ics, HttpServletResponse res) throws Exception {

        // decode asset reference <type>:<name-or-id>@<site>
        if (!Utils.decodeAssetId(ics)) {
            return ics.GetVar("error");
        }

        String c = ics.GetVar("c");
        String cid = ics.GetVar("cid");
        String site = ics.GetVar("site");
        String name = Api.tmp();
        String prefix = Api.tmp();

        // scatter asset
        AssetTag.load().name(name).type(c).objectid(cid).site(site).run(ics);
        AssetTag.scatter().name(name).prefix(prefix).fieldlist("*").run(ics);

        // order vars
        List<String> vars = new LinkedList<String>();
        Enumeration e = ics.GetVars();
        while (e.hasMoreElements()) vars.add(e.nextElement().toString());
        Collections.sort(vars);

        StringBuilder sb = new StringBuilder();
        for (String v : vars) {
            if (v.startsWith(prefix)) {
                String field = v.substring(prefix.length() + 1);
                if (field.startsWith("url") && !(v.endsWith("_folder") || v.endsWith("_file"))) {
                    if (ics.GetVar(v) == null || ics.GetVar(v).length() == 0)
                        AssetTag.get().name(name).field(field).output(v).run(ics);
                }
                sb.append(field).append("=").append(ics.GetVar(v)).append("\n");
                //sb.append(field).append(" as bin is").append(ics.GetBin(v).length+"").append("\n");
            }
        }
        return sb.toString();

    }

    public String dump(HttpServletRequest req, ICS ics, HttpServletResponse res) throws Exception {
        if (!Utils.decodeAssetId(ics))
            return ics.GetVar("error");
        Session ses = SessionFactory.newSession(ics.GetVar("username"), ics.GetVar("password"));
        AssetDataManager adm = (AssetDataManager) ses.getManager(AssetDataManager.class
                .getName());
        AssetId aid = new AssetIdImpl(ics.GetVar("c"), Long.parseLong(ics.GetVar("cid")));
        AssetData data = adm.read(Arrays.asList(aid)).iterator().next();
        StringBuffer sb = new StringBuffer();
        for (String name : data.getAttributeNames())
            sb.append(name).append("=").append(data.getAttributeData(name).getDataAsList().toString()).append("\n");
        return sb.toString(); //com.thoughtworks.xstream.XStream().toXML(data);
    }

    @Override
    public String exec(HttpServletRequest req, ICS ics, HttpServletResponse res) throws Exception {
        if (ics.GetVar("op").equals("scatter"))
            return scatter(req, ics, res);
        else if (ics.GetVar("op").equals("gather"))
            return gather(req, ics, res);
        else if (ics.GetVar("op").equals("dump"))
            return dump(req, ics, res);
        else return "???";
    }
}
