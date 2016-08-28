package agilesitesng.services;

import COM.FutureTense.Interfaces.FTValList;
import COM.FutureTense.Interfaces.ICS;
import agilesites.api.AssetTag;
import agilesites.api.IcsTag;
import agilesites.api.Log;
import agilesites.api.UserTag;
import com.fatwire.assetapi.common.AssetAccessException;
import com.fatwire.assetapi.common.SiteAccessException;
import com.fatwire.assetapi.def.AssetTypeDefManager;
import com.fatwire.assetapi.site.Site;
import com.fatwire.assetapi.site.SiteImpl;
import com.fatwire.assetapi.site.SiteInfo;
import com.fatwire.assetapi.site.SiteManager;
import com.fatwire.system.Session;
import com.fatwire.system.SessionFactory;

import java.io.File;
import java.util.Arrays;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;

/**
 * Created by msciab on 01/08/15.
 */
public class SiteInit {

    final static Log log = Log.getLog(SiteInit.class);

    private ICS ics;
    private Session ses;
    private SiteManager sim;
    private String username;
    private String password;

    /**
     * @param ics ICS facade
     * @param username to access
     * @param password to access
     */
    public SiteInit(ICS ics, String username, String password) {
        this.ics = ics;
        this.username = username;
        this.password = password;

        System.out.println(username);
        System.out.println(password);

        ses = SessionFactory.newSession(username, password);
        sim = (SiteManager) ses.getManager(SiteManager.class
                .getName());
    }

    public String delete(String sitename) {
        try {
            sim.delete(Arrays.asList(sitename));
            return "OK: deleted "+sitename;
        } catch(Exception ex) {
            return "ERROR: "+ex.getMessage();
        }
    }

    private String xmlByType(String typeName) {
        log.trace("xmlByType %s", typeName);
        File base = new File(ics.GetProperty("xcelerate.defaultbase",
                "futuretense_xcel.ini", true));
        StringBuilder sb = new StringBuilder();
        String defDir = new File(base, typeName).getAbsolutePath();

        if (typeName.equals(("Jar"))) {
            sb.append("<?xml version='1.0' ?>\n");
            sb.append("<ASSET NAME='Jar' DESCRIPTION='Jar' DEFDIR='").append(defDir).append("'>\n");
            sb.append(" <PROPERTIES>\n");
            sb.append("  <PROPERTY NAME='URL' DESCRIPTION='URL'>\n");
            sb.append("    <STORAGE TYPE='VARCHAR' LENGTH='255' />\n");
            sb.append("    <INPUTFORM TYPE='UPLOAD' WIDTH='64' LINKTEXT='Url' REQUIRED='YES'/>\n");
            sb.append("  </PROPERTY>\n");
            sb.append(" </PROPERTIES>\n");
            sb.append("</ASSET>\n");
        }
        if (typeName.equals("Static")) {
            sb.append("<?xml version='1.0' ?>\n");
            sb.append("<ASSET NAME='Static' DESCRIPTION='Static' DEFDIR='").append(defDir).append("'>\n");
            sb.append(" <PROPERTIES>\n");
            sb.append("  <PROPERTY NAME='URL' DESCRIPTION='URL'>\n");
            sb.append("   <STORAGE TYPE='VARCHAR' LENGTH='255' />\n");
            sb.append("   <INPUTFORM TYPE='UPLOAD' WIDTH='64' LINKTEXT='Url' REQUIRED='YES'/>\n");
            sb.append(" </PROPERTY>\n");
            sb.append(" <PROPERTY NAME='FILEPATH' DESCRIPTION='FILEPATH'>\n");
            sb.append("   <STORAGE TYPE='VARCHAR' LENGTH='512'/>\n");
            sb.append("   <INPUTFORM TYPE='TEXT' DESCRIPTION='FILE PATH' REQUIRED='YES'/>\n");
            sb.append("   <SEARCHFORM TYPE='TEXT' DESCRIPTION='FILE PATH'/>\n");
            sb.append("   <SEARCHRESULTS INCLUDE='TRUE'/>\n");
            sb.append(" </PROPERTY>\n");
            sb.append(" <PROPERTY NAME='HASH' DESCRIPTION='HASH'>\n");
            sb.append("  <STORAGE TYPE='VARCHAR' LENGTH='32'/>\n");
            sb.append("  <INPUTFORM TYPE='TEXT' DESCRIPTION='HASH' REQUIRED='YES'/>\n");
            sb.append("  <SEARCHFORM TYPE='TEXT' DESCRIPTION='HASH'/>\n");
            sb.append("  <SEARCHRESULTS INCLUDE='TRUE'/>\n");
            sb.append(" </PROPERTY>\n");
            sb.append(" <PROPERTY NAME='HASHFILEPATH' DESCRIPTION='HASHFILEPATH'>\n");
            sb.append("  <STORAGE TYPE='VARCHAR' LENGTH='512'/>\n");
            sb.append("  <INPUTFORM TYPE='TEXT' DESCRIPTION='HASH FILE PATH' REQUIRED='YES'/>\n");
            sb.append("  <SEARCHFORM TYPE='TEXT' DESCRIPTION='HASH FILE PATH'/>\n");
            sb.append("  <SEARCHRESULTS INCLUDE='TRUE'/>\n");
            sb.append(" </PROPERTY>\n");
            sb.append(" <PROPERTY NAME='MIMETYPE' DESCRIPTION='MIMETYPE'>\n");
            sb.append("   <STORAGE TYPE='VARCHAR' LENGTH='255'/>\n");
            sb.append("   <INPUTFORM TYPE='TEXT' DESCRIPTION='MIMETYPE' REQUIRED='YES'/>\n");
            sb.append("   <SEARCHFORM TYPE='TEXT' DESCRIPTION='MIMETYPE'/>\n");
            sb.append("   <SEARCHRESULTS INCLUDE='TRUE'/>\n");
            sb.append("  </PROPERTY>\n");
            sb.append(" </PROPERTIES>\n");
            sb.append("</ASSET>\n");
        }
        String body = sb.toString().replace('\'', '"');
        //System.out.println(body);
        return body;
    }

    // create a type if it does not exist
    private boolean createTypeIfDoesNotExist(String typeName) throws AssetAccessException {
        AssetTypeDefManager atdm = (AssetTypeDefManager) ses
                .getManager(AssetTypeDefManager.class.getName());

        // create the Jar Asset type if it does not exits
        Iterator<String> it = atdm.getAssetTypes().iterator();
        while (it.hasNext())
            if (it.next().equalsIgnoreCase(typeName))
                return false;

        atdm.createAssetMakerAssetType(
                typeName,
                typeName + ".xml",
                xmlByType(typeName), false, false);

        return true;
    }

    // create a site if it does not exist
    private boolean createSiteIfDoesNotExist(String sitename, long siteid) throws SiteAccessException {
        for (SiteInfo inf : sim.list())
            if (inf.getName().equals(sitename))
                return false;
        try {
            Site site = new SiteImpl();
            site.setId(siteid);
            site.setName(sitename);
            site.setDescription(sitename);
            site.setUserRoles(username, Arrays.asList("GeneralAdmin", "SitesUser", "AdvancedUser"));
            sim.create(Arrays.asList(site));

            // sim.create(Collections.<Site>singletonList(new MiniSite(sitename, siteid)));
        } catch (Exception ex) {
            ex.printStackTrace();
            return false;
        }
        return true;
    }

    /**
     * Enable a type for the existing site
     * @param siteName    the site name
     * @param typeName    the type name
     * @return if the type was enabled
     * @throws SiteAccessException if you cannot enable the type
     */
    private boolean enableType(String siteName, String typeName) throws SiteAccessException {
        log.trace("enableType in %s for %s", siteName, typeName);
        Site site = sim.read(Arrays.asList(siteName)).get(0);
        List<String> types = site.getAssetTypes();
        boolean hasType = false;
        for (String type : types)
            if (type.equals(typeName)) {
                hasType = true;
                break;
            }
        if (hasType)
            return false;

        List<String> newtypes = new LinkedList<String>();
        newtypes.addAll(types);
        newtypes.add(typeName);
        site.setAssetTypes(newtypes);
        log.debug("adding " + siteName + " newtypes=" + newtypes);
        sim.update(Arrays.asList(site));
        return true;
    }

    /**
     * init a site creating a Jar, a Static and a Site with a given id
     *
     * @param siteName    the site name
     * @param siteId the site id
     * @throws Exception from asset api
     * @return
     */
    public String init(String siteName, long siteId, String[] enabledTypes) throws Exception {
        StringBuilder sb = new StringBuilder();
        if (createTypeIfDoesNotExist("Jar"))
            sb.append("Created Jar\n");

        if (createTypeIfDoesNotExist("Static"))
            sb.append("Created Static.\n");

        if (createSiteIfDoesNotExist(siteName, siteId))
            sb.append("Created ").append(siteName).append("(").append(siteId).append(")");

        if (enableType(siteName, "Jar"))
            sb.append("Enabled Jar for").append(siteName).append("(").append(siteId).append(")");

        if (enableType(siteName, "Static"))
            sb.append("Enabled Static for").append(siteName).append("(").append(siteId).append(")");
        for (String enabledType : enabledTypes) {
            String[] typeToEnable = enabledType.split(":");
            if (enableType(siteName,typeToEnable[0])) {
                sb.append("Enabled ").append(enabledType).append(" for ").append(siteName).append("(").append(siteId).append(")");
                if (typeToEnable.length == 1 || !"f".equalsIgnoreCase(typeToEnable[1])) {
                    createStartMenus(siteName, enabledType);
                }
            }
        }

        return sb.toString();
    }

    private void createStartMenus(String siteName, String enabledType) {
        StartMenu sf = new StartMenu(enabledType, siteName, "Search", enabledType);
        sf.build(ics);
        StartMenu sn = new StartMenu(enabledType, siteName, "ContentForm", enabledType);
        sn.build(ics);
    }

    /**
     * Upload a jar
     *
     * @param siteid the site id where upload the jar
     * @return error messages or ok
     */
    public String uploadJar(String siteid) {
        UserTag.login()
                .username(username)
                .password(password)
                .run(ics);

        byte[] file = ics.GetBin("jar");
        String filename = ics.GetVar("jar_file");
        String result;

        AssetTag.load()
                .name("obj")
                .type("Jar")
                .field("name")
                .value(filename)
                .editable("true")
                .run(ics);

        if (ics.GetObj("obj") == null) {
            result = "created: ";
            AssetTag.create()
                    .name("obj")
                    .type("Jar")
                    .run(ics);
            AssetTag.set()
                    .name("obj")
                    .field("name")
                    .value(filename)
                    .run(ics);
        } else {
            result = "updated: ";
            AssetTag.scatter()
                    .name("obj")
                    .prefix("data")
                    .fieldlist("url")
                    .run(ics);
        }

        AssetTag.addsite()
                .name("obj")
                .pubid(ics.GetVar("siteid"))
                .run(ics);

        FTValList list = new FTValList();
        list.setValBLOB("jar", file);
        ics.SetVar("data:url", list.getVal("jar"));

        IcsTag.setvar()
                .name("data:url_file")
                .value(filename)
                .run(ics);

        IcsTag.setvar()
                .name("data:url_folder")
                .value("agilesites")
                .run(ics);

        IcsTag.setvar()
                .name("data:status")
                .value("ED")
                .run(ics);

        AssetTag.gather()
                .name("obj")
                .prefix("data")
                .fieldlist("url")
                .run(ics);

        AssetTag.save()
                .name("obj")
                .run(ics);

        AssetTag.get()
                .name("obj")
                .field("id")
                .output("id")
                .run(ics);

        result += filename + " #" + file.length + "(" + ics.GetVar("id") + ")";
        return result;
    }

    private void dumpVars() {
        java.util.Enumeration en = ics.GetVars();
        while (en.hasMoreElements()) {
            String k = en.nextElement().toString();
            log.debug(k + "=" + ics.GetVar(k));
        }
    }
}

